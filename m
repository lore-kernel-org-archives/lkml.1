Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYH0LE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYH0LE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYH0LER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:04:17 -0400
Received: from mailer1.option.com ([81.246.70.162]:7983 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYH0LEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:04:16 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 07:04:16 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMBAGvPtEgKAAAZ/2dsb2JhbAAIuV6BZw
Message-ID: <48B53259.90005@option.com>
Date: Wed, 27 Aug 2008 12:54:17 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: greg@kroah.com, Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hso driver dropping characters on serial port & hacky fix 
References: <20080820010353.593820280@mini.kroah.org> <20080820010752.GB3365@kroah.com> <48B52064.9070700@pobox.com>
In-Reply-To: <48B52064.9070700@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2008 10:54:17.0529 (UTC) FILETIME=[40808A90:01C90833]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
We have a problem with the hso driver serial ports.
The problem is a little complex but I hope I can explain it adequetely.
If you are unfamiliar with USB URBS are basically buffers we give to usb
hardware to recieve or transmit packets to a USB device.

The problem manifests itself when our hardware guys at option
have a userland diagnostics program going & on a system under
heavy load, the tty layers buffers belonging to our emulated serial port
fill up because the userland program gets no
chance to chance to empty data on the modems emulated serial port.

If we modify  put_rxbuf_data(struct urb *urb, struct hso_serial *serial)

with the copied check below we get printks under heavy load

> 		copied=tty_insert_flip_string(tty, urb->transfer_buffer,
> 				       urb->actual_length);
> 		if(copied<urb->actual_length)
> 			printk(KERN_ERR" hso: put_rxbuf_data did not "
> 			       "copy full rx buffer copied=%d asked to copy=%d\n",
> 			       copied,urb->actual_length);

In the current driver code you've got the driver drops packets silently.

I initially thought that this was not our problem/bug because I
thought we had no means for USB flow control & told our diagnostic
guys to go away & stop annoying me.
However I was talking to the firmware developer of our feama 3G modem
& he says that the modem will stall gracefully if it doesn't 
have outstanding bulk_urbs on the emulated serial ports.
i.e. we have a mechanism to do flow control on our emulated serial
ports & get away without dropping packets or data corruption.

If I redesign the code.
We run into a problem if we have no outstanding urbs on
the serial recieve channel as we will get no more read channel callback
interrupts. We need to poll the tty layer to
see if we have free space to put data from the
urbs we have not yet processed on the read channel or go with my hack.

The hack I'm suggesting which Filip Aben is worried that wont
get accepted by you is to put a change the line discipline function pointer
for the hso driver i.e. the bit that calls
disc->ops->receive_buf(tty, char_buf,flag_buf, count);
in
static void flush_to_ldisc(struct work_struct *work)
in
/drivers/char/tty_io.c

to point to our own special function in the hso driver where we call the original
disc->ops->receive_buf so we get automatically 
notified when we have free space in the hso drivers tty buffers.
Short of modifying the tty layer I can see no other way of doing this
efficently.

Is this acceptable to you guys.

This is the most elegant hack I can see to solve this problem,
if any of ye have a cleaner suggestion let me know.

Sincerely,
D.J. Barrow


