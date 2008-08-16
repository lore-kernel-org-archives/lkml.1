Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYHPKKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYHPKKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYHPKJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:09:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:33654 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYHPKJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=goNdceC8CtVCP4bDQpOuLJkuV9CZmiiMM7bR1LHl1malqVrbTerhnQMsRfDstmk1J/
         CpDn2CooTFFKezUJhBYKeJHfTpGcUj8HLXHh1GAfNRSLFyIvCcVWkPf402ummfzOrDWC
         L3meOYNdX28NsAjF2Hzw4hekw9ER52PKOSG2M=
Date: Sat, 16 Aug 2008 14:09:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org, akpm@osdl.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] BUILD_BUG_ON sucks
Message-ID: <20080816100948.GB19926@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON should have never existed -- BUG_ON could upgrade itself to
compile-breaking version if compiler has enough information and this is
what patch does.

The only downside is that one can't write BUG_ON(1) anymore.

Note: this compile-breaks jbd, jbd2, tipc,
      what this code is supposed to do?

	journal = handle->h_transaction->t_journal;
	if (!journal_set_features(journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
		J_ASSERT (!"Cannot set revoke feature!");
			 ^^^^
		return -EINVAL;
        }

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/cris/arch-v10/kernel/io_interface_mux.c |    8 ++++----
 arch/powerpc/include/asm/bug.h               |    3 +--
 drivers/infiniband/core/cma.c                |    2 +-
 drivers/infiniband/core/mad.c                |    2 +-
 drivers/infiniband/hw/amso1100/c2_ae.c       |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c       |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    6 +++---
 drivers/mmc/host/wbsd.c                      |    2 +-
 drivers/net/wireless/b43legacy/b43legacy.h   |    2 ++
 drivers/net/wireless/b43legacy/main.c        |   12 ++++++------
 drivers/net/wireless/b43legacy/phy.c         |    2 +-
 drivers/net/wireless/b43legacy/radio.c       |   22 +++++++++++-----------
 drivers/net/wireless/b43legacy/xmit.c        |   12 ++++++------
 drivers/scsi/device_handler/scsi_dh_emc.c    |    2 +-
 drivers/ssb/scan.c                           |    4 ++--
 drivers/ssb/ssb_private.h                    |    2 ++
 fs/jbd2/journal.c                            |    2 +-
 include/asm-generic/bug.h                    |    8 +++++++-
 include/asm-mips/bug.h                       |    5 ++++-
 kernel/sched.c                               |    2 +-
 net/bluetooth/rfcomm/tty.c                   |    2 +-
 21 files changed, 58 insertions(+), 46 deletions(-)

--- a/arch/cris/arch-v10/kernel/io_interface_mux.c
+++ b/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -650,7 +650,7 @@ int cris_request_io_interface(enum cris_io_interface ioif, const char *device_id
 			if_group_use = interfaces[ioif].group_f;
 			break;
 		default:
-			BUG_ON(1);
+			BUG();
 		}
 
 		if (if_group_use & grp->used) {
@@ -799,7 +799,7 @@ int cris_request_io_interface(enum cris_io_interface ioif, const char *device_id
 			if_group_use = interfaces[ioif].group_f;
 			break;
 		default:
-			BUG_ON(1);
+			BUG();
 		}
 		grp->used |= if_group_use;
 
@@ -891,11 +891,11 @@ void cris_free_io_interface(enum cris_io_interface ioif)
 			if_group_use = interfaces[ioif].group_f;
 			break;
 		default:
-			BUG_ON(1);
+			BUG();
 		}
 
 		if ((grp->used & if_group_use) != if_group_use)
-			BUG_ON(1);
+			BUG();
 		grp->used = grp->used & ~if_group_use;
 
 		group_set = clear_group_from_set(group_set, grp);
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -71,8 +71,7 @@
 
 #define BUG_ON(x) do {						\
 	if (__builtin_constant_p(x)) {				\
-		if (x)						\
-			BUG();					\
+		(void)sizeof(char[1 - 2 * !!(x)]);		\
 	} else {						\
 		__asm__ __volatile__(				\
 		"1:	"PPC_TLNEI"	%4,0\n"			\
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1252,7 +1252,7 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 		event.event = RDMA_CM_EVENT_ESTABLISHED;
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 	}
 
 	event.status = iw_event->status;
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2249,7 +2249,7 @@ static void ib_mad_completion_handler(struct work_struct *work)
 				ib_mad_recv_done_handler(port_priv, &wc);
 				break;
 			default:
-				BUG_ON(1);
+				BUG();
 				break;
 			}
 		} else
