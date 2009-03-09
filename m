Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZCIWtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZCIWtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZCIWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:49:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:58341 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZCIWtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:49:32 -0400
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090306114149.GA5371@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch>
	 <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch>
	 <1236333440.7260.136.camel@pasglop>  <20090306114149.GA5371@soziologie.ch>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 09:49:00 +1100
Message-Id: <1236638940.7260.193.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please also test this patch...

Cheers,
Ben.

radeonfb/aty128fb: Disabled broken early resume hack for PowerBooks

radeonfb and aty128fb have a special hook called by the PowerMac platform
code very very early on resume from sleep to bring the screen back. This
is useful for debugging wakup problems, but unfortunately, this also became
a source of problems of its own.

The hook is called extremely early, with interrupts still off, and the code
path involved with that code nowadays rely on things like taking mutexes,
GFP_KERNEL allocations, etc...

In addition, the driver now relies on the PCI core to restore the standard
config space before calling resume which doesn't happen with this early
code path.

I'm keeping the code in but commented out along with a fixup call to
pci_restore_state(). The reason is that I still want to make it easy to
re-enable temporarily to track wake up problems, and it's possible that
I can revive it at some stage if we make sleeping things save to call
in early resume using a system state.

In the meantime, this should fix several reported regressions.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/drivers/video/aty/radeon_pm.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_pm.c	2009-03-10 09:38:25.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_pm.c	2009-03-10 09:40:51.000000000 +1100
@@ -2762,12 +2762,13 @@ int radeonfb_pci_resume(struct pci_dev *
 	return rc;
 }
 
-#ifdef CONFIG_PPC_OF
+#ifdef CONFIG_PPC_OF__disabled
 static void radeonfb_early_resume(void *data)
 {
         struct radeonfb_info *rinfo = data;
 
 	rinfo->no_schedule = 1;
+	pci_restore_state(rinfo->pdev);
 	radeonfb_pci_resume(rinfo->pdev);
 	rinfo->no_schedule = 0;
 }
@@ -2834,7 +2835,14 @@ void radeonfb_pm_init(struct radeonfb_in
 		 */
 		if (rinfo->pm_mode != radeon_pm_none) {
 			pmac_call_feature(PMAC_FTR_DEVICE_CAN_WAKE, rinfo->of_node, 0, 1);
+#if 0 /* Disable the early video resume hack for now as it's causing problems, among
+       * others we now rely on the PCI core restoring the config space for us, which
+       * isn't the case with that hack, and that code path causes various things to
+       * be called with interrupts off while they shouldn't. I'm leaving the code in
+       * as it can be useful for debugging purposes
+       */
 			pmac_set_early_video_resume(radeonfb_early_resume, rinfo);
+#endif
 		}
 
 #if 0
Index: linux-work/drivers/video/aty/aty128fb.c
===================================================================
--- linux-work.orig/drivers/video/aty/aty128fb.c	2009-03-10 09:41:21.000000000 +1100
+++ linux-work/drivers/video/aty/aty128fb.c	2009-03-10 09:41:44.000000000 +1100
@@ -1853,13 +1853,14 @@ static void aty128_bl_exit(struct backli
  *  Initialisation
  */
 
-#ifdef CONFIG_PPC_PMAC
+#ifdef CONFIG_PPC_PMAC__disabled
 static void aty128_early_resume(void *data)
 {
         struct aty128fb_par *par = data;
 
 	if (try_acquire_console_sem())
 		return;
+	pci_restore_state(par->pdev);
 	aty128_do_resume(par->pdev);
 	release_console_sem();
 }
@@ -1907,7 +1908,14 @@ static int __devinit aty128_init(struct 
 		/* Indicate sleep capability */
 		if (par->chip_gen == rage_M3) {
 			pmac_call_feature(PMAC_FTR_DEVICE_CAN_WAKE, NULL, 0, 1);
+#if 0 /* Disable the early video resume hack for now as it's causing problems, among
+       * others we now rely on the PCI core restoring the config space for us, which
+       * isn't the case with that hack, and that code path causes various things to
+       * be called with interrupts off while they shouldn't. I'm leaving the code in
+       * as it can be useful for debugging purposes
+       */
 			pmac_set_early_video_resume(aty128_early_resume, par);
+#endif
 		}
 
 		/* Find default mode */


