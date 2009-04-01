Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbZDAS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbZDAS6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763056AbZDAS6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:58:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51041 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762296AbZDAS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:58:04 -0400
Date: Wed, 1 Apr 2009 19:57:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       pjones@redhat.com
Subject: [PATCH] efifb: Exit if framebuffer address is invalid
Message-ID: <20090401185758.GA16163@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efifb will attempt to ioremap a framebuffer even if its starting address
is 0, failing and causing an ugly backtrace in the process. Exit before
probing if this is the case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Peter Jones <pjones@redhat.com>
---
 drivers/video/efifb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 0c5b9a9..8dea2bc 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -210,12 +210,15 @@ static int __init efifb_probe(struct platform_device *dev)
 	unsigned int size_total;
 	int request_succeeded = 0;
 
-	printk(KERN_INFO "efifb: probing for efifb\n");
-
 	if (!screen_info.lfb_depth)
 		screen_info.lfb_depth = 32;
 	if (!screen_info.pages)
 		screen_info.pages = 1;
+	if (!screen_info.lfb_base) {
+		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
+		return -ENODEV;
+	}
+	printk(KERN_INFO "efifb: probing for efifb\n");
 
 	/* just assume they're all unset if any are */
 	if (!screen_info.blue_size) {

-- 
Matthew Garrett | mjg59@srcf.ucam.org
