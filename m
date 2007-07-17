Return-Path: <linux-kernel-owner+w=401wt.eu-S936933AbXGQVut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936933AbXGQVut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935626AbXGQVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:50:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935369AbXGQVu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:50:29 -0400
Date: Tue, 17 Jul 2007 17:49:52 -0400
From: Jeff Garzik <jgarzik@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: [git patches 2/2] warnings: use uninitialized_var()
Message-ID: <20070717214952.GG28448@devserv.devel.redhat.com>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717214239.GF28448@devserv.devel.redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For many months, I have maintained a hand-verified list of bogus "may be
used uninitialized" warning fixes, in misc-2.6.git#gccbug.  Andrew urged
me to head these upstream.

I have gone through and re-analyzed each warning, and verified that
these variables are indeed initialized properly, and gcc is making
needless noise.

These uninitialized_var() markers are in a separate branch from the
other warning fixes/silences to enable people to object to this
separately.

Potential upsides of pulling 'uninit-var':

* reduces noise proven to hide bugs
* pushes upstream the work I have done, hand-verifying that each
  warning so marked is indeed bogus.
* uninitialized_var a grep-friendly symbol
* uninitialized_var could be disabled via Kconfig, if someone
  really wanted to see the warnings again

Potential downsides to uninitialized_var():

* Future code changes related to a marked variable could potentially
  result in hiding a valid uninit'd-var warning (i.e. hiding a bug).
* uninitialized_var stands out in the code.  Ugly?  Or a good thing?

This is the second of two git pulls, the -child-.  If you pull branch
'uninit-var', you will receive BOTH 'uninit-var' and 'warnings'
branches.

Please pull from 'uninit-var' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git uninit-var

