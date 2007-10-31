Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYBPUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYBPUay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbYBPU3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:43 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42888 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbYBPU3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:10 -0500
Message-Id: <22a00c751e069bd75131ff0032c0cead05e8707f.1203189978.git.jeff@garzik.org>
In-Reply-To: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
References: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2007 01:10:23 -0400
Subject: [PATCH 03/14] [ISDN] Ready HiSax driver for modularization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* move netjet, isac, arcofi, hscx common sub-modules to new libhisax.ko
* export several symbols that are used by external drivers
* move DEFAULT_PROTO* deterination to shareable header file
* add hotplug and PCI-remove APIs

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/Makefile      |   51 ++++++++++++++++----------------
 drivers/isdn/hisax/arcofi.c      |    3 ++
 drivers/isdn/hisax/config.c      |   59 +++++++++++++++++++++++--------------
 drivers/isdn/hisax/hisax_cfg.h   |    2 +
 drivers/isdn/hisax/hisax_proto.h |   25 ++++++++++++++++
 drivers/isdn/hisax/hscx.c        |    7 ++++
 drivers/isdn/hisax/isac.c        |    9 ++++-
 drivers/isdn/hisax/isdnl1.c      |    9 +++++-
 drivers/isdn/hisax/lmgr.c        |    1 +
 drivers/isdn/hisax/netjet.c      |   10 ++++++-
 drivers/isdn/hisax/q931.c        |    3 ++
 11 files changed, 128 insertions(+), 51 deletions(-)
 create mode 100644 drivers/isdn/hisax/hisax_proto.h

diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index c7a3794..0b73795 100644
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
 
+libhisax-y				:= netjet.o isac.o arcofi.o hscx.o
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
index d30ce5b..5597f15 100644
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -111,6 +111,7 @@ arcofi_fsm(struct IsdnCardState *cs, int event, void *data) {
 	}
 	return(0);
 }
+EXPORT_SYMBOL(arcofi_fsm);
 
 static void
 arcofi_timer(struct IsdnCardState *cs) {
@@ -123,6 +124,7 @@ clear_arcofi(struct IsdnCardState *cs) {
 		del_timer(&cs->dc.isac.arcofitimer);
 	}
 }
+EXPORT_SYMBOL(clear_arcofi);
 
 void
 init_arcofi(struct IsdnCardState *cs) {
@@ -132,3 +134,4 @@ init_arcofi(struct IsdnCardState *cs) {
 	init_waitqueue_head(&cs->dc.isac.arcofi_wait);
 	test_and_set_bit(HW_ARCOFI, &cs->HW_Flags);
 }
+EXPORT_SYMBOL(init_arcofi);
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 84d75a3..3259639 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -23,6 +23,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
+#include "hisax_proto.h"
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
@@ -380,6 +362,7 @@ char *HiSax_getrev(const char *revision)
 		rev = "???";
 	return rev;
 }
+EXPORT_SYMBOL(HiSax_getrev);
 
 static void __init HiSaxVersion(void)
 {
@@ -742,6 +725,7 @@ void HiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, ...)
 	VHiSax_putstatus(cs, head, fmt, args);
 	va_end(args);
 }
+EXPORT_SYMBOL(HiSax_putstatus);
 
 int ll_run(struct IsdnCardState *cs, int addfeatures)
 {
@@ -1285,6 +1269,7 @@ void HiSax_closecard(int cardnr)
 	}
 	nrcards--;
 }
+EXPORT_SYMBOL(HiSax_closecard);
 
 void HiSax_reportcard(int cardnr, int sel)
 {
@@ -1542,6 +1527,38 @@ static void __exit HiSax_exit(void)
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
+EXPORT_SYMBOL(hisax_init_hotplug);
+
 int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 {
 	u_char ids[16];
@@ -1561,9 +1578,7 @@ int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 error:
 	return ret;
 }
-
 EXPORT_SYMBOL(hisax_init_pcmcia);
-EXPORT_SYMBOL(HiSax_closecard);
 
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
index c8f9951..0c044ae 100644
--- a/drivers/isdn/hisax/hscx.c
+++ b/drivers/isdn/hisax/hscx.c
@@ -35,6 +35,7 @@ HscxVersion(struct IsdnCardState *cs, char *s)
 	else
 		return (0);
 }
