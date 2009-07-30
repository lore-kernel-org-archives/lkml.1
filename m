Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZG3PqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZG3PqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZG3PqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:46:04 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51343 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZG3PqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:46:02 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct scatterlist
Date: Thu, 30 Jul 2009 17:37:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301737.23849.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


typedef SG_BUFFER_LIST is removed and its uses are replaced by the use of
struct scatterlist.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/Channel.c    |   42 +++++++++++++-------------------------
 drivers/staging/hv/RingBuffer.c |   27 +++++++++++++------------
 drivers/staging/hv/RingBuffer.h |   13 ++++-------
 3 files changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index be9770e..2938e58 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -773,7 +773,7 @@ VmbusChannelSendPacket(
 	VMPACKET_DESCRIPTOR desc;
 	u32 packetLen = sizeof(VMPACKET_DESCRIPTOR) + BufferLen;
 	u32 packetLenAligned = ALIGN_UP(packetLen, sizeof(u64));
-	SG_BUFFER_LIST bufferList[3];
+	struct scatterlist bufferList[3];
 	u64 alignedData=0;
 
 	DPRINT_ENTER(VMBUS);
@@ -790,14 +790,10 @@ VmbusChannelSendPacket(
 	desc.Length8 = (u16)(packetLenAligned >> 3);
 	desc.TransactionId = RequestId;
 
-	bufferList[0].Data = &desc;
-	bufferList[0].Length = sizeof(VMPACKET_DESCRIPTOR);
-
-	bufferList[1].Data = Buffer;
-	bufferList[1].Length = BufferLen;
-
-	bufferList[2].Data = &alignedData;
-	bufferList[2].Length = packetLenAligned - packetLen;
+	sg_init_table(bufferList,3);
+	sg_set_buf(&bufferList[0], &desc, sizeof(VMPACKET_DESCRIPTOR));
+	sg_set_buf(&bufferList[1], Buffer, BufferLen);
+	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
 
 	ret = RingBufferWrite(
 		&Channel->Outbound,
@@ -841,7 +837,7 @@ VmbusChannelSendPacketPageBuffer(
 	u32 descSize;
 	u32 packetLen;
 	u32 packetLenAligned;
-	SG_BUFFER_LIST bufferList[3];
+	struct scatterlist bufferList[3];
 	u64 alignedData=0;
 
 	DPRINT_ENTER(VMBUS);
@@ -872,14 +868,10 @@ VmbusChannelSendPacketPageBuffer(
 		desc.Range[i].Pfn	 = PageBuffers[i].Pfn;
 	}
 
-	bufferList[0].Data = &desc;
-	bufferList[0].Length = descSize;
-
-	bufferList[1].Data = Buffer;
-	bufferList[1].Length = BufferLen;
-
-	bufferList[2].Data = &alignedData;
-	bufferList[2].Length = packetLenAligned - packetLen;
+	sg_init_table(bufferList,3);
+	sg_set_buf(&bufferList[0], &desc, descSize);
+	sg_set_buf(&bufferList[1], Buffer, BufferLen);
+	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
 
 	ret = RingBufferWrite(
 		&Channel->Outbound,
@@ -922,7 +914,7 @@ VmbusChannelSendPacketMultiPageBuffer(
 	u32 descSize;
 	u32 packetLen;
 	u32 packetLenAligned;
-	SG_BUFFER_LIST bufferList[3];
+	struct scatterlist bufferList[3];
 	u64 alignedData=0;
 	u32 PfnCount = NUM_PAGES_SPANNED(MultiPageBuffer->Offset, MultiPageBuffer->Length);
 
@@ -955,14 +947,10 @@ VmbusChannelSendPacketMultiPageBuffer(
 
 	memcpy(desc.Range.PfnArray, MultiPageBuffer->PfnArray, PfnCount*sizeof(u64));
 
-	bufferList[0].Data = &desc;
-	bufferList[0].Length = descSize;
-
-	bufferList[1].Data = Buffer;
-	bufferList[1].Length = BufferLen;
-
-	bufferList[2].Data = &alignedData;
-	bufferList[2].Length = packetLenAligned - packetLen;
+	sg_init_table(bufferList,3);
+	sg_set_buf(&bufferList[0], &desc, descSize);
+	sg_set_buf(&bufferList[1], Buffer, BufferLen);
+	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
 
 	ret = RingBufferWrite(
 		&Channel->Outbound,
diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index d338ce2..571f9db 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -347,9 +347,9 @@ Description:
 --*/
 static int
 RingBufferWrite(
-	RING_BUFFER_INFO*	OutRingInfo,
-	SG_BUFFER_LIST		SgBuffers[],
-	u32				SgBufferCount
+	RING_BUFFER_INFO *OutRingInfo,
+	struct scatterlist *sglist,
+	u32 sgcount
 	)
 {
 	int i=0;
@@ -357,15 +357,16 @@ RingBufferWrite(
 	u32 byteAvailToRead;
 	u32 totalBytesToWrite=0;
 
+	struct scatterlist *sg;
 	volatile u32 nextWriteLocation;
 	u64 prevIndices=0;
 	unsigned long flags;
 
 	DPRINT_ENTER(VMBUS);
 
-	for (i=0; i < SgBufferCount; i++)
+	for_each_sg(sglist, sg, sgcount, i)
 	{
-		totalBytesToWrite += SgBuffers[i].Length;
+		totalBytesToWrite += sg->length;
 	}
 
 	totalBytesToWrite += sizeof(u64);
@@ -394,21 +395,21 @@ RingBufferWrite(
 	/* Write to the ring buffer */
 	nextWriteLocation = GetNextWriteLocation(OutRingInfo);
 
-	for (i=0; i < SgBufferCount; i++)
+	for_each_sg(sglist, sg, sgcount, i)
 	{
-		 nextWriteLocation = CopyToRingBuffer(OutRingInfo,
-												nextWriteLocation,
-												SgBuffers[i].Data,
-												SgBuffers[i].Length);
+		nextWriteLocation = CopyToRingBuffer(OutRingInfo,
+						     nextWriteLocation,
+						     sg_virt(sg),
+						     sg->length);
 	}
 
 	/* Set previous packet start */
 	prevIndices = GetRingBufferIndices(OutRingInfo);
 
 	nextWriteLocation = CopyToRingBuffer(OutRingInfo,
-												nextWriteLocation,
-												&prevIndices,
-												sizeof(u64));
+					     nextWriteLocation,
+					     &prevIndices,
+					     sizeof(u64));
 
 	/* Make sure we flush all writes before updating the writeIndex */
 	mb();
diff --git a/drivers/staging/hv/RingBuffer.h b/drivers/staging/hv/RingBuffer.h
index a0b6e0e..1658614 100644
--- a/drivers/staging/hv/RingBuffer.h
+++ b/drivers/staging/hv/RingBuffer.h
@@ -25,12 +25,9 @@
 #ifndef _RING_BUFFER_H_
 #define _RING_BUFFER_H_
 
-#include "include/osd.h"
+#include <linux/scatterlist.h>
 
-typedef struct _SG_BUFFER_LIST {
-	void *	Data;
-	u32	Length;
-} SG_BUFFER_LIST;
+#include "include/osd.h"
 
 typedef struct _RING_BUFFER {
     volatile u32	WriteIndex;     /* Offset in bytes from the start of ring data below */
@@ -83,9 +80,9 @@ RingBufferCleanup(
 
 static int
 RingBufferWrite(
-	RING_BUFFER_INFO	*RingInfo,
-	SG_BUFFER_LIST		SgBuffers[],
-	u32				SgBufferCount
+	RING_BUFFER_INFO *RingInfo,
+	struct scatterlist *sglist,
+	u32 sgcount
 	);
 
 static int
-- 
1.6.0.4


-- 
Nicolas Palix
