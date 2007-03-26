Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXCZU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXCZU6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXCZU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:58:31 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:18704 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbXCZU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:58:28 -0400
Date: Mon, 26 Mar 2007 22:58:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070326205825.GB8722@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/kernel/kprobes.c       |    2 +-
 drivers/s390/block/dasd_diag.c   |   10 +++---
 drivers/s390/cio/device_status.c |    6 +++-
 drivers/s390/crypto/ap_bus.c     |   30 +++++++++++--------
 include/asm-s390/checksum.h      |   59 +++++++++----------------------------
 5 files changed, 43 insertions(+), 64 deletions(-)

Cornelia Huck (1):
      [S390] cio: Device status validity.

David Wilder (1):
      [S390] kprobes: Align probe address.

Heiko Carstens (1):
      [S390] Fix TCP/UDP pseudo header checksum computation.

Peter Oberparleiter (1):
      [S390] dasd: Work around gcc bug.

Ralph Wuerthner (2):
      [S390] zcrypt: Fix possible dead lock in AP bus module.
      [S390] zcrypt: Fix ap_poll_requests counter in lost requests error path.

diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 8af549e..993f353 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -167,7 +167,7 @@ static int __kprobes swap_instruction(void *aref)
 	 * shall not cross any page boundaries (vmalloc area!) when writing
 	 * the new instruction.
 	 */
-	addr = (u32 *)ALIGN((unsigned long)args->ptr, 4);
+	addr = (u32 *)((unsigned long)args->ptr & -4UL);
 	if ((unsigned long)args->ptr & 2)
 		instr = ((*addr) & 0xffff0000) | args->new;
 	else
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index ab782bb..e810e4a 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -65,7 +65,7 @@ static const u8 DASD_DIAG_CMS1[] = { 0xc3, 0xd4, 0xe2, 0xf1 };/* EBCDIC CMS1 */
  * resulting condition code and DIAG return code. */
 static inline int dia250(void *iob, int cmd)
 {
-	register unsigned long reg0 asm ("0") = (unsigned long) iob;
+	register unsigned long reg2 asm ("2") = (unsigned long) iob;
 	typedef union {
 		struct dasd_diag_init_io init_io;
 		struct dasd_diag_rw_io rw_io;
@@ -74,15 +74,15 @@ static inline int dia250(void *iob, int cmd)
 
 	rc = 3;
 	asm volatile(
-		"	diag	0,%2,0x250\n"
+		"	diag	2,%2,0x250\n"
 		"0:	ipm	%0\n"
 		"	srl	%0,28\n"
-		"	or	%0,1\n"
+		"	or	%0,3\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
 		: "+d" (rc), "=m" (*(addr_type *) iob)
-		: "d" (cmd), "d" (reg0), "m" (*(addr_type *) iob)
-		: "1", "cc");
+		: "d" (cmd), "d" (reg2), "m" (*(addr_type *) iob)
+		: "3", "cc");
 	return rc;
 }
 
diff --git a/drivers/s390/cio/device_status.c b/drivers/s390/cio/device_status.c
index 6b1caea..25d99bd 100644
--- a/drivers/s390/cio/device_status.c
+++ b/drivers/s390/cio/device_status.c
@@ -263,7 +263,11 @@ ccw_device_accumulate_irb(struct ccw_device *cdev, struct irb *irb)
 		cdev_irb->scsw.cpa = irb->scsw.cpa;
 	/* Accumulate device status, but not the device busy flag. */
 	cdev_irb->scsw.dstat &= ~DEV_STAT_BUSY;
-	cdev_irb->scsw.dstat |= irb->scsw.dstat;
+	/* dstat is not always valid. */
+	if (irb->scsw.stctl &
+	    (SCSW_STCTL_PRIM_STATUS | SCSW_STCTL_SEC_STATUS
+	     | SCSW_STCTL_INTER_STATUS | SCSW_STCTL_ALERT_STATUS))
+		cdev_irb->scsw.dstat |= irb->scsw.dstat;
 	/* Accumulate subchannel status. */
 	cdev_irb->scsw.cstat |= irb->scsw.cstat;
 	/* Copy residual count if it is valid. */
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 181b517..bf37cdf 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -505,6 +505,9 @@ static int ap_device_remove(struct device *dev)
 	spin_lock_bh(&ap_device_lock);
 	list_del_init(&ap_dev->list);
 	spin_unlock_bh(&ap_device_lock);
+	spin_lock_bh(&ap_dev->lock);
+	atomic_sub(ap_dev->queue_count, &ap_poll_requests);
+	spin_unlock_bh(&ap_dev->lock);
 	return 0;
 }
 
