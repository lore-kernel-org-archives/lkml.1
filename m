Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYADQSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYADQSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYADQR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:17:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63552 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYADQRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:17:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:mime-version:content-type:from;
        b=HD9R6PhTNtb3skN0bV0U8Q9l7eaSSzqO2w5Yutr6B0r9zav6XQICfJ8AQZxjdUpXcvnsxmmNMKzjMWZcKXOk6JkBhc+mEweCmSqqKJHL8xoiAcbc12t7QAR0NLZZde04wg3G/Fvpb87eaJjnuvdQMQhI6qR10tQlpY0R2HMsx/E=
Date: Fri, 4 Jan 2008 21:47:34 +0530 (IST)
X-X-Sender: madhul@localhost
To: linux-scsi@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bsg : Add support for io vectors in bsg
Message-ID: <Pine.LNX.4.64.0801042137350.7836@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Deepak Colluru <deepakrc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Colluru <deepakrc@gmail.com>

Add support for io vectors in bsg.

Signed-off-by: Deepak Colluru <deepakrc@gmail.com>
---
  bsg.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
  1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8e181ab..78f47ed 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -245,7 +245,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
  	struct request_queue *q = bd->queue;
  	struct request *rq, *next_rq = NULL;
  	int ret, rw;
-	unsigned int dxfer_len;
+	unsigned int dxfer_len, iovec_count = 0;
  	void *dxferp = NULL;

  	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
@@ -281,7 +281,31 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
  		rq->next_rq = next_rq;

  		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
+		iovec_count = hdr->din_iovec_count;
+		dxfer_len = hdr->din_xfer_len;
+
+		if (iovec_count) {
+			const int size = sizeof(struct sg_iovec) * iovec_count;
+			struct sg_iovec *iov;
+
+			iov = kmalloc(size, GFP_KERNEL);
+			if (!iov) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			if (copy_from_user(iov, dxferp, size)) {
+				kfree(iov);
+				ret = -EFAULT;
+				goto out;
+			}
+			ret = blk_rq_map_user_iov(q, rq, iov, iovec_count,
+								dxfer_len);
+			kfree(iov);
+		} else {
+			ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		}
+
  		if (ret)
  			goto out;
  	}
@@ -289,14 +313,36 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
  	if (hdr->dout_xfer_len) {
  		dxfer_len = hdr->dout_xfer_len;
  		dxferp = (void*)(unsigned long)hdr->dout_xferp;
+		iovec_count = hdr->dout_iovec_count;
  	} else if (hdr->din_xfer_len) {
  		dxfer_len = hdr->din_xfer_len;
  		dxferp = (void*)(unsigned long)hdr->din_xferp;
+		iovec_count = hdr->din_iovec_count;
  	} else
  		dxfer_len = 0;

  	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		if (iovec_count) {
+			const int size = sizeof(struct sg_iovec) * iovec_count;
+			struct sg_iovec *iov;
+
+			iov = kmalloc(size, GFP_KERNEL);
+			if (!iov) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			if (copy_from_user(iov, dxferp, size)) {
+				kfree(iov);
+				ret = -EFAULT;
+				goto out;
+			}
+			ret = blk_rq_map_user_iov(q, rq, iov, iovec_count,
+								dxfer_len);
+			kfree(iov);
+		} else {
+			ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		}
  		if (ret)
  			goto out;
  	}
