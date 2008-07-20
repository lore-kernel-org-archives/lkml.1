Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYGTWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYGTWQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYGTWO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:14:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:38190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbYGTWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:14:55 -0400
Date: Sun, 20 Jul 2008 15:13:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [patch 3/4] fastboot: make the raid autodetect code wait for all
 devices to init
Message-ID: <20080720151339.6f4a83d8@infradead.org>
In-Reply-To: <20080720151140.4aa7c682@infradead.org>
References: <20080720151140.4aa7c682@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 20 Jul 2008 13:07:09 -0700
Subject: [PATCH] fastboot: make the raid autodetect code wait for all devices to init

The raid autodetect code really needs to have all devices probed before
it can detect raid arrays; not doing so would give rather messy situations
where arrays would get detected as degraded while they shouldn't be etc.

This is in preparation of removing the "wait for everything to init"
code that makes everyone pay, not just raid users.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 init/do_mounts_md.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 693d246..c0412a9 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -267,9 +267,16 @@ __setup("md=", md_setup);
 void __init md_run_setup(void)
 {
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
+
 	if (raid_noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
 	else {
+		/*
+		 * Since we don't want to detect and use half a raid array, we
+		 * need to wait for the known devices to complete their probing
+		 */
+		while (driver_probe_done() != 0)
+			msleep(100);
 		int fd = sys_open("/dev/md0", 0, 0);
 		if (fd >= 0) {
 			sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-- 
1.5.5.1

