Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbXCOWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbXCOWTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCOWTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:17 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33714 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 33] IB/ipath - Change packet problems vs chip errors
	handling and reporting
X-Mercurial-Node: c793dc8a526564b73018924a707bcb21052f8f36
Message-Id: <c793dc8a526564b73018.1173995095@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:55 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994464 25200
# Node ID c793dc8a526564b73018924a707bcb21052f8f36
# Parent  4050989280f08d81d06642e3d6cf5c3ea4397107
IB/ipath - Change packet problems vs chip errors handling and reporting

Some types of packet errors are moderately common with longer IB
cables and large clusters, and are not reported with prints by
other IB HCA drivers.  This suppresses those messages unless the
new __IPATH_ERRPKTDBG bit is set in ipath_debug.  Reporting
of temporarily disabled frequent error interrupts was also made
clearer

We also distinguish between chip errors, and bad packets sent or
received in the wording of the messages.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_debug.h
--- a/drivers/infiniband/hw/ipath/ipath_debug.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_debug.h	Thu Mar 15 14:34:24 2007 -0700
@@ -57,6 +57,7 @@
 #define __IPATH_PROCDBG     0x100
 /* print mmap/nopage stuff, not using VDBG any more */
 #define __IPATH_MMDBG       0x200
+#define __IPATH_ERRPKTDBG   0x400
 #define __IPATH_USER_SEND   0x1000	/* use user mode send */
 #define __IPATH_KERNEL_SEND 0x2000	/* use kernel mode send */
 #define __IPATH_EPKTDBG     0x4000	/* print ethernet packet data */
diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:24 2007 -0700
@@ -754,9 +754,42 @@ static int ipath_wait_linkstate(struct i
 	return (dd->ipath_flags & state) ? 0 : -ETIMEDOUT;
 }
 
