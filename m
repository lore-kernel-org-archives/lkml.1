Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZFBNG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZFBNG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZFBNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:06:50 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60777 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZFBNGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:06:49 -0400
Date: Tue, 2 Jun 2009 15:06:49 +0200
From: Andreas Mohr <andi@lisas.de>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Message-ID: <20090602130649.GA14794@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Karsten,

I'm having a hell of a time trying to get the
Linux 2.6.29.4
mISDN git (socket), and also kernel previously
mISDNuser git (socket)
lcr git (and also 20090107 previously)
Asterisk 1:1.4.21.2~dfsg-3
combo to work even marginally here.
Worse, the migration attempt (from i4l) even forced me to disable
regularly-used functionality (isdnlog) due to missing CAPI functionality
of mISDN or alternatively mISDN capability of isdnlog.

I had managed a *working* outgoing call setup Asterisk -> LCR -> ISDN *once*
(by re-loading modules after boot, however boot state itself
didn't work directly), but never since.

I have the suspicion that maybe I shouldn't be loading hisax upon boot
(and then immediately removing it before launching mISDN stuff),
since hfcpci acts very weird - perhaps it cannot recover card state fully
after hisax fumbling.

I will have to test this more.

This is on a Lenny K6-III/150 box (yes, in ACPI mode!!!), 128M, 8G CF.

Might need to revert to non-ACPI operation after all *SIGH*


Behaviour was something like:

base_sock_release(c7600000) sk=c6f84a00
base_sock_release(c7600200) sk=c6f84400
base_sock_release(c7600400) sk=c7ab5800
init_card: entered
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(14) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 1
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(4) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 2
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(14) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 3
create_l2entity: ret 1 -5
base_sock_release(c7600400) sk=c6f94e00
init_card: entered
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(14) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 1
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(4) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 2
reset_hfcpci: entered
HFC_PCI: resetting HFC ChipId(30)
HFC-PCI status(14) before reset
HFC-PCI status(2) after reset
HFC-PCI status(4) after 5us
inithfcpci: entered
HFC PCI: IRQ 12 count 0
HFC PCI: IRQ(12) getting no interrupts during init 3
create_l2entity: ret 1 -5
HiSax: release hfcpci at c8826000
HiSax module removed
ISDN-subsystem unloaded
DSP modul 2.0
mISDN_dsp: DSP clocks every 80 samples. This equals 1 jiffies.



which resulted in cat /proc/interrupts showing multiple "HFC PCI" entries
after a couple of failed request_irq() iterations.
rmmod'ing hfcpci and then doing cat /proc/interrupts quickly led to
a network-killing OOPS.

Note that I still get a WARN_ON even with my hopefully(?) improved version:


------------[ cut here ]------------
WARNING: at kernel/softirq.c:124 _local_bh_enable_ip+0x31/0x6f()
Hardware name:
Modules linked in: hfcpci tun cls_u32 sch_sfq sch_tbf sch_prio sch_ingress sch_htb sch_cbq capifs xt_state xt_multiport xt_tcpudp xt_recent xt_limit iptable_mangle iptable_nat iptable_filter ip_tables nf_nat_tftp nf_conntrack_tftp nf_nat_h323 nf_conntrack_h323 nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ipt_REJECT ipt_LOG x_tables fuse 8021qgarp stp llc usb_storage ehci_hcd ohci_hcd sis5595 i2c_sis5595 i2c_sis630 e100 usbcore i2c_core mISDN_core [last unloaded: mISDN_dsp]
Pid: 3462, comm: mISDN_hfc-pci.1 Not tainted 2.6.29.4-gate #1
Call Trace:
 [<c0118049>] warn_slowpath+0x71/0xa7
 [<c013c2bd>] ? __rmqueue+0x16/0x1b0
 [<c03526ff>] ? _spin_unlock+0x8/0xa
 [<c013d353>] ? rmqueue_bulk+0x5e/0x68
 [<c013d500>] ? get_page_from_freelist+0x1a3/0x32e
 [<c013d726>] ? __alloc_pages_internal+0x9b/0x358
 [<c011bee3>] _local_bh_enable_ip+0x31/0x6f
 [<c011bf36>] local_bh_enable+0xb/0xd
 [<c02eb443>] sk_filter+0x5a/0x63
 [<c02d9f1f>] sock_queue_rcv_skb+0x2b/0xc8
 [<c893f5b3>] mISDN_send+0x4e/0x71 [mISDN_core]
 [<c8941dff>] l2up_create+0x6f/0x96 [mISDN_core]
 [<c8944547>] l2_got_tei+0x3b/0x77 [mISDN_core]
 [<c893e74d>] mISDN_FsmEvent+0x74/0xa8 [mISDN_core]
 [<c894450c>] ? l2_got_tei+0x0/0x77 [mISDN_core]
 [<c8943740>] tei_l2+0x73/0xa3 [mISDN_core]
 [<c8945636>] tei_id_assign+0xab/0xb3 [mISDN_core]
 [<c893e74d>] mISDN_FsmEvent+0x74/0xa8 [mISDN_core]
 [<c894558b>] ? tei_id_assign+0x0/0xb3 [mISDN_core]
 [<c89465f2>] mgr_send+0x30b/0x4d1 [mISDN_core]
 [<c0351ad6>] ? __mutex_lock_slowpath+0x12/0x15
 [<c0351b5b>] ? mutex_lock+0x1c/0x1f
 [<c8940f4d>] mISDNStackd+0x216/0x4f1 [mISDN_core]
 [<c01271ab>] ? autoremove_wake_function+0x0/0x33
 [<c8940d37>] ? mISDNStackd+0x0/0x4f1 [mISDN_core]
 [<c0126f9a>] kthread+0x39/0x5e
 [<c0126f61>] ? kthread+0x0/0x5e
 [<c0103497>] kernel_thread_helper+0x7/0x10
---[ end trace 080cb55fd8ea9459 ]---

which hints at IRQ disable issues (maybe due to my change even??),
but I've got no friggin clue...




Also, misdn_log doesn't seem to do much here either:

# misdn_log
mISDN kernel version 1.01.20 found
mISDN user   version 1.01.20 found
1 controller found
        id:             0
        Dprotocols:     00000006
        Bprotocols:     0000000e
        protocol:       1
        channelmap:     00000000000000000000000000000006
        nrbchan:        2
        name:           hfc-pci.1
log bind ch(1) return -1
log bind error Invalid argument
log bind ch(0) return -1
log bind error Operation already in progress

(strace hints at PF_ISDN socket issues)


Thanks!




ChangeLog:
Make sure to properly bail out (call free_irq())
after hfcpci interrupt detection failure.
Improve comment.

Signed-off-by: Andreas Mohr <andi@lisas.de>

--- ./drivers/isdn/hardware/mISDN/hfcpci.c.orig	2009-06-02 13:54:10.000000000 +0200
+++ ./drivers/isdn/hardware/mISDN/hfcpci.c	2009-06-02 14:29:20.000000000 +0200
@@ -1172,7 +1172,7 @@ hfcpci_int(int intno, void *dev_id)
 			printk(KERN_DEBUG
 			    "HFC-PCI: stat(%02x) s1(%02x)\n", stat, val);
 	} else {
-		/* shared */
+		/* (shared) IRQ triggered by other device */
 		spin_unlock(&hc->lock);
 		return IRQ_NONE;
 	}
@@ -1807,8 +1807,7 @@ init_card(struct hfc_pci *hc)
 			    "HFC PCI: IRQ(%d) getting no interrupts "
 			    "during init %d\n", hc->irq, 4 - cnt);
 			if (cnt == 1) {
-				spin_unlock_irqrestore(&hc->lock, flags);
-				return -EIO;
+				goto fail;
 			} else {
 				reset_hfcpci(hc);
 				cnt--;
@@ -1819,6 +1818,7 @@ init_card(struct hfc_pci *hc)
 			return 0;
 		}
 	}
+fail:
 	disable_hwirq(hc);
 	spin_unlock_irqrestore(&hc->lock, flags);
 	free_irq(hc->irq, hc);