+EXPORT_SYMBOL(HscxVersion);
 
 void
 modehscx(struct BCState *bcs, int mode, int bc)
@@ -90,6 +91,7 @@ modehscx(struct BCState *bcs, int mode, int bc)
 		cs->BC_Write_Reg(cs, hscx, HSCX_CMDR, 0x41);
 	cs->BC_Write_Reg(cs, hscx, HSCX_ISTA, 0x00);
 }
+EXPORT_SYMBOL(modehscx);
 
 void
 hscx_l2l1(struct PStack *st, int pr, void *arg)
@@ -150,6 +152,7 @@ hscx_l2l1(struct PStack *st, int pr, void *arg)
 			break;
 	}
 }
+EXPORT_SYMBOL(hscx_l2l1);
 
 static void
 close_hscxstate(struct BCState *bcs)
@@ -198,6 +201,7 @@ open_hscxstate(struct IsdnCardState *cs, struct BCState *bcs)
 	bcs->tx_cnt = 0;
 	return (0);
 }
+EXPORT_SYMBOL(open_hscxstate);
 
 static int
 setstack_hscx(struct PStack *st, struct BCState *bcs)
@@ -238,6 +242,7 @@ clear_pending_hscx_ints(struct IsdnCardState *cs)
 	cs->BC_Write_Reg(cs, 0, HSCX_MASK, 0xFF);
 	cs->BC_Write_Reg(cs, 1, HSCX_MASK, 0xFF);
 }
+EXPORT_SYMBOL(clear_pending_hscx_ints);
 
 void
 inithscx(struct IsdnCardState *cs)
@@ -255,6 +260,7 @@ inithscx(struct IsdnCardState *cs)
 	modehscx(cs->bcs, 0, 0);
 	modehscx(cs->bcs + 1, 0, 0);
 }
+EXPORT_SYMBOL(inithscx);
 
 void
 inithscxisac(struct IsdnCardState *cs, int part)
@@ -274,3 +280,4 @@ inithscxisac(struct IsdnCardState *cs, int part)
 		cs->writeisac(cs, ISAC_CMDR, 0x41);
 	}
 }
+EXPORT_SYMBOL(inithscxisac);
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 07b1673..9a69fc0 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -27,13 +27,14 @@ static char *ISACVer[] __devinitdata =
 {"2086/2186 V1.1", "2085 B1", "2085 B2",
  "2085 V2.3"};
 
-void __devinit ISACVersion(struct IsdnCardState *cs, char *s)
+void ISACVersion(struct IsdnCardState *cs, char *s)
 {
 	int val;
 
 	val = cs->readisac(cs, ISAC_RBCH);
 	printk(KERN_INFO "%s ISAC version (%x): %s\n", s, val, ISACVer[(val >> 5) & 3]);
 }
+EXPORT_SYMBOL(ISACVersion);
 
 static void
 ph_command(struct IsdnCardState *cs, unsigned int command)
@@ -434,6 +435,7 @@ isac_interrupt(struct IsdnCardState *cs, u_char val)
 		}
 	}
 }
+EXPORT_SYMBOL(isac_interrupt);
 
 static void
 ISAC_l1hw(struct PStack *st, int pr, void *arg)
@@ -645,6 +647,7 @@ void initisac(struct IsdnCardState *cs)
 	ph_command(cs, ISAC_CMD_RS);
 	cs->writeisac(cs, ISAC_MASK, 0x0);
 }
+EXPORT_SYMBOL(initisac);
 
 void clear_pending_isac_ints(struct IsdnCardState *cs)
 {
@@ -669,8 +672,9 @@ void clear_pending_isac_ints(struct IsdnCardState *cs)
 	/* Disable all IRQ */
 	cs->writeisac(cs, ISAC_MASK, 0xFF);
 }
