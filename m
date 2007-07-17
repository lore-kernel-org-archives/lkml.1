Return-Path: <linux-kernel-owner+w=401wt.eu-S936766AbXGQVn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936766AbXGQVn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXGQVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:43:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXGQVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:43:09 -0400
Date: Tue, 17 Jul 2007 17:42:39 -0400
From: Jeff Garzik <jgarzik@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: [git patches 1/2] warnings: attack valid cases spotted by warnings
Message-ID: <20070717214239.GF28448@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Those "may be used uninitialized" warnings are annoying.  So annoying
that kernel developers tune them out, and that occasionally hides
real bugs, as my past patches (and those below) indicate.

I included the full-length changelog below the diffstat, because
that is where the best explanation for each change is found.  In most
cases that's where all the length is -- a paragraph or two describing
what is usually a one-line code change, usually an initialization or
simple cleanup.

This is the first of two git pull sets, the -parent-.  If you pull
'warnings' branch, you get what you see below and nothing else.
WYSIWYG.  You'll see in the second email why I distinguish the two.

Please pull from 'warnings' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings

Jeff Garzik (11):
      kernel/auditfilter: kill bogus uninit'd-var compiler warning
      [netdrvr] natsemi: Fix device removal bug
      [netdrvr] eepro100, ne2k-pci: abort resume if pci_enable_device() fails
      drivers/usb/misc/auerswald: fix status check, remove redundant check
      drivers/net/wan/pc300_drv: fix bug caught by gcc warning
      drivers/telephony/ixj: cleanup and fix gcc warning
      drivers/mtd/ubi/eba: minor cleanup: tighten scope of a local var
      drivers/net/wan/sbni: kill uninit'd var warning
      drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd var warning
      [libata] sata_mv: use pci_try_set_mwi()
      drivers/atm/ambassador: kill uninit'd var warning, and fix bug

 drivers/ata/sata_mv.c                  |    2 +-
 drivers/atm/ambassador.c               |    4 +++-
 drivers/infiniband/hw/mthca/mthca_qp.c |    4 ++--
 drivers/mtd/ubi/eba.c                  |    4 ++--
 drivers/net/eepro100.c                 |    7 ++++++-
 drivers/net/natsemi.c                  |    2 +-
 drivers/net/ne2k-pci.c                 |    7 ++++++-
 drivers/net/wan/pc300_drv.c            |    2 ++
 drivers/net/wan/sbni.c                 |    7 +++----
 drivers/telephony/ixj.c                |    7 ++++++-
 drivers/usb/misc/auerswald.c           |    2 +-
 kernel/auditfilter.c                   |   12 ++++--------
 12 files changed, 37 insertions(+), 23 deletions(-)

