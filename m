Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbZGQAIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbZGQAIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbZGQAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39117 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933684AbZGQAFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 06/21] Blackfin: fix silent crash when no uClinux MTD filesystem exists
Date: Thu, 16 Jul 2009 20:05:31 -0400
Message-Id: <1247789146-18786-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Since we need to relocate the attached filesystem with the uClinux MTD map
(to handle some anomalies), we need to know its real filesize.  If we boot
a kernel without a filesystem actually attached, we end up blindly reading
and copying garbage (since there is no magic value to detect validity).
Often times this results in an early crash and no output.  So add a few
basic sanity checks before operating on things to catch the majority of
cases.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6e150d9..e4d2da7 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -568,17 +568,23 @@ static __init void memory_setup(void)
 #  endif				/* ANOMALY_05000263 */
 # endif				/* CONFIG_ROMFS_FS */
 
-	memory_end -= mtd_size;
-
-	if (mtd_size == 0) {
-		console_init();
-		panic("Don't boot kernel without rootfs attached.");
+	/* Since the default MTD_UCLINUX has no magic number, we just blindly
+	 * read 8 past the end of the kernel's image, and look at it.
+	 * When no image is attached, mtd_size is set to a random number
+	 * Do some basic sanity checks before operating on things
+	 */
+	if (mtd_size == 0 || memory_end <= mtd_size) {
+		pr_emerg("Could not find valid ram mtd attached.\n");
+	} else {
+		memory_end -= mtd_size;
+
+		/* Relocate MTD image to the top of memory after the uncached memory area */
+		uclinux_ram_map.phys = memory_mtd_start = memory_end;
+		uclinux_ram_map.size = mtd_size;
+		pr_info("Found mtd parition at 0x%p, (len=0x%lx), moving to 0x%p\n",
+			_end, mtd_size, (void *)memory_mtd_start);
+		dma_memcpy((void *)uclinux_ram_map.phys, _end, uclinux_ram_map.size);
 	}
-
-	/* Relocate MTD image to the top of memory after the uncached memory area */
-	uclinux_ram_map.phys = memory_mtd_start = memory_end;
-	uclinux_ram_map.size = mtd_size;
-	dma_memcpy((void *)uclinux_ram_map.phys, _end, uclinux_ram_map.size);
 #endif				/* CONFIG_MTD_UCLINUX */
 
 #if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-- 
1.6.3.3

