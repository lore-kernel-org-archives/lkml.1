Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbZJMXLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbZJMXLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbZJMXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:11:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54643 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbZJMXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:11:04 -0400
Date: Wed, 14 Oct 2009 00:11:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boyan <btanastasov@yahoo.co.uk>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014001131.302d3272@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910131548280.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
	<alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
	<4AD437F9.9020708@yahoo.co.uk>
	<alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
	<4AD4DE4C.4010402@yahoo.co.uk>
	<alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
	<20091013223212.3260a7eb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0910131548280.3404@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can't help feeling a mutex might be simpler. It would also then fix
> > tiocsti() which is most definitely broken right now and documented as
> > racing.
> 
> Hmm. Those tty's have too many different locks already.
> 
> But maybe we could just have one generic mutex, and use it for termios and 
> IO locking. It makes perfect sense to serialize the ->receive_buf() code 
> with any termios changes, since termios is what affects _how_ that 
> ->receive_buf() function works.

You cannot trivially just take the same lock for receive_buf and termios
locking at the moment. The reason is that receive_buf can cause the tty to
throttle which causes us to call the throttle methods which take the lock.

tty_throttle() and tty_unthrottle() can be called from both receive_buf
and non receive_buf paths so you can't just remove it.

The better existing lock is probably tty->ldisc_mutex which we take when
doing ldisc changes (which are an even more dramatic change during
receive_buf). We don't do ldisc changes from the receive_buf path and it
opens a path for further simplification of the ldisc logic if we can get
to the point where the ldisc doesn't get called randomly from the tty
layer when changing.

> I do wonder why tiocsti() doesn't just use the tty buffering layer, 
> though? Maybe that harks back to the whole "pty's did things differently" 
> thing? Why does it go directly to ->receive_buf() in the first place?

Historical question - I don't know - and at the time I commented it there
was no quick fix and bigger problems to sort first

Alan
