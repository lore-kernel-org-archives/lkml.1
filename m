Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZJMWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZJMWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbZJMWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:44:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761602AbZJMWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:44:26 -0400
Date: Tue, 13 Oct 2009 15:42:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Fulghum <paulkf@microgate.com>
cc: Boyan <btanastasov@yahoo.co.uk>,
       =?ISO-8859-15?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD4F548.2030506@microgate.com>
Message-ID: <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <4AD4F548.2030506@microgate.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Paul Fulghum wrote:
> 
> If flush_to_ldisc() is reentered with the head set to null, nothing
> is done. New buffers can be added where you say, but they are
> added to the tail. So the order of flushed data is retained.

They are added to the tail only if the tail is non-NULL.

And buf.tail, in turn, is protected by the TTY_FLUSHING bit.

And look what happens to TTY_FLUSHING if flush_to_ldisc() is called by 
multiple contexts - it doesn't nest right. The inner "flush_to_ldisc()" 
will clear the bit (your "nothing is done" case).

Now, I agree that we can solve things differently. We could, for example, 
get rid of TTY_FLUSHING entirely. If you want to keep the crazy "head = 
NULL" special case, we could basically replace all tests of TTY_FLUSHING 
with "tty->buf.tail && !tty->buf.head" instead, and use _that_ as a "the 
TTY is in the middle of a flush" operation. That should be 100% equivalent 
to my patch.

I do object to the whole crazy subtle TTY locking. I'm convinced it's 
wrong, and I'm convinced it's wrong exactly _because_ it tries to be so 
subtle and does non-obvious things.

That's why my patch also changed the whole loop logic: it's not subtle any 
more. Not only did I make TTY_FLUSHING nest correctly, I also stopped 
playing games with buf.head: it's now purely a list, rather than "a list 
and a failed attempt to lock".

And no, I'm not sure my patch helps. I'd have expected 
'tty_buffer_flush()' to be something very rare, for example. But I also 
didn't really check if we may do it some other way.

But I _am_ sure that it makes the code a whole lot more straightforward. 
Bits that say "we're busy flushing" suddenly actually act that way, and 
pointers that say "this is the head of the buffers" also act that wy.

			Linus
