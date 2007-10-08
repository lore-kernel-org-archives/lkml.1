Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXJHKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXJHKwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbXJHKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 06:52:12 -0400
Received: from mail.suse.de ([195.135.220.2]:55860 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXJHKwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 06:52:11 -0400
Date: Mon, 8 Oct 2007 12:52:09 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix data access out of array bounds
Message-ID: <20071008105209.GA11453@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix against access random data bytes outside the
dev->chanmap array. Thanks to Oliver Neukum for
pointing me to this issue.
Patch is against 2.6.23-rc9-git6

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/i4l/isdn_common.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index ec5f404..4910bca 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1135,7 +1135,7 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 			if (count > dev->drv[drvidx]->stavail)
 				count = dev->drv[drvidx]->stavail;
 			len = dev->drv[drvidx]->interface->readstat(buf, count,
-						drvidx, isdn_minor2chan(minor));
+				drvidx, isdn_minor2chan(minor - ISDN_MINOR_CTRL));
 			if (len < 0) {
 				retval = len;
 				goto out;
@@ -1207,7 +1207,8 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off
 		 */
 		if (dev->drv[drvidx]->interface->writecmd)
 			retval = dev->drv[drvidx]->interface->
-				writecmd(buf, count, drvidx, isdn_minor2chan(minor));
+				writecmd(buf, count, drvidx,
+				isdn_minor2chan(minor - ISDN_MINOR_CTRL));
 		else
 			retval = count;
 		goto out;



-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
