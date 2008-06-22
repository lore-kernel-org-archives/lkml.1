Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYFVOT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYFVOT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYFVOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:19:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYFVOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:19:20 -0400
To: mchehab@infradead.org
Subject: [PATCH] saa7146: ->cpu_addr and friends are little-endian
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQPX-0001xO-Ia@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:19:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Annotations + stop saa7146_i2c from playing fast and loose with
reuse of ->cpu_addr for host-endian.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/common/saa7146_core.c  |    4 ++--
 drivers/media/common/saa7146_hlp.c   |    2 +-
 drivers/media/common/saa7146_i2c.c   |   34 +++++++++++++++++-----------------
 drivers/media/common/saa7146_video.c |    4 ++--
 include/media/saa7146.h              |    4 ++--
 5 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 89c7660..d01965e 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -233,7 +233,7 @@ void saa7146_pgtable_free(struct pci_dev *pci, struct saa7146_pgtable *pt)
 
 int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 {
-	u32          *cpu;
+	__le32       *cpu;
 	dma_addr_t   dma_addr;
 
 	cpu = pci_alloc_consistent(pci, PAGE_SIZE, &dma_addr);
@@ -250,7 +250,7 @@ int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt,
 	struct scatterlist *list, int sglen  )
 {
-	u32 *ptr, fill;
+	__le32 *ptr, fill;
 	int nr_pages = 0;
 	int i,p;
 
diff --git a/drivers/media/common/saa7146_hlp.c b/drivers/media/common/saa7146_hlp.c
index 9c90539..05bde9c 100644
--- a/drivers/media/common/saa7146_hlp.c
+++ b/drivers/media/common/saa7146_hlp.c
@@ -338,7 +338,7 @@ static void calculate_clipping_registers_rect(struct saa7146_dev *dev, struct sa
 	struct saa7146_video_dma *vdma2, u32* clip_format, u32* arbtr_ctrl, enum v4l2_field field)
 {
 	struct saa7146_vv *vv = dev->vv_data;
-	u32 *clipping = vv->d_clipping.cpu_addr;
+	__le32 *clipping = vv->d_clipping.cpu_addr;
 
 	int width = fh->ov.win.w.width;
 	int height =  fh->ov.win.w.height;
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 35b01ec..c11da4d 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -24,7 +24,7 @@ static inline u32 saa7146_i2c_status(struct saa7146_dev *dev)
    sent through the saa7146. have a look at the specifications p. 122 ff
    to understand this. it returns the number of u32s to send, or -1
    in case of an error. */
-static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, u32 *op)
+static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, __le32 *op)
 {
 	int h1, h2;
 	int i, j, addr;
@@ -47,7 +47,7 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, u32 *op)
 	}
 
 	/* be careful: clear out the i2c-mem first */
-	memset(op,0,sizeof(u32)*mem);
+	memset(op,0,sizeof(__le32)*mem);
 
 	/* loop through all messages */
 	for(i = 0; i < num; i++) {
@@ -57,16 +57,16 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, u32 *op)
 		   so we have to perform a translation */
 		addr = (m[i].addr*2) + ( (0 != (m[i].flags & I2C_M_RD)) ? 1 : 0);
 		h1 = op_count/3; h2 = op_count%3;
-		op[h1] |= (	    (u8)addr << ((3-h2)*8));
-		op[h1] |= (SAA7146_I2C_START << ((3-h2)*2));
+		op[h1] |= cpu_to_le32(	    (u8)addr << ((3-h2)*8));
+		op[h1] |= cpu_to_le32(SAA7146_I2C_START << ((3-h2)*2));
 		op_count++;
 
 		/* loop through all bytes of message i */
 		for(j = 0; j < m[i].len; j++) {
 			/* insert the data bytes */
 			h1 = op_count/3; h2 = op_count%3;
-			op[h1] |= ( (u32)((u8)m[i].buf[j]) << ((3-h2)*8));
-			op[h1] |= (       SAA7146_I2C_CONT << ((3-h2)*2));
+			op[h1] |= cpu_to_le32( (u32)((u8)m[i].buf[j]) << ((3-h2)*8));
+			op[h1] |= cpu_to_le32(       SAA7146_I2C_CONT << ((3-h2)*2));
 			op_count++;
 		}
 
@@ -75,9 +75,9 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, u32 *op)
 	/* have a look at the last byte inserted:
 	  if it was: ...CONT change it to ...STOP */
 	h1 = (op_count-1)/3; h2 = (op_count-1)%3;
-	if ( SAA7146_I2C_CONT == (0x3 & (op[h1] >> ((3-h2)*2))) ) {
-		op[h1] &= ~(0x2 << ((3-h2)*2));
-		op[h1] |= (SAA7146_I2C_STOP << ((3-h2)*2));
+	if ( SAA7146_I2C_CONT == (0x3 & (le32_to_cpu(op[h1]) >> ((3-h2)*2))) ) {
+		op[h1] &= ~cpu_to_le32(0x2 << ((3-h2)*2));
+		op[h1] |= cpu_to_le32(SAA7146_I2C_STOP << ((3-h2)*2));
 	}
 
 	/* return the number of u32s to send */
@@ -88,7 +88,7 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, u32 *op)
    which bytes were read through the adapter and write them back to the corresponding
    i2c-message. but instead, we simply write back all bytes.
    fixme: this could be improved. */
