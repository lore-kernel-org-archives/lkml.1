Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbXGLMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbXGLMp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbXGLMpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:45:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXGLMpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:45:15 -0400
Date: Thu, 12 Jul 2007 14:45:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Ivo van Doorn <IvDoorn@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, "David S. Miller" <davem@davemloft.net>
Subject: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit
	systems
Message-ID: <20070712124503.GA16633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit systems

this recent commit:

 commit cf4328cd949c2086091c62c5685f1580fe9b55e4
 Author: Ivo van Doorn <IvDoorn@gmail.com>
 Date:   Mon May 7 00:34:20 2007 -0700

     [NET]: rfkill: add support for input key to control wireless radio

added this 64-bit bug:

        ....
	unsigned int flags;
 
 	spin_lock_irqsave(&task->lock, flags);
        ....

irq 'flags' must be unsigned long, not unsigned int. The -rt tree has 
strict checks about this on 64-bit so this triggered a build failure. 

For -stable too i suspect.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux-rt.q/net/rfkill/rfkill-input.c
===================================================================
--- linux-rt.q.orig/net/rfkill/rfkill-input.c
+++ linux-rt.q/net/rfkill/rfkill-input.c
@@ -55,7 +55,7 @@ static void rfkill_task_handler(struct w
 
 static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
-	unsigned int flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&task->lock, flags);
 
