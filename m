Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZGRPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZGRPZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZGRPZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:25:38 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50631 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZGRPZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:25:33 -0400
Date: Sat, 18 Jul 2009 17:25:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] drivers/staging: convert nested spin_lock_irqsave to
 spin_lock
Message-ID: <Pine.LNX.4.64.0907181724550.26792@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/meilhaus/me4600_ai.c           |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/meilhaus/me4600_ai.c b/drivers/staging/meilhaus/me4600_ai.c
index e496d0c..fd9daa9 100644
--- a/drivers/staging/meilhaus/me4600_ai.c
+++ b/drivers/staging/meilhaus/me4600_ai.c
@@ -760,7 +760,7 @@ static int me4600_ai_io_single_read(me_subdevice_t *subdevice,
 	// Mark that StreamConfig is removed.
 	instance->chan_list_len = 0;
 
-	spin_lock_irqsave(instance->ctrl_reg_lock, cpu_flags);
+	spin_lock(instance->ctrl_reg_lock);
 	/// @note Imprtant: Preserve EXT IRQ settings.
 	tmp = inl(instance->ctrl_reg);
 	// Clear FIFOs and dissable interrupts
@@ -824,7 +824,7 @@ static int me4600_ai_io_single_read(me_subdevice_t *subdevice,
 		   instance->ctrl_reg - instance->reg_base,
 		   instance->single_config[channel].ctrl | tmp);
 
-	spin_unlock_irqrestore(instance->ctrl_reg_lock, cpu_flags);
+	spin_unlock(instance->ctrl_reg_lock);
 
 	if (!(instance->single_config[channel].ctrl & ME4600_AI_CTRL_BIT_EX_TRIG)) {	// Software start
 		inl(instance->start_reg);
@@ -877,7 +877,7 @@ static int me4600_ai_io_single_read(me_subdevice_t *subdevice,
 	}
 
 	// Restore settings.
-	spin_lock_irqsave(instance->ctrl_reg_lock, cpu_flags);
+	spin_lock(instance->ctrl_reg_lock);
 	tmp = inl(instance->ctrl_reg);
 	// Clear FIFOs and dissable interrupts.
 	tmp &=
@@ -889,7 +889,7 @@ static int me4600_ai_io_single_read(me_subdevice_t *subdevice,
 	outl(tmp, instance->ctrl_reg);
 	PDEBUG_REG("ctrl_reg outl(0x%lX+0x%lX)=0x%x\n", instance->reg_base,
 		   instance->ctrl_reg - instance->reg_base, tmp);
-	spin_unlock_irqrestore(instance->ctrl_reg_lock, cpu_flags);
+	spin_unlock(instance->ctrl_reg_lock);
 
 	spin_unlock_irqrestore(&instance->subdevice_lock, cpu_flags);
 
@@ -1268,7 +1268,7 @@ static int me4600_ai_io_stream_config(me_subdevice_t *subdevice,
 	}
 
 	instance->status = ai_status_none;
-	spin_lock_irqsave(instance->ctrl_reg_lock, cpu_flags);
+	spin_lock(instance->ctrl_reg_lock);
 	// Stop all actions. Block all interrupts. Clear (disable) FIFOs.
 	ctrl =
 	    ME4600_AI_CTRL_BIT_LE_IRQ_RESET | ME4600_AI_CTRL_BIT_HF_IRQ_RESET |
@@ -1290,7 +1290,7 @@ static int me4600_ai_io_stream_config(me_subdevice_t *subdevice,
 	outl(tmp | ctrl, instance->ctrl_reg);
 	PDEBUG_REG("ctrl_reg outl(0x%lX+0x%lX)=0x%x\n", instance->reg_base,
 		   instance->ctrl_reg - instance->reg_base, tmp | ctrl);
-	spin_unlock_irqrestore(instance->ctrl_reg_lock, cpu_flags);
+	spin_unlock(instance->ctrl_reg_lock);
 
 	// Write the channel list
 	for (i = 0; i < count; i++) {
@@ -1529,7 +1529,7 @@ static int me4600_ai_io_stream_config(me_subdevice_t *subdevice,
 	ctrl |= (ME4600_AI_CTRL_BIT_HF_IRQ | ME4600_AI_CTRL_BIT_SC_IRQ | ME4600_AI_CTRL_BIT_LE_IRQ);	//The last IRQ source (ME4600_AI_CTRL_BIT_LE_IRQ) is unused!
 
 	//Everything is good. Finalize
-	spin_lock_irqsave(instance->ctrl_reg_lock, cpu_flags);
+	spin_lock(instance->ctrl_reg_lock);
 	tmp = inl(instance->ctrl_reg);
 
 	//Preserve EXT IRQ and OFFSET settings. Clean other bits.
@@ -1541,7 +1541,7 @@ static int me4600_ai_io_stream_config(me_subdevice_t *subdevice,
 	outl(ctrl | tmp, instance->ctrl_reg);
 	PDEBUG_REG("ctrl_reg outl(0x%lX+0x%lX)=0x%x\n", instance->reg_base,
 		   instance->ctrl_reg - instance->reg_base, ctrl | tmp);
-	spin_unlock_irqrestore(instance->ctrl_reg_lock, cpu_flags);
+	spin_unlock(instance->ctrl_reg_lock);
 
 	//Set the global parameters end exit.
 	instance->chan_list_len = count;