commit b1734d2388cc45ecdec58615e35955d0d402f938
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 02:32:21 2007 -0400

    drivers/atm/ambassador: kill uninit'd var warning, and fix bug
    
    An uninitialized variable warning illuminated an area where indeed the
    variable was being used without initialization.  Unfortunately, after
    verifying all such paths were fixed, the warning still appears.  So we
    follow the initialization practice of other variables in this function.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit ea8b4db97aa41a66c05daa4055a1974692ccd52d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 02:21:50 2007 -0400

    [libata] sata_mv: use pci_try_set_mwi()
    
    Because sometimes in life, it's ok to fail.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 9db48926208562df3c778682e064990170ab8971
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 02:03:49 2007 -0400

    drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd var warning
    
    drivers/infiniband/hw/mthca/mthca_qp.c: In function
      ‘mthca_tavor_post_send’:
    drivers/infiniband/hw/mthca/mthca_qp.c:1594: warning: ‘f0’ may be used
      uninitialized in this function
    drivers/infiniband/hw/mthca/mthca_qp.c: In function
      ‘mthca_arbel_post_send’:
    drivers/infiniband/hw/mthca/mthca_qp.c:1949: warning: ‘f0’ may be used
      uninitialized in this function
    
    Initializing 'f0' is not strictly necessary in either case, AFAICS.
    
    I was considering use of uninitialized_var(), but looking at the
    complex flow of control in each function, I feel it is wiser and
    safer to simply zero the var and be certain of ourselves.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit e5fb4f42268654ca41ab50b1406fb7da97559db5
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 01:56:32 2007 -0400

    drivers/net/wan/sbni: kill uninit'd var warning
    
    It's actually convenient in the code to initialize this and a sister
    variable to zero.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 2ab934b8afa89b9b3e71b7fb66470a19772f5012
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 01:49:56 2007 -0400

    drivers/mtd/ubi/eba: minor cleanup: tighten scope of a local var
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 0d480db85dea59e1393c3968fbdac0117431e797
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 01:35:08 2007 -0400

    drivers/telephony/ixj: cleanup and fix gcc warning
    
    1) Fix gcc uninit'd var warnings by adding 'default' switch stmt labels
    in two cases.  It was lightning-strikes unlikely that a problem would
    ever arise, but not impossible.
    
    2) Tighten the scope of 'blankword' in two cases.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 79c63e1976df035dee587c016d79cbccb130494a
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 01:32:29 2007 -0400

    drivers/net/wan/pc300_drv: fix bug caught by gcc warning
    
    The warning
    
    drivers/net/wan/pc300_drv.c: In function ‘cpc_open’:
    drivers/net/wan/pc300_drv.c:2942: warning: ‘br’ may be used
    uninitialized in this function
    
    was valid.  Ensure 'br' is initialized in all cases.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit ae97fec3701a559929c3529e35417fab133a4d39
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 01:08:29 2007 -0400

    drivers/usb/misc/auerswald: fix status check, remove redundant check
    
    1) We should only set 'actual_length' output variable if usb length is
    known to be good.
    
    2) No need to check actual_length for NULL.  The only caller always
    passes non-NULL value.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit cad1b9da74f14c5f15b63ffc93c53debe09b3781
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 00:15:54 2007 -0400

    [netdrvr] eepro100, ne2k-pci: abort resume if pci_enable_device() fails
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit f6c4286590e7cb13dd16cb2a6e4dc4a27ce6df1d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 00:01:09 2007 -0400

    [netdrvr] natsemi: Fix device removal bug
    
    This episode illustrates how an overused warning can train people to
    ignore that warning, which winds up hiding bugs.
    
    The warning
    
    drivers/net/natsemi.c: In function ‘natsemi_remove1’:
    drivers/net/natsemi.c:3222: warning: ignoring return value of
    ‘device_create_file’, declared with attribute warn_unused_result
    
    is oft-ignored, even though at close inspection one notices this occurs
    in the /remove/ function, not normally where creation occurs.  A quick
    s/create/remove/ and we are fixed, with the warning gone.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 6f686d3d14621b90f3793b705bdf9fa624fd29ca
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Jul 16 21:25:01 2007 -0400

    kernel/auditfilter: kill bogus uninit'd-var compiler warning
    
    Kill this warning...
    
    kernel/auditfilter.c: In function ‘audit_receive_filter’:
    kernel/auditfilter.c:1213: warning: ‘ndw’ may be used uninitialized in this function
    kernel/auditfilter.c:1213: warning: ‘ndp’ may be used uninitialized in this function
    
    ...with a simplification of the code.  audit_put_nd() can accept NULL
    arguments, just like kfree().  It is cleaner to init two existing vars
    to NULL, remove the redundant test variable 'putnd_needed' branches, and call
    audit_put_nd() directly.
    
    As a desired side effect, the warning goes away.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 5d57643..fb8a749 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2666,7 +2666,7 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mv_print_info(host);
 
 	pci_set_master(pdev);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
 				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
 }
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index 59651ab..b34b382 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -1040,7 +1040,7 @@ static int amb_open (struct atm_vcc * atm_vcc)
   struct atm_qos * qos;
   struct atm_trafprm * txtp;
   struct atm_trafprm * rxtp;
-  u16 tx_rate_bits;
+  u16 tx_rate_bits = -1; // hush gcc
   u16 tx_vc_bits = -1; // hush gcc
   u16 tx_frame_bits = -1; // hush gcc
   
