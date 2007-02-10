Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXBJMBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXBJMBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933417AbXBJLvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXBJLuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:46 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: "Bryan O'Sullivan" <bos@pathscale.com>, Andi Kleen <ak@suse.de>,
       Roland Dreier <rolandd@cisco.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [22/25] x86_64: use memcpy_uncached_read() in RDMA interrupt handler to reduce packet loss
Message-Id: <20070210115035.7683213DCE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Bryan O'Sullivan" <bos@pathscale.com>

In cases where a large incoming RDMA is being received, we have to copy data
inside the interrupt handler before we can ACK each packet.  The source is
DMAed to by the hardware, which means that the CPU won't have it cached.  We
only read the source this one time; using normal load instructions pollutes
the dcache with useless data, reducing performance to the point where we can
lose a significant number of packets.

We use memcpy_uncached_read to try to not fill the dcache with useless data. 
Avoiding the cache refill penalty lets us keep up better with the sender,
resulting in many fewer dropped packets.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ipath/ipath_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/infiniband/hw/ipath/ipath_verbs.c
===================================================================
--- linux.orig/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ linux/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -167,7 +167,7 @@ void ipath_copy_sge(struct ipath_sge_sta
 		BUG_ON(len == 0);
 		if (len > length)
 			len = length;
-		memcpy(sge->vaddr, data, len);
+		memcpy_uncached_read(sge->vaddr, data, len);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
