Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbXHCVus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbXHCVus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762003AbXHCVum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:50:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125AbXHCVul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:50:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION
Date: Fri, 3 Aug 2007 23:59:36 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708032359.37677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
(1) not all architectures support suspend and (2) SMP hibernation is only
possible on X86 and PPC64 (if PPC64_SWSUSP is set).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig	2007-07-30 07:58:48.000000000 +0200
+++ linux-2.6/kernel/power/Kconfig	2007-08-03 23:29:57.000000000 +0200
@@ -74,7 +74,8 @@ config PM_TRACE
 
 config SUSPEND_SMP_POSSIBLE
 	bool
-	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
+	depends on (X86 && !X86_VOYAGER) \
+		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM
 	depends on SMP
 	default y
 
@@ -92,7 +93,8 @@ config PM_SLEEP
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM
-	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	depends on SUSPEND_SMP_POSSIBLE || ((BLACKFIN || MIPS || SUPERH || FRV \
+		    || (PPC32 && PPC_MPC52xx)) && !SMP)
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
@@ -102,7 +104,8 @@ config SUSPEND
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP
-	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
+	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) \
+		   || ((X86 || PPC64_SWSUSP) && SUSPEND_SMP_POSSIBLE)
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
