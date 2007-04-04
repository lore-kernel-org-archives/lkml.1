Return-Path: <linux-kernel-owner+w=401wt.eu-S966252AbXDDBla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966252AbXDDBla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966253AbXDDBla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:41:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5507 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966252AbXDDBl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:41:29 -0400
Subject: Re: real time hang w/ latency tracing
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175626625.10738.21.camel@imap.mvista.com>
References: <1175626625.10738.21.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 18:41:27 -0700
Message-Id: <1175650887.3722.2.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 11:57 -0700, Daniel Walker wrote:
> With 2.6.21-rc5-rt8 / i386 . If I disable wakeup timing , and enable
> interrupt off timing with latency tracing I can cause,
> 
> BUG: scheduling with irqs disabled: IRQ-16/0x00000000/909
> caller is rt_spin_lock_slowlock+0x94/0x190
>  [<c010577a>] show_trace_log_lvl+0x3a/0x60
>  [<c0105fdd>] show_trace+0x2d/0x30
>  [<c01060c7>] dump_stack+0x27/0x30
>  [<c03f52db>] schedule+0x12b/0x130
>  [<c03f6314>] rt_spin_lock_slowlock+0x94/0x190
>  [<c03f6b35>] rt_spin_lock+0x25/0x30
>  [<c02f19bf>] serial8250_console_write+0x16f/0x190
>  [<c012b3aa>] __call_console_drivers+0x7a/0xa0
>  [<c012b427>] _call_console_drivers+0x57/0xa0
>  [<c012b58d>] release_console_sem+0xdd/0x1e0
>  [<c012bd46>] vprintk+0x226/0x3b0
>  [<c012bef0>] printk+0x20/0x30
>  [<c0158d29>] print_traces+0x49/0x100
>  [<c0105792>] show_trace_log_lvl+0x52/0x60
>  [<c0105fdd>] show_trace+0x2d/0x30
>  [<c01060c7>] dump_stack+0x27/0x30
>  [<c0158481>] check_critical_timing+0x2b1/0x380
>  [<c01585f6>] trace_hardirqs_on+0xa6/0xc0
>  [<c01046e5>] restore_nocheck+0x12/0x15

This allows the system to continue printing ..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/serial_core.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.20/include/linux/serial_core.h
===================================================================
--- linux-2.6.20.orig/include/linux/serial_core.h
+++ linux-2.6.20/include/linux/serial_core.h
@@ -213,7 +213,11 @@ struct uart_icount {
 typedef unsigned int __bitwise__ upf_t;
 
 struct uart_port {
+#ifdef CONFIG_LATENCY_TIMING
+	raw_spinlock_t		lock;			/* port lock */
+#else
 	spinlock_t		lock;			/* port lock */
+#endif
 	unsigned int		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		irq;			/* irq number */