--- a/drivers/infiniband/hw/amso1100/c2_ae.c
+++ b/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -256,7 +256,7 @@ void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
 				cm_id->event_handler(cm_id, &cm_event);
 			break;
 		default:
-			BUG_ON(1);
+			BUG();
 			pr_debug("%s:%d Unexpected event_id=%d on QP=%p, "
 				"CM_ID=%p\n",
 				__func__, __LINE__,
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -109,7 +109,7 @@ int cxio_hal_cq_op(struct cxio_rdev *rdev_p, struct t3_cq *cq,
 		while (!CQ_VLD_ENTRY(rptr, cq->size_log2, cqe)) {
 			udelay(1);
 			if (i++ > 1000000) {
-				BUG_ON(1);
+				BUG();
 				printk(KERN_ERR "%s: stalled rnic\n",
 				       rdev_p->dev_name);
 				return -EIO;
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1493,7 +1493,7 @@ static int peer_close(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		disconnect = 0;
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);
 	if (disconnect)
@@ -1590,7 +1590,7 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		spin_unlock_irqrestore(&ep->com.lock, flags);
 		return CPL_RET_BUF_DONE;
 	default:
-		BUG_ON(1);
+		BUG();
 		break;
 	}
 	dst_confirm(ep->dst);
@@ -1653,7 +1653,7 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	case DEAD:
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 		break;
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1416,7 +1416,7 @@ kfree:
 	/*
 	 * If we've gotten here then there is some kind of alignment bug
 	 */
-	BUG_ON(1);
+	BUG();
 
 	dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
 		WBSD_DMA_SIZE, DMA_BIDIRECTIONAL);
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -342,12 +342,14 @@ enum {
 			BUG_ON(expr);					\
 		}							\
 	} while (0)
+# define B43legacy_BUG()	BUG()
 # define B43legacy_DEBUG	1
 #else
 /* This will evaluate the argument even if debugging is disabled. */
 static inline bool __b43legacy_warn_on_dummy(bool x) { return x; }
 # define B43legacy_WARN_ON(x)	__b43legacy_warn_on_dummy(unlikely(!!(x)))
 # define B43legacy_BUG_ON(x)	do { /* nothing */ } while (0)
+# define B43legacy_BUG()	do {} while (0)
 # define B43legacy_DEBUG	0
 #endif
 
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -649,7 +649,7 @@ void b43legacy_dummy_transmission(struct b43legacy_wldev *dev)
 		buffer[0] = 0x000B846E;
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 		return;
 	}
 
@@ -2010,7 +2010,7 @@ static void b43legacy_rate_memory_init(struct b43legacy_wldev *dev)
 		b43legacy_rate_memory_write(dev, B43legacy_CCK_RATE_11MB, 0);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 }
 
