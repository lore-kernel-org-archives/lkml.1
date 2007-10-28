Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXJ1MYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXJ1MYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 08:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJ1MY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 08:24:28 -0400
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:25930 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751260AbXJ1MY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 08:24:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=clut6TOXyLbcKi3oPoUNgrxZM8oXGz30kkx1xr8fgnKqqUCgJKPlR93afPvQXFaa+qCtf9iCNshLE2Z1ysk7TGR/xp8dl15k4UEOs6qvbHm6yLq1favzuGik34kJiNiQ7+2qRNaEJ8CISw5Y4aYdhfTwqpvMSvyQMpjyFsA97Eo=  ;
X-YMail-OSG: v6Xo3vsVM1m.JG2wLkpQMxSkNpd6AQCdfo_d89_WdwtMI5BG3itUpMFmvPdnBRx46d4lTOmLw7IoSCdm1MDq8OTQHb2oT51heJl5hYvMqtn4T5I7cQ--
Date: Sun, 28 Oct 2007 13:24:16 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usbserial: fix inconsistent lock state
Message-ID: <20071028122416.GA11679@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i get

Oct 28 12:50:53 zmei kernel: [ 6656.113371] =================================
Oct 28 12:50:53 zmei kernel: [ 6656.113378] [ INFO: inconsistent lock state ]
Oct 28 12:50:53 zmei kernel: [ 6656.113382] 2.6.24-rc1 #13
Oct 28 12:50:53 zmei kernel: [ 6656.113384] ---------------------------------
Oct 28 12:50:53 zmei kernel: [ 6656.113387] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
Oct 28 12:50:53 zmei kernel: [ 6656.113392] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
Oct 28 12:50:53 zmei kernel: [ 6656.113395]  (&port->lock){+...}, at: [<e09f0658>] usb_serial_generic_read_bulk_callback+0xee/0x14c [usbserial]
Oct 28 12:50:53 zmei kernel: [ 6656.113413] {hardirq-on-W} state was registered at:
Oct 28 12:50:53 zmei kernel: [ 6656.113416]   [<c014220e>] __lock_acquire+0x44d/0xbdd
Oct 28 12:50:53 zmei kernel: [ 6656.113427]   [<c0142d81>] lock_acquire+0x5f/0x78
Oct 28 12:50:53 zmei kernel: [ 6656.113433]   [<c02f92be>] _spin_lock_bh+0x3a/0x47
Oct 28 12:50:53 zmei kernel: [ 6656.113441]   [<e09f08c0>] usb_serial_generic_write+0x8a/0x252 [usbserial]
Oct 28 12:50:53 zmei kernel: [ 6656.113452]   [<e09ee5e2>] serial_write+0xa3/0xb2 [usbserial]
Oct 28 12:50:53 zmei kernel: [ 6656.113462]   [<c021a6a0>] write_chan+0x1e4/0x2ac
Oct 28 12:50:53 zmei kernel: [ 6656.113471]   [<c02182f4>] tty_write+0x13e/0x1ba
Oct 28 12:50:53 zmei kernel: [ 6656.113478]   [<c016e466>] vfs_write+0xa8/0x131
Oct 28 12:50:53 zmei kernel: [ 6656.113486]   [<c016ea06>] sys_write+0x3d/0x61
Oct 28 12:50:53 zmei kernel: [ 6656.113493]   [<c010411a>] syscall_call+0x7/0xb
Oct 28 12:50:53 zmei kernel: [ 6656.113500]   [<ffffffff>] 0xffffffff
Oct 28 12:50:53 zmei kernel: [ 6656.113510] irq event stamp: 68037894
Oct 28 12:50:53 zmei kernel: [ 6656.113513] hardirqs last  enabled at (68037893): [<c0102b1f>] default_idle+0x3e/0x59
Oct 28 12:50:53 zmei kernel: [ 6656.113520] hardirqs last disabled at (68037894): [<c0104b20>] common_interrupt+0x24/0x34
Oct 28 12:50:53 zmei kernel: [ 6656.113526] softirqs last  enabled at (68037884): [<c012a56e>] __do_softirq+0xe5/0xed
Oct 28 12:50:53 zmei kernel: [ 6656.113535] softirqs last disabled at (68037873): [<c012a5af>] do_softirq+0x39/0x55
Oct 28 12:50:53 zmei kernel: [ 6656.113542] 
Oct 28 12:50:53 zmei kernel: [ 6656.113543] other info that might help us debug this:
Oct 28 12:50:53 zmei kernel: [ 6656.113546] no locks held by swapper/0.
Oct 28 12:50:53 zmei kernel: [ 6656.113548] 
Oct 28 12:50:53 zmei kernel: [ 6656.113549] stack backtrace:
Oct 28 12:50:53 zmei kernel: [ 6656.113553]  [<c010515b>] show_trace_log_lvl+0x1a/0x2f
Oct 28 12:50:53 zmei kernel: [ 6656.113559]  [<c0105b4d>] show_trace+0x12/0x14
Oct 28 12:50:53 zmei kernel: [ 6656.113566]  [<c0105c6d>] dump_stack+0x16/0x18
Oct 28 12:50:53 zmei kernel: [ 6656.113571]  [<c0140de6>] print_usage_bug+0x143/0x14d
Oct 28 12:50:53 zmei kernel: [ 6656.113576]  [<c01413cc>] mark_lock+0xc5/0x46a
Oct 28 12:50:53 zmei kernel: [ 6656.113580]  [<c01421a1>] __lock_acquire+0x3e0/0xbdd
Oct 28 12:50:53 zmei kernel: [ 6656.113585]  [<c0142d81>] lock_acquire+0x5f/0x78
Oct 28 12:50:53 zmei kernel: [ 6656.113590]  [<c02f9277>] _spin_lock+0x35/0x42
Oct 28 12:50:53 zmei kernel: [ 6656.113594]  [<e09f0658>] usb_serial_generic_read_bulk_callback+0xee/0x14c [usbserial]
Oct 28 12:50:53 zmei kernel: [ 6656.113603]  [<c024f161>] usb_hcd_giveback_urb+0x61/0x93
Oct 28 12:50:53 zmei kernel: [ 6656.113609]  [<e0846902>] ehci_urb_done+0x7d/0x8a [ehci_hcd]
Oct 28 12:50:53 zmei kernel: [ 6656.113617]  [<e0847897>] qh_completions+0x3fb/0x499 [ehci_hcd]
Oct 28 12:50:53 zmei kernel: [ 6656.113624]  [<e08479f6>] ehci_work+0xc1/0x6c7 [ehci_hcd]
Oct 28 12:50:53 zmei kernel: [ 6656.113630]  [<e084c0c9>] ehci_irq+0x24d/0x275 [ehci_hcd]
Oct 28 12:50:53 zmei kernel: [ 6656.113637]  [<c024fa75>] usb_hcd_irq+0x4f/0x58
Oct 28 12:50:53 zmei kernel: [ 6656.113641]  [<c014e459>] handle_IRQ_event+0x1a/0x46
Oct 28 12:50:53 zmei kernel: [ 6656.113648]  [<c014f53c>] handle_fasteoi_irq+0xab/0xb8
Oct 28 12:50:53 zmei kernel: [ 6656.113653]  [<c0106a9e>] do_IRQ+0x7c/0x96
Oct 28 12:50:53 zmei kernel: [ 6656.113657]  [<c0104b2a>] common_interrupt+0x2e/0x34
Oct 28 12:50:53 zmei kernel: [ 6656.113662]  [<c01025b3>] cpu_idle+0x9e/0xd3
Oct 28 12:50:53 zmei kernel: [ 6656.113666]  [<c02f6ea9>] rest_init+0x5d/0x5f
Oct 28 12:50:53 zmei kernel: [ 6656.113672]  [<c041393a>] start_kernel+0x2e3/0x2eb
Oct 28 12:50:53 zmei kernel: [ 6656.113679]  [<00000000>] 0x0
Oct 28 12:50:53 zmei kernel: [ 6656.113683]  =======================
<snip>

when inserting my UTMS usb modem and the following patch fixes it:

---
In commit acd2a847e7fee7df11817f67dba75a2802793e5d usb_serial_generic_write()
disables interrupts when taking &port->lock which is also taken in
usb_serial_generic_read_bulk_callback() resulting in an inconsistent lock state
due to the latter not disabling interrupts on the local cpu. Fix that by
disabling interrupts in the latter call site also.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 9eb4a65..d415311 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -327,6 +327,7 @@ void usb_serial_generic_read_bulk_callback (struct urb *urb)
 	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
@@ -339,11 +340,11 @@ void usb_serial_generic_read_bulk_callback (struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev, __FUNCTION__, urb->actual_length, data);
 
 	/* Throttle the device if requested by tty */
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 	if (!(port->throttled = port->throttle_req))
 		/* Handle data and continue reading from device */
 		flush_and_resubmit_read_urb(port);
-	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
-- 
Regards/Gruﬂ,
    Boris.
