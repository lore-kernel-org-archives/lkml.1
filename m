Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZFWFwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZFWFwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZFWFwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:52:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbZFWFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:52:03 -0400
Date: Mon, 22 Jun 2009 22:51:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] printk: add printk_delay to make messages readable for
 some  scenarios
Message-Id: <20090622225154.61a95f60.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0906160154r3c7ab4d4u378efe4f5545e077@mail.gmail.com>
References: <a8e1da0906160154r3c7ab4d4u378efe4f5545e077@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 16:54:12 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> When syslog is not possible, at the same time there's no serial/net console
> available, it will be hard to read the printk messages.
> For example oops/panic/warning messages in shutdown phase.
> 
> Here add a printk delay feature, we can make each printk message
> delay some milliseconds.
> 
> Setting the delay by proc/sysctl interface: /proc/sys/kernel/printk_delay
> 
> The value range from 0 - 10000, default value is 0
> 

Seems OK(ish).

> ---
> Documentation/sysctl/kernel.txt |    8 ++++++++
> include/linux/kernel.h          |    2 ++
> include/linux/sysctl.h          |    1 +
> kernel/printk.c                 |   14 ++++++++++++++
> kernel/sysctl.c                 |   12 ++++++++++++
> 5 files changed, 37 insertions(+)
> 
> --- linux-2.6.orig/kernel/printk.c	2009-06-16 11:07:15.000000000 +0800
> +++ linux-2.6/kernel/printk.c	2009-06-16 11:31:01.000000000 +0800
> @@ -638,6 +638,19 @@ static int recursion_bug;
>  static int new_text_line = 1;
>  static char printk_buf[1024];
> 
> +int printk_delay_msec;
> +
> +static inline void printk_delay(void)
> +{
> +	if (unlikely(printk_delay_msec)) {
> +		int m = printk_delay_msec;
> +		while (m--) {
> +			mdelay(1);
> +			touch_nmi_watchdog();
> +		}
> +	}
> +}
> +
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  {
>  	int printed_len = 0;
> @@ -647,6 +660,7 @@ asmlinkage int vprintk(const char *fmt,
>  	char *p;
> 
>  	boot_delay_msec();
> +	printk_delay();
> 
>  	preempt_disable();
>  	/* This stops the holder of console_sem just where we want him */
> --- linux-2.6.orig/include/linux/kernel.h	2009-04-18 19:48:06.000000000 +0800
> +++ linux-2.6/include/linux/kernel.h	2009-06-16 11:24:43.000000000 +0800
> @@ -243,6 +243,8 @@ extern int printk_ratelimit(void);
>  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  				   unsigned int interval_msec);
> 
> +extern int printk_delay_msec;
> +

Sigh.

It's pretty dumb to clutter up kernel.h just because we want to share a
declaration with sysctl.c.  And it was pretty dumb to fill sysctl.c with
extern declarations.

What we should do is to create a new header file which contains all the
declarations which sysctl.c needs.  Include that from within sysctl.c
and all .c files which which to share declarations with sysctl.c.

But that's all a matter for another patchset.

>  /*
>   * Print a one-time message (analogous to WARN_ONCE() et al):
>   */
> --- linux-2.6.orig/kernel/sysctl.c	2009-06-15 10:33:11.000000000 +0800
> +++ linux-2.6/kernel/sysctl.c	2009-06-16 11:29:52.000000000 +0800
> @@ -102,6 +102,7 @@ static int __maybe_unused one = 1;
>  static int __maybe_unused two = 2;
>  static unsigned long one_ul = 1;
>  static int one_hundred = 100;
> +static int ten_thousand = 10000;
> 
>  /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
>  static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
> @@ -699,6 +700,17 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +	{
> +		.ctl_name	= KERN_PRINTK_DELAY,
> +		.procname	= "printk_delay",
> +		.data		= &printk_delay_msec,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,
> +		.extra1		= &zero,
> +		.extra2		= &ten_thousand,
> +	},
>  #endif

See that endif there?  If CONFIG_PRINTK=n, we'll get an unused-var
warning for `ten_thousand'.  Another sysctl.c wart.  I'll fix it.

>  	{
>  		.ctl_name	= KERN_NGROUPS_MAX,
> --- linux-2.6.orig/include/linux/sysctl.h	2009-04-09 16:23:01.000000000 +0800
> +++ linux-2.6/include/linux/sysctl.h	2009-06-16 12:30:14.000000000 +0800
> @@ -163,6 +163,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74,
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_PRINTK_DELAY = 77,	/* int: tune printk delay*/

No, we don't do this any more.  I'll fix that too.

Please retest the result.


diff -puN include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
+++ a/include/linux/sysctl.h
@@ -163,7 +163,6 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
-	KERN_PRINTK_DELAY = 77,	/* int: tune printk delay*/
 };
 
 
--- a/kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
+++ a/kernel/sysctl.c
@@ -103,7 +103,9 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+#ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
+#endif
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -710,7 +712,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_PRINTK_DELAY,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "printk_delay",
 		.data		= &printk_delay_msec,
 		.maxlen		= sizeof(int),
_

