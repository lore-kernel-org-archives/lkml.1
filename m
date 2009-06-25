Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZFYSQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZFYSQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFYSPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:15:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54400 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZFYSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:15:51 -0400
To: Greg KH <gregkh@suse.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org
References: <20090624213211.GA11291@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Jun 2009 11:15:45 -0700
In-Reply-To: <20090624213211.GA11291@kroah.com> (Greg KH's message of "Wed\, 24 Jun 2009 14\:32\:11 -0700")
Message-ID: <m1ab3wgoxa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, linux-kernel@vger.kernel.org, garloff@suse.de, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> From: Kurt Garloff <garloff@suse.de>
>
> This patch introduces a sysctl /proc/sys/kernel/panic_on_io_nmi, which
> defaults to 0 (off).
>
> When enabled, the kernel panics when the kernel receives an NMI caused
> by an IO error.
>
> The IO error triggered NMI indicates a serious system condition, which
> could result in IO data corruption. Rather than contiuing, panicing and
> dumping might be a better choice, so one can figure out what's causing
> the IO error.
>
> This could be especially important to companies running IO intensive
> applications where corruption must be avoided, e.g. a banks databases.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

New binary sysctls are not allowed.   Please remove the
sysctl.h and .ctl_name portions.

see:
Documentation/sysctl/ctl_unnumbered.txt
Documentation/feature-remove-schedule.txt

I have a set of patches that should make this kind of thing
fail to compile for .32.  Hopefully I can get that out in 
the next couple of days.  Making problems like this easier
to spot and deal with.

> Signed-off-by: Kurt Garloff <garloff@suse.de>
> Signed-off-by: Roberto Angelino <robertangelino@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>
> I don't know why this wasn't sent to you before now, sorry about that.
> SuSE has been shipping it for a while, it was done at the request of a
> large database vendor, for their users.  Can you queue it up for .32?
>   - gregkh
>
>  arch/x86/kernel/dumpstack.c |    1 +
>  arch/x86/kernel/traps.c     |    3 +++
>  include/linux/kernel.h      |    1 +
>  include/linux/sysctl.h      |    1 +
>  kernel/sysctl.c             |    8 ++++++++
>  kernel/sysctl_check.c       |    1 +
>  6 files changed, 15 insertions(+)
>
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -22,6 +22,7 @@
>  #include "dumpstack.h"
>  
>  int panic_on_unrecovered_nmi;
> +int panic_on_io_nmi;
>  unsigned int code_bytes = 64;
>  int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
>  static int die_counter;
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -346,6 +346,9 @@ io_check_error(unsigned char reason, str
>  	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
>  	show_registers(regs);
>  
> +	if (panic_on_io_nmi)
> +		panic("NMI IOCK error: Not continuing");
> +
>  	/* Re-enable the IOCK line, wait for a few seconds */
>  	reason = (reason & 0xf) | 8;
>  	outb(reason, 0x61);
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -303,6 +303,7 @@ extern int oops_in_progress;		/* If set,
>  extern int panic_timeout;
>  extern int panic_on_oops;
>  extern int panic_on_unrecovered_nmi;
> +extern int panic_on_io_nmi;
>  extern const char *print_tainted(void);
>  extern void add_taint(unsigned flag);
>  extern int test_taint(unsigned flag);
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -163,6 +163,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74,
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_PANIC_ON_IO_NMI=77, /* int: whether we will panic on an io NMI */
>  };
>  
>  
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -744,6 +744,14 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> +		.ctl_name	= KERN_PANIC_ON_IO_NMI,
> +		.procname	= "panic_on_io_nmi",
> +		.data		= &panic_on_io_nmi,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +	{
>  		.ctl_name	= KERN_BOOTLOADER_TYPE,
>  		.procname	= "bootloader_type",
>  		.data		= &bootloader_type,
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -104,6 +104,7 @@ static const struct trans_ctl_table tran
>  	{ KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>  	{ KERN_NMI_WATCHDOG,		"nmi_watchdog" },
>  	{ KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> +	{ KERN_PANIC_ON_IO_NMI,		"panic_on_io_nmi" },
>  	{}
>  };
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
