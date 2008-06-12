Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYFLNMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYFLNMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761376AbYFLNMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:12:36 -0400
Received: from styx.suse.cz ([82.119.242.94]:60692 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760011AbYFLNMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:12:35 -0400
Date: Thu, 12 Jun 2008 15:12:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] Input: add retry logic to resume with respect to
 CTR
Message-ID: <Pine.LNX.4.64.0806121511290.10085@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are systems that fail in i8042_resume() with

	i8042: Can't write CTR to resume

as i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR) fails even though the
controller claimed itself to be ready before.

One retry after failing write fixes the problems on the failing systems.

Reported-by: Helmut Schaa <hschaa@novell.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/input/serio/i8042.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.25.orig/drivers/input/serio/i8042.c
+++ linux-2.6.25/drivers/input/serio/i8042.c
@@ -938,8 +938,12 @@ static int i8042_resume(struct platform_
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042: Can't write CTR to resume\n");
-		return -EIO;
+		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying ...\n");
+		msleep(50);
+		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
+			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			return -EIO;
+		}
 	}
 
 	if (i8042_mux_present) {

--
1.5.2.4

