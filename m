Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbXDWUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbXDWUcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXDWUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:32:39 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42675 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXDWUcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:32:39 -0400
Date: Mon, 23 Apr 2007 22:32:24 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alex Williamson <alex.williamson@hp.com>
Subject: Re: serial8250 lockdep report from 2.6.21-rc7
In-Reply-To: <20070423170742.GA9823@redhat.com>
Message-ID: <Pine.LNX.4.64.0704232219570.20657@twin.jikos.cz>
References: <20070423170742.GA9823@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Dave Jones wrote:

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.20-1.3094.fc7 #1
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&port_lock_key){++..}, at: [<c0558f96>] serial8250_interrupt+0x4a/0xe0
> {hardirq-on-W} state was registered at:
>   [<c044021d>] __lock_acquire+0x448/0xba9
>   [<c0440d70>] lock_acquire+0x56/0x6f
>   [<c060ffd1>] _spin_lock+0x2b/0x38
>   [<c055893b>] serial8250_backup_timeout+0x6d/0xe8
>   [<c042c972>] run_timer_softirq+0x121/0x189
>   [<c0429dfb>] __do_softirq+0x6f/0xe2
>   [<c0407a64>] do_softirq+0x61/0xd0
>   [<ffffffff>] 0xffffffff
> irq event stamp: 332718
> hardirqs last  enabled at (332717): [<c0403dde>] default_idle+0x3e/0x59
> hardirqs last disabled at (332718): [<c0406054>] common_interrupt+0x24/0x40
> softirqs last  enabled at (332708): [<c0429e68>] __do_softirq+0xdc/0xe2
> softirqs last disabled at (332691): [<c0407a64>] do_softirq+0x61/0xd0

Hi Dave,

I guess the one below fixes this one, right?

(BTW the overall locking of port.lock in 8250.c looks a bit suspicious, it 
might probably be deadlockable on other places too, I will look at it more 
thoroughly soon, if noone beats me with it)



From: Jiri Kosina <jkosina@suse.cz>

8250: fix possible deadlock between serial8250_handle_port() and serial8250_interrupt()
    
Commit 40b36daa introduced possibility that serial8250_backup_timeout() -> 
serial8250_handle_port() locks port.lock without disabling irqs, thus 
allowing deadlock against interrupt handler (port.lock is acquired in 
serial8250_interrupt()).
    
Spotted by lockdep.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c129a0e..fda99d1 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1333,8 +1333,9 @@ static inline void
 serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
+	unsigned long flags;
 
-	spin_lock(&up->port.lock);
+	spin_lock_irqsave(&up->port.lock, flags);
 
 	status = serial_inp(up, UART_LSR);
 
@@ -1346,7 +1347,7 @@ serial8250_handle_port(struct uart_8250_port *up)
 	if (status & UART_LSR_THRE)
 		transmit_chars(up);
 
-	spin_unlock(&up->port.lock);
+	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 /*
