Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbXJ2Tjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbXJ2Tjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXJ2TjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:39:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58523 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXJ2Ti7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:38:59 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <981c038c47f009250d577bda8d21d26b9e7b23ea.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 02/16] [ISDN] Ready HiSax driver for modularization
Date: Mon, 29 Oct 2007 15:38:57 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* move netjet, isac, arcofi, hscx common sub-modules to new libhisax.ko
* export several symbols that are used by external drivers
* move DEFAULT_PROTO* deterination to shareable header file
* add hotplug and PCI-remove APIs

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/Makefile      |   51 +++++++++++++++++----------------
 drivers/isdn/hisax/arcofi.c      |    4 ++
 drivers/isdn/hisax/config.c      |   57 ++++++++++++++++++++++++-------------
 drivers/isdn/hisax/hisax_cfg.h   |    2 +
 drivers/isdn/hisax/hisax_proto.h |   25 ++++++++++++++++
 drivers/isdn/hisax/hscx.c        |    7 ++++
 drivers/isdn/hisax/isac.c        |    6 ++++
 drivers/isdn/hisax/isdnl1.c      |   12 +++++++-
 drivers/isdn/hisax/lmgr.c        |    2 +
 drivers/isdn/hisax/netjet.c      |    9 ++++++
 drivers/isdn/hisax/q931.c        |    4 ++
 11 files changed, 133 insertions(+), 46 deletions(-)
 create mode 100644 drivers/isdn/hisax/hisax_proto.h

diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index c7a3794..b0b09e9 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -6,7 +6,7 @@
 
 EXTRA_CFLAGS      += -DHISAX_MAX_CARDS=$(CONFIG_HISAX_MAX_CARDS)
 
-obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o
+obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o libhisax.o
 obj-$(CONFIG_HISAX_SEDLBAUER_CS)	+= sedlbauer_cs.o
 obj-$(CONFIG_HISAX_ELSA_CS)		+= elsa_cs.o
 obj-$(CONFIG_HISAX_AVM_A1_CS)		+= avma1_cs.o
@@ -16,6 +16,8 @@ obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 
+libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
+
 ifdef CONFIG_HISAX_HDLC
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= isdnhdlc.o
 endif
@@ -31,33 +33,32 @@ hisax-$(CONFIG_HISAX_EURO)		+= l3dss1.o
 hisax-$(CONFIG_HISAX_NI1)		+= l3ni1.o
 hisax-$(CONFIG_HISAX_1TR6)		+= l3_1tr6.o
 
-hisax-$(CONFIG_HISAX_16_0)		+= teles0.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_16_3)		+= teles3.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o isac.o arcofi.o
-hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o isac.o arcofi.o hscx.o ipacx.o 
-hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o isac.o arcofi.o hfc_2bs0.o
-hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isac.o arcofi.o hscx.o \
-					   isar.o
-hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_MIC)		+= mic.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o netjet.o isac.o arcofi.o
-hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o netjet.o icc.o
+hisax-$(CONFIG_HISAX_16_0)		+= teles0.o
+hisax-$(CONFIG_HISAX_16_3)		+= teles3.o
+hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o
+hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o
+hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o
+hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o
+hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o
+hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o
+hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o
+hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o ipacx.o 
+hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o
+hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o hfc_2bs0.o
+hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isar.o
+hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o
+hisax-$(CONFIG_HISAX_MIC)		+= mic.o
+hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o
+hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o icc.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
-hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isac.o arcofi.o isar.o
-hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o isac.o arcofi.o jade.o
-hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o isac.o arcofi.o hscx.o
+hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
+hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
+hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
+hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o jade.o
+hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
+hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
 hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
 
diff --git a/drivers/isdn/hisax/arcofi.c b/drivers/isdn/hisax/arcofi.c
index d30ce5b..bf2e10d 100644
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -132,3 +132,7 @@ init_arcofi(struct IsdnCardState *cs) {
 	init_waitqueue_head(&cs->dc.isac.arcofi_wait);
 	test_and_set_bit(HW_ARCOFI, &cs->HW_Flags);
 }
