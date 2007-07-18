Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbXGRT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbXGRT2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGRT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:28:17 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:58977
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXGRT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:28:16 -0400
Subject: Re: [PATCH] Use tty_schedule in VT code.
From: Paul Fulghum <paulkf@microgate.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
	 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
	 <469D2810.9080109@microgate.com>
	 <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
	 <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 13:27:59 -0500
Message-Id: <1184783279.3444.15.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 19:17 +0100, James Simmons wrote:

> I have no problem leaving at one. Here is the new patch. I did address the 
> problem with tty_flip_buffer_push in this patch. It is possible for a 
> driver to call tty_flip_buffer_push within a interrupt context if they
> set the low_latency flag.
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -3647,11 +3647,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
>  	if (tty->buf.tail != NULL)
>  		tty->buf.tail->commit = tty->buf.tail->used;
>  	spin_unlock_irqrestore(&tty->buf.lock, flags);
> -
> -	if (tty->low_latency)
> -		flush_to_ldisc(&tty->buf.work.work);
> -	else
> -		schedule_delayed_work(&tty->buf.work, 1);
> +	schedule_delayed_work(&tty->buf.work, 1);
>  }

While I have no problem with this, it would be a significant
behavior change (more so than changing the initial delay to 0).

IIRC, when the serial_core dead lock was being debugged
(by Russel King with some Dell guy who reported it 1-2 years ago) 
this change was suggested and rejected because some callers
are not running at IRQ context and want to use low_latency.
In the end, I think they decided to leave the correct use of
low_latency WRT running in IRQ context to the caller.

It might be safest to drop this portion so you can get the
obvious part of the patch accepted (consolidating
the redundant xxx_schedule_flip functions).
 
--
Paul Fulghum
Microgate Systems, Ltd

