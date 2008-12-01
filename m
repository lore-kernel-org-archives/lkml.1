Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYLAX04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYLAX04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYLAX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:26:45 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1229 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbYLAX0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:26:44 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
From: "Michael Chan" <mchan@broadcom.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>, davem@davemloft.net
cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <1227719692.13189.7.camel@HP1>
References: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
 <491154C8.3040401@cosmosbay.com> <492D107B.1060303@cosmosbay.com>
 <1227719692.13189.7.camel@HP1>
Date: Mon, 01 Dec 2008 15:23:39 -0800
Message-ID: <1228173819.15505.15.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 652AAD2637G22351957-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-11-26 at 09:14 -0800, Michael Chan wrote:
> On Wed, 2008-11-26 at 01:01 -0800, Eric Dumazet wrote:
> > Eric Dumazet a écrit :
> > > Michael Chan a écrit :
> > >> I believe this may be the patch that broke it:
> > >>
> > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd 
> > >>
> > >>
> > >> I don't remember all the details, but the Broadcom 5708 chip is
> > >> affected because it does not support MSI per-vector masking.
> > >>
> > >> One way to get around is to disable MSI with bnx2 parameter
> > >> disable_msi=1.
> > >>
> > 
> > > 
> > > I tried this MSI disabling and yes, it now works.
> > > 
> > > 16:      42726        128        105        106         89         
> > > 89        145        152   IO-APIC-fasteoi   uhci_hcd:usb1, eth0, eth1
> > > 
> > 
> > I believe the bnx2 driver doesnt work at all if !disable_msi (default setting)
> > 
> > Doing a "echo 0 >/sys/devices/system/cpu/cpu1/online" just freeze network
> > 
> > No messages logged
> > 
> > If loaded with disable_msi=1, the cpu unplug works as expected.
> > 
> > Thats a pretty serious issue.
> >
> Yes, that's the same issue and it is serious.  If MSI is being delivered
> to CPU 1 and you then take CPU 1 offline, the MSI will not be delivered
> to another CPU.
> 
> I think I can detect this problem in bnx2_timer() and try to recover.
> I'll post a patch when I have something ready.  Thanks.

[PATCH] bnx2: Add workaround to handle missed MSI.

The bnx2 chips do not support per MSI vector masking.  On 5706/5708, new MSI
address/data are stored only when the MSI enable bit is toggled.  As a result,
SMP affinity no longer works in the latest kernel.  A more serious problem is
that the driver will no longer receive interrupts when the MSI receiving CPU
goes offline.

The workaround in this patch only addresses the problem of CPU going offline.
When that happens, the driver's timer function will detect that it is making
no forward progress on pending interrupt events and will recover from it.

Eric Dumazet reported the problem.

We also found that if an interrupt is internally asserted while MSI and INTA
are disabled, the chip will end up in the same state after MSI is re-enabled.
The same workaround is needed for this problem. 

Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/net/bnx2.c |   35 ++++++++++++++++++++++++++++++++---
 drivers/net/bnx2.h |    6 ++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 182f241..0e2218d 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -3147,6 +3147,28 @@ bnx2_has_work(struct bnx2_napi *bnapi)
 	return 0;
 }
 
+static void
+bnx2_chk_missed_msi(struct bnx2 *bp)
+{
+	struct bnx2_napi *bnapi = &bp->bnx2_napi[0];
+	u32 msi_ctrl;
+
+	if (bnx2_has_work(bnapi)) {
+		msi_ctrl = REG_RD(bp, BNX2_PCICFG_MSI_CONTROL);
+		if (!(msi_ctrl & BNX2_PCICFG_MSI_CONTROL_ENABLE))
+			return;
+
+		if (bnapi->last_status_idx == bp->idle_chk_status_idx) {
+			REG_WR(bp, BNX2_PCICFG_MSI_CONTROL, msi_ctrl &
+			       ~BNX2_PCICFG_MSI_CONTROL_ENABLE);
+			REG_WR(bp, BNX2_PCICFG_MSI_CONTROL, msi_ctrl);
+			bnx2_msi(bp->irq_tbl[0].vector, bnapi);
+		}
+	}
+
+	bp->idle_chk_status_idx = bnapi->last_status_idx;
+}
+
 static void bnx2_poll_link(struct bnx2 *bp, struct bnx2_napi *bnapi)
 {
 	struct status_block *sblk = bnapi->status_blk.msi;
@@ -3221,14 +3243,15 @@ static int bnx2_poll(struct napi_struct *napi, int budget)
 
 		work_done = bnx2_poll_work(bp, bnapi, work_done, budget);
 
-		if (unlikely(work_done >= budget))
-			break;
-
 		/* bnapi->last_status_idx is used below to tell the hw how
 		 * much work has been processed, so we must read it before
 		 * checking for more work.
 		 */
 		bnapi->last_status_idx = sblk->status_idx;
+
+		if (unlikely(work_done >= budget))
+			break;
+
 		rmb();
 		if (likely(!bnx2_has_work(bnapi))) {
 			netif_rx_complete(bp->dev, napi);
@@ -4581,6 +4604,8 @@ bnx2_init_chip(struct bnx2 *bp)
 	for (i = 0; i < BNX2_MAX_MSIX_VEC; i++)
 		bp->bnx2_napi[i].last_status_idx = 0;
 
+	bp->idle_chk_status_idx = 0xffff;
+
 	bp->rx_mode = BNX2_EMAC_RX_MODE_SORT_MODE;
 
 	/* Set up how to generate a link change interrupt. */
@@ -5729,6 +5754,10 @@ bnx2_timer(unsigned long data)
 	if (atomic_read(&bp->intr_sem) != 0)
 		goto bnx2_restart_timer;
 
+	if ((bp->flags & (BNX2_FLAG_USING_MSI | BNX2_FLAG_ONE_SHOT_MSI)) ==
+	     BNX2_FLAG_USING_MSI)
+		bnx2_chk_missed_msi(bp);
+
 	bnx2_send_heart_beat(bp);
 
 	bp->stats_blk->stat_FwRxDrop =
diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index 0763108..2f43c45 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -378,6 +378,9 @@ struct l2_fhdr {
  *  pci_config_l definition
  *  offset: 0000
  */
+#define BNX2_PCICFG_MSI_CONTROL				0x00000058
+#define BNX2_PCICFG_MSI_CONTROL_ENABLE			 (1L<<16)
+
 #define BNX2_PCICFG_MISC_CONFIG				0x00000068
 #define BNX2_PCICFG_MISC_CONFIG_TARGET_BYTE_SWAP	 (1L<<2)
 #define BNX2_PCICFG_MISC_CONFIG_TARGET_MB_WORD_SWAP	 (1L<<3)
@@ -6882,6 +6885,9 @@ struct bnx2 {
 
 	u8			num_tx_rings;
 	u8			num_rx_rings;
+
+	u32			idle_chk_status_idx;
+
 };
 
 #define REG_RD(bp, offset)					\
-- 
1.5.6.GIT




