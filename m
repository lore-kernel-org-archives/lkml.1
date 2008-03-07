Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYCGKId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYCGKId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYCGKIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:08:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYCGKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:08:23 -0500
Date: Fri, 7 Mar 2008 11:08:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] drivers/char/esp.c: fix bootup lockup (was: Re: Linux
	2.6.25-rc4)
Message-ID: <20080307100806.GA4350@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


randconfig testing found a bootup lockup in drivers/char/esp.c - find 
the fix below. Not sure why it became more prominent in 2.6.25-rc4, the 
bug seems rather old and i've been doing allyesconfig bootups for ages 
with CONFIG_ESP enabled.

------------->
Subject: drivers/char/esp.c: fix bootup lockup
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 07 10:47:43 CET 2008

fix this bootup lockup:

 PM: Adding info for No Bus:ttyP63
 ttyP32 at 0x0240 (irq = 0) is an ESP primary port
 BUG: spinlock lockup on CPU#0, swapper/1, f56dd004
 Pid: 1, comm: swapper Not tainted 2.6.25-rc4-sched-devel.git-x86-latest.git #402 [<c03ac6f4>] _raw_spin_lock+0x134/0x140
  [<c08649be>] _spin_lock_irqsave+0x5e/0x80
  [<c0b9fbfe>] ? espserial_init+0x2be/0x6e0
  [<c0b9fbfe>] espserial_init+0x2be/0x6e0
  [<c0b877a3>] kernel_init+0x83/0x260
  [<c0b9f940>] ? espserial_init+0x0/0x6e0
  [<c010416a>] ? restore_nocheck_notrace+0x0/0xe
  [<c0b87720>] ? kernel_init+0x0/0x260
  [<c0b87720>] ? kernel_init+0x0/0x260
  [<c0104507>] kernel_thread_helper+0x7/0x10
  =======================

kzalloc() is not the way to initialize spinlocks anymore.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/esp.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/char/esp.c
===================================================================
--- linux.orig/drivers/char/esp.c
+++ linux/drivers/char/esp.c
@@ -2484,6 +2484,7 @@ static int __init espserial_init(void)
 			return 0;
 		}
 
+		spin_lock_init(&info->lock);
 		/* rx_trigger, tx_trigger are needed by autoconfig */
 		info->config.rx_trigger = rx_trigger;
 		info->config.tx_trigger = tx_trigger;