@@ -2032,7 +2032,7 @@ static void b43legacy_mgmtframe_txantenna(struct b43legacy_wldev *dev,
 		ant |= B43legacy_TX4_PHY_ANTLAST;
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 
 	/* FIXME We also need to set the other flags of the PHY control
@@ -2442,7 +2442,7 @@ static const char *phymode_to_string(unsigned int phymode)
 	case B43legacy_PHYMODE_G:
 		return "G";
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 	return "";
 }
@@ -2887,7 +2887,7 @@ static int b43legacy_phy_versioning(struct b43legacy_wldev *dev)
 			unsupported = 1;
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 	if (unsupported) {
 		b43legacyerr(dev->wl, "FOUND UNSUPPORTED RADIO "
@@ -3563,7 +3563,7 @@ static int b43legacy_wireless_core_attach(struct b43legacy_wldev *dev)
 			have_gphy = 1;
 			break;
 		default:
-			B43legacy_BUG_ON(1);
+			B43legacy_BUG();
 		}
 	}
 	dev->phy.gmode = (have_gphy || have_bphy);
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -1760,7 +1760,7 @@ static s8 b43legacy_phy_estimate_power_out(struct b43legacy_wldev *dev, s8 tssi)
 		dbm = phy->tssi2dbm[tmp];
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 
 	return dbm;
--- a/drivers/net/wireless/b43legacy/radio.c
+++ b/drivers/net/wireless/b43legacy/radio.c
@@ -131,7 +131,7 @@ u16 b43legacy_radio_read16(struct b43legacy_wldev *dev, u16 offset)
 		offset |= 0x80;
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 
 	b43legacy_write16(dev, B43legacy_MMIO_RADIO_CONTROL, offset);
@@ -811,7 +811,7 @@ void b43legacy_calc_nrssi_slope(struct b43legacy_wldev *dev)
 		b43legacy_calc_nrssi_threshold(dev);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 }
 
@@ -910,7 +910,7 @@ void b43legacy_calc_nrssi_threshold(struct b43legacy_wldev *dev)
 		}
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 }
 
@@ -946,7 +946,7 @@ static u16 _stack_restore(u32 *stackptr,
 			continue;
 		return ((*stackptr & 0xFFFF0000) >> 16);
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 
 	return 0;
 }
@@ -1227,7 +1227,7 @@ b43legacy_radio_interference_mitigation_enable(struct b43legacy_wldev *dev,
 		b43legacy_calc_nrssi_slope(dev);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 }
 
@@ -1325,7 +1325,7 @@ b43legacy_radio_interference_mitigation_disable(struct b43legacy_wldev *dev,
 		b43legacy_calc_nrssi_slope(dev);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 }
 
@@ -1419,7 +1419,7 @@ static u16 b43legacy_get_812_value(struct b43legacy_wldev *dev, u8 lpd)
 			case LPD(1, 0, 0):
 				return 0x30B3;
 			default:
-				B43legacy_BUG_ON(1);
+				B43legacy_BUG();
 			}
 		} else {
 			switch (lpd) {
@@ -1432,7 +1432,7 @@ static u16 b43legacy_get_812_value(struct b43legacy_wldev *dev, u8 lpd)
 			case LPD(1, 0, 0):
 				return 0x20B3;
 			default:
-				B43legacy_BUG_ON(1);
+				B43legacy_BUG();
 			}
 		}
 	} else {
@@ -1474,7 +1474,7 @@ static u16 b43legacy_get_812_value(struct b43legacy_wldev *dev, u8 lpd)
 			case LPD(1, 0, 0):
 				return (0x2093 | loop_or);
 			default:
-				B43legacy_BUG_ON(1);
+				B43legacy_BUG();
 			}
 		} else {
 			switch (lpd) {
@@ -1486,7 +1486,7 @@ static u16 b43legacy_get_812_value(struct b43legacy_wldev *dev, u8 lpd)
 			case LPD(1, 0, 0):
 				return (0x0093 | loop_or);
 			default:
-				B43legacy_BUG_ON(1);
+				B43legacy_BUG();
 			}
 		}
 	}
@@ -2111,7 +2111,7 @@ void b43legacy_radio_turn_on(struct b43legacy_wldev *dev)
 		B43legacy_WARN_ON(err);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 	phy->radio_on = 1;
 }
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -49,7 +49,7 @@ static u8 b43legacy_plcp_get_bitrate_idx_cck(struct b43legacy_plcp_hdr6 *plcp)
 	case 0x6E:
 		return 3;
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 	return -1;
 }
 
@@ -77,7 +77,7 @@ static u8 b43legacy_plcp_get_bitrate_idx_ofdm(struct b43legacy_plcp_hdr6 *plcp,
 	case 0xC:
 		return base + 7;
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 	return -1;
 }
 
@@ -93,7 +93,7 @@ u8 b43legacy_plcp_get_ratecode_cck(const u8 bitrate)
 	case B43legacy_CCK_RATE_11MB:
 		return 0x6E;
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 	return 0;
 }
 
@@ -117,7 +117,7 @@ u8 b43legacy_plcp_get_ratecode_ofdm(const u8 bitrate)
 	case B43legacy_OFDM_RATE_54MB:
 		return 0xC;
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 	return 0;
 }
 
@@ -180,7 +180,7 @@ static u8 b43legacy_calc_fallback_rate(u8 bitrate)
 	case B43legacy_OFDM_RATE_54MB:
 		return B43legacy_OFDM_RATE_48MB;
 	}
-	B43legacy_BUG_ON(1);
+	B43legacy_BUG();
 	return 0;
 }
 
@@ -289,7 +289,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 		phy_ctl |= B43legacy_TX4_PHY_ANT1;
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		B43legacy_BUG();
 	}
 
 	/* MAC control */
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -298,7 +298,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		memset(buffer, 0, len);
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 		break;
 	}
 
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -203,7 +203,7 @@ void ssb_iounmap(struct ssb_bus *bus)
 #ifdef CONFIG_SSB_PCIHOST
 		pci_iounmap(bus->host_pci, bus->mmio);
 #else