commit 8e1c091cccd551557d24ce845715e8ceb6c49d36
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 05:40:59 2007 -0400

    arch/i386/* fs/* ipc/*: mark variables with uninitialized_var()
    
    Mark variables with uninitialized_var() if such a warning appears,
    and analysis proves that the var is initialized properly on all paths
    it is used.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit a6343afb6e16b65b9f0b264f94f8207212e7e3ae
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 17 05:39:58 2007 -0400

    drivers/*: mark variables with uninitialized_var()
    
    Mark variables in drivers/* with uninitialized_var() if such a warning
    appears, and analysis proves that the var is initialized properly on all
    paths it is used.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 arch/i386/kernel/efi.c                |    2 +-
 drivers/atm/zatm.c                    |    4 +++-
 drivers/char/cyclades.c               |    4 ++--
 drivers/mtd/ubi/eba.c                 |    2 +-
 drivers/net/r8169.c                   |    2 +-
 drivers/net/tokenring/smctr.c         |    6 ++++--
 drivers/usb/misc/auerswald.c          |    2 +-
 drivers/video/matrox/matroxfb_maven.c |    9 +++++++--
 drivers/video/riva/riva_hw.c          |    7 ++++++-
 fs/ocfs2/file.c                       |    3 ++-
 fs/udf/super.c                        |    2 +-
 ipc/msg.c                             |    4 ++--
 ipc/sem.c                             |    2 +-
 13 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/i386/kernel/efi.c b/arch/i386/kernel/efi.c
index a180802..2452c6f 100644
--- a/arch/i386/kernel/efi.c
+++ b/arch/i386/kernel/efi.c
@@ -278,7 +278,7 @@ void efi_memmap_walk(efi_freemem_callback_t callback, void *arg)
 	struct range {
 		unsigned long start;
 		unsigned long end;
-	} prev, curr;
+	} uninitialized_var(prev), curr;
 	efi_memory_desc_t *md;
 	unsigned long start, end;
 	void *p;
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 020a87a..58583c6 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -915,7 +915,7 @@ static int open_tx_first(struct atm_vcc *vcc)
 	unsigned long flags;
 	u32 *loop;
 	unsigned short chan;
-	int pcr,unlimited;
+	int unlimited;
 
 	DPRINTK("open_tx_first\n");
 	zatm_dev = ZATM_DEV(vcc->dev);
@@ -936,6 +936,8 @@ static int open_tx_first(struct atm_vcc *vcc)
 	    vcc->qos.txtp.max_pcr >= ATM_OC3_PCR);
 	if (unlimited && zatm_dev->ubr != -1) zatm_vcc->shaper = zatm_dev->ubr;
 	else {
+		int uninitialized_var(pcr);
+
 		if (unlimited) vcc->qos.txtp.max_sdu = ATM_MAX_AAL5_PDU;
 		if ((zatm_vcc->shaper = alloc_shaper(vcc->dev,&pcr,
 		    vcc->qos.txtp.min_pcr,vcc->qos.txtp.max_pcr,unlimited))
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 7b08394..9e0adfe 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4466,10 +4466,10 @@ static void cy_hangup(struct tty_struct *tty)
 static int __devinit cy_init_card(struct cyclades_card *cinfo)
 {
 	struct cyclades_port *info;
-	u32 mailbox;
+	u32 uninitialized_var(mailbox);
 	unsigned int nports;
 	unsigned short chip_number;
-	int index, port;
+	int uninitialized_var(index), port;
 
 	spin_lock_init(&cinfo->card_lock);
 
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 4dc10c8..7c6b223 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -368,7 +368,7 @@ int ubi_eba_read_leb(struct ubi_device *ubi, int vol_id, int lnum, void *buf,
 	int err, pnum, scrub = 0, idx = vol_id2idx(ubi, vol_id);
 	struct ubi_vid_hdr *vid_hdr;
 	struct ubi_volume *vol = ubi->volumes[idx];
-	uint32_t crc;
+	uint32_t uninitialized_var(crc);
 
 	err = leb_read_lock(ubi, vol_id, lnum);
 	if (err)
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 982a901..bb6896a 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2338,7 +2338,7 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 {
 	struct skb_shared_info *info = skb_shinfo(skb);
 	unsigned int cur_frag, entry;
-	struct TxDesc *txd;
+	struct TxDesc * uninitialized_var(txd);
 
 	entry = tp->cur_tx;
 	for (cur_frag = 0; cur_frag < info->nr_frags; cur_frag++) {
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 58d7e5d..f83bb5c 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -3692,7 +3692,6 @@ static int smctr_process_rx_packet(MAC_HEADER *rmf, __u16 size,
         __u16 rcode, correlator;
         int err = 0;
         __u8 xframe = 1;
-        __u16 tx_fstatus;
 
         rmf->vl = SWAP_BYTES(rmf->vl);
         if(rx_status & FCB_RX_STATUS_DA_MATCHED)
@@ -3783,7 +3782,9 @@ static int smctr_process_rx_packet(MAC_HEADER *rmf, __u16 size,
                                 }
                                 break;
 
-                        case TX_FORWARD:
+                        case TX_FORWARD: {
+        			__u16 uninitialized_var(tx_fstatus);
+
                                 if((rcode = smctr_rcv_tx_forward(dev, rmf))
                                         != POSITIVE_ACK)
                                 {
@@ -3811,6 +3812,7 @@ static int smctr_process_rx_packet(MAC_HEADER *rmf, __u16 size,
                                         }
                                 }
                                 break;
+			}
 
                         /* Received MAC Frames Processed by CRS/REM/RPS. */
                         case RSP:
diff --git a/drivers/usb/misc/auerswald.c b/drivers/usb/misc/auerswald.c
index 3e22b2f..42d4e64 100644
--- a/drivers/usb/misc/auerswald.c
+++ b/drivers/usb/misc/auerswald.c
@@ -664,7 +664,7 @@ static int auerchain_control_msg (pauerchain_t acp, struct usb_device *dev, unsi
 	int ret;
 	struct usb_ctrlrequest *dr;
 	struct urb *urb;
-        int length;
+        int uninitialized_var(length);
 
         dbg ("auerchain_control_msg");
         dr = kmalloc (sizeof (struct usb_ctrlrequest), GFP_KERNEL);
diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
index 5d29a26..de0d755 100644
--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -273,8 +273,11 @@ static int matroxfb_PLL_mavenclock(const struct matrox_pll_features2* pll,
 			}
 		}
 	}
