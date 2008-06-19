Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbYFSLCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbYFSLCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYFSLCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:02:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYFSLCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:02:32 -0400
Date: Thu, 19 Jun 2008 13:02:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080619110214.GJ15228@elte.hu>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> X86 reboot-notify additions.
> 
> This patch adds scans of the "reboot_notifier_list" callback chain in
> a three other places where the kernel is being stopped and/or restarted.
> 
> Adds calls to blocking_notifier_call_chain() in:
>    crash_kexec(), emergency_restart(), sys_kexec_load()
> 
> In the crash_kexec() and emergency_restart() cases it is indicated to the
> called-back function that the system is not in a sane state, so that
> it can avoid taking a lock or some such potentially blocking action.
> 
> These callbacks are important to a partition system. The stopped kernel needs
> to inform other partitions of their need to disconnect (stop sharing memory).
> 
> Diffed against 2.6.26-rc6
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  include/linux/notifier.h |    4 ++++
>  kernel/kexec.c           |    5 +++++
>  kernel/sys.c             |    1 +
>  3 files changed, 10 insertions(+)
> 
> Index: linux/include/linux/notifier.h
> ===================================================================
> --- linux.orig/include/linux/notifier.h
> +++ linux/include/linux/notifier.h
> @@ -202,6 +202,10 @@ static inline int notifier_to_errno(int 
>  #define SYS_RESTART	SYS_DOWN
>  #define SYS_HALT	0x0002	/* Notify of system halt */
>  #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
> +#define SYS_INSANE	0x0004	/* Notify of system error/panic/oops */
> +/* For the SYS_INSANE case, no locks should be taken by the called-back
> + * function.  The kernel is ready for an immediate reboot.
> + */
>  
>  #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
>  
> Index: linux/kernel/kexec.c
> ===================================================================
> --- linux.orig/kernel/kexec.c
> +++ linux/kernel/kexec.c
> @@ -1001,6 +1001,9 @@ asmlinkage long sys_kexec_load(unsigned 
>  		if (result)
>  			goto out;
>  	}
> +
> +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);
> +
>  	/* Install the new kernel, and  Uninstall the old */
>  	image = xchg(dest_image, image);
>  
> @@ -1068,6 +1071,8 @@ void crash_kexec(struct pt_regs *regs)
>  	if (!locked) {
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
> +			blocking_notifier_call_chain(&reboot_notifier_list,
> +				SYS_INSANE, NULL);
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> Index: linux/kernel/sys.c
> ===================================================================
> --- linux.orig/kernel/sys.c
> +++ linux/kernel/sys.c
> @@ -270,6 +270,7 @@ out_unlock:
>   */
>  void emergency_restart(void)
>  {
> +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_INSANE, NULL);
>  	machine_emergency_restart();
>  }
>  EXPORT_SYMBOL_GPL(emergency_restart);

i dont think this is a good idea. reboot_notifier_list is a blocking 
notifier, i.e. it comes with a notifier->rwsem read-write mutex that is 
taken when blocking_notifier_call_chain() is executed.

i.e. this patch puts a sleeping mutex operation (a down_read()) into a 
highly critical code path of the kernel. This will decrease the 
reliability of the kernel.

what exactly are you trying to achieve?

	Ingo
