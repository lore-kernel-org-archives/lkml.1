Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbXGRRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbXGRRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935060AbXGRRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:19:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43288 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934896AbXGRRTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:19:49 -0400
Date: Wed, 18 Jul 2007 18:19:39 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <469D35B1.5050905@microgate.com>
Message-ID: <Pine.LNX.4.64.0707181805150.28741@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
 <469D2F67.40305@microgate.com> <Pine.LNX.4.64.0707172104050.9131@pentafluge.infradead.org>
 <469D35B1.5050905@microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> James Simmons wrote:
> > The low_latency is used by the drivers in the case where its not in a
> > interrupt context. Well we are trusting the drivers.
> > Now if it is true what you said then tty_flip_buffer_push has
> > a bug. Looking at several drivers including serial devices
> > they set the low_latency flag.
> 
> The generic serial driver (8250) is the one that was
> dead locking when that code originally existed.
> It was setting low_latency and calling from interrupt context.

serial8250_interrupt -> serial8250_handle_port ->
receive_chars -> tty_flip_buffer_push

It could still dead lock. The low_latency flag is too weak of a test.
I patched tty_flip_buffer_push to fix this.

> > > And the initial schedule has no reason to add the extra delay.
> > 
> > So do you support a non delay work queue as well?
> 
> No, the delay work must be used for flush_to_ldisc()
> so it makes no sense to define two different work queues
> (one delayed and one not) for the same work.

Sorry I mean move to a just a non delay work queue only.
Which we won't anyways.

> I support your patch.

> The current stuff works and your patch works.
> With your patch, you actually reduce initial
> latency for processing receive data.

Thanks.