+EXPORT_SYMBOL(clear_pending_isac_ints);
 
-void __devinit
+void
 setup_isac(struct IsdnCardState *cs)
 {
 	INIT_WORK(&cs->tqueue, isac_bh);
@@ -678,3 +682,4 @@ setup_isac(struct IsdnCardState *cs)
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
 }
+EXPORT_SYMBOL(setup_isac);
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index a14204e..93b54a7 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -136,6 +136,7 @@ debugl1(struct IsdnCardState *cs, char *fmt, ...)
 	VHiSax_putstatus(cs, tmp, fmt, args);
 	va_end(args);
 }
+EXPORT_SYMBOL(debugl1);
 
 static void
 l1m_debug(struct FsmInst *fi, char *fmt, ...)
@@ -198,6 +199,7 @@ DChannel_proc_xmt(struct IsdnCardState *cs)
 			stptr = stptr->next;
 	}
 }
+EXPORT_SYMBOL(DChannel_proc_xmt);
 
 void
 DChannel_proc_rcv(struct IsdnCardState *cs)
@@ -265,6 +267,7 @@ DChannel_proc_rcv(struct IsdnCardState *cs)
 			dev_kfree_skb(skb);
 	}
 }
+EXPORT_SYMBOL(DChannel_proc_rcv);
 
 static void
 BChannel_proc_xmt(struct BCState *bcs)
@@ -451,7 +454,8 @@ Logl2Frame(struct IsdnCardState *cs, struct sk_buff *skb, char *buf, int dir)
 			(dir ? "<-" : "->"), buf, l2frames(ptr),
 			((ptr[0] & 2) >> 1) == dir ? 'C' : 'R', ptr[0] >> 2, ptr[1] >> 1);
 }
-#endif
+EXPORT_SYMBOL(Logl2Frame);
+#endif /* L2FRAME_DEBUG */
 
 static void
 l1_reset(struct FsmInst *fi, int event, void *arg)
@@ -878,6 +882,7 @@ l1_msg(struct IsdnCardState *cs, int pr, void *arg) {
 		st = st->next;
 	}
 }
+EXPORT_SYMBOL(l1_msg);
 
 void
 l1_msg_b(struct PStack *st, int pr, void *arg) {
@@ -890,6 +895,7 @@ l1_msg_b(struct PStack *st, int pr, void *arg) {
 			break;
 	}
 }
+EXPORT_SYMBOL(l1_msg_b);
 
 void
 setstack_HiSax(struct PStack *st, struct IsdnCardState *cs)
@@ -933,3 +939,4 @@ setstack_l1_B(struct PStack *st)
 	st->l1.Flags = 0;
 	FsmInitTimer(&st->l1.l1m, &st->l1.timer);
 }
+EXPORT_SYMBOL(setstack_l1_B);
diff --git a/drivers/isdn/hisax/lmgr.c b/drivers/isdn/hisax/lmgr.c
index d4f86d6..7122093 100644
--- a/drivers/isdn/hisax/lmgr.c
+++ b/drivers/isdn/hisax/lmgr.c
@@ -48,3 +48,4 @@ setstack_manager(struct PStack *st)
 {
 	st->ma.layer = hisax_manager;
 }
+EXPORT_SYMBOL(setstack_manager);
diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
index 02c6fba..3b09d8e 100644
--- a/drivers/isdn/hisax/netjet.c
+++ b/drivers/isdn/hisax/netjet.c
@@ -37,6 +37,7 @@ NETjet_ReadIC(struct IsdnCardState *cs, u_char offset)
 	ret = bytein(cs->hw.njet.isac + ((offset & 0xf)<<2));
 	return(ret);
 }
+EXPORT_SYMBOL(NETjet_ReadIC);
 
 void
 NETjet_WriteIC(struct IsdnCardState *cs, u_char offset, u_char value)
