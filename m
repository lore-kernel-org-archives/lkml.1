Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0BMAJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 19:09:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59819 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751568Ab0BMAJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 19:09:30 -0500
Date: Sat, 13 Feb 2010 00:09:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henry Nestler <henry-20071123@arcor.de>
Cc: linux-kernel@vger.kernel.org,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       gregkh@suse.de, Simon.Richter@phobos.fachschaften.tu-muenchen.de
Subject: Re: [2.6.33-rc7] tty: page allocation failure (from
 tty_buffer_request_room)
Message-ID: <20100213000923.03007ddf@lxorguk.ukuu.org.uk>
In-Reply-To: <4B75E528.7090605@arcor.de>
References: <ed7v4-5Xl-13@gated-at.bofh.it>
	<4B75E528.7090605@arcor.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You are doing some output on console, for example write to a device /dev/tty.
> > Inside tty_buffer_request_room I found, that kmalloc was called and interrupts
> > are disabled. That means, memory can not swap out - if no free page is
> > available. tty_buffer_request_room checks for NULL returns. So, it assumes,
> > that kmalloc can fail. Unless they have forgotten to set __GFP_NOWARN. - Or it
> > is a defective design, and kmalloc should not called inside a spin_lock.


Neither - if we can't allocate a small buffer (and I would expect this to
be a small buffer of under one page) then we lose data and while we
continue to run it indicates a very serious low memory condition that the
user really ought to be aware of.

If anything what this says is that tty_insert_flip_string and friends
ought to be tweaked to do

nt tty_insert_flip_string(struct tty_struct *tty, const unsigned char
*chars, size_t size)
{  
        int copied = 0;
        do {
		int want = min(size - copied, TTY_BUFFER_PAGE);
                int space = tty_buffer_request_room(tty, want);
		...


where TTY_BUFFER_PAGE is defined to be the size to request so the buffer
will fit in one page of memory.

