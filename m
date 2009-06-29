Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbZF2QEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbZF2QEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZF2QE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:04:28 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:52416 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZF2QE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:04:28 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: perex@perex.cz, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] OSS: mpu401, fix deadlock
Date: Mon, 29 Jun 2009 18:03:34 +0200
Message-Id: <1246291414-3563-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If somebody cares about oss at all.
--
mpu401_chk_version is called with a spin lock already held. Don't take it
again.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 sound/oss/mpu401.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index 6c0a770..1b2316f 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -926,31 +926,21 @@ static struct midi_operations mpu401_midi_operations[MAX_MIDI_DEV];
 static void mpu401_chk_version(int n, struct mpu_config *devc)
 {
 	int tmp;
-	unsigned long flags;
 
 	devc->version = devc->revision = 0;
 
-	spin_lock_irqsave(&devc->lock,flags);
-	if ((tmp = mpu_cmd(n, 0xAC, 0)) < 0)
-	{
-		spin_unlock_irqrestore(&devc->lock,flags);
+	tmp = mpu_cmd(n, 0xAC, 0);
+	if (tmp < 0)
 		return;
-	}
 	if ((tmp & 0xf0) > 0x20)	/* Why it's larger than 2.x ??? */
-	{
-		spin_unlock_irqrestore(&devc->lock,flags);
 		return;
-	}
 	devc->version = tmp;
 
-	if ((tmp = mpu_cmd(n, 0xAD, 0)) < 0)
-	{
+	if ((tmp = mpu_cmd(n, 0xAD, 0)) < 0) {
 		devc->version = 0;
-		spin_unlock_irqrestore(&devc->lock,flags);
 		return;
 	}
 	devc->revision = tmp;
-	spin_unlock_irqrestore(&devc->lock,flags);
 }
 
 int attach_mpu401(struct address_info *hw_config, struct module *owner)
-- 
1.6.3.2

