Return-Path: <linux-kernel-owner+w=401wt.eu-S939826AbXG3USy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939826AbXG3USy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938216AbXG3USp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:18:45 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:11812 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937744AbXG3USo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:18:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABrkrUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,200,1183359600"; 
   d="scan'208"; a="508494704:sNHT130397284"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Jul 2007 13:18:42 -0700
Message-ID: <adahcnlsl0d.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2007 20:18:42.0652 (UTC) FILETIME=[D2EEB9C0:01C7D2E6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some small fixes for 2.6.23:

Dave Olson (4):
      IB/ipath: Remove unsafe fastrcvint code from interrupt handler
      IB/ipath: Use faster put_tid_2 routine after initialization
      IB/ipath: Fix some issues with buffer cancel and sendctrl register update
      IB/ipath: Workaround problem of errormask register being overwritten

Hoang-Nam Nguyen (2):
      IB/ehca: Fix include order to better match kernel style
      IB/ehca: Move extern declarations from .c files to .h files

Jack Morgenstein (1):
      mlx4_core: Remove kfree() in mlx4_mr_alloc() error flow

Roland Dreier (1):
      IB/mlx4: Whitespace fix

Tom Tucker (1):
      RDMA/amso1100: Initialize the wait_queue_head_t in the c2_qp structure

 drivers/infiniband/hw/amso1100/c2_qp.c        |    1 +
 drivers/infiniband/hw/ehca/ehca_classes.h     |    1 +
 drivers/infiniband/hw/ehca/ehca_mrmw.c        |    6 +--
 drivers/infiniband/hw/ehca/ehca_pd.c          |    1 -
 drivers/infiniband/hw/ehca/hcp_if.c           |    1 -
 drivers/infiniband/hw/ehca/ipz_pt_fn.h        |    2 +
 drivers/infiniband/hw/ipath/ipath_common.h    |    3 +-
 drivers/infiniband/hw/ipath/ipath_driver.c    |   11 +++--
 drivers/infiniband/hw/ipath/ipath_iba6120.c   |   20 +++++---
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    7 ++-
 drivers/infiniband/hw/ipath/ipath_intr.c      |   63 ++++++------------------
 drivers/infiniband/hw/ipath/ipath_kernel.h    |   13 +----
 drivers/infiniband/hw/ipath/ipath_stats.c     |   54 +++++++++++++++++++--
 drivers/infiniband/hw/mlx4/qp.c               |    1 -
 drivers/net/mlx4/mr.c                         |   15 +-----
 15 files changed, 101 insertions(+), 98 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 420c138..01d0786 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -506,6 +506,7 @@ int c2_alloc_qp(struct c2_dev *c2dev,
 	qp->send_sgl_depth = qp_attrs->cap.max_send_sge;
 	qp->rdma_write_sgl_depth = qp_attrs->cap.max_send_sge;
 	qp->recv_sgl_depth = qp_attrs->cap.max_recv_sge;
+	init_waitqueue_head(&qp->wait);
 
 	/* Initialize the SQ MQ */
 	q_size = be32_to_cpu(reply->sq_depth);
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 3725aa8..b5e9603 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -322,6 +322,7 @@ extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
+extern int ehca_mr_largepage;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index c1b868b..d97eda3 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -40,10 +40,10 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <rdma/ib_umem.h>
-
 #include <asm/current.h>
 
+#include <rdma/ib_umem.h>
+
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
 #include "hcp_if.h"
@@ -64,8 +64,6 @@ enum ehca_mr_pgsize {
 	EHCA_MR_PGSIZE16M = 0x1000000L
 };
 
-extern int ehca_mr_largepage;
-
 static u32 ehca_encode_hwpage_size(u32 pgsize)
 {
 	u32 idx = 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/infiniband/hw/ehca/ehca_pd.c
index 3dafd7f..43bcf08 100644
--- a/drivers/infiniband/hw/ehca/ehca_pd.c
+++ b/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -88,7 +88,6 @@ int ehca_dealloc_pd(struct ib_pd *pd)
 	u32 cur_pid = current->tgid;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
 	int i, leftovers = 0;
-	extern struct kmem_cache *small_qp_cache;
 	struct ipz_small_queue_page *page, *tmp;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index fdbfebe..24f4541 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -758,7 +758,6 @@ u64 hipz_h_register_rpage_mr(const struct ipz_adapter_handle adapter_handle,
 			     const u64 logical_address_of_page,
 			     const u64 count)
 {
-	extern int ehca_debug_level;
 	u64 ret;
 
 	if (unlikely(ehca_debug_level >= 2)) {
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index c6937a0..a801274 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -54,6 +54,8 @@
 struct ehca_pd;
 struct ipz_small_queue_page;
 
+extern struct kmem_cache *small_qp_cache;
+
 /* struct generic ehca page */
 struct ipz_page {
 	u8 entries[EHCA_PAGESIZE];
diff --git a/drivers/infiniband/hw/ipath/ipath_common.h b/drivers/infiniband/hw/ipath/ipath_common.h
index b4b786d..6ad822c 100644
--- a/drivers/infiniband/hw/ipath/ipath_common.h
+++ b/drivers/infiniband/hw/ipath/ipath_common.h
@@ -100,8 +100,7 @@ struct infinipath_stats {
 	__u64 sps_hwerrs;
 	/* number of times IB link changed state unexpectedly */
 	__u64 sps_iblink;
-	/* kernel receive interrupts that didn't read intstat */
-	__u64 sps_fastrcvint;
+	__u64 sps_unused; /* was fastrcvint, no longer implemented */
 	/* number of kernel (port0) packets received */
 	__u64 sps_port0pkts;
 	/* number of "ethernet" packets sent by driver */
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 09c5fd8..6ccba36 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -740,7 +740,7 @@ void ipath_disarm_piobufs(struct ipath_devdata *dd, unsigned first,
 	 * pioavail updates to memory to stop.
 	 */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl,
-			 sendorig & ~IPATH_S_PIOBUFAVAILUPD);
+			 sendorig & ~INFINIPATH_S_PIOBUFAVAILUPD);
 	sendorig = ipath_read_kreg64(dd, dd->ipath_kregs->kr_scratch);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl,
 			 dd->ipath_sendctrl);
@@ -1614,7 +1614,7 @@ int ipath_waitfor_mdio_cmdready(struct ipath_devdata *dd)
  * it's safer to always do it.
  * PIOAvail bits are updated by the chip as if normal send had happened.
  */
-void ipath_cancel_sends(struct ipath_devdata *dd)
+void ipath_cancel_sends(struct ipath_devdata *dd, int restore_sendctrl)
 {
 	ipath_dbg("Cancelling all in-progress send buffers\n");
 	dd->ipath_lastcancel = jiffies+HZ/2; /* skip armlaunch errs a bit */
@@ -1627,6 +1627,9 @@ void ipath_cancel_sends(struct ipath_devdata *dd)
 	ipath_read_kreg64(dd, dd->ipath_kregs->kr_scratch);
 	ipath_disarm_piobufs(dd, 0,
 		(unsigned)(dd->ipath_piobcnt2k + dd->ipath_piobcnt4k));
+	if (restore_sendctrl) /* else done by caller later */
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl,
+				 dd->ipath_sendctrl);
 
 	/* and again, be sure all have hit the chip */
 	ipath_read_kreg64(dd, dd->ipath_kregs->kr_scratch);
@@ -1655,7 +1658,7 @@ static void ipath_set_ib_lstate(struct ipath_devdata *dd, int which)
 	/* flush all queued sends when going to DOWN or INIT, to be sure that
 	 * they don't block MAD packets */
 	if (!linkcmd || linkcmd == INFINIPATH_IBCC_LINKCMD_INIT)
-		ipath_cancel_sends(dd);
+		ipath_cancel_sends(dd, 1);
 
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_ibcctrl,
 			 dd->ipath_ibcctrl | which);
@@ -2000,7 +2003,7 @@ void ipath_shutdown_device(struct ipath_devdata *dd)
 
 	ipath_set_ib_lstate(dd, INFINIPATH_IBCC_LINKINITCMD_DISABLE <<
 			    INFINIPATH_IBCC_LINKINITCMD_SHIFT);
-	ipath_cancel_sends(dd);
+	ipath_cancel_sends(dd, 0);
 
 	/* disable IBC */
 	dd->ipath_control &= ~INFINIPATH_C_LINKENABLE;
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6120.c b/drivers/infiniband/hw/ipath/ipath_iba6120.c
index 9868ccd..5b6ac9a 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c
@@ -321,6 +321,8 @@ static const struct ipath_hwerror_msgs ipath_6120_hwerror_msgs[] = {
 		        << INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT)
 
 static int ipath_pe_txe_recover(struct ipath_devdata *);
+static void ipath_pe_put_tid_2(struct ipath_devdata *, u64 __iomem *,
+			       u32, unsigned long);
 
 /**
  * ipath_pe_handle_hwerrors - display hardware errors.
@@ -555,8 +557,11 @@ static int ipath_pe_boardname(struct ipath_devdata *dd, char *name,
 		ipath_dev_err(dd, "Unsupported InfiniPath hardware revision %u.%u!\n",
 			      dd->ipath_majrev, dd->ipath_minrev);
 		ret = 1;
-	} else
+	} else {
 		ret = 0;
+		if (dd->ipath_minrev >= 2)
+			dd->ipath_f_put_tid = ipath_pe_put_tid_2;
+	}
 
 	return ret;
 }
@@ -1220,7 +1225,7 @@ static void ipath_pe_clear_tids(struct ipath_devdata *dd, unsigned port)
 		 port * dd->ipath_rcvtidcnt * sizeof(*tidbase));
 
 	for (i = 0; i < dd->ipath_rcvtidcnt; i++)
-		ipath_pe_put_tid(dd, &tidbase[i], RCVHQ_RCV_TYPE_EXPECTED,
+		dd->ipath_f_put_tid(dd, &tidbase[i], RCVHQ_RCV_TYPE_EXPECTED,
 				 tidinv);
 
 	tidbase = (u64 __iomem *)
@@ -1229,7 +1234,7 @@ static void ipath_pe_clear_tids(struct ipath_devdata *dd, unsigned port)
 		 port * dd->ipath_rcvegrcnt * sizeof(*tidbase));
 
 	for (i = 0; i < dd->ipath_rcvegrcnt; i++)
-		ipath_pe_put_tid(dd, &tidbase[i], RCVHQ_RCV_TYPE_EAGER,
+		dd->ipath_f_put_tid(dd, &tidbase[i], RCVHQ_RCV_TYPE_EAGER,
 				 tidinv);
 }
 
@@ -1395,10 +1400,11 @@ void ipath_init_iba6120_funcs(struct ipath_devdata *dd)
 	dd->ipath_f_quiet_serdes = ipath_pe_quiet_serdes;
 	dd->ipath_f_bringup_serdes = ipath_pe_bringup_serdes;
 	dd->ipath_f_clear_tids = ipath_pe_clear_tids;
-	if (dd->ipath_minrev >= 2)
-		dd->ipath_f_put_tid = ipath_pe_put_tid_2;
-	else
-		dd->ipath_f_put_tid = ipath_pe_put_tid;
+	/*
+	 * this may get changed after we read the chip revision,
+	 * but we start with the safe version for all revs
+	 */
+	dd->ipath_f_put_tid = ipath_pe_put_tid;
 	dd->ipath_f_cleanup = ipath_setup_pe_cleanup;
 	dd->ipath_f_setextled = ipath_setup_pe_setextled;
 	dd->ipath_f_get_base_info = ipath_pe_get_base_info;
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index 49951d5..9dd0bac 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -782,7 +782,7 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 	 * Follows early_init because some chips have to initialize
 	 * PIO buffers in early_init to avoid false parity errors.
 	 */
-	ipath_cancel_sends(dd);
+	ipath_cancel_sends(dd, 0);
 
 	/* early_init sets rcvhdrentsize and rcvhdrsize, so this must be
 	 * done after early_init */
@@ -851,13 +851,14 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_hwerrmask,
 			 dd->ipath_hwerrmask);
 
-	dd->ipath_maskederrs = dd->ipath_ignorederrs;
 	/* clear all */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errorclear, -1LL);
 	/* enable errors that are masked, at least this first time. */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
 			 ~dd->ipath_maskederrs);
-	/* clear any interrups up to this point (ints still not enabled) */
+	dd->ipath_errormask = ipath_read_kreg64(dd,
+		dd->ipath_kregs->kr_errormask);
+	/* clear any interrupts up to this point (ints still not enabled) */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_intclear, -1LL);
 
 	/*
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 1fd91c5..b29fe7e 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -303,7 +303,7 @@ static void handle_e_ibstatuschanged(struct ipath_devdata *dd,
 		 * Flush all queued sends when link went to DOWN or INIT,
 		 * to be sure that they don't block SMA and other MAD packets
 		 */
