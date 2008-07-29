Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYG2T4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYG2T4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYG2T4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:56:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:50225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYG2T4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:56:40 -0400
Date: Tue, 29 Jul 2008 21:56:37 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] mISDN cleanup user interface
Message-ID: <20080729195637.GB25929@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

The channelmap should have the same size on 32 and 64 bit
systems. Thanks to David Woodhouse for spotting this.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    6 +++---
 drivers/isdn/hardware/mISDN/hfcpci.c   |    2 +-
 drivers/isdn/mISDN/l1oip_core.c        |    4 +++-
 drivers/isdn/mISDN/socket.c            |    4 ++--
 include/linux/mISDNif.h                |    7 ++++---
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 2649ea5..6449ffa 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3971,7 +3971,7 @@ open_bchannel(struct hfc_multi *hc, struct dchannel *dch,
 	struct bchannel	*bch;
 	int		ch;
 
-	if (!test_bit(rq->adr.channel, &dch->dev.channelmap[0]))
+	if (!test_bit(rq->adr.channel, (u_long *)&dch->dev.channelmap[0]))
 		return -EINVAL;
 	if (rq->protocol == ISDN_P_NONE)
 		return -EINVAL;
@@ -4587,7 +4587,7 @@ init_e1_port(struct hfc_multi *hc, struct hm_map *m)
 		list_add(&bch->ch.list, &dch->dev.bchannels);
 		hc->chan[ch].bch = bch;
 		hc->chan[ch].port = 0;
-		test_and_set_bit(bch->nr, &dch->dev.channelmap[0]);
+		test_and_set_bit(bch->nr, (u_long *)&dch->dev.channelmap[0]);
 	}
 	/* set optical line type */
 	if (port[Port_cnt] & 0x001) {
@@ -4755,7 +4755,7 @@ init_multi_port(struct hfc_multi *hc, int pt)
 		list_add(&bch->ch.list, &dch->dev.bchannels);
 		hc->chan[i + ch].bch = bch;
 		hc->chan[i + ch].port = pt;
-		test_and_set_bit(bch->nr, &dch->dev.channelmap[0]);
+		test_and_set_bit(bch->nr, (u_long *)&dch->dev.channelmap[0]);
 	}
 	/* set master clock */
 	if (port[Port_cnt] & 0x001) {
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 3231814..b111179 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2056,7 +2056,7 @@ setup_card(struct hfc_pci *card)
 	card->dch.dev.nrbchan = 2;
 	for (i = 0; i < 2; i++) {
 		card->bch[i].nr = i + 1;
-		test_and_set_bit(i + 1, &card->dch.dev.channelmap[0]);
+		test_and_set_bit(i + 1, (u_long *)&card->dch.dev.channelmap[0]);
 		card->bch[i].debug = debug;
 		mISDN_initbchannel(&card->bch[i], MAX_DATA_MEM);
 		card->bch[i].hw = card;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 155b997..6cc7fd3 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1006,8 +1006,10 @@ open_bchannel(struct l1oip *hc, struct dchannel *dch, struct channel_req *rq)
 	struct bchannel	*bch;
 	int		ch;
 
+	if (rq->adr.channel > MISDN_MAX_CHANNEL)
+		return -EINVAL;
 	if (!test_bit(rq->adr.channel & 0x1f,
-		&dch->dev.channelmap[rq->adr.channel >> 5]))
+		(u_long *)&dch->dev.channelmap[rq->adr.channel >> 5]))
 		return -EINVAL;
 	if (rq->protocol == ISDN_P_NONE)
 		return -EINVAL;
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
index 5c948f3..0172ea8 100644
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
+#define MISDN_CHMAP_SIZE	((MISDN_MAX_CHANNEL + 1) >> 5)
 
 #define SOL_MISDN	0
 
@@ -275,7 +276,7 @@ struct mISDN_devinfo {
 	u_int			Dprotocols;
 	u_int			Bprotocols;
 	u_int			protocol;
-	u_long			channelmap[MISDN_CHMAP_SIZE];
+	u_int			channelmap[MISDN_CHMAP_SIZE];
 	u_int			nrbchan;
 	char			name[MISDN_MAX_IDLEN];
 };
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
