Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXE0Kkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXE0Kkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXE0KkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:40:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33176 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbXE0KkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:40:21 -0400
Date: Sun, 27 May 2007 06:40:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, chas@cmf.nrl.navy.mil
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-atm-general@lists.sourceforge.net
Subject: [PATCH] ATM: fix warning
Message-ID: <20070527104020.GA10665@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The compiler warning

drivers/atm/firestream.c: In function ‘top_off_fp’:
drivers/atm/firestream.c:1505: warning: cast to pointer from integer of different size

does indicate a bug, albeit a minor one.  Fixed, by using a 32-bit
temporary prior to the call to bus_to_virt().

The larger bug is still present:  the entire driver assumes that machine
pointers are 32-bit, as it stores pointers in 32-bit hardware registers.
This is obvious to anyone who knows the driver well, but for the casual
readers it is helpfully noted with FIXME.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 9c67df5..7f6d02c 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1475,6 +1475,7 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
 	struct FS_BPENTRY *qe, *ne;
 	struct sk_buff *skb;
 	int n = 0;
+	u32 qe_tmp;
 
 	fs_dprintk (FS_DEBUG_QUEUE, "Topping off queue at %x (%d-%d/%d)\n", 
 		    fp->offset, read_fs (dev, FP_CNT (fp->offset)), fp->n, 
@@ -1502,10 +1503,16 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
 		ne->skb = skb;
 		ne->fp = fp;
 
-		qe = (struct FS_BPENTRY *) (read_fs (dev, FP_EA(fp->offset)));
-		fs_dprintk (FS_DEBUG_QUEUE, "link at %p\n", qe);
-		if (qe) {
-			qe = bus_to_virt ((long) qe);
+		/*
+		 * FIXME: following code encodes and decodes
+		 * machine pointers (could be 64-bit) into a
+		 * 32-bit register.
+		 */
+
+		qe_tmp = read_fs (dev, FP_EA(fp->offset));
+		fs_dprintk (FS_DEBUG_QUEUE, "link at %x\n", qe_tmp);
+		if (qe_tmp) {
+			qe = bus_to_virt ((long) qe_tmp);
 			qe->next = virt_to_bus(ne);
 			qe->flags &= ~FP_FLAGS_EPI;
 		} else