-void ipath_decode_err(char *buf, size_t blen, ipath_err_t err)
-{
+/*
+ * Decode the error status into strings, deciding whether to always
+ * print * it or not depending on "normal packet errors" vs everything
+ * else.   Return 1 if "real" errors, otherwise 0 if only packet
+ * errors, so caller can decide what to print with the string.
+ */
+int ipath_decode_err(char *buf, size_t blen, ipath_err_t err)
+{
+	int iserr = 1;
 	*buf = '\0';
+	if (err & INFINIPATH_E_PKTERRS) {
+		if (!(err & ~INFINIPATH_E_PKTERRS))
+			iserr = 0; // if only packet errors.
+		if (ipath_debug & __IPATH_ERRPKTDBG) {
+			if (err & INFINIPATH_E_REBP)
+				strlcat(buf, "EBP ", blen);
+			if (err & INFINIPATH_E_RVCRC)
+				strlcat(buf, "VCRC ", blen);
+			if (err & INFINIPATH_E_RICRC) {
+				strlcat(buf, "CRC ", blen);
+				// clear for check below, so only once
+				err &= INFINIPATH_E_RICRC; 
+			}
+			if (err & INFINIPATH_E_RSHORTPKTLEN)
+				strlcat(buf, "rshortpktlen ", blen);
+			if (err & INFINIPATH_E_SDROPPEDDATAPKT)
+				strlcat(buf, "sdroppeddatapkt ", blen);
+			if (err & INFINIPATH_E_SPKTLEN)
+				strlcat(buf, "spktlen ", blen);
+		}
+		if ((err & INFINIPATH_E_RICRC) &&
+			!(err&(INFINIPATH_E_RVCRC|INFINIPATH_E_REBP)))
+			strlcat(buf, "CRC ", blen);
+		if (!iserr)
+			goto done;
+	}
 	if (err & INFINIPATH_E_RHDRLEN)
 		strlcat(buf, "rhdrlen ", blen);
 	if (err & INFINIPATH_E_RBADTID)
@@ -767,12 +800,12 @@ void ipath_decode_err(char *buf, size_t 
 		strlcat(buf, "rhdr ", blen);
 	if (err & INFINIPATH_E_RLONGPKTLEN)
 		strlcat(buf, "rlongpktlen ", blen);
-	if (err & INFINIPATH_E_RSHORTPKTLEN)
-		strlcat(buf, "rshortpktlen ", blen);
 	if (err & INFINIPATH_E_RMAXPKTLEN)
 		strlcat(buf, "rmaxpktlen ", blen);
 	if (err & INFINIPATH_E_RMINPKTLEN)
 		strlcat(buf, "rminpktlen ", blen);
+	if (err & INFINIPATH_E_SMINPKTLEN)
+		strlcat(buf, "sminpktlen ", blen);
 	if (err & INFINIPATH_E_RFORMATERR)
 		strlcat(buf, "rformaterr ", blen);
 	if (err & INFINIPATH_E_RUNSUPVL)
@@ -781,32 +814,20 @@ void ipath_decode_err(char *buf, size_t 
 		strlcat(buf, "runexpchar ", blen);
 	if (err & INFINIPATH_E_RIBFLOW)
 		strlcat(buf, "ribflow ", blen);
-	if (err & INFINIPATH_E_REBP)
-		strlcat(buf, "EBP ", blen);
 	if (err & INFINIPATH_E_SUNDERRUN)
 		strlcat(buf, "sunderrun ", blen);
 	if (err & INFINIPATH_E_SPIOARMLAUNCH)
 		strlcat(buf, "spioarmlaunch ", blen);
 	if (err & INFINIPATH_E_SUNEXPERRPKTNUM)
 		strlcat(buf, "sunexperrpktnum ", blen);
-	if (err & INFINIPATH_E_SDROPPEDDATAPKT)
-		strlcat(buf, "sdroppeddatapkt ", blen);
 	if (err & INFINIPATH_E_SDROPPEDSMPPKT)
 		strlcat(buf, "sdroppedsmppkt ", blen);
 	if (err & INFINIPATH_E_SMAXPKTLEN)
 		strlcat(buf, "smaxpktlen ", blen);
-	if (err & INFINIPATH_E_SMINPKTLEN)
-		strlcat(buf, "sminpktlen ", blen);
 	if (err & INFINIPATH_E_SUNSUPVL)
 		strlcat(buf, "sunsupVL ", blen);
-	if (err & INFINIPATH_E_SPKTLEN)
-		strlcat(buf, "spktlen ", blen);
 	if (err & INFINIPATH_E_INVALIDADDR)
 		strlcat(buf, "invalidaddr ", blen);
-	if (err & INFINIPATH_E_RICRC)
-		strlcat(buf, "CRC ", blen);
-	if (err & INFINIPATH_E_RVCRC)
-		strlcat(buf, "VCRC ", blen);
 	if (err & INFINIPATH_E_RRCVEGRFULL)
 		strlcat(buf, "rcvegrfull ", blen);
 	if (err & INFINIPATH_E_RRCVHDRFULL)
@@ -819,6 +840,8 @@ void ipath_decode_err(char *buf, size_t 
 		strlcat(buf, "hardware ", blen);
 	if (err & INFINIPATH_E_RESET)
 		strlcat(buf, "reset ", blen);
+done:
+	return iserr;
 }
 
 /**
diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_intr.c
--- a/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:24 2007 -0700
@@ -403,10 +403,13 @@ static void handle_supp_msgs(struct ipat
 	 * happens so often we never want to count it.
 	 */
 	if (dd->ipath_lasterror & ~INFINIPATH_E_IBSTATUSCHANGED) {
-		ipath_decode_err(msg, sizeof msg, dd->ipath_lasterror &
-				 ~INFINIPATH_E_IBSTATUSCHANGED);
+		int iserr;
+		iserr = ipath_decode_err(msg, sizeof msg,
+				dd->ipath_lasterror &
+				~INFINIPATH_E_IBSTATUSCHANGED);
 		if (dd->ipath_lasterror &
-		    ~(INFINIPATH_E_RRCVEGRFULL | INFINIPATH_E_RRCVHDRFULL))
+		    	~(INFINIPATH_E_RRCVEGRFULL |
+			INFINIPATH_E_RRCVHDRFULL | INFINIPATH_E_PKTERRS))
 			ipath_dev_err(dd, "Suppressed %u messages for "
 				      "fast-repeating errors (%s) (%llx)\n",
 				      supp_msgs, msg,
@@ -420,8 +423,13 @@ static void handle_supp_msgs(struct ipat
 			 * them. So only complain about these at debug
 			 * level.
 			 */
-			ipath_dbg("Suppressed %u messages for %s\n",
-				  supp_msgs, msg);
+			if (iserr)
+				ipath_dbg("Suppressed %u messages for %s\n",
+					  supp_msgs, msg);
+			else
+				ipath_cdbg(ERRPKT,
+					"Suppressed %u messages for %s\n",
+					  supp_msgs, msg);
 		}
 	}
 }
@@ -462,7 +470,7 @@ static int handle_errors(struct ipath_de
 {
 	char msg[512];
 	u64 ignore_this_time = 0;
-	int i;
+	int i, iserr = 0;
 	int chkerrpkts = 0, noprint = 0;
 	unsigned supp_msgs;
 
@@ -502,6 +510,7 @@ static int handle_errors(struct ipath_de
 	}
 
 	if (supp_msgs == 250000) {
+		int s_iserr;
 		/*
 		 * It's not entirely reasonable assuming that the errors set
 		 * in the last clear period are all responsible for the
@@ -511,17 +520,17 @@ static int handle_errors(struct ipath_de
 		dd->ipath_maskederrs |= dd->ipath_lasterror | errs;
 		ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
 				 ~dd->ipath_maskederrs);
-		ipath_decode_err(msg, sizeof msg,
+		s_iserr = ipath_decode_err(msg, sizeof msg,
 				 (dd->ipath_maskederrs & ~dd->
 				  ipath_ignorederrs));
 
 		if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs) &
-		    ~(INFINIPATH_E_RRCVEGRFULL | INFINIPATH_E_RRCVHDRFULL))
-			ipath_dev_err(dd, "Disabling error(s) %llx because "
-				      "occurring too frequently (%s)\n",
-				      (unsigned long long)
-				      (dd->ipath_maskederrs &
-				       ~dd->ipath_ignorederrs), msg);
+			~(INFINIPATH_E_RRCVEGRFULL |
+			INFINIPATH_E_RRCVHDRFULL | INFINIPATH_E_PKTERRS))
+			ipath_dev_err(dd, "Temporarily disabling "
+			    "error(s) %llx reporting; too frequent (%s)\n",
+				(unsigned long long) (dd->ipath_maskederrs &
+				~dd->ipath_ignorederrs), msg);
 		else {
 			/*
 			 * rcvegrfull and rcvhdrqfull are "normal",
@@ -530,8 +539,15 @@ static int handle_errors(struct ipath_de
 			 * processing them.  So only complain about
 			 * these at debug level.
 			 */
-			ipath_dbg("Disabling frequent queue full errors "
-				  "(%s)\n", msg);
+			if (s_iserr)
+				ipath_dbg("Temporarily disabling reporting "
+				    "too frequent queue full errors (%s)\n",
+				    msg);
+			else
+				ipath_cdbg(ERRPKT,
+				    "Temporarily disabling reporting too"
+				    " frequent packet errors (%s)\n",
+				    msg);
 		}
 
 		/*
@@ -589,6 +605,8 @@ static int handle_errors(struct ipath_de
 		ipath_stats.sps_crcerrs++;
 		chkerrpkts = 1;
 	}
+	iserr = errs & ~(E_SUM_PKTERRS | INFINIPATH_E_PKTERRS);
+
 
 	/*
 	 * We don't want to print these two as they happen, or we can make
@@ -677,8 +695,13 @@ static int handle_errors(struct ipath_de
 		*dd->ipath_statusp &= ~IPATH_STATUS_IB_CONF;
 	}
 
-	if (!noprint && *msg)
-		ipath_dev_err(dd, "%s error\n", msg);
+	if (!noprint && *msg) {
+		if (iserr)
+			ipath_dev_err(dd, "%s error\n", msg);
+		else
+			dev_info(&dd->pcidev->dev, "%s packet problems\n",
+				msg);
+	}
 	if (dd->ipath_state_wanted & dd->ipath_flags) {
 		ipath_cdbg(VERBOSE, "driver wanted state %x, iflags now %x, "
 			   "waking\n", dd->ipath_state_wanted,
diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:24 2007 -0700
@@ -611,7 +611,7 @@ extern int ipath_diag_inuse;
 extern int ipath_diag_inuse;
 
 irqreturn_t ipath_intr(int irq, void *devid);
-void ipath_decode_err(char *buf, size_t blen, ipath_err_t err);
+int ipath_decode_err(char *buf, size_t blen, ipath_err_t err);
 #if __IPATH_INFO || __IPATH_DBG
 extern const char *ipath_ibcstatus_str[];
 #endif
diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_registers.h
--- a/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:24 2007 -0700
@@ -125,6 +125,15 @@
 #define INFINIPATH_E_INVALIDADDR     0x0002000000000000ULL
 #define INFINIPATH_E_RESET           0x0004000000000000ULL
 #define INFINIPATH_E_HARDWARE        0x0008000000000000ULL
+
+/*
+ * this is used to print "common" packet errors only when the
+ * __IPATH_ERRPKTDBG bit is set in ipath_debug.
+ */
+#define INFINIPATH_E_PKTERRS ( INFINIPATH_E_SPKTLEN \
+		| INFINIPATH_E_SDROPPEDDATAPKT | INFINIPATH_E_RVCRC \
+		| INFINIPATH_E_RICRC | INFINIPATH_E_RSHORTPKTLEN \
+		| INFINIPATH_E_REBP )
 
 /* kr_hwerrclear, kr_hwerrmask, kr_hwerrstatus, bits */
 /* TXEMEMPARITYERR bit 0: PIObuf, 1: PIOpbc, 2: launchfifo
diff -r 4050989280f0 -r c793dc8a5265 drivers/infiniband/hw/ipath/ipath_stats.c
--- a/drivers/infiniband/hw/ipath/ipath_stats.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_stats.c	Thu Mar 15 14:34:24 2007 -0700
@@ -237,11 +237,13 @@ void ipath_get_faststats(unsigned long o
 	if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs)
 	    && time_after(jiffies, dd->ipath_unmasktime)) {
 		char ebuf[256];
-		ipath_decode_err(ebuf, sizeof ebuf,
+		int iserr;
+		iserr = ipath_decode_err(ebuf, sizeof ebuf,
 				 (dd->ipath_maskederrs & ~dd->
 				  ipath_ignorederrs));
 		if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs) &
-		    ~(INFINIPATH_E_RRCVEGRFULL | INFINIPATH_E_RRCVHDRFULL))
+				~(INFINIPATH_E_RRCVEGRFULL | INFINIPATH_E_RRCVHDRFULL |
+				INFINIPATH_E_PKTERRS ))
 			ipath_dev_err(dd, "Re-enabling masked errors "
 				      "(%s)\n", ebuf);
 		else {
@@ -252,8 +254,12 @@ void ipath_get_faststats(unsigned long o
 			 * them.  So only complain about these at debug
 			 * level.
 			 */
-			ipath_dbg("Disabling frequent queue full errors "
-				  "(%s)\n", ebuf);
+			if (iserr)
+					ipath_dbg("Re-enabling queue full errors (%s)\n",
+							ebuf);
+			else
+				ipath_cdbg(ERRPKT, "Re-enabling packet"
+						" problem interrupt (%s)\n", ebuf);
 		}
 		dd->ipath_maskederrs = dd->ipath_ignorederrs;
 		ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
