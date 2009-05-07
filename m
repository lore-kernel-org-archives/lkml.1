Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZEGPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZEGPuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZEGPuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:50:07 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:16481 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZEGPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:50:05 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KJA6MS-04-NUQ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: fix cpu buffer size
Date: Thu, 7 May 2009 17:47:47 +0200
Message-ID: <1241711267-16534-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
X-OriginalArrivalTime: 07 May 2009 15:49:42.0988 (UTC) FILETIME=[7035B0C0:01C9CF2B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unit of oprofile_cpu_buffer_size is in samples, but was allocated
in bytes. This led to the allocation of too small cpu buffers. This
patch recalculates the buffer size in bytes taking also the
ring_buffer_event header size into account.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index f0e99d4..242257b 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -78,16 +78,20 @@ void free_cpu_buffers(void)
 	op_ring_buffer_write = NULL;
 }
 
+#define RB_EVENT_HDR_SIZE 4
+
 int alloc_cpu_buffers(void)
 {
 	int i;
 
 	unsigned long buffer_size = oprofile_cpu_buffer_size;
+	unsigned long byte_size = buffer_size * (sizeof(struct op_sample) +
+						 RB_EVENT_HDR_SIZE);
 
-	op_ring_buffer_read = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	op_ring_buffer_read = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
 	if (!op_ring_buffer_read)
 		goto fail;
-	op_ring_buffer_write = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	op_ring_buffer_write = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
 	if (!op_ring_buffer_write)
 		goto fail;
 
-- 
1.6.1.3


