Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYEZTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYEZTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYEZTQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:16:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37697 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYEZTQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:16:48 -0400
Date: Mon, 26 May 2008 21:17:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: aperture_64.c: corner case wrong
Message-ID: <20080526191730.GA18425@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If 

fix == 0, aper_enabled == 1, gart_fix_e820 == 0

	if (!fix && !aper_enabled)
		return;

	if (gart_fix_e820 && !fix && aper_enabled) {
		if (e820_any_mapped(aper_base, aper_base + aper_size,
				    E820_RAM)) {
			/* reserve it, so we can reuse it in second
kernel */
			printk(KERN_INFO "update e820 for GART\n");
			add_memory_region(aper_base, aper_size,
E820_RESERVED);
			update_e820();
		}
		return;
	}

	/* different nodes have different setting, disable them all atfirst*/

we'll fall back here and disable all the settings, even when they were
all consistent.

What about this? (I hope it compiles...)

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 02f4dba..aa4876a 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -344,14 +323,16 @@ out:
 	if (gart_fix_e820 && !fix && aper_enabled) {
 		if (!e820_all_mapped(aper_base, aper_base + aper_size,
 				    E820_RESERVED)) {
 			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
 		}
-		return;
 	}
 
+	if (!fix)
+		return;
+
 	/* different nodes have different setting, disable them all at first*/
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
