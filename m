Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZIXCDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZIXCDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 22:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZIXCDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 22:03:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:47694 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZIXCDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 22:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xnR/pt5Uuh7+JZXkNdMO/3/NDB0eRsIzaSZPeyUV1BmCnQ6ltqXVRh4k+/IAFX0Up0
         M+PDExnKHjUX1VIb/enyHFe+Wb00z1rf+lKViayHxyaD7dqBEF9EaTDzHufPcPDrrWla
         12RW4XxeFXuUAJU3EVy7bj8E8QqWSHke5fZXk=
MIME-Version: 1.0
In-Reply-To: <505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
References: <505766fa0909222137q217be3d0x8fc12ab467833666@mail.gmail.com>
	 <505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
Date: Thu, 24 Sep 2009 10:03:25 +0800
Message-ID: <505766fa0909231903t2fe2f7b6y26d2681d6d38ef0e@mail.gmail.com>
Subject: Re: Linux guest domain with two vnets bound to the same vswitch 
	experiences hung in bootup (sun_netraT5220)
From: hyl <heyongli@gmail.com>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57b549e5e4dfc8b34d66bbad7f4297a1bc81a43d Mon Sep 17 00:00:00 2001
From: Yongli He <heyongli@gmail.com>
Date: Thu, 24 Sep 2009 10:00:04 +0800
Subject: [PATCH] Sun ldom vnet driver dead lock

if 2 vnet attach to same vswitch, ldom will report
2 same irq then lead to dead lock on the lp->lock
or the vio->lock

static irqreturn_t ldc_rx(int irq, void *dev_id){
...
out:
	spin_unlock_irqrestore(&lp->lock, flags);
           << here run with out any lock
	send_events(lp, event_mask);
           >> vnet evetn process will dead lock on
           >> lp->lock or the vio->lock

Signed-off-by: Yongli He <heyongli@gmail.com>
---
 arch/sparc/include/asm/ldc.h |    1 +
 arch/sparc64/kernel/ldc.c    |    4 ++++
 drivers/net/sunvnet.c        |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/ldc.h b/arch/sparc/include/asm/ldc.h
index bdb524a..dd2b30f 100644
--- a/arch/sparc/include/asm/ldc.h
+++ b/arch/sparc/include/asm/ldc.h
@@ -20,6 +20,7 @@ extern void ldom_power_off(void);
  */
 struct ldc_channel_config {
 	void (*event)(void *arg, int event);
+	spinlock_t *serial_lock;

 	u32			mtu;
 	unsigned int		rx_irq;
diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
index a6b75cd..72b9501 100644
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -892,9 +892,13 @@ handshake_complete:
 	}

 out:
+	if(lp->cfg.serial_lock)
+		spin_lock_irqsave(lp->cfg.serial_lock, flags);
 	spin_unlock_irqrestore(&lp->lock, flags);

 	send_events(lp, event_mask);
+	if(lp->cfg.serial_lock)
+        	spin_unlock_irqrestore(lp->cfg.serial_lock, flags);

 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index 6415ce1..e58f9da 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1117,11 +1117,13 @@ static struct vnet * __devinit
vnet_find_parent(struct mdesc_handle *hp,

 	return vnet_find_or_create(local_mac);
 }
+static spinlock_t event_lock=__SPIN_LOCK_UNLOCKED("vnet_event");

 static struct ldc_channel_config vnet_ldc_cfg = {
 	.event		= vnet_event,
 	.mtu		= 64,
 	.mode		= LDC_MODE_UNRELIABLE,
+	.serial_lock	= &event_lock,
 };

 static struct vio_driver_ops vnet_vio_ops = {
-- 
1.5.5.1.dirty