-static int saa7146_i2c_msg_cleanup(const struct i2c_msg *m, int num, u32 *op)
+static int saa7146_i2c_msg_cleanup(const struct i2c_msg *m, int num, __le32 *op)
 {
 	int i, j;
 	int op_count = 0;
@@ -101,7 +101,7 @@ static int saa7146_i2c_msg_cleanup(const struct i2c_msg *m, int num, u32 *op)
 		/* loop throgh all bytes of message i */
 		for(j = 0; j < m[i].len; j++) {
 			/* write back all bytes that could have been read */
-			m[i].buf[j] = (op[op_count/3] >> ((3-(op_count%3))*8));
+			m[i].buf[j] = (le32_to_cpu(op[op_count/3]) >> ((3-(op_count%3))*8));
 			op_count++;
 		}
 	}
@@ -174,7 +174,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 /* this functions writes out the data-byte 'dword' to the i2c-device.
    it returns 0 if ok, -1 if the transfer failed, -2 if the transfer
    failed badly (e.g. address error) */
-static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_delay)
+static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int short_delay)
 {
 	u32 status = 0, mc2 = 0;
 	int trial = 0;
@@ -186,7 +186,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 	if( 0 != (SAA7146_USE_I2C_IRQ & dev->ext->flags)) {
 
 		saa7146_write(dev, I2C_STATUS,	 dev->i2c_bitrate);
-		saa7146_write(dev, I2C_TRANSFER, *dword);
+		saa7146_write(dev, I2C_TRANSFER, le32_to_cpu(*dword));
 
 		dev->i2c_op = 1;
 		SAA7146_ISR_CLEAR(dev, MASK_16|MASK_17);
@@ -209,7 +209,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 		status = saa7146_read(dev, I2C_STATUS);
 	} else {
 		saa7146_write(dev, I2C_STATUS,	 dev->i2c_bitrate);
-		saa7146_write(dev, I2C_TRANSFER, *dword);
+		saa7146_write(dev, I2C_TRANSFER, le32_to_cpu(*dword));
 		saa7146_write(dev, MC2, (MASK_00 | MASK_16));
 
 		/* do not poll for i2c-status before upload is complete */
@@ -282,7 +282,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 	}
 
 	/* read back data, just in case we were reading ... */
-	*dword = saa7146_read(dev, I2C_TRANSFER);
+	*dword = cpu_to_le32(saa7146_read(dev, I2C_TRANSFER));
 
 	DEB_I2C(("after: 0x%08x\n",*dword));
 	return 0;
@@ -291,7 +291,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *msgs, int num, int retries)
 {
 	int i = 0, count = 0;
-	u32* buffer = dev->d_i2c.cpu_addr;
+	__le32 *buffer = dev->d_i2c.cpu_addr;
 	int err = 0;
 	int address_err = 0;
 	int short_delay = 0;
@@ -376,7 +376,7 @@ out:
 	/* another bug in revision 0: the i2c-registers get uploaded randomly by other
 	   uploads, so we better clear them out before continueing */
 	if( 0 == dev->revision ) {
-		u32 zero = 0;
+		__le32 zero = 0;
 		saa7146_i2c_reset(dev);
 		if( 0 != saa7146_i2c_writeout(dev, &zero, short_delay)) {
 			INFO(("revision 0 error. this should never happen.\n"));
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 3cbc6eb..a5e6275 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -605,8 +605,8 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 		struct saa7146_pgtable *pt1 = &buf->pt[0];
 		struct saa7146_pgtable *pt2 = &buf->pt[1];
 		struct saa7146_pgtable *pt3 = &buf->pt[2];
-		u32  *ptr1, *ptr2, *ptr3;
-		u32 fill;
+		__le32  *ptr1, *ptr2, *ptr3;
+		__le32 fill;
 
 		int size = buf->fmt->width*buf->fmt->height;
 		int i,p,m1,m2,m3,o1,o2;
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 88b2b5a..2f68f4c 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -53,7 +53,7 @@ struct saa7146_vv;
 /* saa7146 page table */
 struct saa7146_pgtable {
 	unsigned int	size;
-	u32		*cpu;
+	__le32		*cpu;
 	dma_addr_t	dma;
 	/* used for offsets for u,v planes for planar capture modes */
 	unsigned long	offset;
@@ -101,7 +101,7 @@ struct saa7146_extension
 struct saa7146_dma
 {
 	dma_addr_t	dma_handle;
-	u32		*cpu_addr;
+	__le32		*cpu_addr;
 };
 
 struct saa7146_dev
-- 
1.5.3.GIT