+
+EXPORT_SYMBOL(init_arcofi);
+EXPORT_SYMBOL(clear_arcofi);
+EXPORT_SYMBOL(arcofi_fsm);
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 4c536b7..44928bc 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -19,10 +19,12 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
 #define HISAX_STATUS_BUFSIZE 4096
 
 /*
@@ -283,26 +285,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {0,0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_1TR6
-#define DEFAULT_PROTO ISDN_PTYPE_1TR6
-#define DEFAULT_PROTO_NAME "1TR6"
-#endif
-#ifdef CONFIG_HISAX_NI1
-#undef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_NI1
-#undef DEFAULT_PROTO_NAME
-#define DEFAULT_PROTO_NAME "NI1"
-#endif
-#ifdef CONFIG_HISAX_EURO
-#undef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_EURO
-#undef DEFAULT_PROTO_NAME
-#define DEFAULT_PROTO_NAME "EURO"
-#endif
-#ifndef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
-#define DEFAULT_PROTO_NAME "UNKNOWN"
-#endif
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -1539,6 +1521,38 @@ static void __exit HiSax_exit(void)
 	printk(KERN_INFO "HiSax module removed\n");
 }
 
+#ifdef CONFIG_PCI
+void hisax_pci_remove_one(struct pci_dev *pdev)
+{
+	int cardnr = (unsigned long) pci_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+EXPORT_SYMBOL(hisax_pci_remove_one);
+#endif /* CONFIG_PCI */
+
+int hisax_init_hotplug(struct IsdnCard *card, hisax_setup_func_t card_setup)
+{
+	u_char ids[16];
+	int ret = -1;
+
+	cards[nrcards] = *card;
+	if (nrcards)
+		sprintf(ids, "HiSax%d", nrcards);
+	else
+		sprintf(ids, "HiSax");
+	if (!checkcard(nrcards, ids, NULL, THIS_MODULE, card_setup))
+		goto error;
+
+	ret = nrcards;
+	nrcards++;
+error:
+	return ret;
+}
+
 int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 {
 	u_char ids[16];
@@ -1560,7 +1574,10 @@ error:
 }
 
 EXPORT_SYMBOL(hisax_init_pcmcia);
+EXPORT_SYMBOL(hisax_init_hotplug);
 EXPORT_SYMBOL(HiSax_closecard);
+EXPORT_SYMBOL(HiSax_getrev);
+EXPORT_SYMBOL(HiSax_putstatus);
 
 #include "hisax_if.h"
 
diff --git a/drivers/isdn/hisax/hisax_cfg.h b/drivers/isdn/hisax/hisax_cfg.h
index 17a2fea..0625756 100644
--- a/drivers/isdn/hisax/hisax_cfg.h
+++ b/drivers/isdn/hisax/hisax_cfg.h
@@ -64,3 +64,5 @@ typedef int (*hisax_setup_func_t)(struct IsdnCard *card);
 
 extern void	HiSax_closecard(int);
 extern int	hisax_init_pcmcia(void *, int *, IsdnCard_t *);
+extern int	hisax_init_hotplug(IsdnCard_t *, hisax_setup_func_t card_setup);
+extern void	hisax_pci_remove_one(struct pci_dev *pdev);
diff --git a/drivers/isdn/hisax/hisax_proto.h b/drivers/isdn/hisax/hisax_proto.h
new file mode 100644
index 0000000..7eea361
--- /dev/null
+++ b/drivers/isdn/hisax/hisax_proto.h
@@ -0,0 +1,25 @@
+#ifndef __ISDN_HISAX_HISAX_PROTO_H__
+#define __ISDN_HISAX_HISAX_PROTO_H__
+
+#ifdef CONFIG_HISAX_1TR6
+#define DEFAULT_PROTO ISDN_PTYPE_1TR6
+#define DEFAULT_PROTO_NAME "1TR6"
+#endif
+#ifdef CONFIG_HISAX_NI1
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_NI1
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "NI1"
+#endif
+#ifdef CONFIG_HISAX_EURO
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_EURO
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "EURO"
+#endif
+#ifndef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
+#define DEFAULT_PROTO_NAME "UNKNOWN"
+#endif
+
+#endif /* __ISDN_HISAX_HISAX_PROTO_H__ */
diff --git a/drivers/isdn/hisax/hscx.c b/drivers/isdn/hisax/hscx.c
index c8f9951..09e1546 100644
--- a/drivers/isdn/hisax/hscx.c
+++ b/drivers/isdn/hisax/hscx.c
@@ -274,3 +274,10 @@ inithscxisac(struct IsdnCardState *cs, int part)
 		cs->writeisac(cs, ISAC_CMDR, 0x41);
 	}
 }
