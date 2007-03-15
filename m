Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXCOWT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXCOWT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933927AbXCOWTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:23 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33719 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 33] IB/ipath - Improve handling and reporting of parity
	errors, mostly cleanup
X-Mercurial-Node: 01cde17958018b5262570cd9ea399378f95051e7
Message-Id: <01cde17958018b526257.1173995107@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:07 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID 01cde17958018b5262570cd9ea399378f95051e7
# Parent  fe719d50378ce70909f96bd5e7bc8e4f28a5031b
IB/ipath - Improve handling and reporting of parity errors, mostly cleanup

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
@@ -605,8 +605,9 @@ static void __devexit cleanup_device(str
 
 		ipath_cdbg(VERBOSE, "Free shadow page tid array at %p\n",
 			   dd->ipath_pageshadow);
-		vfree(dd->ipath_pageshadow);
+		tmpp = dd->ipath_pageshadow;
 		dd->ipath_pageshadow = NULL;
+		vfree(tmpp);
 	}
 
 	/*
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_eeprom.c
--- a/drivers/infiniband/hw/ipath/ipath_eeprom.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_eeprom.c	Thu Mar 15 14:34:25 2007 -0700
@@ -626,6 +626,10 @@ void ipath_get_eeprom_info(struct ipath_
 	} else
 		memcpy(dd->ipath_serial, ifp->if_serial,
 		       sizeof ifp->if_serial);
+	if (!strstr(ifp->if_comment, "Tested successfully"))
+		ipath_dev_err(dd, "Board SN %s did not pass functional "
+			"test: %s\n", dd->ipath_serial,
+			ifp->if_comment);
 
 	ipath_cdbg(VERBOSE, "Initted GUID to %llx from eeprom\n",
 		   (unsigned long long) be64_to_cpu(dd->ipath_guid));
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_iba6110.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
@@ -284,6 +284,14 @@ static const struct ipath_cregs ipath_ht
 #define INFINIPATH_EXTS_MEMBIST_ENDTEST     0x0000000000004000
 #define INFINIPATH_EXTS_MEMBIST_CORRECT     0x0000000000008000
 
+
+/* TID entries (memory), HT-only */
+#define INFINIPATH_RT_ADDR_MASK 0xFFFFFFFFFFULL	/* 40 bits valid */
+#define INFINIPATH_RT_VALID 0x8000000000000000ULL
+#define INFINIPATH_RT_ADDR_SHIFT 0
+#define INFINIPATH_RT_BUFSIZE_MASK 0x3FFFULL
+#define INFINIPATH_RT_BUFSIZE_SHIFT 48
+
 /*
  * masks and bits that are different in different chips, or present only
  * in one
@@ -402,6 +410,14 @@ static const struct ipath_hwerror_msgs i
 	INFINIPATH_HWE_MSG(SERDESPLLFAILED, "SerDes PLL"),
 };
 
+#define TXE_PIO_PARITY ((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF | \
+		        INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC) \
+		        << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT)
+#define RXE_EAGER_PARITY (INFINIPATH_HWE_RXEMEMPARITYERR_EAGERTID \
+			  << INFINIPATH_HWE_RXEMEMPARITYERR_SHIFT)
+
+static int ipath_ht_txe_recover(struct ipath_devdata *);
+
 /**
  * ipath_ht_handle_hwerrors - display hardware errors.
  * @dd: the infinipath device
@@ -450,13 +466,12 @@ static void ipath_ht_handle_hwerrors(str
 
 	/*
 	 * make sure we get this much out, unless told to be quiet,
+	 * it's a parity error we may recover from,
 	 * or it's occurred within the last 5 seconds
 	 */
-	if ((hwerrs & ~(dd->ipath_lasthwerror |
-			((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF |
-			  INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC)
-			<< INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT))) ||
-	    (ipath_debug & __IPATH_VERBDBG))
+	if ((hwerrs & ~(dd->ipath_lasthwerror | TXE_PIO_PARITY |
+		RXE_EAGER_PARITY)) ||
+		(ipath_debug & __IPATH_VERBDBG))
 		dev_info(&dd->pcidev->dev, "Hardware error: hwerr=0x%llx "
 			 "(cleared)\n", (unsigned long long) hwerrs);
 	dd->ipath_lasthwerror |= hwerrs;
