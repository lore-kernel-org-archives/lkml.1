Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYE1QZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYE1QZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYE1QZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:25:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:44299 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYE1QZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i91Ia4PP58E5EcN6e0sJEmF0xepyKPrvbm/oQ1rxpeSo24ajgxgINvWrhKh9WBxjJcPf19/PsxwNsjgc7pFej3n40Rl2trcAup6MfkRpP3K2J8UbMWl294QDweGSxePZAQ/8aqr0abid4x/E9lJ3Tq46S49Y4eDHTk4joBmPOd8=
Date: Wed, 28 May 2008 20:25:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
	of apic_write
Message-ID: <20080528162527.GB6910@cvg>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com> <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl> <20080528160413.GA6910@cvg> <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, May 28, 2008 at 05:13:08PM +0100]
| On Wed, 28 May 2008, Cyrill Gorcunov wrote:
| 
| > Could you take a look please on
| > 
| > http://lkml.org/lkml/2008/5/26/146
| > 
| > i'm investigateting what is happening (Adrian pointed on
| > main reason I think) but can't understand why is that.
| 
|  Do you have a link with the patch included?
| 
|   Maciej
| 

Here is the patch itself:

---
x86: nmi_32.c - add nmi_watchdog_default helper

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:01:21.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 13:04:20.000000000 +0400
@@ -51,6 +51,17 @@ static DEFINE_PER_CPU(short, wd_enabled)
 
 static int endflag __initdata = 0;
 
+/* Run after command line and cpu_init init, but before all other checks */
+void nmi_watchdog_default(void)
+{
+	if (nmi_watchdog != NMI_DEFAULT)
+		return;
+	if (lapic_watchdog_ok())
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else
+		nmi_watchdog = NMI_IO_APIC;
+}
+
 #ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
@@ -437,12 +448,8 @@ int proc_nmi_enabled(struct ctl_table *t
 		return -EIO;
 	}
 
-	if (nmi_watchdog == NMI_DEFAULT) {
-		if (lapic_watchdog_ok())
-			nmi_watchdog = NMI_LOCAL_APIC;
-		else
-			nmi_watchdog = NMI_IO_APIC;
-	}
+	/* if nmi_watchdog is not set yet, then set it */
+	nmi_watchdog_default();
 
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
 		if (nmi_watchdog_enabled)
Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-05-24 13:00:50.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-05-24 13:04:51.000000000 +0400
@@ -38,11 +38,9 @@ static inline void unset_nmi_pm_callback
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
-extern void nmi_watchdog_default(void);
-#else
-#define nmi_watchdog_default() do {} while (0)
 #endif
 
+extern void nmi_watchdog_default(void);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
---

So I've moved a part of code (32bit) from proc_nmi_enabled() to
nmi_watchdog_default() BUT this nmi_watchdog_default() also called
from smpboot.c:native_smp_prepare_cpus() and before this patch
this call was just an empty call (and eliminated by gcc I think)
now it's not empy. But how it leads to hang I can't understand.
The only thing is done - nmi_watchdog is set to NMI_LOCAL_APIC
or NMI_IO_APIC and my only suspicious is that something happens
asynchronously and leads to machine hang. Let me know if I wrote
in obscure manner.

		- Cyrill -
