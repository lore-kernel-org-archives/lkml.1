Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXBSUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXBSUOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXBSUOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:14:38 -0500
Received: from mta13.mail.adelphia.net ([68.168.78.44]:65239 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbXBSUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:14:37 -0500
Date: Mon, 19 Feb 2007 14:14:35 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
Message-ID: <20070219201434.GA19172@localdomain>
Reply-To: minyard@acm.org
References: <20070214201257.GD5364@localdomain> <20070214195718.e78458cf.akpm@linux-foundation.org> <17875.56356.396676.239952@cargo.ozlabs.ibm.com> <20070214201632.a7f18794.akpm@linux-foundation.org> <45D480FB.4030503@acm.org> <20070215142124.4a6733fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215142124.4a6733fc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 02:21:24PM -0800, Andrew Morton wrote:
> On Thu, 15 Feb 2007 09:49:15 -0600
> Corey Minyard <minyard@acm.org> wrote:
> 
> > So I see the following options besides what's already there:
> > 
> > 1) add asm/kdebug.h and DIE_NMI_POST to everything that might have an 
> > IPMI implementation.
> > 2) use CONFIG_X86 to tell if NMI will work, since that's the only thing 
> > it will work on at the present.
> > 
> > I don't have any way to know how different systems have implemented that 
> > feature, so I can't actually implement it for the various architectures 
> > (plus I don't have any of those boards).  So maybe #2 is the best?
> 
> I tend to think that #1 is the best option - it keeps things consistent
> and it gives arch/board maintainers a framework in which to add the
> support code at their leisure.   But it's something which would be best
> worked through with the affected arch maintainers, please.
> 
> Which architectures are we talking about here?  ia64 and ppc?


Reduce the "gruesomness" of the IPMI NMI watchdog handling.

Basically, I've looked at this and thought about it a while, and
the only reasonable architecture that will currently support this
is x86.  Anything else is just a pipe dream and the implementation
would be quite different and difficult to predict.  So just make
this x86-only for now and remove all the junk that is no longer
necessary.

Suitable for merging into the previous patch.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.20/arch/i386/Kconfig.debug
===================================================================
--- linux-2.6.20.orig/arch/i386/Kconfig.debug
+++ linux-2.6.20/arch/i386/Kconfig.debug
@@ -4,10 +4,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HAVE_STANDARD_NOTIFY_DIE
-	bool
-	default y
-
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
Index: linux-2.6.20/arch/x86_64/Kconfig.debug
===================================================================
--- linux-2.6.20.orig/arch/x86_64/Kconfig.debug
+++ linux-2.6.20/arch/x86_64/Kconfig.debug
@@ -4,10 +4,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HAVE_STANDARD_NOTIFY_DIE
-	bool
-	default y
-
 source "lib/Kconfig.debug"
 
 config DEBUG_RODATA
Index: linux-2.6.20/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.20.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6.20/drivers/char/ipmi/ipmi_watchdog.c
@@ -51,8 +51,17 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <asm/atomic.h>
-#ifdef CONFIG_HAVE_STANDARD_NOTIFY_DIE
+
+#ifdef CONFIG_X86
+/* This is ugly, but I've determined that x86 is the only architecture
+   that can reasonably support the IPMI NMI watchdog timeout at this
+   time.  If another architecture adds this capability somehow, it
+   will have to be a somewhat different mechanism and I have no idea
+   how it will work.  So in the unlikely event that another
+   architecture supports this, we can figure out a good generic
+   mechanism for it at that time. */
 #include <asm/kdebug.h>
+#define HAVE_DIE_NMI_POST
 #endif
 
 #define	PFX "IPMI Watchdog: "
@@ -364,6 +373,10 @@ static int i_ipmi_set_timeout(struct ipm
 	int                               hbnow = 0;
 
 
+	/* These can be cleared as we are setting the timeout. */
+	ipmi_start_timer_on_heartbeat = 0;
+	pretimeout_since_last_heartbeat = 0;
+
 	data[0] = 0;
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
@@ -438,13 +451,12 @@ static int ipmi_set_timeout(int do_heart
 
 	wait_for_completion(&set_timeout_wait);
 
+	mutex_unlock(&set_timeout_lock);
+
 	if ((do_heartbeat == IPMI_SET_TIMEOUT_FORCE_HB)
 	    || ((send_heartbeat_now)
 		&& (do_heartbeat == IPMI_SET_TIMEOUT_HB_IF_NECESSARY)))
-	{
 		rv = ipmi_heartbeat();
-	}
-	mutex_unlock(&set_timeout_lock);
 
 out:
 	return rv;
@@ -524,12 +536,10 @@ static int ipmi_heartbeat(void)
 	int                               rv;
 	struct ipmi_system_interface_addr addr;
 
-	if (ipmi_ignore_heartbeat) {
+	if (ipmi_ignore_heartbeat)
 		return 0;
-	}
 
 	if (ipmi_start_timer_on_heartbeat) {
-		ipmi_start_timer_on_heartbeat = 0;
 		ipmi_watchdog_state = action_val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 	} else if (pretimeout_since_last_heartbeat) {
@@ -537,7 +547,6 @@ static int ipmi_heartbeat(void)
 		   We don't want to set the action, though, we want to
 		   leave that alone (thus it can't be combined with the
 		   above operation. */
-		pretimeout_since_last_heartbeat = 0;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 	}
 
Index: linux-2.6.20/include/asm-i386/kdebug.h
===================================================================
--- linux-2.6.20.orig/include/asm-i386/kdebug.h
+++ linux-2.6.20/include/asm-i386/kdebug.h
@@ -42,8 +42,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-#define HAVE_DIE_NMI_POST
-
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
Index: linux-2.6.20/include/asm-x86_64/kdebug.h
===================================================================
--- linux-2.6.20.orig/include/asm-x86_64/kdebug.h
+++ linux-2.6.20/include/asm-x86_64/kdebug.h
@@ -37,8 +37,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-#define HAVE_DIE_NMI_POST
-
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
