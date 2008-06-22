Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYFVOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYFVOVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYFVOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39353 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYFVOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:30 -0400
To: mchehab@infradead.org
Subject: [PATCH] split dvb_ringbuffer dual-use functions
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQf-00023I-J6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:20:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


split the suckers into kernel-memory and user-memory versions,
annotate both properly.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-core/dmxdev.c         |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    8 ++--
 drivers/media/dvb/dvb-core/dvb_ringbuffer.c |   78 ++++++++++++++++++---------
 drivers/media/dvb/dvb-core/dvb_ringbuffer.h |   12 +++--
 drivers/media/dvb/ttpci/av7110.c            |    2 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    2 +-
 drivers/media/dvb/ttpci/av7110_ca.c         |    2 +-
 7 files changed, 69 insertions(+), 37 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index df5bef6..1cf9fcb 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -96,7 +96,7 @@ static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
 		if (avail > todo)
 			avail = todo;
 
-		ret = dvb_ringbuffer_read(src, (u8 *)buf, avail, 1);
+		ret = dvb_ringbuffer_read_user(src, buf, avail);
 		if (ret < 0)
 			break;
 
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 588fbe1..8e5dd7b 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1357,7 +1357,7 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 
 		idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, -1, &fraglen);
 		while (idx != -1) {
-			dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2, 0);
+			dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
 			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
@@ -1438,7 +1438,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 			goto exit;
 		}
 
-		dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2, 0);
+		dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
 		if (connection_id == -1)
 			connection_id = hdr[0];
 		if (hdr[0] == connection_id) {
@@ -1449,8 +1449,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 					fraglen -= 2;
 				}
 
-				if ((status = dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 2,
-								      (u8 *)buf + pktlen, fraglen, 1)) < 0) {
+				if ((status = dvb_ringbuffer_pkt_read_user(&ca->slot_info[slot].rx_buffer, idx, 2,
+								      buf + pktlen, fraglen)) < 0) {
 					goto exit;
 				}
 				pktlen += fraglen;
diff --git a/drivers/media/dvb/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
index 872985b..584bbd1 100644
--- a/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
+++ b/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
@@ -107,35 +107,43 @@ void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf)
 	wake_up(&rbuf->queue);
 }
 
-
-
-ssize_t dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf, size_t len, int usermem)
+ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf, u8 __user *buf, size_t len)
 {
 	size_t todo = len;
 	size_t split;
 
 	split = (rbuf->pread + len > rbuf->size) ? rbuf->size - rbuf->pread : 0;
 	if (split > 0) {
-		if (!usermem)
-			memcpy(buf, rbuf->data+rbuf->pread, split);
-		else
-			if (copy_to_user(buf, rbuf->data+rbuf->pread, split))
-				return -EFAULT;
+		if (copy_to_user(buf, rbuf->data+rbuf->pread, split))
+			return -EFAULT;
 		buf += split;
 		todo -= split;
 		rbuf->pread = 0;
 	}
-	if (!usermem)
-		memcpy(buf, rbuf->data+rbuf->pread, todo);
-	else
-		if (copy_to_user(buf, rbuf->data+rbuf->pread, todo))
-			return -EFAULT;
+	if (copy_to_user(buf, rbuf->data+rbuf->pread, todo))
+		return -EFAULT;
 
 	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
 
 	return len;
 }
 
+void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf, size_t len)
+{
+	size_t todo = len;
+	size_t split;
+
+	split = (rbuf->pread + len > rbuf->size) ? rbuf->size - rbuf->pread : 0;
+	if (split > 0) {
+		memcpy(buf, rbuf->data+rbuf->pread, split);
+		buf += split;
+		todo -= split;
+		rbuf->pread = 0;
+	}
+	memcpy(buf, rbuf->data+rbuf->pread, todo);
+
+	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
+}
 
 
 ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf, size_t len)
@@ -171,8 +179,8 @@ ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf, size_t le
 	return status;
 }
 
-ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
-				int offset, u8* buf, size_t len, int usermem)
+ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf, size_t idx,
+				int offset, u8 __user *buf, size_t len)
 {
 	size_t todo;
 	size_t split;
@@ -187,21 +195,40 @@ ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
 	todo = len;
 	split = ((idx + len) > rbuf->size) ? rbuf->size - idx : 0;
 	if (split > 0) {
-		if (!usermem)
-			memcpy(buf, rbuf->data+idx, split);
-		else
-			if (copy_to_user(buf, rbuf->data+idx, split))
-				return -EFAULT;
+		if (copy_to_user(buf, rbuf->data+idx, split))
+			return -EFAULT;
 		buf += split;
 		todo -= split;
 		idx = 0;
 	}
-	if (!usermem)
-		memcpy(buf, rbuf->data+idx, todo);
-	else
-		if (copy_to_user(buf, rbuf->data+idx, todo))
-			return -EFAULT;
+	if (copy_to_user(buf, rbuf->data+idx, todo))
+		return -EFAULT;
+
+	return len;
+}
 
+ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
+				int offset, u8* buf, size_t len)
+{
+	size_t todo;
+	size_t split;
+	size_t pktlen;
+
+	pktlen = rbuf->data[idx] << 8;
+	pktlen |= rbuf->data[(idx + 1) % rbuf->size];
+	if (offset > pktlen) return -EINVAL;
+	if ((offset + len) > pktlen) len = pktlen - offset;
+
+	idx = (idx + DVB_RINGBUFFER_PKTHDRSIZE + offset) % rbuf->size;
+	todo = len;
+	split = ((idx + len) > rbuf->size) ? rbuf->size - idx : 0;
+	if (split > 0) {
+		memcpy(buf, rbuf->data+idx, split);
+		buf += split;
+		todo -= split;
+		idx = 0;
+	}
+	memcpy(buf, rbuf->data+idx, todo);
 	return len;
 }
 
@@ -266,5 +293,6 @@ EXPORT_SYMBOL(dvb_ringbuffer_empty);
 EXPORT_SYMBOL(dvb_ringbuffer_free);
 EXPORT_SYMBOL(dvb_ringbuffer_avail);
 EXPORT_SYMBOL(dvb_ringbuffer_flush_spinlock_wakeup);
+EXPORT_SYMBOL(dvb_ringbuffer_read_user);
 EXPORT_SYMBOL(dvb_ringbuffer_read);
 EXPORT_SYMBOL(dvb_ringbuffer_write);
diff --git a/drivers/media/dvb/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb/dvb-core/dvb_ringbuffer.h
index 8908262..41f04da 100644
--- a/drivers/media/dvb/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb/dvb-core/dvb_ringbuffer.h
@@ -61,7 +61,7 @@ struct dvb_ringbuffer {
 **     *** read min. 1000, max. <bufsize> bytes ***
 **     avail = dvb_ringbuffer_avail(rbuf);
 **     if (avail >= 1000)
-**         count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize), 0);
+**         count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
 **     else
 **         ...
 **
@@ -114,8 +114,10 @@ extern void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf);
 ** <usermem> specifies whether <buf> resides in user space
 ** returns number of bytes transferred or -EFAULT
 */
-extern ssize_t dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf,
-				   size_t len, int usermem);
+extern ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf,
+				   u8 __user *buf, size_t len);
+extern void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf,
+				   u8 *buf, size_t len);
 
 
 /* write routines & macros */
@@ -157,8 +159,10 @@ extern ssize_t dvb_ringbuffer_pkt_write(struct dvb_ringbuffer *rbuf, u8* buf,
  * <usermem> Set to 1 if <buf> is in userspace.
  * returns Number of bytes read, or -EFAULT.
  */
+extern ssize_t dvb_ringbuffer_pkt_read_user(struct dvb_ringbuffer *rbuf, size_t idx,
+				       int offset, u8 __user *buf, size_t len);
 extern ssize_t dvb_ringbuffer_pkt_read(struct dvb_ringbuffer *rbuf, size_t idx,
-				       int offset, u8* buf, size_t len, int usermem);
+				       int offset, u8 *buf, size_t len);
 
 /**
  * Dispose of a packet in the ring buffer.
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 9f96293..6374922 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -587,7 +587,7 @@ static void gpioirq(unsigned long data)
 		}
 		DVB_RINGBUFFER_SKIP(cibuf, 2);
 
-		dvb_ringbuffer_read(cibuf, av7110->debi_virt, len, 0);
+		dvb_ringbuffer_read(cibuf, av7110->debi_virt, len);
 
 		iwdebi(av7110, DEBINOSWAP, TX_LEN, len, 2);
 		iwdebi(av7110, DEBINOSWAP, IRQ_STATE_EXT, len, 2);
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index ec55a96..184647a 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -269,7 +269,7 @@ int av7110_pes_play(void *dest, struct dvb_ringbuffer *buf, int dlen)
 		return -1;
 	}
 
-	dvb_ringbuffer_read(buf, dest, (size_t) blen, 0);
+	dvb_ringbuffer_read(buf, dest, (size_t) blen);
 
 	dprintk(2, "pread=0x%08lx, pwrite=0x%08lx\n",
 	       (unsigned long) buf->pread, (unsigned long) buf->pwrite);
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index c58e3fc..261135d 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -208,7 +208,7 @@ static ssize_t ci_ll_read(struct dvb_ringbuffer *cibuf, struct file *file,
 		return -EINVAL;
 	DVB_RINGBUFFER_SKIP(cibuf, 2);
 
-	return dvb_ringbuffer_read(cibuf, (u8 *)buf, len, 1);
+	return dvb_ringbuffer_read_user(cibuf, buf, len);
 }
 
 static int dvb_ca_open(struct inode *inode, struct file *file)
-- 
1.5.3.GIT