@@ -757,10 +760,16 @@ static void ap_scan_bus(struct work_struct *unused)
 				      (void *)(unsigned long)qid,
 				      __ap_scan_bus);
 		rc = ap_query_queue(qid, &queue_depth, &device_type);
-		if (dev && rc) {
-			put_device(dev);
-			device_unregister(dev);
-			continue;
+		if (dev) {
+			ap_dev = to_ap_dev(dev);
+			spin_lock_bh(&ap_dev->lock);
+			if (rc || ap_dev->unregistered) {
+				spin_unlock_bh(&ap_dev->lock);
+				put_device(dev);
+				device_unregister(dev);
+				continue;
+			} else
+				spin_unlock_bh(&ap_dev->lock);
 		}
 		if (dev) {
 			put_device(dev);
@@ -861,6 +870,7 @@ static int ap_poll_read(struct ap_device *ap_dev, unsigned long *flags)
 	case AP_RESPONSE_NO_PENDING_REPLY:
 		if (status.queue_empty) {
 			/* The card shouldn't forget requests but who knows. */
+			atomic_sub(ap_dev->queue_count, &ap_poll_requests);
 			ap_dev->queue_count = 0;
 			list_splice_init(&ap_dev->pendingq, &ap_dev->requestq);
 			ap_dev->requestq_count += ap_dev->pendingq_count;
@@ -994,7 +1004,7 @@ void ap_queue_message(struct ap_device *ap_dev, struct ap_message *ap_msg)
 			ap_dev->unregistered = 1;
 	} else {
 		ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
-		rc = 0;
+		rc = -ENODEV;
 	}
 	spin_unlock_bh(&ap_dev->lock);
 	if (rc == -ENODEV)
@@ -1044,18 +1054,12 @@ static void ap_poll_timeout(unsigned long unused)
  */
 static int __ap_poll_all(struct ap_device *ap_dev, unsigned long *flags)
 {
-	int rc;
-
 	spin_lock(&ap_dev->lock);
 	if (!ap_dev->unregistered) {
-		rc = ap_poll_queue(ap_dev, flags);
-		if (rc)
+		if (ap_poll_queue(ap_dev, flags))
 			ap_dev->unregistered = 1;
-	} else
-		rc = 0;
+	}
 	spin_unlock(&ap_dev->lock);
-	if (rc)
-		device_unregister(&ap_dev->device);
 	return 0;
 }
 
diff --git a/include/asm-s390/checksum.h b/include/asm-s390/checksum.h
index 0a3cd7e..d5a8e7c 100644
--- a/include/asm-s390/checksum.h
+++ b/include/asm-s390/checksum.h
@@ -121,50 +121,21 @@ csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
                    unsigned short len, unsigned short proto,
                    __wsum sum)
 {
-#ifndef __s390x__
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += saddr */
-		"	brc	12,0f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"0:"
-		: "+&d" (sum) : "d" (saddr) : "cc");
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += daddr */
-		"	brc	12,1f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"1:"
-		: "+&d" (sum) : "d" (daddr) : "cc");
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += len + proto */
-		"	brc	12,2f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"2:"
-		: "+&d" (sum)
-		: "d" (len + proto)
-		: "cc");
-#else /* __s390x__ */
-	asm volatile(
-		"	lgfr	%0,%0\n"
-		"	algr	%0,%1\n"  /* sum += saddr */
-		"	brc	12,0f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"0:	algr	%0,%2\n"  /* sum += daddr */
-		"	brc	12,1f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"1:	algfr	%0,%3\n"  /* sum += len + proto */
-		"	brc	12,2f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"2:	srlg	0,%0,32\n"
-		"	alr	%0,0\n"   /* fold to 32 bits */
-		"	brc	12,3f\n"
-		"	ahi	%0,1\n"   /* add carry */
-		"3:	llgfr	%0,%0"
-		: "+&d" (sum)
-		: "d" (saddr), "d" (daddr),
-		  "d" (len + proto)
-		: "cc", "0");
-#endif /* __s390x__ */
-	return sum;
+	__u32 csum = (__force __u32)sum;
+
+	csum += (__force __u32)saddr;
+	if (csum < (__force __u32)saddr)
+		csum++;
+
+	csum += (__force __u32)daddr;
+	if (csum < (__force __u32)daddr)
+		csum++;
+
+	csum += len + proto;
+	if (csum < len + proto)
+		csum++;
+
+	return (__force __wsum)csum;
 }
 
 /*
