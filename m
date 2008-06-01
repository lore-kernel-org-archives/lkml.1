Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYFAMyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYFAMyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 08:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYFAMy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 08:54:27 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:47858 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbYFAMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 08:54:26 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-fbdev-devel@lists.sourceforge.net
Subject: [VIDEO] vfb: only enable if explicitly requested when compiled in
Date: Sun, 1 Jun 2008 14:54:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011454.23123.elendil@planet.nl>
X-OriginalArrivalTime: 01 Jun 2008 12:54:23.0705 (UTC) FILETIME=[9DC77C90:01C8C3E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

The Kconfig help for the vfb driver says:
   Do NOT enable it for normal systems! To protect the innocent, it
   has to be enabled explicitly at boot time using the kernel option
   `video=vfb:'.
    
This change lets the code match the description.
    
Support for vfb:disable is kept for backwards compatibility; vfb:off
works because it is tested at a higher level.
    
Signed-off-by: Frans Pop <elendil@planet.nl>
CC: Antonino A. Daplas <adaplas@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>

---
Note: any undefined option (e.g. vfb:enable) will also enable this driver.

The relevant code has been unchanged since before the migration to
git (2.6.12).

This patch fixes bugzilla #9310 and was the root cause behind
http://lkml.org/lkml/2008/5/31/220.

My confusion stemmed from the fact that I was still assuming that the
Kconfig help would be correct (even though Antonino had already
determined it was not: http://lkml.org/lkml/2007/10/14/25, but somehow
my brain never parsed that).


diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 072638a..51e935f 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -443,19 +443,29 @@ static int vfb_mmap(struct fb_info *info,
 }
 
 #ifndef MODULE
+/*
+ * The virtual framebuffer driver is only enabled if explicitly
+ * requested by passing 'video=vfb:' (or any actual options).
+ */
 static int __init vfb_setup(char *options)
 {
 	char *this_opt;
 
-	vfb_enable = 1;
+	vfb_enable = 0;
 
-	if (!options || !*options)
+	if (!options)
+		return 1;
+
+	vfb_enable = 1;
+
+	if (!*options)
 		return 1;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if (!strncmp(this_opt, "disable", 7))
+		/* Test disable for backwards compatibility */
+		if (!strcmp(this_opt, "disable"))
 			vfb_enable = 0;
 	}
 	return 1;