-		ipath_cancel_sends(dd);
+		ipath_cancel_sends(dd, 1);
 	}
 	else if (lstate == IPATH_IBSTATE_INIT || lstate == IPATH_IBSTATE_ARM ||
 	    lstate == IPATH_IBSTATE_ACTIVE) {
@@ -517,10 +517,7 @@ static int handle_errors(struct ipath_devdata *dd, ipath_err_t errs)
 
 	supp_msgs = handle_frequent_errors(dd, errs, msg, &noprint);
 
-	/*
-	 * don't report errors that are masked (includes those always
-	 * ignored)
-	 */
+	/* don't report errors that are masked */
 	errs &= ~dd->ipath_maskederrs;
 
 	/* do these first, they are most important */
@@ -566,19 +563,19 @@ static int handle_errors(struct ipath_devdata *dd, ipath_err_t errs)
 		 * ones on this particular interrupt, which also isn't great
 		 */
 		dd->ipath_maskederrs |= dd->ipath_lasterror | errs;
+		dd->ipath_errormask &= ~dd->ipath_maskederrs;
 		ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
-				 ~dd->ipath_maskederrs);
+			dd->ipath_errormask);
 		s_iserr = ipath_decode_err(msg, sizeof msg,
-				 (dd->ipath_maskederrs & ~dd->
-				  ipath_ignorederrs));
+			dd->ipath_maskederrs);
 
