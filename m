Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYEZSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYEZSkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYEZSkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:40:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbYEZSkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:40:01 -0400
Date: Mon, 26 May 2008 20:40:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: aperture_64.c: duplicated code, buggy?
Message-ID: <20080526184047.GA13706@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

void __init early_gart_iommu_check(void)

contains

	for (num = 24; num < 32; num++) {
		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
			continue;

loop, with very similar loop duplicated in

void __init gart_iommu_hole_init(void)

. First copy of a loop seems to be buggy, too. It uses 0 as a "nothing
set" value, which may actually bite us in last_aper_enabled case
(because it may be often zero).

(Beware, it is hard to test this patch, because this code has about
2^8 different code paths, depending on hardware and cmdline settings).

Plus, the second loop does not check for consistency of
aper_enabled. Should it?

---

early_gart_iommu_check(void) uses 0 as a "nothing set" value, which
may actually bite us in last_aper_enabled case (because it may be
often zero).

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 4a3d8cf..2088b6a 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -241,11 +242,12 @@ void __init early_gart_iommu_check(void)
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base = 0, last_aper_base = 0;
-	int aper_enabled = 0, last_aper_enabled = 0;
+	int aper_enabled = 0, last_aper_enabled = 0, last_valid = 0;
 
 	if (!early_pci_allowed())
 		return;
 
+	/* This is mostly duplicate of iommu_hole_init */
 	fix = 0;
 	for (num = 24; num < 32; num++) {
 		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
@@ -258,15 +260,17 @@ void __init early_gart_iommu_check(void)
 		aper_base = read_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 		aper_base <<= 25;
 
-		if ((last_aper_order && aper_order != last_aper_order) ||
-		    (last_aper_base && aper_base != last_aper_base) ||
-		    (last_aper_enabled && aper_enabled != last_aper_enabled)) {
-			fix = 1;
-			break;
-		}
+		if (last_valid)
+			if ((aper_order != last_aper_order) ||
+			    (aper_base != last_aper_base) ||
+			    (aper_enabled != last_aper_enabled)) {
+				fix = 1;
+				break;
+			}
 		last_aper_order = aper_order;
 		last_aper_base = aper_base;
 		last_aper_enabled = aper_enabled;
+		last_valid = 1;
 	}
 
 	if (!fix && !aper_enabled)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
