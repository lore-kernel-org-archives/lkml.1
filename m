Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYE3OpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYE3OpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYE3OpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:45:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:36015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYE3OpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MjSdQseizWWce7dsCiYJQqmvgSljZ1XSQFb9BTrrcpA3NrnnmI8zSDl/QFU6rZx7vfqEz42k4+aV06TQMAUTF1/OKeszB/yvxQ6RZ0MIU+ATXZsqCThVvRP9tmlKNdIB+4eZIfGOkSQzYW2smyngTZDsnUnnFILQTWWhEJpNgrk=
Date: Fri, 30 May 2008 18:44:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default
Message-ID: <20080530144449.GA6979@cvg>
References: <20080528190047.GE6910@cvg> <20080530125359.GA11667@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530125359.GA11667@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, May 30, 2008 at 02:54:00PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > +extern void nmi_watchdog_default(void);
| > +#else
| > +#define nmi_watchdog_default(void) do {} while (0)
|                                   ^------
| 
| that doesnt work too well in a macro ... :-)
| 
| 	Ingo
| 

Oh my.... maybe two prerocessor passes would help? ;-)
here is an updated version, please reapply, and thanks a lot
for catching this Ingo! Sorry for inconvenience.

		- Cyrill -
---

Subject: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default

Commit

commit 4b82b277707a39b97271439c475f186f63ec4692
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Sat May 24 19:36:35 2008 +0400

sets nmi_watchdog to NMI_IO_APIC as by default value
even not being asking to. That causes hangs on some
machines with buggy watchdogs. Fix it - i.e. restore
old behaviour.

Thanks to Sitsofe Wheeler and Adrian Bunk for catching
the problem and Maciej W. Rozycki for explanation what
is going on there.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Maciej W. Rozycki <macro@linux-mips.org>
---

Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-05-28 22:32:38.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-05-28 22:40:48.000000000 +0400
@@ -84,20 +84,15 @@ static inline unsigned int get_timer_irq
 #endif
 }
 
+#ifdef CONFIG_X86_64
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
 	if (nmi_watchdog != NMI_DEFAULT)
 		return;
-#ifdef CONFIG_X86_64
 	nmi_watchdog = NMI_NONE;
-#else
-	if (lapic_watchdog_ok())
-		nmi_watchdog = NMI_LOCAL_APIC;
-	else
-		nmi_watchdog = NMI_IO_APIC;
-#endif
 }
+#endif
 
 #ifdef CONFIG_SMP
 /*
@@ -488,8 +483,15 @@ int proc_nmi_enabled(struct ctl_table *t
 		return -EIO;
 	}
 
+#ifdef CONFIG_X86_64
 	/* if nmi_watchdog is not set yet, then set it */
 	nmi_watchdog_default();
+#else
+	if (lapic_watchdog_ok())
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else
+		nmi_watchdog = NMI_IO_APIC;
+#endif
 
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
 		if (nmi_watchdog_enabled)
Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-05-28 22:32:41.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-05-28 22:39:55.000000000 +0400
@@ -38,9 +38,11 @@ static inline void unset_nmi_pm_callback
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
+extern void nmi_watchdog_default(void);
+#else
+#define nmi_watchdog_default() do {} while (0)
 #endif
 
-extern void nmi_watchdog_default(void);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
