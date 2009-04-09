Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbZDIOw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbZDIOw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933551AbZDIOwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:52:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59976 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762698AbZDIOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Kqpgfro/9FFcSEGZy3gbU9KveE5920o/AK6IWipTjH+EvUvzkTqZx0stvq9mdiWAuz
         vQDmrsU91OACE/7sl5N+ffI818YcIWgZM773PbTlc2c/gdoTeKZg9aL2hdXeWMnXH3EN
         84GYeITMjpfX+sDxLBt10yPvUxxk3jwx/IBu8=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] tifm: avoid inconsistent lock state
Date: Thu,  9 Apr 2009 16:52:03 +0200
Message-Id: <1239288723-4240-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the following INFO from lock debugging:

[  901.190400] irq 18: nobody cared (try booting with the "irqpoll" option)
[  901.190411] Pid: 4255, comm: pulseaudio Not tainted 2.6.30-rc1 #21
[  901.190415] Call Trace:
[  901.190419]  <IRQ>  [<ffffffffa0022969>] ? tifm_7xx1_isr+0x99/0x170 [tifm_7xx1]
[  901.190452]  [<ffffffff802bbdcb>] __report_bad_irq+0x2b/0xb0
[  901.190459]  [<ffffffff802bbfe8>] note_interrupt+0x198/0x1e0
[  901.190467]  [<ffffffff802bc6ad>] handle_fasteoi_irq+0xdd/0x110
[  901.190474]  [<ffffffff80215bd4>] handle_irq+0x24/0x40
[  901.190483]  [<ffffffff8074d0a3>] do_IRQ+0x73/0x100
[  901.190491]  [<ffffffff80213cd3>] ret_from_intr+0x0/0x16
[  901.190495]  <EOI>  [<ffffffff80747eb2>] ? _spin_unlock_irqrestore+0x72/0x80
[  901.190510]  [<ffffffff8027356e>] ? add_wait_queue+0x4e/0x60
[  901.190517]  [<ffffffff803292d6>] ? __pollwait+0x86/0x110
[  901.190535]  [<ffffffffa016c831>] ? snd_ctl_poll+0x61/0x70 [snd]
[  901.190543]  [<ffffffff803295cc>] ? do_sys_poll+0x21c/0x4c0
[  901.190549]  [<ffffffff80329250>] ? __pollwait+0x0/0x110
[  901.190556]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190562]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190569]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190575]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190581]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190587]  [<ffffffff80329360>] ? pollwake+0x0/0x50
[  901.190594]  [<ffffffff80747e07>] ? _spin_unlock_irq+0x37/0x70
[  901.190601]  [<ffffffff80747e11>] ? _spin_unlock_irq+0x41/0x70
[  901.190609]  [<ffffffff8024c283>] ? finish_task_switch+0x83/0x140
[  901.190616]  [<ffffffff8024c240>] ? finish_task_switch+0x40/0x140
[  901.190625]  [<ffffffff80288558>] ? __lock_acquire+0x328/0x13e0
[  901.190634]  [<ffffffff8047ac0e>] ? _raw_spin_unlock+0x7e/0xa0
[  901.190642]  [<ffffffff8027cf51>] ? getnstimeofday+0x61/0xf0
[  901.190649]  [<ffffffff80276e51>] ? ktime_get_ts+0x61/0x70
[  901.190656]  [<ffffffff803289e8>] ? poll_select_set_timeout+0x88/0xa0
[  901.190663]  [<ffffffff80329a7c>] ? sys_poll+0x7c/0x110
[  901.190670]  [<ffffffff80213232>] ? system_call_fastpath+0x16/0x1b
[  901.190675] handlers:
[  901.190679] [<ffffffff8059f7d0>] (usb_hcd_irq+0x0/0xe0)
[  901.190690] [<ffffffff8059f7d0>] (usb_hcd_irq+0x0/0xe0)
[  901.190699] [<ffffffffa00228d0>] (tifm_7xx1_isr+0x0/0x170 [tifm_7xx1])
[  901.190710] Disabling IRQ #18
[  901.288126]
[  901.288128] =================================
[  901.288132] [ INFO: inconsistent lock state ]
[  901.288135] 2.6.30-rc1 #21
[  901.288137] ---------------------------------
[  901.288140] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[  901.288143] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[  901.288145]  (&irq_desc_lock_class){?.-...}, at: [<ffffffff802bbbc3>] try_one_irq+0x33/0x160
[  901.288156] {IN-HARDIRQ-W} state was registered at:
[  901.288158]   [<ffffffffffffffff>] 0xffffffffffffffff
[  901.288172] irq event stamp: 970106
[  901.288174] hardirqs last  enabled at (970106): [<ffffffff80747e00>] _spin_unlock_irq+0x30/0x70
[  901.288181] hardirqs last disabled at (970105): [<ffffffff807474cf>] _spin_lock_irq+0x1f/0x90
[  901.288186] softirqs last  enabled at (970078): [<ffffffff8025f0e4>] __do_softirq+0x1d4/0x250
[  901.288193] softirqs last disabled at (970103): [<ffffffff802144fc>] call_softirq+0x1c/0x30

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/misc/tifm_7xx1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index a6ef182..b38ee02 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -41,11 +41,12 @@ static irqreturn_t tifm_7xx1_isr(int irq, void *dev_id)
 	struct tifm_adapter *fm = dev_id;
 	struct tifm_dev *sock;
 	unsigned int irq_status, cnt;
+	unsigned long flags;
 
-	spin_lock(&fm->lock);
+	spin_lock_irqsave(&fm->lock, flags);
 	irq_status = readl(fm->addr + FM_INTERRUPT_STATUS);
 	if (irq_status == 0 || irq_status == (~0)) {
-		spin_unlock(&fm->lock);
+		spin_unlock_irqrestore(&fm->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -74,7 +75,7 @@ static irqreturn_t tifm_7xx1_isr(int irq, void *dev_id)
 	else
 		tifm_queue_work(&fm->media_switcher);
 
-	spin_unlock(&fm->lock);
+	spin_unlock_irqrestore(&fm->lock, flags);
 	return IRQ_HANDLED;
 }
 
-- 
1.6.0.4