@@ -467,7 +482,7 @@ static void ipath_ht_handle_hwerrors(str
 			      (hwerrs & ~dd->ipath_hwe_bitsextant));
 
 	ctrl = ipath_read_kreg32(dd, dd->ipath_kregs->kr_control);
-	if (ctrl & INFINIPATH_C_FREEZEMODE) {
+	if ((ctrl & INFINIPATH_C_FREEZEMODE) && !ipath_diag_inuse) {
 		/*
 		 * parity errors in send memory are recoverable,
 		 * just cancel the send (if indicated in * sendbuffererror),
@@ -476,50 +491,14 @@ static void ipath_ht_handle_hwerrors(str
 		 * occur if a processor speculative read is done to the PIO
 		 * buffer while we are sending a packet, for example.
 		 */
-		if (hwerrs & ((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF |
-			       INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC)
-			      << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT)) {
-			ipath_stats.sps_txeparity++;
-			ipath_dbg("Recovering from TXE parity error (%llu), "
-			    	  "hwerrstatus=%llx\n",
-				  (unsigned long long) ipath_stats.sps_txeparity,
-				  (unsigned long long) hwerrs);
-			ipath_disarm_senderrbufs(dd);
-			hwerrs &= ~((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF |
-				     INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC)
-				    << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT);
-			if (!hwerrs) { /* else leave in freeze mode */
-				ipath_write_kreg(dd,
-						 dd->ipath_kregs->kr_control,
-						 dd->ipath_control);
-				return;
-			}
-		}
-		if (hwerrs) {
-			/*
-			 * if any set that we aren't ignoring; only
-			 * make the complaint once, in case it's stuck
-			 * or recurring, and we get here multiple
-			 * times.
-			 */
-			if (dd->ipath_flags & IPATH_INITTED) {
-				ipath_dev_err(dd, "Fatal Hardware Error (freeze "
-					      "mode), no longer usable, SN %.16s\n",
-						  dd->ipath_serial);
-				isfatal = 1;
-			}
-			*dd->ipath_statusp &= ~IPATH_STATUS_IB_READY;
-			/* mark as having had error */
-			*dd->ipath_statusp |= IPATH_STATUS_HWERROR;
-			/*
-			 * mark as not usable, at a minimum until driver
-			 * is reloaded, probably until reboot, since no
-			 * other reset is possible.
-			 */
-			dd->ipath_flags &= ~IPATH_INITTED;
-		} else {
-			ipath_dbg("Clearing freezemode on ignored hardware "
-				  "error\n");
+		if ((hwerrs & TXE_PIO_PARITY) && ipath_ht_txe_recover(dd))
+			hwerrs &= ~TXE_PIO_PARITY;
+		if (hwerrs & RXE_EAGER_PARITY)
+			ipath_dev_err(dd, "RXE parity, Eager TID error is not "
+				"recoverable\n");
+		if (!hwerrs) {
+			ipath_dbg("Clearing freezemode on ignored or "
+				  "recovered hardware error\n");
 			ctrl &= ~INFINIPATH_C_FREEZEMODE;
 			ipath_write_kreg(dd, dd->ipath_kregs->kr_control,
 					 ctrl);
@@ -587,7 +566,32 @@ static void ipath_ht_handle_hwerrors(str
 				 dd->ipath_hwerrmask);
 	}
 
-	ipath_dev_err(dd, "%s hardware error\n", msg);
+	if (hwerrs) {
+		/*
+		 * if any set that we aren't ignoring; only
+		 * make the complaint once, in case it's stuck
+		 * or recurring, and we get here multiple
+		 * times.
+		 */
+		ipath_dev_err(dd, "%s hardware error\n", msg);
+		if (dd->ipath_flags & IPATH_INITTED) {
+			ipath_dev_err(dd, "Fatal Hardware Error (freeze "
+					  "mode), no longer usable, SN %.16s\n",
+					  dd->ipath_serial);
+			isfatal = 1;
+		}
+		*dd->ipath_statusp &= ~IPATH_STATUS_IB_READY;
+		/* mark as having had error */
+		*dd->ipath_statusp |= IPATH_STATUS_HWERROR;
+		/*
+		 * mark as not usable, at a minimum until driver
+		 * is reloaded, probably until reboot, since no
+		 * other reset is possible.
+		 */
+		dd->ipath_flags &= ~IPATH_INITTED;
+	}
+	else
+		*msg = 0; /* recovered from all of them */
 	if (isfatal && !ipath_diag_inuse && dd->ipath_freezemsg)
 		/*
 		 * for status file; if no trailing brace is copied,
@@ -658,7 +662,8 @@ static int ipath_ht_boardname(struct ipa
 	if (n)
 		snprintf(name, namelen, "%s", n);
 
-	if (dd->ipath_majrev != 3 || (dd->ipath_minrev < 2 || dd->ipath_minrev > 3)) {
+	if (dd->ipath_majrev != 3 || (dd->ipath_minrev < 2 ||
+		dd->ipath_minrev > 3)) {
 		/*
 		 * This version of the driver only supports Rev 3.2 and 3.3
 		 */
@@ -1163,6 +1168,8 @@ static void ipath_ht_init_hwerrors(struc
 
 	if (!(extsval & INFINIPATH_EXTS_MEMBIST_ENDTEST))
 		ipath_dev_err(dd, "MemBIST did not complete!\n");
+	if (extsval & INFINIPATH_EXTS_MEMBIST_CORRECT)
+		ipath_dbg("MemBIST corrected\n");
 
 	ipath_check_htlink(dd);
 
@@ -1366,6 +1373,9 @@ static void ipath_ht_put_tid(struct ipat
 			     u64 __iomem *tidptr, u32 type,
 			     unsigned long pa)
 {
+	if (!dd->ipath_kregbase)
+		return;
+
 	if (pa != dd->ipath_tidinvalid) {
 		if (unlikely((pa & ~INFINIPATH_RT_ADDR_MASK))) {
 			dev_info(&dd->pcidev->dev,
@@ -1382,9 +1392,9 @@ static void ipath_ht_put_tid(struct ipat
 			pa |= lenvalid | INFINIPATH_RT_VALID;
 		}
 	}
-	if (dd->ipath_kregbase)
-		writeq(pa, tidptr);
-}
+	writeq(pa, tidptr);
+}
+
 
 /**
  * ipath_ht_clear_tid - clear all TID entries for a port, expected and eager
@@ -1515,7 +1525,7 @@ static int ipath_ht_early_init(struct ip
 			 INFINIPATH_S_ABORT);
 
 	ipath_get_eeprom_info(dd);
-	if(dd->ipath_boardrev == 5 && dd->ipath_serial[0] == '1' &&
+	if (dd->ipath_boardrev == 5 && dd->ipath_serial[0] == '1' &&
 		dd->ipath_serial[1] == '2' && dd->ipath_serial[2] == '8') {
 		/*
 		 * Later production QHT7040 has same changes as QHT7140, so
@@ -1527,6 +1537,24 @@ static int ipath_ht_early_init(struct ip
 	}
 	return 0;
 }
+
+
+static int ipath_ht_txe_recover(struct ipath_devdata *dd)
+{
+	int cnt = ++ipath_stats.sps_txeparity;
+	if (cnt >= IPATH_MAX_PARITY_ATTEMPTS)  {
+		if (cnt == IPATH_MAX_PARITY_ATTEMPTS)
+			ipath_dev_err(dd,
+				"Too many attempts to recover from "
+				"TXE parity, giving up\n");
+		return 0;
+	}
+	dev_info(&dd->pcidev->dev,
+		"Recovering from TXE PIO parity error\n");
+	ipath_disarm_senderrbufs(dd, 1);
+	return 1;
+}
+
 
 /**
  * ipath_init_ht_get_base_info - set chip-specific flags for user code
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_iba6120.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
@@ -321,6 +321,12 @@ static const struct ipath_hwerror_msgs i
 	INFINIPATH_HWE_MSG(SERDESPLLFAILED, "SerDes PLL"),
 };
 
+#define TXE_PIO_PARITY ((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF | \
+		        INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC) \
+		        << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT)
+
+static int ipath_pe_txe_recover(struct ipath_devdata *);
+
 /**
  * ipath_pe_handle_hwerrors - display hardware errors.
  * @dd: the infinipath device
@@ -394,25 +400,8 @@ static void ipath_pe_handle_hwerrors(str
 		 * occur if a processor speculative read is done to the PIO
 		 * buffer while we are sending a packet, for example.
 		 */
-		if (hwerrs & ((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF |
-			       INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC)
-			      << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT)) {
-			ipath_stats.sps_txeparity++;
-			ipath_dbg("Recovering from TXE parity error (%llu), "
-			    	  "hwerrstatus=%llx\n",
-				  (unsigned long long) ipath_stats.sps_txeparity,
-				  (unsigned long long) hwerrs);
-			ipath_disarm_senderrbufs(dd);
-			hwerrs &= ~((INFINIPATH_HWE_TXEMEMPARITYERR_PIOBUF |
-				     INFINIPATH_HWE_TXEMEMPARITYERR_PIOPBC)
-				    << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT);
-			if (!hwerrs) { /* else leave in freeze mode */
-				ipath_write_kreg(dd,
-						 dd->ipath_kregs->kr_control,
-						 dd->ipath_control);
-			    return;
-			}
-		}
+		if ((hwerrs & TXE_PIO_PARITY) && ipath_pe_txe_recover(dd))
+			hwerrs &= ~TXE_PIO_PARITY;
 		if (hwerrs) {
 			/*
 			 * if any set that we aren't ignoring only make the
@@ -581,6 +570,8 @@ static void ipath_pe_init_hwerrors(struc
 
 	if (!(extsval & INFINIPATH_EXTS_MEMBIST_ENDTEST))
 		ipath_dev_err(dd, "MemBIST did not complete!\n");
+	if (extsval & INFINIPATH_EXTS_MEMBIST_FOUND)
+		ipath_dbg("MemBIST corrected\n");
 
 	val = ~0ULL;	/* barring bugs, all hwerrors become interrupts, */
 
@@ -1330,6 +1321,35 @@ static void ipath_pe_free_irq(struct ipa
 	dd->ipath_irq = 0;
 }
 
+/*
+ * On platforms using this chip, and not having ordered WC stores, we
+ * can get TXE parity errors due to speculative reads to the PIO buffers,
+ * and this, due to a chip bug can result in (many) false parity error
+ * reports.  So it's a debug print on those, and an info print on systems
+ * where the speculative reads don't occur.
+ * Because we can get lots of false errors, we have no upper limit
+ * on recovery attempts on those platforms.
+ */
+static int ipath_pe_txe_recover(struct ipath_devdata *dd)
+{
+	if (ipath_unordered_wc())
+		ipath_dbg("Recovering from TXE PIO parity error\n");
+	else {
+		int cnt = ++ipath_stats.sps_txeparity;
+		if (cnt >= IPATH_MAX_PARITY_ATTEMPTS)  {
+			if (cnt == IPATH_MAX_PARITY_ATTEMPTS)
+				ipath_dev_err(dd,
+					"Too many attempts to recover from "
+					"TXE parity, giving up\n");
+			return 0;
+		}
+		dev_info(&dd->pcidev->dev,
+			"Recovering from TXE PIO parity error\n");
+	}
+	ipath_disarm_senderrbufs(dd, 1);
+	return 1;
+}
+
 /**
  * ipath_init_iba6120_funcs - set up the chip-specific function pointers
  * @dd: the infinipath device
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_init_chip.c
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c	Thu Mar 15 14:34:25 2007 -0700
@@ -590,6 +590,10 @@ static int init_housekeeping(struct ipat
 		goto done;
 	}
 
+
+	/* clear diagctrl register, in case diags were running and crashed */
+	ipath_write_kreg (dd, dd->ipath_kregs->kr_hwdiagctrl, 0);
+
 	/* clear the initial reset flag, in case first driver load */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errorclear,
 			 INFINIPATH_E_RESET);
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_intr.c
--- a/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:25 2007 -0700
@@ -37,11 +37,40 @@
 #include "ipath_verbs.h"
 #include "ipath_common.h"
 
+/* 
+ * clear (write) a pio buffer, to clear a parity error.   This routine
+ * should only be called when in freeze mode, and the buffer should be
+ * canceled afterwards.
+ */
+static void ipath_clrpiobuf(struct ipath_devdata *dd, u32 pnum)
+{
+	u32 __iomem *pbuf;
+	u32 dwcnt; /* dword count to write */
+	if (pnum < dd->ipath_piobcnt2k) {
+		pbuf = (u32 __iomem *) (dd->ipath_pio2kbase + pnum *
+			dd->ipath_palign);
+		dwcnt = dd->ipath_piosize2k >> 2;
+	}
+	else {
+		pbuf = (u32 __iomem *) (dd->ipath_pio4kbase +
+			(pnum - dd->ipath_piobcnt2k) * dd->ipath_4kalign);
+		dwcnt = dd->ipath_piosize4k >> 2;
+	}
+	dev_info(&dd->pcidev->dev,
+		"Rewrite PIO buffer %u, to recover from parity error\n",
+		pnum);
+	*pbuf = dwcnt+1; /* no flush required, since already in freeze */
+	while(--dwcnt)
+		*pbuf++ = 0;
+}
+
 /*
  * Called when we might have an error that is specific to a particular
  * PIO buffer, and may need to cancel that buffer, so it can be re-used.
+ * If rewrite is true, and bits are set in the sendbufferror registers,
+ * we'll write to the buffer, for error recovery on parity errors.
  */
-void ipath_disarm_senderrbufs(struct ipath_devdata *dd)
+void ipath_disarm_senderrbufs(struct ipath_devdata *dd, int rewrite)
 {
 	u32 piobcnt;
 	unsigned long sbuf[4];
@@ -74,8 +103,11 @@ void ipath_disarm_senderrbufs(struct ipa
 		}
 
 		for (i = 0; i < piobcnt; i++)
-			if (test_bit(i, sbuf))
+			if (test_bit(i, sbuf)) {
+				if (rewrite)
+					ipath_clrpiobuf(dd, i);
 				ipath_disarm_piobufs(dd, i, 1);
+			}
 		dd->ipath_lastcancel = jiffies+3; /* no armlaunch for a bit */
 	}
 }
@@ -114,7 +146,7 @@ static u64 handle_e_sum_errs(struct ipat
 {
 	u64 ignore_this_time = 0;
 
-	ipath_disarm_senderrbufs(dd);
+	ipath_disarm_senderrbufs(dd, 0);
 	if ((errs & E_SUM_LINK_PKTERRS) &&
 	    !(dd->ipath_flags & IPATH_LINKACTIVE)) {
 		/*
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:25 2007 -0700
@@ -590,7 +590,6 @@ void ipath_disable_wc(struct ipath_devda
 void ipath_disable_wc(struct ipath_devdata *dd);
 int ipath_count_units(int *npresentp, int *nupp, u32 *maxportsp);
 void ipath_shutdown_device(struct ipath_devdata *);
-void ipath_disarm_senderrbufs(struct ipath_devdata *);
 
 struct file_operations;
 int ipath_cdev_init(int minor, char *name, const struct file_operations *fops,
@@ -713,6 +712,7 @@ void ipath_init_iba6110_funcs(struct ipa
 void ipath_init_iba6110_funcs(struct ipath_devdata *);
 void ipath_get_eeprom_info(struct ipath_devdata *);
 u64 ipath_snap_cntr(struct ipath_devdata *, ipath_creg);
+void ipath_disarm_senderrbufs(struct ipath_devdata *, int);
 
 /*
  * number of words used for protocol header if not set by ipath_userinit();
@@ -896,6 +896,8 @@ dma_addr_t ipath_map_single(struct pci_d
 #endif
 
 extern unsigned ipath_debug; /* debugging bit mask */
+
+#define IPATH_MAX_PARITY_ATTEMPTS 10000 /* max times to try recovery */
 
 const char *ipath_get_unit_name(int unit);
 
diff -r fe719d50378c -r 01cde1795801 drivers/infiniband/hw/ipath/ipath_registers.h
--- a/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:25 2007 -0700
@@ -308,13 +308,6 @@
 #define INFINIPATH_XGXS_RX_POL_SHIFT 19
 #define INFINIPATH_XGXS_RX_POL_MASK 0xfULL
 
-#define INFINIPATH_RT_ADDR_MASK 0xFFFFFFFFFFULL	/* 40 bits valid */
-
-/* TID entries (memory), HT-only */
-#define INFINIPATH_RT_VALID 0x8000000000000000ULL
-#define INFINIPATH_RT_ADDR_SHIFT 0
-#define INFINIPATH_RT_BUFSIZE_MASK 0x3FFF
-#define INFINIPATH_RT_BUFSIZE_SHIFT 48
 
 /*
  * IPATH_PIO_MAXIBHDR is the max IB header size allowed for in our
