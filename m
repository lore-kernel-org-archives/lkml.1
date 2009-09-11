Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZIKPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZIKPuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZIKPuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:50:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:15690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZIKPuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w3KbOcaernz0cnbNtJGNNkXc5g2PLBiFVwBb3SuBeLIpwxOx+G/9ZVaYAQjBBU54+J
         wl0FYfRErjaZFeITNytUsxzq6SOGu8GXGR7E9AsUkSxdhbUSBfC5gu4clso7S30xXW+M
         OEdh8QvHElBxnF1IdLLbbKIWmlu2jfHMf1G+k=
From: janboe <janboe.ye@gmail.com>
To: dwmw2@infradead.org, jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, janboe <janboe.ye@gmail.com>
Subject: [PATCH] tuner-xc2028: remove variable length array
Date: Fri, 11 Sep 2009 23:49:51 +0800
Message-Id: <1252684191-22623-1-git-send-email-janboe.ye@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using variable length array on kernel stack is not safe, so this patch
using kmalloc instead variable length array in tuner-xc2028

Signed-off-by: janboe <janboe.ye@gmail.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   30 +++++++++++++++++----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 1adce9f..3b5c60d 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -516,8 +516,8 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			 v4l2_std_id *id)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
-	int                pos, rc;
-	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
+	int                pos, rc, ret = -EINVAL;
+	unsigned char      *p, *endp, *buf;
 
 	tuner_dbg("%s called\n", __func__);
 
@@ -532,6 +532,9 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 
 	p = priv->firm[pos].ptr;
 	endp = p + priv->firm[pos].size;
+	buf = kmalloc(priv->ctrl.max_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	while (p < endp) {
 		__u16 size;
@@ -539,14 +542,16 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		/* Checks if there's enough bytes to read */
 		if (p + sizeof(size) > endp) {
 			tuner_err("Firmware chunk size is wrong\n");
-			return -EINVAL;
+			goto fail;
 		}
 
 		size = le16_to_cpu(*(__u16 *) p);
 		p += sizeof(size);
 
-		if (size == 0xffff)
-			return 0;
+		if (size == 0xffff) {
+			ret = 0;
+			goto fail;
+		}
 
 		if (!size) {
 			/* Special callback command received */
@@ -554,7 +559,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			if (rc < 0) {
 				tuner_err("Error at RESET code %d\n",
 					   (*p) & 0x7f);
-				return -EINVAL;
+				goto fail;
 			}
 			continue;
 		}
@@ -565,13 +570,13 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 				if (rc < 0) {
 					tuner_err("Error at RESET code %d\n",
 						  (*p) & 0x7f);
-					return -EINVAL;
+					goto fail;
 				}
 				break;
 			default:
 				tuner_info("Invalid RESET code %d\n",
 					   size & 0x7f);
-				return -EINVAL;
+				goto fail;
 
 			}
 			continue;
@@ -586,7 +591,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		if ((size + p > endp)) {
 			tuner_err("missing bytes: need %d, have %d\n",
 				   size, (int)(endp - p));
-			return -EINVAL;
+			goto fail;
 		}
 
 		buf[0] = *p;
@@ -603,14 +608,17 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			rc = i2c_send(priv, buf, len + 1);
 			if (rc < 0) {
 				tuner_err("%d returned from send\n", rc);
-				return -EINVAL;
+				goto fail;
 			}
 
 			p += len;
 			size -= len;
 		}
 	}
-	return 0;
+	ret = 0;
+fail:
+	kfree(buf);
+	return ret;
 }
 
 static int load_scode(struct dvb_frontend *fe, unsigned int type,
-- 
1.6.3.3

