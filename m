Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYBNSFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYBNSFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYBNSEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:04:54 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35828 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYBNSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:04:53 -0500
Message-ID: <47B482B4.9010208@davidnewall.com>
Date: Fri, 15 Feb 2008 04:34:36 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com>	<20080214050211.GB1432@kroah.com>	<47B40918.20206@davidnewall.com> <20080214121026.16a9c510@core>
In-Reply-To: <20080214121026.16a9c510@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
>> a race: An in-flight write URB can fill all hardware buffers, making
>> unsafe what previously appeared to be a safe write.  I think it's
>> essential to delay submission of the URB on a stop-transmit condition.
>>     
>
> Hardware flow control *is* a race, and always will be. The remote end has
> a delay in signalling 'stop' there is a propogation delay and a response
> delay. This is why most implementations assert stop a bit *before* they
> run out.
>   

That's a very good point.  Even so: on the 2.4 driver, write_room isn't
implemented (refer to a previous message by Alan); and in 2.6, a 1k
buffer is built into the driver, with nothing to prevent it being sent
when the hardware buffer fills.  These could be bugs in the two versions
of pl2303, if you like; in fact I suppose they are; but there's a wider
problem: The same weakness can be found in aircable.c, airprime.c,
cyberjack.c, cypress_m8.c (I think), empeg.c, ftdi_sio (I think),
io_ti.c, and that's where I stop checking, and declare it's widespread.

> Given the size of transfers and the internal buffering one would hope the
> USB devices do their own flow control if told to properly.
>   

RS232 is (normally) so much slower than USB that, on an extended
transmission, the buffer internal to the local hardware can fill well
before the remote device has demanded that transmission stop.  In fact,
now that you've mentioned it, I can't see that anything to stop the
driver from overflowing the internal buffer, which is very perplexing. 
Would that be right?  That seems a pretty dramatic weakness; how do you
write a large report to a slow printer without losing data?


I'm beginning to realise that overflowing the internal buffer is the
greatest risk of data loss.  Hardware flow control almost seems
serendipitous.  It gives us a reason to stop submitting bulk writes.

This is the essence of the change that I looking at for pl2303.c. 
(Patch relative to kernel 2.6.23.14.)  Does it make sense?

--- pl2303.c	2008-01-15 07:19:56.000000000 +1030
+++ pl2303.c.new	2008-02-15 04:22:12.000000000 +1030
@@ -370,6 +370,18 @@
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+	/*
+	 * there's a limit to how much we can buffer, so don't accept data while
+	 * CTS or DSR are low.  XXX I don't know what to do about XON/XOFF.
+	 */
+	if ((priv->line_control | CONTROL_RTS && !(priv->line_status & UART_CTS)) || \
+	    (priv->line_control | CONTROL_DTR && !(priv->line_status & UART_DSR))) {
+		/* 
+		spin_unlock_irqrestore(&priv->lock, flags);
+		dbg("%s: send paused by remote flow control", __FUNCTION__);
+		return;
+	}
+
 	if (priv->write_urb_in_use) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
@@ -957,6 +969,9 @@
 
 	pl2303_update_line_status(port, data, actual_length);
 
+	/* send any buffered data */
+	pl2303_send(port);
+
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)


