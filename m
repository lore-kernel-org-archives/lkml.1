Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbZDQOtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbZDQOtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbZDQOta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:49:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53139 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbZDQOta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:49:30 -0400
Date: Fri, 17 Apr 2009 11:49:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 2/2] kvm userspace: Add MCE simulation to kvm
Message-ID: <20090417144908.GA24261@amt.cnet>
References: <1239953925.6842.21.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239953925.6842.21.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Fri, Apr 17, 2009 at 03:38:45PM +0800, Huang Ying wrote:
> - MCE features are initialized when VCPU is initialized according to CPUID.
> - A monitor command "mce" is added to inject a MCE.
> 
> 
> ChangeLog:
> 
> v2:
> 
> - Use new kernel MCE capability exportion interface.
> 
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  libkvm/libkvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
>  libkvm/libkvm.h        |    4 ++++
>  qemu/monitor.c         |   26 ++++++++++++++++++++++++++
>  qemu/qemu-kvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
>  qemu/qemu-kvm.c        |   26 ++++++++++++++++++++++++++
>  qemu/qemu-kvm.h        |    4 ++++
>  qemu/target-i386/cpu.h |    3 +++
>  7 files changed, 129 insertions(+)
> 
> --- a/qemu/monitor.c
> +++ b/qemu/monitor.c
> @@ -1557,6 +1557,31 @@ static void do_info_status(Monitor *mon)
>  }
>  
>  
> +#if defined(TARGET_I386) || defined(TARGET_X86_64)
> +static void do_inject_mce(Monitor *mon,
> +			  int cpu_index, int bank,
> +			  unsigned status_hi, unsigned status_lo,
> +			  unsigned mcg_status_hi, unsigned mcg_status_lo,
> +			  unsigned addr_hi, unsigned addr_lo,
> +			  unsigned misc_hi, unsigned misc_lo)
> +{
> +    CPUState *env;
> +    struct kvm_x86_mce mce = {
> +	.bank = bank,
> +	.status = ((uint64_t)status_hi << 32) | status_lo,
> +	.mcg_status = ((uint64_t)mcg_status_hi << 32) | mcg_status_lo,
> +	.addr = ((uint64_t)addr_hi << 32) | addr_lo,
> +	.misc = ((uint64_t)misc_hi << 32) | misc_lo,
> +    };
> +
> +    for (env = first_cpu; env != NULL; env = env->next_cpu)
> +	if (env->cpu_index == cpu_index && env->mcg_cap) {
> +	    kvm_inject_x86_mce(env, &mce);
> +	    break;
> +	}
> +}
> +#endif

This will break compilation on hosts with older kernel headers. To ease
the merge with QEMU, do_inject_mce should call qemu_inject_x86_mce,
which does nothing for the case where KVM is disabled, or call KVM
specific function otherwise (knowledge about struct kvm_x86_mce should
be contained within KVM code).

> +
>  static void do_balloon(Monitor *mon, int value)
>  {
>      ram_addr_t target = value;
> @@ -1758,6 +1783,7 @@ static const mon_cmd_t mon_cmds[] = {
>        "[tap,user,socket,vde] options", "add host VLAN client" },
>      { "host_net_remove", "is", net_host_device_remove,
>        "vlan_id name", "remove host VLAN client" },
> +    { "mce", "iillll", do_inject_mce, "cpu bank status mcgstatus addr misc", "inject a MCE on the given CPU"},
>  #endif
>      { "balloon", "i", do_balloon,
>        "target", "request VM to change it's memory allocation (in MB)" },
> --- a/libkvm/libkvm-x86.c
> +++ b/libkvm/libkvm-x86.c
> @@ -379,6 +379,39 @@ int kvm_set_msrs(kvm_context_t kvm, int 
>      return r;
>  }
>  
>
> +int kvm_get_mce_cap_supported(kvm_context_t kvm, uint64_t *mce_cap,
> +			      int *max_banks)
> +{
> +    int r;
> +
> +    r = ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> +    if (r > 0) {
> +	*max_banks = r;
> +	return ioctl(kvm->fd, KVM_X86_GET_MCE_CAP_SUPPORTED, mce_cap);
> +    }
> +    return -ENOSYS;
> +}
> +
> +int kvm_setup_mce(kvm_context_t kvm, int vcpu, uint64_t *mcg_cap)
> +{
> +    int r;
> +
> +    r = ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> +    if (r > 0)
> +	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SETUP_MCE, mcg_cap);
> +    return -ENOSYS;
> +}
> +
> +int kvm_set_mce(kvm_context_t kvm, int vcpu, struct kvm_x86_mce *m)
> +{
> +    int r;
> +
> +    r = ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> +    if (r > 0)
> +	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SET_MCE, m);
> +    return -ENOSYS;
> +}

Have to #ifdef KVM_CAP_MCE where appropriate, otherwise compilation 
on hosts with older kernel headers fail.

