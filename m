Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXCAI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXCAI1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXCAI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:27:33 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:44096 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097AbXCAI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:27:31 -0500
Date: Thu, 1 Mar 2007 17:24:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ben Dooks <ben@fluff.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] fb: sm501fb off-by-1 sysfs store
Message-ID: <20070301082456.GA3701@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ben Dooks <ben@fluff.org.uk>, linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sm501fb_crtsrc_store() won't allow the routing to be changed
via echos from userspace in to the sysfs file. The reason for this is
that the strnicmp() for both heads uses a sizeof() for the string length,
which ends up being strlen() + 1 (\0 in the normal case, but the echo
gives a newline, which is where the issue occurs), this then causes a
mismatch and subsequently bails with the -EINVAL.

In addition to this, the hardcoded lengths were then used for the store
length that was returned, which ended up being erroneous and resulting in
a write error. There's also no point in returning anything but the full
length since it will -EINVAL out on a mismatch well before then anyways.

sizeof("string") is great for making sure you have space in your buffer,
but rather less so for string comparisons :-)

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/video/sm501fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 02b290c..72b5358 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1074,9 +1074,9 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 	if (len < 1)
 		return -EINVAL;
 
-	if (strnicmp(buf, "crt", sizeof("crt")) == 0)
+	if (strnicmp(buf, "crt", 3) == 0)
 		head = HEAD_CRT;
-	else if (strnicmp(buf, "panel", sizeof("panel")) == 0)
+	else if (strnicmp(buf, "panel", 5) == 0)
 		head = HEAD_PANEL;
 	else
 		return -EINVAL;
@@ -1098,7 +1098,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 	writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(info);
 
-	return (head == HEAD_CRT) ? 3 : 5;
+	return len;
 }
 
 /* Prepare the device_attr for registration with sysfs later */
