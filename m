Return-Path: <linux-kernel-owner+w=401wt.eu-S933926AbZJMP7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbZJMP7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZJMP7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:59:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55734 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933880AbZJMP7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:59:22 -0400
Date: Tue, 13 Oct 2009 16:59:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Fulghum <paulkf@microgate.com>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013165921.4b0ffef5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910130837370.26777@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<20091013113232.384b2432@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
	<1255447980.3898.3.camel@x2.microgate.com>
	<alpine.LFD.2.01.0910130837370.26777@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I was pointing out is that there are a lot of 
> "tty_buffer_request_room()" calls, and as far as I can see, all of them 
> (or at least a large percentage) are just pure and utter crap.

Almost certainly. When the original conversion was done all the code
which tried to peer into the flip buffer and check what bytes were left
was converted systematically to call request_room() as well in order to
make the conversion easy and reliable. For most devices thats a fairly
naïve conversion as with the new buffering the tty device really
shouldn't care about overruns. If we overrun now it's because we really
do want to dump stuff not because of crappy buffering.

The request_room actually trying to produce big buffers semantic was
added because some of the high speed DMA based adapters (notably 3G USB
ones) would hand large blocks of data over each time at rates upwards of
10-20Mbits. Without that request_room tweak they tended to drop data.

Because of the way they work the DMA buffers are allocated when the URB
is submitted so they can't use prepare_* ops but had to copy in some form.

With those in place we top out at about 40-50Mbits over a USB serial
link, which ought to be enough for anyone sane for the moment.

Your change to tty_insert_flip_string() is irrelevant for any practical
situation simply because the caller has to provide ordering of the blocks
it submits (if it receives 5 bytes and they all queue asynchronously then
it doesn't matter one iota whether tty_insert_flip_string has extra
internal locking "linus" is still going to turn randomly into things like
"sunil" in the serial stream and cause much confusion).

I actually think you should make the tty_insert_flip_string internal
length checking change because:
- It makes the consistency of tty_insert_flip_string clearer to any
  future reader
- It's a very very mindbogglingly slight performance win
- It'll no doubt make you feel less grumpy ;)

Alan
