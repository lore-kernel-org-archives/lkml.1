Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYHBPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYHBPQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYHBPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:15:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:54593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbYHBPPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:15:30 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Date: Wed, 30 Jul 2008 18:26:58 +0200
Subject: [PATCH 2/4] mISDN cleanup user interface
Message-Id: <20080802151528.17E20A3C09@pingi.kke.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channelmap should have the same size on 32 and 64 bit systems
and should not depend on endianess.
Thanks to David Woodhouse for spotting this.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    6 +++---
 drivers/isdn/hardware/mISDN/hfcpci.c   |    2 +-
 drivers/isdn/mISDN/l1oip_core.c        |    6 ++----
 drivers/isdn/mISDN/socket.c            |    4 ++--
 include/linux/mISDNif.h                |   32 +++++++++++++++++++++++++++-----
 5 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 2649ea5..10144e8 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3971,7 +3971,7 @@ open_bchannel(struct hfc_multi *hc, struct dchannel *dch,
 	struct bchannel	*bch;
 	int		ch;
 
-	if (!test_bit(rq->adr.channel, &dch->dev.channelmap[0]))
+	if (!test_channelmap(rq->adr.channel, dch->dev.channelmap))
 		return -EINVAL;
 	if (rq->protocol == ISDN_P_NONE)
 		return -EINVAL;
@@ -4587,7 +4587,7 @@ init_e1_port(struct hfc_multi *hc, struct hm_map *m)
 		list_add(&bch->ch.list, &dch->dev.bchannels);
 		hc->chan[ch].bch = bch;
 		hc->chan[ch].port = 0;
-		test_and_set_bit(bch->nr, &dch->dev.channelmap[0]);
+		set_channelmap(bch->nr, dch->dev.channelmap);
 	}
 	/* set optical line type */
 	if (port[Port_cnt] & 0x001) {
@@ -4755,7 +4755,7 @@ init_multi_port(struct hfc_multi *hc, int pt)
 		list_add(&bch->ch.list, &dch->dev.bchannels);
 		hc->chan[i + ch].bch = bch;
 		hc->chan[i + ch].port = pt;
-		test_and_set_bit(bch->nr, &dch->dev.channelmap[0]);
+		set_channelmap(bch->nr, dch->dev.channelmap);
 	}
 	/* set master clock */
 	if (port[Port_cnt] & 0x001) {
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 3231814..9cf5edb 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2056,7 +2056,7 @@ setup_card(struct hfc_pci *card)
 	card->dch.dev.nrbchan = 2;
 	for (i = 0; i < 2; i++) {
 		card->bch[i].nr = i + 1;
-		test_and_set_bit(i + 1, &card->dch.dev.channelmap[0]);
+		set_channelmap(i + 1, card->dch.dev.channelmap);
 		card->bch[i].debug = debug;
 		mISDN_initbchannel(&card->bch[i], MAX_DATA_MEM);
 		card->bch[i].hw = card;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 155b997..e42150a 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1006,8 +1006,7 @@ open_bchannel(struct l1oip *hc, struct dchannel *dch, struct channel_req *rq)
 	struct bchannel	*bch;
 	int		ch;
 
-	if (!test_bit(rq->adr.channel & 0x1f,
-		&dch->dev.channelmap[rq->adr.channel >> 5]))
+	if (!test_channelmap(rq->adr.channel, dch->dev.channelmap))
 		return -EINVAL;
 	if (rq->protocol == ISDN_P_NONE)
 		return -EINVAL;
@@ -1412,8 +1411,7 @@ init_card(struct l1oip *hc, int pri, int bundle)
 		bch->ch.nr = i + ch;
 		list_add(&bch->ch.list, &dch->dev.bchannels);
 		hc->chan[i + ch].bch = bch;
-		test_and_set_bit(bch->nr & 0x1f,
-			&dch->dev.channelmap[bch->nr >> 5]);
+		set_channelmap(bch->nr, dch->dev.channelmap);
 	}
 	ret = mISDN_register_device(&dch->dev, hc->name);
 	if (ret)
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 4ba4cc3..e5a20f9 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -379,7 +379,7 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
 			di.protocol = dev->D.protocol;
 			memcpy(di.channelmap, dev->channelmap,
-				MISDN_CHMAP_SIZE * 4);
+				sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
 			strcpy(di.name, dev->name);
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
@@ -637,7 +637,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
 			di.protocol = dev->D.protocol;
 			memcpy(di.channelmap, dev->channelmap,
-				MISDN_CHMAP_SIZE * 4);
+				sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
 			strcpy(di.name, dev->name);
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
index 5c948f3..8f2d60d 100644
--- a/include/linux/mISDNif.h
+++ b/include/linux/mISDNif.h
@@ -37,7 +37,7 @@
  */
 #define	MISDN_MAJOR_VERSION	1
 #define	MISDN_MINOR_VERSION	0
-#define MISDN_RELEASE		18
+#define MISDN_RELEASE		19
 
 /* primitives for information exchange
  * generell format
@@ -242,7 +242,8 @@ struct mISDNhead {
 #define TEI_SAPI		63
 #define CTRL_SAPI		0
 
-#define MISDN_CHMAP_SIZE	4
+#define MISDN_MAX_CHANNEL	127
+#define MISDN_CHMAP_SIZE	((MISDN_MAX_CHANNEL + 1) >> 3)
 
 #define SOL_MISDN	0
 
@@ -275,11 +276,32 @@ struct mISDN_devinfo {
 	u_int			Dprotocols;
 	u_int			Bprotocols;
 	u_int			protocol;
-	u_long			channelmap[MISDN_CHMAP_SIZE];
+	u_char			channelmap[MISDN_CHMAP_SIZE];
 	u_int			nrbchan;
 	char			name[MISDN_MAX_IDLEN];
 };
 
+static inline int
+test_channelmap(u_int nr, u_char *map)
+{
+	if (nr <= MISDN_MAX_CHANNEL)
+		return map[nr >> 3] & (1 << (nr & 7));
+	else
+		return 0;
+}
+
+static inline void
+set_channelmap(u_int nr, u_char *map)
+{
+	map[nr >> 3] |= (1 << (nr & 7));
+}
+
+static inline void
+clear_channelmap(u_int nr, u_char *map)
+{
+	map[nr >> 3] &= ~(1 << (nr & 7));
+}
+
 /* CONTROL_CHANNEL parameters */
 #define MISDN_CTRL_GETOP		0x0000
 #define MISDN_CTRL_LOOP			0x0001
@@ -405,7 +427,7 @@ struct mISDNdevice {
 	u_int			Dprotocols;
 	u_int			Bprotocols;
 	u_int			nrbchan;
-	u_long			channelmap[MISDN_CHMAP_SIZE];
+	u_char			channelmap[MISDN_CHMAP_SIZE];
 	struct list_head	bchannels;
 	struct mISDNchannel	*teimgr;
 	struct device		dev;
@@ -430,7 +452,7 @@ struct mISDNstack {
 #endif
 };
 
-/* global alloc/queue dunctions */
+/* global alloc/queue functions */
 
 static inline struct sk_buff *
 mI_alloc_skb(unsigned int len, gfp_t gfp_mask)
-- 
1.5.6.4

