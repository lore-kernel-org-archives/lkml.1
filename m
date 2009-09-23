Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbZIWJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbZIWJoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZIWJn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:43:59 -0400
Received: from mail-qy0-f188.google.com ([209.85.221.188]:34014 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZIWJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:43:58 -0400
X-Greylist: delayed 7420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 05:43:57 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=s1j+ZSd3oUIb96v8uLfHYSPlIo8hwACitdoMQSoLXDAmt8plEHjFoVwkupa13qlvqC
         9Q663Di4DpqLbIRyyDc4FbkU+w5Uy/5oqEXRtgF9PK1lIFpS+JkipM+ofcnnHChDP2fD
         Rda7qSmUTQkP3HJVMQaXYTwSxOmrg4owrawt0=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 17:44:01 +0800
Message-ID: <505766fa0909230244r3737379s1748a8f7c181f366@mail.gmail.com>
Subject: Re: Linux guest domain with two vnets , the dirty quick fix
From: hyl <heyongli@gmail.com>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. add the debug code:
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -540,6 +540,11 @@ static void vnet_event(void *arg, int event)
                }
                if (err == 0)
                        break;
+                {
+                  long stackdiff;
+                 viodbg(DATA, "** vio:%llx, vio->lp:%llx, stack:%llx\n",
+                                   &vio,     &vio->lp,     &stackdiff);
+                }
                viodbg(DATA, "TAG [%02x:%02x:%04x:%08x]\n",
                       msgbuf.tag.type,
                       msgbuf.tag.stype,

2. the output
from the below output, we see a re-enter to  vnet_event happend. the
vio-hardwre report 2 interrupt
for same packet/or msg( why?)

vio: ID[0] vnet_walk_rx start[00000009] end[00000008]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:842800:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:845000:800]
vio: ID[0] ** vio:fffff8003f9cafa8, vio->lp:fffff8003ebf0008,
stack:fffff8003f9cafa0  << same ldc vio
vio: ID[0] ** vio:fffff8003f9cafa8, vio->lp:fffff8003ebf0008,
stack:fffff8003f9ccc     << with diffrent run stack
afa0
vio: ID[0] TAG [02:01:0042:0d4becc7]
vio: ID[0] TAG [02:01:0042:0d4becc7]
...........
vio: ID[0] vnet_walk_rx start[0000000a] end[00000009]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:845000:800]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:845000:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:847800:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:847800:800]
vio: ID[0] ** vio:fffff8003f9cb588, vio->lp:fffff8003ebf0008,
stack:fffff8003f9cb580
vio: ID[0] ** vio:fffff8003f9cb588, vio->lp:fffff8003ebf0008,
stack:fffff8003f9ccc


3. where need protection
the reason is :
static irqreturn_t ldc_rx(int irq, void *dev_id){

out:
	spin_unlock_irqrestore(&lp->lock, flags);
                                                                  <<
here run with out any lock
	send_events(lp, event_mask);

4. the dirty fix, welcome fain grained lock implementation suggestion:

>From f24f76cc7b9bba04fcbe0406d8a1ada959c0bc4a Mon Sep 17 00:00:00 2001
From: Yongli He <yongli.he@windriver.com>
Date: Wed, 23 Sep 2009 17:42:16 +0800
Subject: [PATCH] Sun ldom vnet driver dead lock

static irqreturn_t ldc_rx(int irq, void *dev_id){
...
out:
	spin_unlock_irqrestore(&lp->lock, flags);
                     << here run with out any lock
	send_events(lp, event_mask);
       //if 2 vnet attach to same vswitch, ldom
       //will report 2 irq then lead to dead lock
       //on the vio->lock or lp->lock
}

this version fix just serialize all the event.

Signed-off-by: Yongli He <heyongli@gmail.com>
---
 arch/sparc64/kernel/ldc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
index a6b75cd..8d7c9b5 100644
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -785,6 +785,8 @@ static void send_events(struct ldc_channel *lp,
unsigned int event_mask)
 		lp->cfg.event(lp->event_arg, LDC_EVENT_DATA_READY);
 }

+static spinlock_t event_lock=__SPIN_LOCK_UNLOCKED("ldc_event lock");
+
 static irqreturn_t ldc_rx(int irq, void *dev_id)
 {
 	struct ldc_channel *lp = dev_id;
@@ -892,9 +894,10 @@ handshake_complete:
 	}

 out:
+	spin_lock_irqsave(&event_lock, flags);//serialize all events
 	spin_unlock_irqrestore(&lp->lock, flags);
-
 	send_events(lp, event_mask);
+        spin_unlock_irqrestore(&event_lock, flags);

 	return IRQ_HANDLED;
 }
-- 
1.5.5.1.dirty




2009/9/23 hyl <heyongli@gmail.com>:
> console output:
>
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> sunvnet.c:v1.0 (June 25, 2007)
> sunvnet.c:v1.0 (June 25, 2007)
> eth0: Sun LDOM vnet 00:14:4f:f9:68:e0:t
> e0
> eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
> eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
> eth1: Sun LDOM vnet 00:14:4f:f8:c5:7b:t
> 7b
> eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
> eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
>
> two vnets bound to the same vswitch, then hang,
> ldm add-vnet vnet0 primary-vsw1 dom1
> ldm add-vnet vnet1 primary-vsw1 ldom1
>
> If 'eth1' and 'eth2' are bound to different vswitches, everything is fine.
>
>
> Yongli He
>