+
+EXPORT_SYMBOL(HscxVersion);
+EXPORT_SYMBOL(inithscxisac);
+EXPORT_SYMBOL(clear_pending_hscx_ints);
+EXPORT_SYMBOL(hscx_l2l1);
+EXPORT_SYMBOL(open_hscxstate);
+EXPORT_SYMBOL(modehscx);
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 4e9f238..b919543 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -681,3 +681,9 @@ setup_isac(struct IsdnCardState *cs)
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
 }
+
+EXPORT_SYMBOL(isac_interrupt);
+EXPORT_SYMBOL(initisac);
+EXPORT_SYMBOL(clear_pending_isac_ints);
+EXPORT_SYMBOL(ISACVersion);
+EXPORT_SYMBOL(setup_isac);
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index a14204e..ec81b12 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -451,7 +451,7 @@ Logl2Frame(struct IsdnCardState *cs, struct sk_buff *skb, char *buf, int dir)
 			(dir ? "<-" : "->"), buf, l2frames(ptr),
 			((ptr[0] & 2) >> 1) == dir ? 'C' : 'R', ptr[0] >> 2, ptr[1] >> 1);
 }
-#endif
+#endif /* L2FRAME_DEBUG */
 
 static void
 l1_reset(struct FsmInst *fi, int event, void *arg)
@@ -933,3 +933,13 @@ setstack_l1_B(struct PStack *st)
 	st->l1.Flags = 0;
 	FsmInitTimer(&st->l1.l1m, &st->l1.timer);
 }
+
+EXPORT_SYMBOL(l1_msg);
+EXPORT_SYMBOL(l1_msg_b);
+EXPORT_SYMBOL(debugl1);
+EXPORT_SYMBOL(setstack_l1_B);
+EXPORT_SYMBOL(DChannel_proc_rcv);
+EXPORT_SYMBOL(DChannel_proc_xmt);
+#ifdef L2FRAME_DEBUG
+EXPORT_SYMBOL(Logl2Frame);
+#endif
diff --git a/drivers/isdn/hisax/lmgr.c b/drivers/isdn/hisax/lmgr.c
index d4f86d6..5980490 100644
--- a/drivers/isdn/hisax/lmgr.c
+++ b/drivers/isdn/hisax/lmgr.c
@@ -48,3 +48,5 @@ setstack_manager(struct PStack *st)
 {
 	st->ma.layer = hisax_manager;
 }
+
+EXPORT_SYMBOL(setstack_manager);
diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
index 02c6fba..1e3e45b 100644
--- a/drivers/isdn/hisax/netjet.c
+++ b/drivers/isdn/hisax/netjet.c
@@ -979,3 +979,12 @@ release_io_netjet(struct IsdnCardState *cs)
 	release_region(cs->hw.njet.base, 256);
 }
 
+EXPORT_SYMBOL(NETjet_WriteICfifo);
+EXPORT_SYMBOL(NETjet_ReadICfifo);
+EXPORT_SYMBOL(NETjet_WriteIC);
+EXPORT_SYMBOL(NETjet_ReadIC);
+EXPORT_SYMBOL(write_tiger);
+EXPORT_SYMBOL(read_tiger);
+EXPORT_SYMBOL(inittiger);
+EXPORT_SYMBOL(netjet_fill_dma);
+EXPORT_SYMBOL(release_io_netjet);
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index aacbf0d..8a4e60b 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -1520,3 +1520,7 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 	*dp = 0;
 	HiSax_putstatus(cs, NULL, cs->dlog);
 }
+
+EXPORT_SYMBOL(dlogframe);
+EXPORT_SYMBOL(LogFrame);
+EXPORT_SYMBOL(QuickHex);
-- 
1.5.2.4

