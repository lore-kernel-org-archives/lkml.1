Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYKXBCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYKXBCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 20:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYKXBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 20:01:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:43818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYKXBBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 20:01:52 -0500
Date: Sun, 23 Nov 2008 17:02:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, anssi.hannula@gmail.com,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: [PATCH] input: replace spin_lock_bh with spin_lock_irqsave in
 ml_ff_playback
Message-ID: <20081123170247.311f4b8f@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 829678fc4684defcef2139182e88a304acdfa0ad Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 23 Nov 2008 16:57:36 -0800
Subject: [PATCH] input: replace spin_lock_bh with spin_lock_irqsave in ml_ff_playback

ml_ff_playback() uses spin_(un)lock_bh. However this function is called
with interrupts disabled from erase_effect() in drivers/input/ff-core.c:196.

This is not permitted, and will result in a WARN_ON in the bottom half handling code.
This patch changes this function to just use spin_lock_irqsave() instead, solving
the problem and simplifying the locking logic.

This was reported as entry #106559 in kerneloops.org

Reported-by: kerneloops.org
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/input/ff-memless.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 6790e97..bc4e40f 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -397,8 +397,9 @@ static int ml_ff_playback(struct input_dev *dev, int effect_id, int value)
 {
 	struct ml_device *ml = dev->ff->private;
 	struct ml_effect_state *state = &ml->states[effect_id];
+	unsigned long flags;
 
-	spin_lock_bh(&ml->timer_lock);
+	spin_lock_irqsave(&ml->timer_lock, flags);
 
 	if (value > 0) {
 		debug("initiated play");
@@ -424,7 +425,7 @@ static int ml_ff_playback(struct input_dev *dev, int effect_id, int value)
 		ml_play_effects(ml);
 	}
 
-	spin_unlock_bh(&ml->timer_lock);
+	spin_unlock_irqrestore(&ml->timer_lock, flags);
 
 	return 0;
 }
-- 
1.6.0.3


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
