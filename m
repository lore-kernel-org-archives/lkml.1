Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbXJNFCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbXJNFCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXJNFCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:02:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbXJNFCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:02:37 -0400
X-Greylist: delayed 935 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 01:02:36 EDT
Date: Sat, 13 Oct 2007 23:46:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] ssb: Fix regression in 2.6.23-git3 due to change in
 calling add_uevent_var
Message-ID: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7eff2e7a8b65c25920207324e56611150eb1cd9a, the calling sequence
for add_uevent_var was changed, but the ssb driver was not modified, which
leads to a "Unable to handle kernel paging request" oops. This patch fixes
the problem.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/ssb/main.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/ssb/main.c
===================================================================
--- linux-2.6.orig/drivers/ssb/main.c
+++ linux-2.6/drivers/ssb/main.c
@@ -320,22 +320,17 @@ static int ssb_bus_match(struct device *
 	return 0;
 }
 
-static int ssb_device_uevent(struct device *dev, char **envp, int num_envp,
-			     char *buffer, int buffer_size)
+static int ssb_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
-	int ret, i = 0, length = 0;
+	int ret;
 
 	if (!dev)
 		return -ENODEV;
 
-	ret = add_uevent_var(envp, num_envp, &i,
-			     buffer, buffer_size, &length,
-			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
+	ret = add_uevent_var(env, "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
 			     ssb_dev->id.revision);
-	envp[i] = NULL;
-
 	return ret;
 }
 
