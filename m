Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYEKTw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYEKTw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYEKTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:52:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43250 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYEKTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=woyySooOghkwpcwh7J7tHPnr/HQwqtTk2msmYk7NiOJbb5npzc3a208TCxnveQeHZN4bdTTZuJnZZTgBJO1gWeFABTIx0/5PfQBjsn5oUt8aDbIUOkBX5yqtKY8tX7nlDnbQNUFtbVq17hdy9QGhybzVNfbMhQNJjT9CmR0SDNc=
Date: Sun, 11 May 2008 21:52:23 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: fix meaning of tea5767_autodetection
Message-ID: <20080511195219.GC19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) tea5767_autodetection should return negative values on errors
2) tuner_probe should check only for zero/non-zero

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
compile tested only
---
 drivers/media/common/tuners/tea5767.c |    6 +++---
 drivers/media/video/tuner-core.c      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/tea5767.c b/drivers/media/common/tuners/tea5767.c
--- a/drivers/media/common/tuners/tea5767.c
+++ b/drivers/media/common/tuners/tea5767.c
@@ -373,14 +373,14 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 
 	if ((rc = tuner_i2c_xfer_recv(&i2c, buffer, 7))< 5) {
 		printk(KERN_WARNING "It is not a TEA5767. Received %i bytes.\n", rc);
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	/* If all bytes are the same then it's a TV tuner and not a tea5767 */
 	if (buffer[0] == buffer[1] && buffer[0] == buffer[2] &&
 	    buffer[0] == buffer[3] && buffer[0] == buffer[4]) {
 		printk(KERN_WARNING "All bytes are equal. It is not a TEA5767\n");
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	/*  Status bytes:
@@ -390,7 +390,7 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	 */
 	if (((buffer[3] & 0x0f) != 0x00) || (buffer[4] != 0x00)) {
 		printk(KERN_WARNING "Chip ID is not zero. It is not a TEA5767\n");
-		return EINVAL;
+		return -EINVAL;
 	}
 
 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1181,7 +1181,7 @@ static int tuner_probe(struct i2c_client *client,
 		case 0x60:
 			if (tuner_symbol_probe(tea5767_autodetection,
 					       t->i2c->adapter, t->i2c->addr)
-					!= EINVAL) {
+					== 0) {
 				t->type = TUNER_TEA5767;
 				t->mode_mask = T_RADIO;
 				t->mode = T_STANDBY;
-- 