-		if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs) &
+		if (dd->ipath_maskederrs &
 			~(INFINIPATH_E_RRCVEGRFULL |
 			INFINIPATH_E_RRCVHDRFULL | INFINIPATH_E_PKTERRS))
 			ipath_dev_err(dd, "Temporarily disabling "
 			    "error(s) %llx reporting; too frequent (%s)\n",
-				(unsigned long long) (dd->ipath_maskederrs &
-				~dd->ipath_ignorederrs), msg);
+				(unsigned long long)dd->ipath_maskederrs,
+				msg);
 		else {
 			/*
 			 * rcvegrfull and rcvhdrqfull are "normal",
@@ -793,19 +790,22 @@ void ipath_clear_freeze(struct ipath_devdata *dd)
 	/* disable error interrupts, to avoid confusion */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask, 0ULL);
 
+	/* also disable interrupts; errormask is sometimes overwriten */
+	ipath_write_kreg(dd, dd->ipath_kregs->kr_intmask, 0ULL);
+
 	/*
 	 * clear all sends, because they have may been
 	 * completed by usercode while in freeze mode, and
 	 * therefore would not be sent, and eventually
 	 * might cause the process to run out of bufs
 	 */
-	ipath_cancel_sends(dd);
+	ipath_cancel_sends(dd, 0);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_control,
 			 dd->ipath_control);
 
 	/* ensure pio avail updates continue */
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl,
-		 dd->ipath_sendctrl & ~IPATH_S_PIOBUFAVAILUPD);
+		 dd->ipath_sendctrl & ~INFINIPATH_S_PIOBUFAVAILUPD);
 	ipath_read_kreg64(dd, dd->ipath_kregs->kr_scratch);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl,
 		 dd->ipath_sendctrl);
