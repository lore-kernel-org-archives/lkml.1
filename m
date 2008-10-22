Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYJVMT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYJVMT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYJVMTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:19:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYJVMTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:19:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some compilation warnings (was: Re: [announce] new tree: "fix all build warnings, on all configs")
Date: Wed, 22 Oct 2008 14:23:42 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20081017171139.GA1792@elte.hu> <200810212137.58020.rjw@sisk.pl> <alpine.LFD.1.10.0810220008050.2984@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810220008050.2984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810221423.44216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 22 of October 2008, Len Brown wrote:
> 
> > >   drivers/acpi/sleep/main.c:67: warning: ‘acpi_pm_disable_gpes’ defined but not used
> 
> > > 
> > > Shows that this code has an identity crisis due to a maze of #ifdefs, in
> > > the PM_SLEEP && !SUSPEND && !HIBERNATION case for example.
> > 
> > This case is invalid, because PM_SLEEP == SUSPEND || HIBERNATION !
> 
> I though so too, but 2.6.27 appears to have added XEN to the mix:
> 
> config PM_SLEEP
>         bool
>         depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE

Yeah, which breaks things. :-(

The patch below should fix it and BTW I think ACPI_SLEEP should not depend
on XEN_SAVE_RESTORE anyway, so this is a bug fix really (please consider as
.28 material, probably -stable too).

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some compilation warnings

Initially CONFIG_PM_SLEEP was defined as
CONFIG_SUSPEND || CONFIG_HIBERNATION and some ACPI code, most
importantly the code in drivers/acpi/main.c, was written with this
assumption.  Currently, however, CONFIG_PM_SLEEP is also set when
CONFIG_XEN_SAVE_RESTORE is set.

This causes some compilation warnings to appear in
drivers/acpi/main.c if both CONFIG_SUSPEND and CONFIG_HIBERNATION
are unset and CONFIG_PM_SLEEP is set (this was impossible before).
To fix this problem, redefine CONFIG_ACPI_SLEEP do depend directly
on CONFIG_SUSPEND || CONFIG_HIBERNATION, as originally intended, and
use it instead of CONFIG_PM_SLEEP in drivers/acpi/main.c, wherever
appropriate.

Additionally, move the acpi_target_sleep_state definition from under
the #ifdef to prevent compilation from failing in some cases. 

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/Kconfig      |    2 +-
 drivers/acpi/sleep/main.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -42,7 +42,7 @@ if ACPI
 
 config ACPI_SLEEP
 	bool
-	depends on PM_SLEEP
+	depends on SUSPEND || HIBERNATION
 	default y
 
 config ACPI_PROCFS
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -23,6 +23,7 @@
 #include "sleep.h"
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
+static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
 static int acpi_sleep_prepare(u32 acpi_state)
 {
@@ -45,9 +46,7 @@ static int acpi_sleep_prepare(u32 acpi_s
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static u32 acpi_target_sleep_state = ACPI_STATE_S0;
-
+#ifdef CONFIG_ACPI_SLEEP
 /*
  * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
  * user to request that behavior by using the 'acpi_old_suspend_ordering'
@@ -132,7 +131,7 @@ static void acpi_pm_end(void)
 	 */
 	acpi_target_sleep_state = ACPI_STATE_S0;
 }
-#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
 extern void do_suspend_lowlevel(void);