-		SSB_BUG_ON(1); /* Can't reach this code. */
+		SSB_BUG(); /* Can't reach this code. */
 #endif
 		break;
 	}
@@ -227,7 +227,7 @@ static void __iomem *ssb_ioremap(struct ssb_bus *bus,
 #ifdef CONFIG_SSB_PCIHOST
 		mmio = pci_iomap(bus->host_pci, 0, ~0UL);
 #else
-		SSB_BUG_ON(1); /* Can't reach this code. */
+		SSB_BUG(); /* Can't reach this code. */
 #endif
 		break;
 	}
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -23,10 +23,12 @@
 #ifdef CONFIG_SSB_DEBUG
 # define SSB_WARN_ON(x)		WARN_ON(x)
 # define SSB_BUG_ON(x)		BUG_ON(x)
+# define SSB_BUG()		BUG()
 #else
 static inline int __ssb_do_nothing(int x) { return x; }
 # define SSB_WARN_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
 # define SSB_BUG_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
+# define SSB_BUG()		do {} while (0)
 #endif
 
 
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -731,7 +731,7 @@ static int jbd2_seq_history_show(struct seq_file *seq, void *v)
 				ts->u.chp.cs_written, ts->u.chp.cs_dropped,
 				ts->u.chp.cs_forced_to_close);
 	else
-		J_ASSERT(0);
+		BUG();
 	return 0;
 }
 
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -28,7 +28,13 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
+#define BUG_ON(condition)						\
+	do {								\
+		if (__builtin_constant_p(condition))			\
+			(void)sizeof(char[1 - 2 * !!(condition)]);	\
+		else if (unlikely(condition))				\
+			BUG();						\
+	} while (0)
 #endif
 
 #ifndef __WARN
--- a/include/asm-mips/bug.h
+++ b/include/asm-mips/bug.h
@@ -18,7 +18,10 @@ do {									\
 
 #define BUG_ON(condition)						\
 do {									\
-	__asm__ __volatile__("tne $0, %0, %1"				\
+	if (__builtin_constant_p(condition))				\
+		(void)sizeof(char[1 - 2 * !!(condition)]);		\
+	else
+		__asm__ __volatile__("tne $0, %0, %1"			\
 			     : : "r" (condition), "i" (BRK_BUG));	\
 } while (0)
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2798,7 +2798,7 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	if (unlikely(!irqs_disabled())) {
 		/* printk() doesn't work good under rq->lock */
 		spin_unlock(&this_rq->lock);
-		BUG_ON(1);
+		BUG();
 	}
 	if (unlikely(!spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -331,7 +331,7 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
 	BT_DBG("dev %p", dev);
 
 	if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
-		BUG_ON(1);
+		BUG();
 	else
 		set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 