@@ -817,7 +817,7 @@ void ipath_clear_freeze(struct ipath_devdata *dd)
 	for (i = 0; i < dd->ipath_pioavregs; i++) {
 		/* deal with 6110 chip bug */
 		im = i > 3 ? ((i&1) ? i-1 : i+1) : i;
-		val = ipath_read_kreg64(dd, 0x1000+(im*sizeof(u64)));
+		val = ipath_read_kreg64(dd, (0x1000/sizeof(u64))+im);
 		dd->ipath_pioavailregs_dma[i] = dd->ipath_pioavailshadow[i]
 			= le64_to_cpu(val);
 	}
@@ -832,7 +832,8 @@ void ipath_clear_freeze(struct ipath_devdata *dd)
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errorclear,
 		E_SPKT_ERRS_IGNORE);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
-		~dd->ipath_maskederrs);
+		dd->ipath_errormask);
+	ipath_write_kreg(dd, dd->ipath_kregs->kr_intmask, -1LL);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_intclear, 0ULL);
 }
 
@@ -1002,7 +1003,6 @@ irqreturn_t ipath_intr(int irq, void *data)
 	u32 istat, chk0rcv = 0;
 	ipath_err_t estat = 0;
 	irqreturn_t ret;
-	u32 oldhead, curtail;
 	static unsigned unexpected = 0;
 	static const u32 port0rbits = (1U<<INFINIPATH_I_RCVAVAIL_SHIFT) |
 		 (1U<<INFINIPATH_I_RCVURG_SHIFT);
