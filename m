Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbZJMVsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbZJMVsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZJMVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:48:04 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43450
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZJMVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:48:03 -0400
Message-ID: <4AD4F548.2030506@microgate.com>
Date: Tue, 13 Oct 2009 16:46:48 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Boyan <btanastasov@yahoo.co.uk>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E?=
	 =?ISO-8859-1?Q?_W=2E_Meunier=22?= <fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain> <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> and by releasing that lock it actually seems to break all the buffering 
> guarantees! What can happen is:
> 
> 	CPU1 (or thread1 with PREEMPTION)
> 					CPU2 (or thread2 with PREEMPTION)
> 
> 	flush_to_ldisc()
> 	...
> 	spin_lock_irqsave(..)
> 	.. get one buffer..
> 	spin_unlock_irqrestore(..);
> 
> 			<- PREEMPTION POINT, anything can happen ->
> 			<- more buffers can be added, etc ->
> 
> 					flush_to_ldisc()
> 					spin_lock_irqsave(..)
> 					.. get second buffer..
> 					spin_unlock_irqrestore(..);
> 					->receive_buf(tty, char_buf, ...
> 					spin_lock_irqrestore(..)
> 					.. all done ..
> 
> 
> 	->receive_buf(tty, char_buf, ...
>         spin_lock_irqrestore(...)
> 
> Notice how the "->receive_buf()" calls were done out of order, even if the 
> data was perfectly in-order in the buffers.

The buffer head is removed and set to null just before
the flushing loop.

If flush_to_ldisc() is reentered with the head set to null, nothing
is done. New buffers can be added where you say, but they are
added to the tail. So the order of flushed data is retained.

This existing mechanism essentially does the same thing as your patch.


-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
