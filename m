Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYICKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYICKki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYICKka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:40:30 -0400
Received: from mailer2.option.com ([81.246.70.163]:15752 "EHLO
	mailer2.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYICKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:40:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgBAKwFvkgKAAAZ/2dsb2JhbAAItXSBaQ
Message-ID: <48BE603A.4040502@option.com>
Date: Wed, 03 Sep 2008 12:00:26 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: /drivers/char/n_tty.c drops characters
References: <48BE3FD9.6070303@option.com> <20080903112458.0be25714@lxorguk.ukuu.org.uk>
In-Reply-To: <20080903112458.0be25714@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 10:40:27.0424 (UTC) FILETIME=[7A9CD200:01C90DB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
Sorry for wasting your valuable time.
There are tty_throttle & tty_unthrottle functions
should if working properly do everything I want.

Alan Cox wrote:
>> Maybe my interpretation of this statement is incorrect but
>> is Alan implying that ttys will no longer drop charaters ? 
>> if this is what Alan is saying it is simply not true but it can be implemented.
> 
> The current queue code will not drop characters queued to the line
> discipline unless we are in extreme circumstances [64K queued on this
> tty, out of memory]
> 
>> My understanding of this code might be imperfect but this really looks
>> likes this blindly copies into a ring buffer of N_TTY_BUF_SIZE &
>> doesn't return any indication an attempt to copy a tty buffer of larger than N_TTY_BUF_SIZE
>> & overflows the buffer before the task activated by the code at the bottom of n_tty_receive_buf
> 
> There is no check needed. See flush_to_ldisc
> 
>             if (count > tty->receive_room)
>                     count = tty->receive_room;
> 
> So if we are dropping characters on this path it means
> tty->receive_room is either getting set too large or the n_tty driver is
> shrinking it by more than the bytes it gets a some point.
> 
> Most of the network drivers actually just set it to "send everything" as
> they want overruns on the serial side to drop bytes to get proper TCP
> queueing but n_tty does try to manage the value.
> 
>> My main complaints are
>> 1) there is no mechanism for informing the tty layer that not all the
>> characters are copied from the tty layer to the line discipline.
> 
> The tty layer doesn't need to know. What will the tty driver do if it
> finds this - queue bytes ? We already queue bytes in the core code now
> for up to 64K. Flow control ? - it is late for flow control at that point,
> and the core code already provides flow control callbacks.
> 
>> 2) The use of a a ring buffer in the line discipline,
>> we are memcpying at least twice in the kernel before passing the
>> buffer back to userland.
> 
> For n_tty this really does not worry me. n_tty is not a performance
> critical path for any use I know of. For the ppp layer we do a copy from
> the tty buffers to the socket buffers and we have to do that to unpack
> the async padding. That one is the one that bothers me more. I'm willing
> to be enlightened however.
> 
> We do try to keep all the transfers cache-hot. In theory you could tweak
> the ldisc code so that the tty_buffer object ownership is transferred to
> the ldisc which then frees the buffer back when it is done. That may have
> possibilities.
> 
>> 3) There is no mechanism for tty_io.c of informing the
>> char driver which is feeding the tty that it can
>> release flow control & start feeding read buffers
>> to the device hardware again to restart io. 
> 
> driver->ops->unthrottle()
> 
> I am not 100% certain we call throttle early enough and unthrottle
> at times appropriate for devices with large internal buffers like some of
> the USB hardware but those are points that can be adjusted.


-- 
best regards,
D.J. Barrow
