Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbXKFVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbXKFVfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbXKFVfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:35:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:39057 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbXKFVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h/qaG5x5t35GnSYJZfKPemtUKNw1KTPSZdmI3X/3lO/ry2NqEGnsDDc8ApASdGDwAz1jI47Fxl0k7KdfRxWZliQXhD4yeI6t2IG298bvvU5LVInDtr9InhWF+dTE2xQxa+a7/bSEDZNNG5TM80wdvLuQ430F+yejNMz5cXmyK2M=
Message-ID: <5d6222a80711061335q7ef03b42i335bb1e8c07eb7e4@mail.gmail.com>
Date: Tue, 6 Nov 2007 19:35:38 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
Subject: Re: [kvm-devel] include files for kvmclock
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hollisb@us.ibm.com,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
In-Reply-To: <11943875433821-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11943875362987-git-send-email-gcosta@redhat.com>
	 <11943875433821-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> This patch introduces the include files for kvm clock.
> They'll be needed for both guest and host part.

And of course, this was my test files by mistake ;-)
Oh god... ;-)

Patches aren't numbered but this one should go first. And please just ignore,
the replica of the hv_clock union definition in the patch bellow. It
should all go in asm/kvm_para.h

The other two patches are fine, and can be applied in any order, so
it's not worth resending. I'll grab your comments first.

> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  include/asm-x86/kvm_para.h |   23 +++++++++++++++++++++++
>  include/linux/kvm.h        |    1 +
>  include/linux/kvm_para.h   |   20 ++++++++++++++++++++
>  3 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
> index c6f3fd8..af9fb75 100644
> --- a/include/asm-x86/kvm_para.h
> +++ b/include/asm-x86/kvm_para.h
> @@ -10,15 +10,38 @@
>   * paravirtualization, the appropriate feature bit should be checked.
>   */
>  #define KVM_CPUID_FEATURES     0x40000001
> +#define KVM_FEATURE_CLOCKEVENTS 0
> +#define KVM_FEATURE_CLOCKSOURCE 1
> +
>
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
> +extern void kvmclock_init(void);
> +
> +union kvm_hv_clock {
> +       struct {
> +               u64 tsc_mult;
> +               u64 now_ns;
> +               /* That's the wall clock, not the water closet */
> +               u64 wc_sec;
> +               u64 wc_nsec;
> +               u64 last_tsc;
> +               /* At first, we could use the tsc value as a marker, but Jeremy
> +                * well noted that it will cause us locking problems in 32-bit
> +                * sys, so we have a special version field */
> +               u32 version;
> +       };
> +       char page_align[PAGE_SIZE];
> +};
> +
>
>  /* This instruction is vmcall.  On non-VT architectures, it will generate a
>   * trap that we will then rewrite to the appropriate instruction.
>   */
>  #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
>
> +#define KVM_HCALL_REGISTER_CLOCK       1
> +
>  /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
>   * instruction.  The hypervisor may replace it with something else but only the
>   * instructions are guaranteed to be supported.
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 71d33d6..7ac8786 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -359,6 +359,7 @@ struct kvm_signal_mask {
>  #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
>  #define KVM_CAP_USER_MEMORY 3
>  #define KVM_CAP_SET_TSS_ADDR 4
> +#define KVM_CAP_CLK      5
>
>  /*
>   * ioctls for VM fds
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index e4db25f..567a192 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -11,8 +11,28 @@
>
>  /* Return values for hypercalls */
>  #define KVM_ENOSYS             1000
> +#define KVM_ENODEV             1019
> +#define KVM_EINVAL             1022
>
>  #ifdef __KERNEL__
> +#define KVM_HCALL_REGISTER_CLOCK       1
> +
> +union kvm_hv_clock {
> +       struct {
> +               u64 tsc_mult;
> +               u64 now_ns;
> +               /* That's the wall clock, not the water closet */
> +               u64 wc_sec;
> +               u64 wc_nsec;
> +               u64 last_tsc;
> +               /* At first, we could use the tsc value as a marker, but Jeremy
> +                * well noted that it will cause us locking problems in 32-bit
> +                * sys, so we have a special version field */
> +               u32 version;
> +       };
> +       char page_align[PAGE_SIZE];
> +};
> +
>  /*
>   * hypercalls use architecture specific
>   */
> --
> 1.5.0.6
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
