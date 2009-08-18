Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZHRWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZHRWER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZHRWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:04:15 -0400
Received: from ru.mvista.com ([213.79.90.228]:44063 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030AbZHRWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:04:14 -0400
Date: Wed, 19 Aug 2009 02:04:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] powerpc/qe&cpm2: Avoid redefinitions in CPM2 and QE
 headers
Message-ID: <20090818220415.GB25090@oksana.dev.rtsoft.ru>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mcc defined in both immap_qe.h and immap_cpm2.h, so they will
conflic when included in a single file. The mcc struct is easy to deal
with, since it isn't used in any driver (yet), so let's just rename QE
version to qe_mcc.

The ucb_ctlr is a bit trickier, since it is used by fsl_qe_udc driver,
and the driver supports both CPM and QE UDCs, plus the QE version is
used to form a bigger immap struct.

I don't want to touch too much of USB code in this series, so for now
let's just copy most generic version into the common cpm.h header,
later we'll create cpm_usb.h where we'll place common USB structs that
are used by QE/CPM UDC and QE Host drivers (FHCI).

And as for the structs in qe.h and cpm2.h, just prefix them with qe_
and cpm_.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/cpm.h        |   22 ++++++++++++++++++++++
 arch/powerpc/include/asm/immap_cpm2.h |    2 +-
 arch/powerpc/include/asm/immap_qe.h   |    8 ++++----
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/cpm.h b/arch/powerpc/include/asm/cpm.h
index 24d79e3..b5f1534 100644
--- a/arch/powerpc/include/asm/cpm.h
+++ b/arch/powerpc/include/asm/cpm.h
@@ -5,6 +5,28 @@
 #include <linux/types.h>
 #include <linux/of.h>
 
+/*
+ * USB Controller pram common to QE and CPM.
+ */
+struct usb_ctlr {
+	u8	usb_usmod;
+	u8	usb_usadr;
+	u8	usb_uscom;
+	u8	res1[1];
+	__be16	usb_usep[4];
+	u8	res2[4];
+	__be16	usb_usber;
+	u8	res3[2];
+	__be16	usb_usbmr;
+	u8	res4[1];
+	u8	usb_usbs;
+	/* Fields down below are QE-only */
+	__be16	usb_ussft;
+	u8	res5[2];
+	__be16	usb_usfrn;
+	u8	res6[0x22];
+} __attribute__ ((packed));
+
 /* Opcodes common to CPM1 and CPM2
 */
 #define CPM_CR_INIT_TRX		((ushort)0x0000)
diff --git a/arch/powerpc/include/asm/immap_cpm2.h b/arch/powerpc/include/asm/immap_cpm2.h
index d4f069b..7c64fda 100644
--- a/arch/powerpc/include/asm/immap_cpm2.h
+++ b/arch/powerpc/include/asm/immap_cpm2.h
@@ -549,7 +549,7 @@ typedef struct comm_proc {
 
 /* USB Controller.
 */
-typedef struct usb_ctlr {
+typedef struct cpm_usb_ctlr {
 	u8	usb_usmod;
 	u8	usb_usadr;
 	u8	usb_uscom;
diff --git a/arch/powerpc/include/asm/immap_qe.h b/arch/powerpc/include/asm/immap_qe.h
index c346d0b..4e10f50 100644
--- a/arch/powerpc/include/asm/immap_qe.h
+++ b/arch/powerpc/include/asm/immap_qe.h
@@ -210,7 +210,7 @@ struct sir {
 } __attribute__ ((packed));
 
 /* USB Controller */
-struct usb_ctlr {
+struct qe_usb_ctlr {
 	u8	usb_usmod;
 	u8	usb_usadr;
 	u8	usb_uscom;
@@ -229,7 +229,7 @@ struct usb_ctlr {
 } __attribute__ ((packed));
 
 /* MCC */
-struct mcc {
+struct qe_mcc {
 	__be32	mcce;		/* MCC event register */
 	__be32	mccm;		/* MCC mask register */
 	__be32	mccf;		/* MCC configuration register */
@@ -431,9 +431,9 @@ struct qe_immap {
 	struct qe_mux		qmx;		/* QE Multiplexer */
 	struct qe_timers	qet;		/* QE Timers */
 	struct spi		spi[0x2];	/* spi */
-	struct mcc		mcc;		/* mcc */
+	struct qe_mcc		mcc;		/* mcc */
 	struct qe_brg		brg;		/* brg */
-	struct usb_ctlr		usb;		/* USB */
+	struct qe_usb_ctlr	usb;		/* USB */
 	struct si1		si1;		/* SI */
 	u8			res11[0x800];
 	struct sir		sir;		/* SI Routing Tables */
-- 
1.6.3.3

