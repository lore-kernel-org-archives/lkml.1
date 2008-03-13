Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYCMKOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYCMKOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYCMKLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35281 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbYCMKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:44 -0400
Date: Thu, 13 Mar 2008 11:05:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ak@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: fix aperture vs. suspend problem
Message-ID: <20080313100531.GA3399@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aperture_64.c takes a piece of memory and makes it into iommu
window... but such window may not be saved by swsusp -- that leads to
oops during suspend.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 608152a..88747f3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -18,6 +18,7 @@ #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
+#include <linux/suspend.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/gart.h>
@@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, __pa(p));
 	insert_aperture_resource((u32)__pa(p), aper_size);
+	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
 
 	return (u32)__pa(p);
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