@@ -1035,36 +1035,6 @@ irqreturn_t ipath_intr(int irq, void *data)
 		goto bail;
 	}
 
-	/*
-	 * We try to avoid reading the interrupt status register, since
-	 * that's a PIO read, and stalls the processor for up to about
-	 * ~0.25 usec. The idea is that if we processed a port0 packet,
-	 * we blindly clear the  port 0 receive interrupt bits, and nothing
-	 * else, then return.  If other interrupts are pending, the chip
-	 * will re-interrupt us as soon as we write the intclear register.
-	 * We then won't process any more kernel packets (if not the 2nd
-	 * time, then the 3rd or 4th) and we'll then handle the other
-	 * interrupts.   We clear the interrupts first so that we don't
-	 * lose intr for later packets that arrive while we are processing.
-	 */
-	oldhead = dd->ipath_port0head;
-	curtail = (u32)le64_to_cpu(*dd->ipath_hdrqtailptr);
-	if (oldhead != curtail) {
-		if (dd->ipath_flags & IPATH_GPIO_INTR) {
-			ipath_write_kreg(dd, dd->ipath_kregs->kr_gpio_clear,
-					 (u64) (1 << IPATH_GPIO_PORT0_BIT));
-			istat = port0rbits | INFINIPATH_I_GPIO;
-		}
-		else
-			istat = port0rbits;
-		ipath_write_kreg(dd, dd->ipath_kregs->kr_intclear, istat);
-		ipath_kreceive(dd);
-		if (oldhead != dd->ipath_port0head) {
-			ipath_stats.sps_fastrcvint++;
-			goto done;
-		}
-	}
-
 	istat = ipath_read_kreg32(dd, dd->ipath_kregs->kr_intstatus);
 
 	if (unlikely(!istat)) {
@@ -1225,7 +1195,6 @@ irqreturn_t ipath_intr(int irq, void *data)
 		handle_layer_pioavail(dd);
 	}
 
-done:
 	ret = IRQ_HANDLED;
 
 bail:
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index ace63ef..7a7966f 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -261,18 +261,10 @@ struct ipath_devdata {
 	 * limiting of hwerror reporting
 	 */
 	ipath_err_t ipath_lasthwerror;
-	/*
-	 * errors masked because they occur too fast, also includes errors
-	 * that are always ignored (ipath_ignorederrs)
-	 */
+	/* errors masked because they occur too fast */
 	ipath_err_t ipath_maskederrs;
 	/* time in jiffies at which to re-enable maskederrs */
 	unsigned long ipath_unmasktime;
-	/*
-	 * errors always ignored (masked), at least for a given
-	 * chip/device, because they are wrong or not useful
-	 */
-	ipath_err_t ipath_ignorederrs;
 	/* count of egrfull errors, combined for all ports */
 	u64 ipath_last_tidfull;
 	/* for ipath_qcheck() */
@@ -436,6 +428,7 @@ struct ipath_devdata {
 	u64 ipath_lastibcstat;
 	/* hwerrmask shadow */
 	ipath_err_t ipath_hwerrmask;
+	ipath_err_t ipath_errormask; /* errormask shadow */
 	/* interrupt config reg shadow */
 	u64 ipath_intconfig;
 	/* kr_sendpiobufbase value */
@@ -683,7 +676,7 @@ int ipath_unordered_wc(void);
 
 void ipath_disarm_piobufs(struct ipath_devdata *, unsigned first,
 			  unsigned cnt);
-void ipath_cancel_sends(struct ipath_devdata *);
+void ipath_cancel_sends(struct ipath_devdata *, int);
 
 int ipath_create_rcvhdrq(struct ipath_devdata *, struct ipath_portdata *);
 void ipath_free_pddata(struct ipath_devdata *, struct ipath_portdata *);
diff --git a/drivers/infiniband/hw/ipath/ipath_stats.c b/drivers/infiniband/hw/ipath/ipath_stats.c
index 73ed17d..bae4f56 100644
--- a/drivers/infiniband/hw/ipath/ipath_stats.c
+++ b/drivers/infiniband/hw/ipath/ipath_stats.c
@@ -196,6 +196,45 @@ static void ipath_qcheck(struct ipath_devdata *dd)
 	}
 }
 
