Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZAET0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZAET0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZAET03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:26:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:3757 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZAET02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:26:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jcG+dXSq+77+zrJu3pDnDQOvIT+kvEOwf6cL1jN0PryPBfV0wkM+TtuJv0+7SfyVRH
         LU0Q/gk+ZGLUxSojin92qKTXgHX47br/caLL1maUozrP3BG7eIkwy7EE2Blg5BdaXo3n
         8Rv4CelJwgshDOK6U9QvTmnCuYZ1AJ0XzlfS8=
Subject: [PATCH] mflash: remove small byteswapping function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: unsik Kim <donari75@gmail.com>
Cc: Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105111321.7d210c01@lxorguk.ukuu.org.uk>
References: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com>
	 <20090105023346.GE6115@zakalwe.fi>
	 <20090105111321.7d210c01@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 11:26:25 -0800
Message-Id: <1231183585.11902.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byteswap as we read in the data rather than having a
byteswap in place function that is only used once.

MG_SECTOR_SIZE >> 1 == 256 so this should be a no-op.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Also, you always call mg_ide_fixstring with byteswap == 1,
I'd suggest removing that parameter and doing it unconditionally.

 drivers/block/mg_disk.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 24edc9a..116f2a3 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -141,20 +141,6 @@ static irqreturn_t mg_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void mg_fix_disk_id(u16 *id)
-{
-#ifndef __LITTLE_ENDIAN
-# ifdef __BIG_ENDIAN
-	int i;
-
-	for (i = 0; i < 256; i++)
-		id[i] = __le16_to_cpu(id[i]);
-# else
-#  error "Please fix <asm/byteorder.h>"
-# endif
-#endif
-}
-
 static void mg_ide_fixstring(u8 *s, const int bytecount, const int byteswap)
 {
 	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
@@ -194,12 +180,11 @@ static int mg_get_disk_id(struct mg_host *host)
 	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
 	if (!err) {
 		for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
-			id[i] = inw(host->dev_base + MG_BUFF_OFFSET + i * 2);
+			id[i] = le16_to_cpu(inw(host->dev_base + MG_BUFF_OFFSET + i * 2));
 
 		outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
 		err = mg_wait(host, MG_STAT_READY, 3000);
 		if (!err) {
-			mg_fix_disk_id(id);
 			if ((host->id_data.field_valid & 1) == 0) {
 				err = MG_ERR_TRANSLATION;
 			} else {
-- 
1.6.1.71.gd5e04



