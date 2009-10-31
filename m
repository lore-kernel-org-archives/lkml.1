Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbZJaVSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbZJaVSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbZJaVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:18:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:58463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249AbZJaVSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:18:11 -0400
Date: Sat, 31 Oct 2009 14:19:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-input@vger.kernel.org
Subject: [PATCH] input: fix locking context in ml_ff_set_gain
Message-ID: <20091031141925.149c9874@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 177c4e7a84c40925605d485f6d5367deb44a84c8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 31 Oct 2009 14:13:40 -0700
Subject: [PATCH] input: fix locking context in ml_ff_set_gain

the ml_ff_set_gain() function uses spin_lock_bh/spin_unlock_bh
for locking. Unfortunately, this function can be called with irqs
off:
vfs_write ->
evdev_write ->
input_inject_event (disables interrupts) ->
input_handle_event ->
input_ff_event ->
ml_ff_set_gain

and doing spin_unlock_bh() with interrupts off is not allowed
(and causes a nice warning as a result).

This patch fixes this by turning the locking into the _irqsave variant.

Reported-by: kerneloops.org 
Reported-by: http://www.kerneloops.org/searchweek.php?search=ml_ff_set_gain
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/input/ff-memless.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 2d1415e..1a0bb4f 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -380,8 +380,9 @@ static void ml_ff_set_gain(struct input_dev *dev, u16 gain)
 {
 	struct ml_device *ml = dev->ff->private;
 	int i;
+	unsigned long flags;
 
-	spin_lock_bh(&ml->timer_lock);
+	spin_lock_irqsave(&ml->timer_lock, flags);
 
 	ml->gain = gain;
 
@@ -390,7 +391,7 @@ static void ml_ff_set_gain(struct input_dev *dev, u16 gain)
 
 	ml_play_effects(ml);
 
-	spin_unlock_bh(&ml->timer_lock);
+	spin_unlock_irqrestore(&ml->timer_lock, flags);
 }
 
 static int ml_ff_playback(struct input_dev *dev, int effect_id, int value)
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