@@ -1096,6 +1096,8 @@ static int amb_open (struct atm_vcc * atm_vcc)
 	    r = round_up;
 	  }
 	  error = make_rate (pcr, r, &tx_rate_bits, NULL);
+	  if (error)
+	    return error;
 	  tx_vc_bits = TX_UBR_CAPPED;
 	  tx_frame_bits = TX_FRAME_CAPPED;
 	}
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index eef415b..11f1d99 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1591,7 +1591,7 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int i;
 	int size;
 	int size0 = 0;
-	u32 f0;
+	u32 f0 = 0;
 	int ind;
 	u8 op0 = 0;
 
@@ -1946,7 +1946,7 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int i;
 	int size;
 	int size0 = 0;
-	u32 f0;
+	u32 f0 = 0;
 	int ind;
 	u8 op0 = 0;
 
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 7400294..4dc10c8 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -368,7 +368,7 @@ int ubi_eba_read_leb(struct ubi_device *ubi, int vol_id, int lnum, void *buf,
 	int err, pnum, scrub = 0, idx = vol_id2idx(ubi, vol_id);
 	struct ubi_vid_hdr *vid_hdr;
 	struct ubi_volume *vol = ubi->volumes[idx];
-	uint32_t crc, crc1;
+	uint32_t crc;
 
 	err = leb_read_lock(ubi, vol_id, lnum);
 	if (err)
@@ -451,7 +451,7 @@ retry:
 	}
 
 	if (check) {
-		crc1 = crc32(UBI_CRC32_INIT, buf, len);
+		uint32_t crc1 = crc32(UBI_CRC32_INIT, buf, len);
 		if (crc1 != crc) {
 			ubi_warn("CRC error: calculated %#08x, must be %#08x",
 				 crc1, crc);
diff --git a/drivers/net/eepro100.c b/drivers/net/eepro100.c
index 9afa47e..3c54014 100644
--- a/drivers/net/eepro100.c
+++ b/drivers/net/eepro100.c
@@ -2292,10 +2292,15 @@ static int eepro100_resume(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata (pdev);
 	struct speedo_private *sp = netdev_priv(dev);
 	void __iomem *ioaddr = sp->regs;
+	int rc;
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
 	pci_set_master(pdev);
 
 	if (!netif_running(dev))
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 3450051..6bb48ba 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -671,7 +671,7 @@ static ssize_t natsemi_show_##_name(struct device *dev, \
 #define NATSEMI_CREATE_FILE(_dev, _name) \
          device_create_file(&_dev->dev, &dev_attr_##_name)
 #define NATSEMI_REMOVE_FILE(_dev, _name) \
-         device_create_file(&_dev->dev, &dev_attr_##_name)
+         device_remove_file(&_dev->dev, &dev_attr_##_name)
 
 NATSEMI_ATTR(dspcfg_workaround);
 
diff --git a/drivers/net/ne2k-pci.c b/drivers/net/ne2k-pci.c
index 995c0a5..cfdeaf7 100644
--- a/drivers/net/ne2k-pci.c
+++ b/drivers/net/ne2k-pci.c
@@ -669,10 +669,15 @@ static int ne2k_pci_suspend (struct pci_dev *pdev, pm_message_t state)
 static int ne2k_pci_resume (struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
+	int rc;
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
 	NS8390_init(dev, 1);
 	netif_device_attach(dev);
 
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index ec1c556..5d8c78e 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -2833,6 +2833,8 @@ static int clock_rate_calc(uclong rate, uclong clock, int *br_io)
 	int br, tc;
 	int br_pwr, error;
 
+	*br_io = 0;
+
 	if (rate == 0)
 		return (0);
 
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 35eded7..1cc18e7 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -595,8 +595,8 @@ recv_frame( struct net_device  *dev )
 
 	u32  crc = CRC32_INITIAL;
 
-	unsigned  framelen, frameno, ack;
-	unsigned  is_first, frame_ok;
+	unsigned  framelen = 0, frameno, ack;
+	unsigned  is_first, frame_ok = 0;
 
 	if( check_fhdr( ioaddr, &framelen, &frameno, &ack, &is_first, &crc ) ) {
 		frame_ok = framelen > 4
@@ -604,8 +604,7 @@ recv_frame( struct net_device  *dev )
 			:  skip_tail( ioaddr, framelen, crc );
 		if( frame_ok )
 			interpret_ack( dev, ack );
-	} else
-		frame_ok = 0;
+	}
 
 	outb( inb( ioaddr + CSR0 ) ^ CT_ZER, ioaddr + CSR0 );
 	if( frame_ok ) {
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index c7b0a35..49cd979 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -3453,7 +3453,6 @@ static void ixj_write_frame(IXJ *j)
 {
 	int cnt, frame_count, dly;
 	IXJ_WORD dat;
-	BYTES blankword;
 
 	frame_count = 0;
 	if(j->flags.cidplay) {
@@ -3501,6 +3500,8 @@ static void ixj_write_frame(IXJ *j)
 		}
 		if (frame_count >= 1) {
 			if (j->ver.low == 0x12 && j->play_mode && j->flags.play_first_frame) {
+				BYTES blankword;
+
 				switch (j->play_mode) {
 				case PLAYBACK_MODE_ULAW:
 				case PLAYBACK_MODE_ALAW:
@@ -3508,6 +3509,7 @@ static void ixj_write_frame(IXJ *j)
 					break;
 				case PLAYBACK_MODE_8LINEAR:
 				case PLAYBACK_MODE_16LINEAR:
+				default:
 					blankword.low = blankword.high = 0x00;
 					break;
 				case PLAYBACK_MODE_8LINEAR_WSS:
@@ -3531,6 +3533,8 @@ static void ixj_write_frame(IXJ *j)
 				j->flags.play_first_frame = 0;
 			} else	if (j->play_codec == G723_63 && j->flags.play_first_frame) {
 				for (cnt = 0; cnt < 24; cnt++) {
+					BYTES blankword;
+
 					if(cnt == 12) {
 						blankword.low = 0x02;
 						blankword.high = 0x00;
@@ -4868,6 +4872,7 @@ static char daa_CR_read(IXJ *j, int cr)
 		bytes.high = 0xB0 + cr;
 		break;
 	case SOP_PU_PULSEDIALING:
+	default:
 		bytes.high = 0xF0 + cr;
 		break;
 	}
diff --git a/drivers/usb/misc/auerswald.c b/drivers/usb/misc/auerswald.c
index 1fd5fc2..3e22b2f 100644
--- a/drivers/usb/misc/auerswald.c
+++ b/drivers/usb/misc/auerswald.c
@@ -630,7 +630,7 @@ static int auerchain_start_wait_urb (pauerchain_t acp, struct urb *urb, int time
 	} else
 		status = urb->status;
 
-	if (actual_length)
+	if (status >= 0)
 		*actual_length = urb->actual_length;
 
   	return status;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index ce61f42..1bf093d 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1210,8 +1210,8 @@ static inline int audit_add_rule(struct audit_entry *entry,
 	struct audit_entry *e;
 	struct audit_field *inode_f = entry->rule.inode_f;
 	struct audit_watch *watch = entry->rule.watch;
-	struct nameidata *ndp, *ndw;
-	int h, err, putnd_needed = 0;
+	struct nameidata *ndp = NULL, *ndw = NULL;
+	int h, err;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
 
@@ -1239,7 +1239,6 @@ static inline int audit_add_rule(struct audit_entry *entry,
 		err = audit_get_nd(watch->path, &ndp, &ndw);
 		if (err)
 			goto error;
-		putnd_needed = 1;
 	}
 
 	mutex_lock(&audit_filter_mutex);
@@ -1269,14 +1268,11 @@ static inline int audit_add_rule(struct audit_entry *entry,
 #endif
 	mutex_unlock(&audit_filter_mutex);
 
-	if (putnd_needed)
-		audit_put_nd(ndp, ndw);
-
+	audit_put_nd(ndp, ndw);		/* NULL args OK */
  	return 0;
 
 error:
-	if (putnd_needed)
-		audit_put_nd(ndp, ndw);
+	audit_put_nd(ndp, ndw);		/* NULL args OK */
 	if (watch)
 		audit_put_watch(watch); /* tmp watch, matches initial get */
 	return err;
