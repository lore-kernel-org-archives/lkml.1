Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZIKJK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZIKJK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZIKJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:10:58 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:46265 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZIKJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gEQokmKoFOJi2vxm2lPZECQScaLkTEgmuGuZqmcPTFEMpW1zDZK6QS1VEyyzlFqYTu
         gFPZx/w5mAXQssP2ubkQ2qRDxQIumkDyW27+3d8fWqPgJoV5BxYnev6YGxM0TDEYQvKi
         q3BWURh2dV6g1HKWv4tyhQtVUHX9kj1o0Jzs4=
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 17:11:00 +0800
Message-ID: <af3ea28a0909110211o559657e6hc62947708b4fc55d@mail.gmail.com>
Subject: [PATCH] remove variable length array tuner-xc2028
From: ye janboe <janboe.ye@gmail.com>
To: dwmw2@infradead.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi

using variable length array on kernel stack is not safe, so this patch
using kmalloc instead variable length array in tuner-xc2028

Signed-off-by: janboe <janboe.ye@gmail.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c
b/drivers/media/common/tuners/tuner-xc2028.c
index 1adce9f..96259c5 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -516,8 +516,8 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,
 			 v4l2_std_id *id)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
-	int                pos, rc;
-	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
+	int                pos, rc, ret = -EINVAL;
+	unsigned char      *p, *endp, *buf;

 	tuner_dbg("%s called\n", __func__);

@@ -532,6 +532,7 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,

 	p = priv->firm[pos].ptr;
 	endp = p + priv->firm[pos].size;
+	buf = kmalloc(priv->ctrl.max_len, GFP_KERNEL);

 	while (p < endp) {
 		__u16 size;
@@ -539,14 +540,16 @@ static int load_firmware(struct dvb_frontend
*fe, unsigned int type,
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
@@ -554,7 +557,7 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,
 			if (rc < 0) {
 				tuner_err("Error at RESET code %d\n",
 					   (*p) & 0x7f);
-				return -EINVAL;
+				goto fail;
 			}
 			continue;
 		}
@@ -565,13 +568,13 @@ static int load_firmware(struct dvb_frontend
*fe, unsigned int type,
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
@@ -586,7 +589,7 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,
 		if ((size + p > endp)) {
 			tuner_err("missing bytes: need %d, have %d\n",
 				   size, (int)(endp - p));
-			return -EINVAL;
+			goto fail;
 		}

 		buf[0] = *p;
@@ -603,7 +606,7 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,
 			rc = i2c_send(priv, buf, len + 1);
 			if (rc < 0) {
 				tuner_err("%d returned from send\n", rc);
-				return -EINVAL;
+				goto fail;
 			}

 			p += len;
@@ -611,6 +614,9 @@ static int load_firmware(struct dvb_frontend *fe,
unsigned int type,
 		}
 	}
 	return 0;
+fail:
+	kfree(buf);
+	return ret;
 }

 static int load_scode(struct dvb_frontend *fe, unsigned int type,