+
+	/* if h2/post/in/feed have not been assigned, return zero (error) */
 	if (besth2 < 2)
 		return 0;
+
 	dprintk(KERN_ERR "clk: %02X %02X %02X %d %d\n", *in, *feed, *post, fxtal, fwant);
 	return fxtal * (*feed) / (*in) * ctl->den;
 }
@@ -284,7 +287,7 @@ static unsigned int matroxfb_mavenclock(const struct matrox_pll_ctl* ctl,
 		unsigned int* in, unsigned int* feed, unsigned int* post,
 		unsigned int* htotal2) {
 	unsigned int fvco;
-	unsigned int p;
+	unsigned int uninitialized_var(p);
 
 	fvco = matroxfb_PLL_mavenclock(&maven1000_pll, ctl, htotal, vtotal, in, feed, &p, htotal2);
 	if (!fvco)
@@ -715,7 +718,9 @@ static int maven_find_exact_clocks(unsigned int ht, unsigned int vt,
 	m->regs[0x82] = 0x81;
 
 	for (x = 0; x < 8; x++) {
-		unsigned int a, b, c, h2;
+		unsigned int c;
+		unsigned int uninitialized_var(a), uninitialized_var(b),
+			     uninitialized_var(h2);
 		unsigned int h = ht + 2 + x;
 
 		if (!matroxfb_mavenclock((m->mode == MATROXFB_OUTPUT_MODE_PAL) ? &maven_PAL : &maven_NTSC, h, vt, &a, &b, &c, &h2)) {
diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
index 70bfd78..1330770 100644
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -1223,6 +1223,8 @@ static int CalcVClock
         }
     }
     }
+
+    /* non-zero: M/N/P/clock values assigned.  zero: error (not set) */
     return (DeltaOld != 0xFFFFFFFF);
 }
 /*
@@ -1240,7 +1242,10 @@ int CalcStateExt
     int            dotClock
 )
 {
-    int pixelDepth, VClk, m, n, p;
+    int pixelDepth;
+    int uninitialized_var(VClk),uninitialized_var(m),
+        uninitialized_var(n),	uninitialized_var(p);
+
     /*
      * Save mode parameters.
      */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f04c7aa..004c2ab 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1867,7 +1867,8 @@ static ssize_t ocfs2_file_buffered_write(struct file *file, loff_t *ppos,
 	loff_t pos;
 	const struct iovec *cur_iov = iov;
 	struct page *user_page, *page;
-	char *buf, *dst;
+	char * uninitialized_var(buf);
+	char *dst;
 	void *fsdata;
 
 	/*
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6658afb..d6a504f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1356,7 +1356,7 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			case UDF_VIRTUAL_MAP15:
 			case UDF_VIRTUAL_MAP20:
 			{
-				kernel_lb_addr ino;
+				kernel_lb_addr uninitialized_var(ino);
 
 				if (!UDF_SB_LASTBLOCK(sb))
 				{
diff --git a/ipc/msg.c b/ipc/msg.c
index cbd27e5..a03fcb5 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -385,7 +385,7 @@ copy_msqid_from_user(struct msq_setbuf *out, void __user *buf, int version)
 asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msq_setbuf setbuf;
+	struct msq_setbuf uninitialized_var(setbuf);
 	struct msg_queue *msq;
 	int err, version;
 	struct ipc_namespace *ns;
@@ -509,7 +509,7 @@ asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 	err = audit_ipc_obj(ipcp);
 	if (err)
 		goto out_unlock_up;
-	if (cmd==IPC_SET) {
+	if (cmd == IPC_SET) {
 		err = audit_ipc_set_perm(setbuf.qbytes, setbuf.uid, setbuf.gid,
 					 setbuf.mode);
 		if (err)
diff --git a/ipc/sem.c b/ipc/sem.c
index 89bfdff..b676fef 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -856,7 +856,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
 {
 	struct sem_array *sma;
 	int err;
-	struct sem_setbuf setbuf;
+	struct sem_setbuf uninitialized_var(setbuf);
 	struct kern_ipc_perm *ipcp;
 
 	if(cmd == IPC_SET) {
