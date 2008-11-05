Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYKERfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYKERfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYKERfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:35:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36714 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYKERfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:35:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
	<1225810364-8990-16-git-send-email-ehabkost@redhat.com>
Date: Wed, 05 Nov 2008 09:26:53 -0800
In-Reply-To: <1225810364-8990-16-git-send-email-ehabkost@redhat.com> (Eduardo
	Habkost's message of "Tue, 4 Nov 2008 12:52:43 -0200")
Message-ID: <m1od0u3wyq.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eduardo Habkost <ehabkost@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 15/16] kvm: x86: set kdump virt_disable function on initialization
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> Finally implement the virt_disable function for kdump. It will call
> kvm_x86_ops->crash_hardware_disable(), that will disable virtualization
> extensions on the CPU if it is not disabled yet.
>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 049c6a0..9e61baf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -40,6 +40,7 @@
>  #include <asm/msr.h>
>  #include <asm/desc.h>
>  #include <asm/mtrr.h>
> +#include <asm/virtext.h>
>  
>  #define MAX_IO_MSRS 256
>  #define CR0_RESERVED_BITS						\
> @@ -2581,6 +2582,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct
> kvm_run *run, int in,
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
>  
> +/* Called at crash time, so we can disable virtualization if needed
> + */
> +static void crash_hardware_disable(void)
> +{
> +	kvm_x86_ops->crash_hardware_disable(NULL);
> +}
> +
>  int kvm_arch_init(void *opaque)
>  {
>  	int r;
> @@ -2605,9 +2613,15 @@ int kvm_arch_init(void *opaque)
>  
>  	kvm_x86_ops = ops;
>  
> +	r = set_virt_disable_func(crash_hardware_disable);

Can we make this say:
set_virt_disable_func(kvm_x86_ops->crash_hardware_disable);

So we can avoid going through 2 levels of function pointers?
I find that a little scary in code that might be running
at the edge of stack overflow.

> +	if (r) {
> +		printk(KERN_ERR "kvm: virt_disable function already set?\n");
> +		goto out_clear_ops;
> +	}
> +
>  	r = kvm_mmu_module_init();
>  	if (r)
> -		goto out_clear_ops;
> +		goto out_clear_crash;
>  
>  	kvm_init_msr_list();
>  
> @@ -2617,6 +2631,8 @@ int kvm_arch_init(void *opaque)
>  			PT_DIRTY_MASK, PT64_NX_MASK, 0, 0);
>  	return 0;
>  
> +out_clear_crash:
> +	clear_virt_disable_func();
>  out_clear_ops:
>  	kvm_x86_ops = NULL;
>  out:
> @@ -2625,6 +2641,7 @@ out:
>  
>  void kvm_arch_exit(void)
>  {
> +	clear_virt_disable_func();
>  	kvm_x86_ops = NULL;
>  	kvm_mmu_module_exit();
>  }
> -- 
> 1.5.5.GIT