+static void ipath_chk_errormask(struct ipath_devdata *dd)
+{
+	static u32 fixed;
+	u32 ctrl;
+	unsigned long errormask;
+	unsigned long hwerrs;
+
+	if (!dd->ipath_errormask || !(dd->ipath_flags & IPATH_INITTED))
+		return;
+
+	errormask = ipath_read_kreg64(dd, dd->ipath_kregs->kr_errormask);
+
+	if (errormask == dd->ipath_errormask)
+		return;
+	fixed++;
+
+	hwerrs = ipath_read_kreg64(dd, dd->ipath_kregs->kr_hwerrstatus);
+	ctrl = ipath_read_kreg32(dd, dd->ipath_kregs->kr_control);
+
+	ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
+		dd->ipath_errormask);
+
+	if ((hwerrs & dd->ipath_hwerrmask) ||
+		(ctrl & INFINIPATH_C_FREEZEMODE)) {
+		/* force re-interrupt of pending events, just in case */
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_hwerrclear, 0ULL);
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_errorclear, 0ULL);
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_intclear, 0ULL);
+		dev_info(&dd->pcidev->dev,
+			"errormask fixed(%u) %lx -> %lx, ctrl %x hwerr %lx\n",
+			fixed, errormask, (unsigned long)dd->ipath_errormask,
+			ctrl, hwerrs);
+	} else
+		ipath_dbg("errormask fixed(%u) %lx -> %lx, no freeze\n",
+			fixed, errormask,
+			(unsigned long)dd->ipath_errormask);
+}
+
+
 /**
  * ipath_get_faststats - get word counters from chip before they overflow
  * @opaque - contains a pointer to the infinipath device ipath_devdata
@@ -251,14 +290,13 @@ void ipath_get_faststats(unsigned long opaque)
 		dd->ipath_lasterror = 0;
 	if (dd->ipath_lasthwerror)
 		dd->ipath_lasthwerror = 0;
-	if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs)
+	if (dd->ipath_maskederrs
 	    && time_after(jiffies, dd->ipath_unmasktime)) {
 		char ebuf[256];
 		int iserr;
 		iserr = ipath_decode_err(ebuf, sizeof ebuf,
-				 (dd->ipath_maskederrs & ~dd->
-				  ipath_ignorederrs));
-		if ((dd->ipath_maskederrs & ~dd->ipath_ignorederrs) &
+			dd->ipath_maskederrs);
+		if (dd->ipath_maskederrs &
 				~(INFINIPATH_E_RRCVEGRFULL | INFINIPATH_E_RRCVHDRFULL |
 				INFINIPATH_E_PKTERRS ))
 			ipath_dev_err(dd, "Re-enabling masked errors "
@@ -278,9 +316,12 @@ void ipath_get_faststats(unsigned long opaque)
 				ipath_cdbg(ERRPKT, "Re-enabling packet"
 						" problem interrupt (%s)\n", ebuf);
 		}
-		dd->ipath_maskederrs = dd->ipath_ignorederrs;
+
+		/* re-enable masked errors */
+		dd->ipath_errormask |= dd->ipath_maskederrs;
 		ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask,
-				 ~dd->ipath_maskederrs);
+			dd->ipath_errormask);
+		dd->ipath_maskederrs = 0;
 	}
 
 	/* limit qfull messages to ~one per minute per port */
@@ -294,6 +335,7 @@ void ipath_get_faststats(unsigned long opaque)
 		}
 	}
 
+	ipath_chk_errormask(dd);
 done:
 	mod_timer(&dd->ipath_stats_timer, jiffies + HZ * 5);
 }
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index f6315df..ba0428d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1209,7 +1209,6 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = cpu_to_be32(wr->wr.ud.remote_qpn);
 	dseg->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
-
 }
 
 static void set_data_seg(struct mlx4_wqe_data_seg *dseg,
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index d0808fa..5b87183 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -255,10 +255,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 	int err;
 
 	index = mlx4_bitmap_alloc(&priv->mr_table.mpt_bitmap);
-	if (index == -1) {
-		err = -ENOMEM;
-		goto err;
-	}
+	if (index == -1)
+		return -ENOMEM;
 
 	mr->iova       = iova;
 	mr->size       = size;
@@ -269,15 +267,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 
 	err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
 	if (err)
-		goto err_index;
-
-	return 0;
-
-err_index:
-	mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, index);
+		mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, index);
 
-err:
-	kfree(mr);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_alloc);