@@ -46,6 +47,7 @@ NETjet_WriteIC(struct IsdnCardState *cs, u_char offset, u_char value)
 	byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
 	byteout(cs->hw.njet.isac + ((offset & 0xf)<<2), value);
 }
+EXPORT_SYMBOL(NETjet_WriteIC);
 
 void
 NETjet_ReadICfifo(struct IsdnCardState *cs, u_char *data, int size)
@@ -54,6 +56,7 @@ NETjet_ReadICfifo(struct IsdnCardState *cs, u_char *data, int size)
 	byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
 	insb(cs->hw.njet.isac, data, size);
 }
+EXPORT_SYMBOL(NETjet_ReadICfifo);
 
 void 
 NETjet_WriteICfifo(struct IsdnCardState *cs, u_char *data, int size)
@@ -62,6 +65,7 @@ NETjet_WriteICfifo(struct IsdnCardState *cs, u_char *data, int size)
 	byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
 	outsb(cs->hw.njet.isac, data, size);
 }
+EXPORT_SYMBOL(NETjet_WriteICfifo);
 
 static void fill_mem(struct BCState *bcs, u_int *pos, u_int cnt, int chan, u_char fill)
 {
@@ -600,6 +604,7 @@ void read_tiger(struct IsdnCardState *cs) {
 		read_raw(cs->bcs + 1, p, cnt);
 	cs->hw.njet.irqstat0 &= ~NETJET_IRQM0_READ;
 }
+EXPORT_SYMBOL(read_tiger);
 
 static void write_raw(struct BCState *bcs, u_int *buf, int cnt);
 
@@ -669,6 +674,7 @@ void netjet_fill_dma(struct BCState *bcs)
 		debugl1(bcs->cs,"tiger fill_dma3: c%d %4x", bcs->channel,
 			bcs->Flag);
 }
+EXPORT_SYMBOL(netjet_fill_dma);
 
 static void write_raw(struct BCState *bcs, u_int *buf, int cnt) {
 	u_int mask, val, *p=buf;
@@ -787,6 +793,7 @@ void write_tiger(struct IsdnCardState *cs) {
 		write_raw(cs->bcs + 1, p, cnt);
 	cs->hw.njet.irqstat0 &= ~NETJET_IRQM0_WRITE;
 }
+EXPORT_SYMBOL(write_tiger);
 
 static void
 tiger_l2l1(struct PStack *st, int pr, void *arg)
@@ -958,6 +965,7 @@ inittiger(struct IsdnCardState *cs)
 	cs->bcs[0].BC_Close = close_tigerstate;
 	cs->bcs[1].BC_Close = close_tigerstate;
 }
+EXPORT_SYMBOL(inittiger);
 
 static void
 releasetiger(struct IsdnCardState *cs)
@@ -978,4 +986,4 @@ release_io_netjet(struct IsdnCardState *cs)
 	releasetiger(cs);
 	release_region(cs->hw.njet.base, 256);
 }
-
+EXPORT_SYMBOL(release_io_netjet);
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index aacbf0d..7225a6d 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -1170,6 +1170,7 @@ QuickHex(char *txt, u_char * p, int cnt)
 	*t++ = 0;
 	return (t - txt);
 }
+EXPORT_SYMBOL(QuickHex);
 
 void
 LogFrame(struct IsdnCardState *cs, u_char * buf, int size)
@@ -1192,6 +1193,7 @@ LogFrame(struct IsdnCardState *cs, u_char * buf, int size)
 	} else
 		HiSax_putstatus(cs, "LogFrame: ", "warning Frame too big (%d)", size);
 }
+EXPORT_SYMBOL(LogFrame);
 
 void
 dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
@@ -1520,3 +1522,4 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 	*dp = 0;
 	HiSax_putstatus(cs, NULL, cs->dlog);
 }
+EXPORT_SYMBOL(dlogframe);
-- 
1.5.3.8

