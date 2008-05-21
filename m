Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbYEUTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbYEUTcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYEUTcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:32:13 -0400
Received: from sslsrv.de ([62.75.159.123]:42812 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbYEUTcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:32:09 -0400
X-Greylist: delayed 1094 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 15:32:08 EDT
From: Philipp Marek <philipp@marek.priv.at>
To: linux-kernel@vger.kernel.org
Subject: [patch] kmalloc returns (void*), don't do type conversions
Date: Wed, 21 May 2008 21:13:51 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vRHNIm2WXpOieT5"
Message-Id: <200805212113.51936@marek.priv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_vRHNIm2WXpOieT5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello everybody,

as requested on http://kernelnewbies.org/KernelJanitors/Todo
here's a first patch that removes type conversion on
kmalloc() (which returns a (void*)):


It was done against current linus-git=20
(d40ace0c7b4a329f7d869d0fbf27435543bb2acc, if I'm not mistaken),
and looks like that:
    list_del(&bss->list);
    local->num_bss_info--;
  } else {
=2D   bss =3D (struct hostap_bss_info *)
=2D     kmalloc(sizeof(*bss), GFP_ATOMIC);
+   bss =3D kmalloc(sizeof(*bss), GFP_ATOMIC);
    if (bss =3D=3D NULL)
      return NULL;
  }


Most of the patch is auto-generated (by a script in=20
http://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs);=20
but it is hand-changed in some parts to avoid checkpatch warnings:
=2D line length
=2D "foo* bar" to "foo *bar"
=2D space prohibited between function name and open parenthesis '('
  (like "sizeof (")

checkpatch didn't give any warnings or errors on this patch.
I tried a "make allyesconfig", but that gave some compile errors=20
that don't seem related to my changes:
	drivers/block/cciss_scsi.c:75: error: =E2=80=98MAX_CTLR=E2=80=99 undeclare=
d here (not in a function)
	drivers/block/cciss_scsi.c:76: error: field name not in record or union in=
itializer


Please tell me if that's the correct approach; I'm sorry that I=20
couldn't find out who the correct maintainer for these changes is.


Regards,

Phil


$ diffstat kmalloc-type-changes.patch
 arch/cris/arch-v32/mm/intmem.c                |   13 +++++--------
 arch/ia64/kernel/mca_drv.c                    |    4 ++--
 arch/powerpc/kernel/nvram_64.c                |    3 +--
 drivers/block/cciss.c                         |    3 +--
 drivers/block/cciss_scsi.c                    |    3 +--
 drivers/block/floppy.c                        |    3 +--
 drivers/i2c/i2c-dev.c                         |    3 +--
 drivers/isdn/capi/capidrv.c                   |    3 +--
 drivers/isdn/hisax/hfc_sx.c                   |    5 +++--
 drivers/media/video/vino.c                    |    8 ++++----
 drivers/message/i2o/i2o_config.c              |    3 +--
 drivers/mtd/maps/tqm8xxl.c                    |    2 +-
 drivers/net/gianfar.c                         |    6 ++----
 drivers/net/s2io.c                            |    4 ++--
 drivers/net/tulip/eeprom.c                    |    8 ++++----
 drivers/net/wireless/hostap/hostap_80211_rx.c |    3 +--
 drivers/net/wireless/hostap/hostap_ioctl.c    |    3 +--
 drivers/net/wireless/ipw2100.c                |   10 ++++------
 drivers/net/wireless/zd1211rw/zd_chip.c       |    2 +-
 drivers/s390/net/ctcm_mpc.c                   |    6 ++----
 drivers/s390/net/qeth_core_main.c             |    4 ++--
 drivers/scsi/osst.c                           |    5 ++---
 drivers/usb/storage/isd200.c                  |    3 +--
 fs/befs/btree.c                               |    4 ++--
 fs/ufs/util.c                                 |    3 +--
 net/ipv4/igmp.c                               |    3 +--
 net/ipv6/mcast.c                              |    3 +--
 net/sctp/protocol.c                           |    4 ++--
 security/selinux/ss/conditional.c             |    4 ++--
 29 files changed, 53 insertions(+), 75 deletions(-)


--Boundary-00=_vRHNIm2WXpOieT5
Content-Type: text/x-diff;
  charset="utf-8";
  name="kmalloc-type-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kmalloc-type-changes.patch"

Remove type conversions that are done on the result of kmalloc() -
this is defined as (void*).


Signed-off-by: philipp@marek.priv.at

--- linux-2.6.git/drivers/i2c/i2c-dev.c
+++ linux-2.6.git/drivers/i2c/i2c-dev.c
@@ -218,8 +218,7 @@ static noinline int i2cdev_ioctl_rdrw(st
 	if (rdwr_arg.nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
 		return -EINVAL;
 
-	rdwr_pa = (struct i2c_msg *)
-		kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg),
+	rdwr_pa = kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg),
 		GFP_KERNEL);
 	if (!rdwr_pa)
 		return -ENOMEM;
--- linux-2.6.git/drivers/net/s2io.c
+++ linux-2.6.git/drivers/net/s2io.c
@@ -899,7 +899,7 @@ static int init_shared_mem(struct s2io_n
 				while (k != rxd_count[nic->rxd_mode]) {
 					ba = &mac_control->rings[i].ba[j][k];
 
-					ba->ba_0_org = (void *) kmalloc
+					ba->ba_0_org = kmalloc
 					    (BUF0_LEN + ALIGN_SIZE, GFP_KERNEL);
 					if (!ba->ba_0_org)
 						return -ENOMEM;
@@ -910,7 +910,7 @@ static int init_shared_mem(struct s2io_n
 					tmp &= ~((unsigned long) ALIGN_SIZE);
 					ba->ba_0 = (void *) tmp;
 
-					ba->ba_1_org = (void *) kmalloc
+					ba->ba_1_org = kmalloc
 					    (BUF1_LEN + ALIGN_SIZE, GFP_KERNEL);
 					if (!ba->ba_1_org)
 						return -ENOMEM;
--- linux-2.6.git/drivers/net/wireless/hostap/hostap_ioctl.c
+++ linux-2.6.git/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3057,8 +3057,7 @@ static int prism2_ioctl_priv_download(lo
 	    p->length > 1024 || !p->pointer)
 		return -EINVAL;
 
-	param = (struct prism2_download_param *)
-		kmalloc(p->length, GFP_KERNEL);
+	param = kmalloc(p->length, GFP_KERNEL);
 	if (param == NULL)
 		return -ENOMEM;
 
--- linux-2.6.git/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ linux-2.6.git/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -335,8 +335,7 @@ static struct hostap_bss_info *__hostap_
 		list_del(&bss->list);
 		local->num_bss_info--;
 	} else {
-		bss = (struct hostap_bss_info *)
-			kmalloc(sizeof(*bss), GFP_ATOMIC);
+		bss = kmalloc(sizeof(*bss), GFP_ATOMIC);
 		if (bss == NULL)
 			return NULL;
 	}
--- linux-2.6.git/drivers/net/wireless/zd1211rw/zd_chip.c
+++ linux-2.6.git/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -117,7 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
+	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
 		                   GFP_KERNEL);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
--- linux-2.6.git/drivers/net/wireless/ipw2100.c
+++ linux-2.6.git/drivers/net/wireless/ipw2100.c
@@ -3373,8 +3373,7 @@ static int ipw2100_msg_allocate(struct i
 	void *v;
 	dma_addr_t p;
 
-	priv->msg_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(IPW_COMMAND_POOL_SIZE *
+	priv->msg_buffers = kmalloc(IPW_COMMAND_POOL_SIZE *
 						sizeof(struct
 						       ipw2100_tx_packet),
 						GFP_KERNEL);
@@ -4406,8 +4405,7 @@ static int ipw2100_tx_allocate(struct ip
 		return err;
 	}
 
-	priv->tx_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(TX_PENDED_QUEUE_LENGTH *
+	priv->tx_buffers = kmalloc(TX_PENDED_QUEUE_LENGTH *
 						sizeof(struct
 						       ipw2100_tx_packet),
 						GFP_ATOMIC);
@@ -4559,8 +4557,8 @@ static int ipw2100_rx_allocate(struct ip
 	/*
 	 * allocate packets
 	 */
-	priv->rx_buffers = (struct ipw2100_rx_packet *)
-	    kmalloc(RX_QUEUE_LENGTH * sizeof(struct ipw2100_rx_packet),
+	priv->rx_buffers = kmalloc(RX_QUEUE_LENGTH *
+		    sizeof(struct ipw2100_rx_packet),
 		    GFP_KERNEL);
 	if (!priv->rx_buffers) {
 		IPW_DEBUG_INFO("can't allocate rx packet buffer table\n");
--- linux-2.6.git/drivers/net/tulip/eeprom.c
+++ linux-2.6.git/drivers/net/tulip/eeprom.c
@@ -121,8 +121,8 @@ static void __devinit tulip_build_fake_m
 			  0x00, 0x06  /* ttm bit map */
 			};
 
-		tp->mtable = (struct mediatable *)
-			kmalloc(sizeof(struct mediatable) + sizeof(struct medialeaf), GFP_KERNEL);
+		tp->mtable = kmalloc(sizeof(struct mediatable) +
+			sizeof(struct medialeaf), GFP_KERNEL);
 
 		if (tp->mtable == NULL)
 			return; /* Horrible, impossible failure. */
@@ -224,8 +223,8 @@ subsequent_board:
 		        return;
 		}
 
-		mtable = (struct mediatable *)
-			kmalloc(sizeof(struct mediatable) + count*sizeof(struct medialeaf),
+		mtable = kmalloc(sizeof(struct mediatable) +
+			count*sizeof(struct medialeaf),
 					GFP_KERNEL);
 		if (mtable == NULL)
 			return;				/* Horrible, impossible failure. */
--- linux-2.6.git/drivers/net/gianfar.c
+++ linux-2.6.git/drivers/net/gianfar.c
@@ -737,8 +737,7 @@ int startup_gfar(struct net_device *dev)
 	gfar_write(&regs->rbase0, addr);
 
 	/* Setup the skbuff rings */
-	priv->tx_skbuff =
-	    (struct sk_buff **) kmalloc(sizeof (struct sk_buff *) *
+	priv->tx_skbuff = kmalloc(sizeof(struct sk_buff *) *
 					priv->tx_ring_size, GFP_KERNEL);
 
 	if (NULL == priv->tx_skbuff) {
@@ -752,8 +751,7 @@ int startup_gfar(struct net_device *dev)
 	for (i = 0; i < priv->tx_ring_size; i++)
 		priv->tx_skbuff[i] = NULL;
 
-	priv->rx_skbuff =
-	    (struct sk_buff **) kmalloc(sizeof (struct sk_buff *) *
+	priv->rx_skbuff = kmalloc(sizeof(struct sk_buff *) *
 					priv->rx_ring_size, GFP_KERNEL);
 
 	if (NULL == priv->rx_skbuff) {
--- linux-2.6.git/drivers/s390/net/qeth_core_main.c
+++ linux-2.6.git/drivers/s390/net/qeth_core_main.c
@@ -634,8 +634,8 @@ static int qeth_setup_channel(struct qet
 
 	QETH_DBF_TEXT(SETUP, 2, "setupch");
 	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++) {
-		channel->iob[cnt].data = (char *)
-			kmalloc(QETH_BUFSIZE, GFP_DMA|GFP_KERNEL);
+		channel->iob[cnt].data =
+			kmalloc(QETH_BUFSIZE, GFP_DMA|GFP_KERNEL);
 		if (channel->iob[cnt].data == NULL)
 			break;
 		channel->iob[cnt].state = BUF_STATE_FREE;
--- linux-2.6.git/drivers/s390/net/ctcm_mpc.c
+++ linux-2.6.git/drivers/s390/net/ctcm_mpc.c
@@ -696,8 +696,7 @@ static void ctcmpc_send_sweep_resp(struc
 				goto done;
 	}
 
-	header = (struct th_sweep *)
-			kmalloc(sizeof(struct th_sweep), gfp_type());
+	header = kmalloc(sizeof(struct th_sweep), gfp_type());
 
 	if (!header) {
 		dev_kfree_skb_any(sweep_skb);
@@ -1308,8 +1307,7 @@ static void ctcmpc_unpack_skb(struct cha
 			skb_pull(pskb, new_len); /* point to next PDU */
 		}
 	} else {
-		mpcginfo = (struct mpcg_info *)
-				kmalloc(sizeof(struct mpcg_info), gfp_type());
+		mpcginfo = kmalloc(sizeof(struct mpcg_info), gfp_type());
 		if (mpcginfo == NULL)
 					goto done;
 
--- linux-2.6.git/drivers/isdn/capi/capidrv.c
+++ linux-2.6.git/drivers/isdn/capi/capidrv.c
@@ -469,8 +469,7 @@ static int capidrv_add_ack(struct capidr
 {
 	struct ncci_datahandle_queue *n, **pp;
 
-	n = (struct ncci_datahandle_queue *)
-		kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
+	n = kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
 	if (!n) {
 	   printk(KERN_ERR "capidrv: kmalloc ncci_datahandle failed\n");
 	   return -1;
--- linux-2.6.git/drivers/isdn/hisax/hfc_sx.c
+++ linux-2.6.git/drivers/isdn/hisax/hfc_sx.c
@@ -1480,8 +1480,9 @@ setup_hfcsx(struct IsdnCard *card)
 		  release_region(cs->hw.hfcsx.base, 2);
 		  return(0);
 		}  
-		if (!(cs->hw.hfcsx.extra = (void *)
-		      kmalloc(sizeof(struct hfcsx_extra), GFP_ATOMIC))) {
+		cs->hw.hfcsx.extra = kmalloc(sizeof(struct hfcsx_extra),
+			GFP_ATOMIC);
+		if (!cs->hw.hfcsx.extra)
 		  release_region(cs->hw.hfcsx.base, 2);
 		  printk(KERN_WARNING "HFC-SX: unable to allocate memory\n");
 		  return(0);
--- linux-2.6.git/drivers/scsi/osst.c
+++ linux-2.6.git/drivers/scsi/osst.c
@@ -5758,8 +5758,7 @@ static int osst_probe(struct device *dev
 	/* if this is the first attach, build the infrastructure */
 	write_lock(&os_scsi_tapes_lock);
 	if (os_scsi_tapes == NULL) {
-		os_scsi_tapes =
-			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
-				   GFP_ATOMIC);
+		os_scsi_tapes = kmalloc(osst_max_dev *
+				   sizeof(struct osst_tape *), GFP_ATOMIC);
 		if (os_scsi_tapes == NULL) {
 			write_unlock(&os_scsi_tapes_lock);
--- linux-2.6.git/drivers/block/cciss_scsi.c
+++ linux-2.6.git/drivers/block/cciss_scsi.c
@@ -535,8 +535,7 @@ cciss_scsi_setup(int cntl_num)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[cntl_num].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
--- linux-2.6.git/drivers/block/floppy.c
+++ linux-2.6.git/drivers/block/floppy.c
@@ -3194,8 +3194,7 @@ static inline int raw_cmd_copyin(int cmd
 
 	*rcmd = NULL;
 	while (1) {
-		ptr = (struct floppy_raw_cmd *)
-		    kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
--- linux-2.6.git/drivers/block/cciss.c
+++ linux-2.6.git/drivers/block/cciss.c
@@ -1073,8 +1073,7 @@ static int cciss_ioctl(struct inode *ino
 				return -EINVAL;
 			if (!capable(CAP_SYS_RAWIO))
 				return -EPERM;
-			ioc = (BIG_IOCTL_Command_struct *)
-			    kmalloc(sizeof(*ioc), GFP_KERNEL);
+			ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 			if (!ioc) {
 				status = -ENOMEM;
 				goto cleanup1;
--- linux-2.6.git/drivers/media/video/vino.c
+++ linux-2.6.git/drivers/media/video/vino.c
@@ -848,8 +848,8 @@ static int vino_allocate_buffer(struct v
 		size, count);
 
 	/* allocate memory for table with virtual (page) addresses */
-	fb->desc_table.virtual = (unsigned long *)
-		kmalloc(count * sizeof(unsigned long), GFP_KERNEL);
+	fb->desc_table.virtual = kmalloc(count *
+	    sizeof(unsigned long), GFP_KERNEL);
 	if (!fb->desc_table.virtual)
 		return -ENOMEM;
 
@@ -935,8 +934,8 @@ static int vino_prepare_user_buffer(stru
 		size, count);
 
 	/* allocate memory for table with virtual (page) addresses */
-	fb->desc_table.virtual = (unsigned long *)
-		kmalloc(count * sizeof(unsigned long), GFP_KERNEL);
+	fb->desc_table.virtual = kmalloc(count *
+	    sizeof(unsigned long), GFP_KERNEL);
 	if (!fb->desc_table.virtual)
 		return -ENOMEM;
 
--- linux-2.6.git/drivers/message/i2o/i2o_config.c
+++ linux-2.6.git/drivers/message/i2o/i2o_config.c
@@ -1053,8 +1053,7 @@ static int i2o_cfg_ioctl(struct inode *i
 
 static int cfg_open(struct inode *inode, struct file *file)
 {
-	struct i2o_cfg_info *tmp =
-	    (struct i2o_cfg_info *)kmalloc(sizeof(struct i2o_cfg_info),
+	struct i2o_cfg_info *tmp = kmalloc(sizeof(struct i2o_cfg_info),
 					   GFP_KERNEL);
 	unsigned long flags;
 
--- linux-2.6.git/drivers/usb/storage/isd200.c
+++ linux-2.6.git/drivers/usb/storage/isd200.c
@@ -1496,8 +1496,7 @@ static int isd200_init_info(struct us_da
 	else {
 		info->id = (struct hd_driveid *)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
-		info->RegsBuf = (unsigned char *)
-				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
+		info->RegsBuf = kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
 		info->srb.sense_buffer =
 				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
 		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
--- linux-2.6.git/drivers/mtd/maps/tqm8xxl.c
+++ linux-2.6.git/drivers/mtd/maps/tqm8xxl.c
@@ -141,7 +141,7 @@ int __init init_tqm_mtd(void)
 			goto error_mem;
 		}
 
-		map_banks[idx]->name = (char *)kmalloc(16, GFP_KERNEL);
+		map_banks[idx]->name = kmalloc(16, GFP_KERNEL);
 
 		if (!map_banks[idx]->name) {
 			ret = -ENOMEM;
--- linux-2.6.git/net/sctp/protocol.c
+++ linux-2.6.git/net/sctp/protocol.c
@@ -1188,8 +1188,8 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
-		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
+	sctp_ep_hashtable = kmalloc(64 *
+	    sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		printk(KERN_ERR "SCTP: Failed endpoint_hash alloc.\n");
 		status = -ENOMEM;
--- linux-2.6.git/net/ipv6/mcast.c
+++ linux-2.6.git/net/ipv6/mcast.c
@@ -2044,8 +2044,7 @@ static int sf_setstate(struct ifmcaddr6 
 				    &psf->sf_addr))
 					break;
 			if (!dpsf) {
-				dpsf = (struct ip6_sf_list *)
-					kmalloc(sizeof(*dpsf), GFP_ATOMIC);
+				dpsf = kmalloc(sizeof(*dpsf), GFP_ATOMIC);
 				if (!dpsf)
 					continue;
 				*dpsf = *psf;
--- linux-2.6.git/net/ipv4/igmp.c
+++ linux-2.6.git/net/ipv4/igmp.c
@@ -1638,8 +1638,7 @@ static int sf_setstate(struct ip_mc_list
 				if (dpsf->sf_inaddr == psf->sf_inaddr)
 					break;
 			if (!dpsf) {
-				dpsf = (struct ip_sf_list *)
-					kmalloc(sizeof(*dpsf), GFP_ATOMIC);
+				dpsf = kmalloc(sizeof(*dpsf), GFP_ATOMIC);
 				if (!dpsf)
 					continue;
 				*dpsf = *psf;
--- linux-2.6.git/fs/ufs/util.c
+++ linux-2.6.git/fs/ufs/util.c
@@ -26,8 +26,7 @@ struct ufs_buffer_head * _ubh_bread_ (st
 	count = size >> uspi->s_fshift;
 	if (count > UFS_MAXFRAG)
 		return NULL;
-	ubh = (struct ufs_buffer_head *)
-		kmalloc (sizeof (struct ufs_buffer_head), GFP_KERNEL);
+	ubh = kmalloc(sizeof(struct ufs_buffer_head), GFP_KERNEL);
 	if (!ubh)
 		return NULL;
 	ubh->fragment = fragment;
--- linux-2.6.git/fs/befs/btree.c
+++ linux-2.6.git/fs/befs/btree.c
@@ -436,8 +436,8 @@ befs_btree_read(struct super_block *sb, 
 		goto error;
 	}
 
-	if ((this_node = (befs_btree_node *)
-	     kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
+	this_node = kmalloc(sizeof(befs_btree_node), GFP_NOFS);
+	if (!this_node) {
 		befs_error(sb, "befs_btree_read() failed to allocate %u "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
--- linux-2.6.git/security/selinux/ss/conditional.c
+++ linux-2.6.git/security/selinux/ss/conditional.c
@@ -171,8 +171,8 @@ void cond_policydb_destroy(struct policy
 int cond_init_bool_indexes(struct policydb *p)
 {
 	kfree(p->bool_val_to_struct);
-	p->bool_val_to_struct = (struct cond_bool_datum **)
-		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
+	p->bool_val_to_struct = kmalloc(p->p_bools.nprim *
+	    sizeof(struct cond_bool_datum *), GFP_KERNEL);
 	if (!p->bool_val_to_struct)
 		return -1;
 	return 0;
--- linux-2.6.git/arch/powerpc/kernel/nvram_64.c
+++ linux-2.6.git/arch/powerpc/kernel/nvram_64.c
@@ -527,8 +527,7 @@ static int nvram_scan_partitions(void)
 			       "detected: 0-length partition\n");
 			goto out;
 		}
-		tmp_part = (struct nvram_partition *)
-			kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
+		tmp_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
 		err = -ENOMEM;
 		if (!tmp_part) {
 			printk(KERN_ERR "nvram_scan_partitions: kmalloc failed\n");
--- linux-2.6.git/arch/cris/arch-v32/mm/intmem.c
+++ linux-2.6.git/arch/cris/arch-v32/mm/intmem.c
@@ -33,8 +33,8 @@ static void crisv32_intmem_init(void)
 {
 	static int initiated = 0;
 	if (!initiated) {
-		struct intmem_allocation* alloc =
-		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
+		struct intmem_allocation *alloc =
+		    kmalloc(sizeof(*alloc), GFP_KERNEL);
 		INIT_LIST_HEAD(&intmem_allocations);
 		intmem_virtual = ioremap(MEM_INTMEM_START + RESERVED_SIZE,
 					 MEM_INTMEM_SIZE - RESERVED_SIZE);
@@ -62,9 +61,8 @@ void* crisv32_intmem_alloc(unsigned size
 		if (allocation->status == STATUS_FREE &&
 		    allocation->size >= size + alignment) {
 			if (allocation->size > size + alignment) {
-				struct intmem_allocation* alloc =
-					(struct intmem_allocation*)
-					kmalloc(sizeof *alloc, GFP_ATOMIC);
+				struct intmem_allocation *alloc =
+				    kmalloc(sizeof(*alloc), GFP_ATOMIC);
 				alloc->status = STATUS_FREE;
 				alloc->size = allocation->size - size -
 					alignment;
@@ -74,8 +71,6 @@ void* crisv32_intmem_alloc(unsigned size
 
 				if (alignment) {
 					struct intmem_allocation *tmp;
-					tmp = (struct intmem_allocation *)
-						kmalloc(sizeof *tmp,
-							GFP_ATOMIC);
+					tmp = kmalloc(sizeof(*tmp), GFP_ATOMIC);
 					tmp->offset = allocation->offset;
 					tmp->size = alignment;
--- linux-2.6.git/arch/ia64/kernel/mca_drv.c
+++ linux-2.6.git/arch/ia64/kernel/mca_drv.c
@@ -348,8 +348,8 @@ init_record_index_pools(void)
 
 	/* - 3 - */
 	slidx_pool.max_idx = (rec_max_size/sect_min_size) * 2 + 1;
-	slidx_pool.buffer = (slidx_list_t *)
-		kmalloc(slidx_pool.max_idx * sizeof(slidx_list_t), GFP_KERNEL);
+	slidx_pool.buffer = kmalloc(slidx_pool.max_idx *
+	    sizeof(slidx_list_t), GFP_KERNEL);
 
 	return slidx_pool.buffer ? 0 : -ENOMEM;
 }

--Boundary-00=_vRHNIm2WXpOieT5--
