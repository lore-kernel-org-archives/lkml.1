Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbZJNBEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbZJNBEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760562AbZJNBEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:04:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbZJNBEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:04:45 -0400
Date: Tue, 13 Oct 2009 18:03:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Fulghum <paulkf@microgate.com>
cc: Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "OGAWA Hirofumi \"" <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD51D6B.7010509@microgate.com>
Message-ID: <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>  <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>  <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>  <87ljjgfcbu.fsf@spindle.srvr.nix>  <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> 
 <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>  <4AD3F769.5080405@gmail.com>  <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>  <4AD437F9.9020708@yahoo.co.uk>  <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> 
 <4AD4DE4C.4010402@yahoo.co.uk>  <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>  <4AD4F548.2030506@microgate.com>  <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain>
 <4AD51D6B.7010509@microgate.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Paul Fulghum wrote:
> 
> This is correct, the last buffer is not passed to tty_buffer_free()
> if it is the last in the list so tail is maintained.
> There is no free space in it so no new data can be added.
> There is no place where tail is null while the spinlock
> is released in preparation for calling receive_buf.
> I still can't spot any flaw in the current locking.

Do you even bother reading my emails?

Let me walk through an example of where the locking F*CKS UP, exactly 
because it's broken.

	thread1		thread2		thread3

	flush_to_ldisc
	set_bit(TTY_FLUSHING)
	buf.head = NULL
	...
	..release lock..
	.. sleep in ->receive_buf ..

			flush_to_ldisc
			set_bit(TTY_FLUSHING)
			.. head==NULL ..
			clear_bit(TTY_FLUSHING)
			.. release lock ..

					tty_ldisc_flush()
					-> tty_buffer_flush()
					TTY_FLUSHING not set!
					-> __tty_buffer_flush()
					-> tty->buf.tail = NULL

and now you're screwed. See? You have both 'buf.tail' and 'buf.head' both 
being NULL, and look what happens in that case 'tty_buffer_request_room()' 
if some new data comes in? Right: it will add the buffer to both tail and 
head.

And notice how 'thread1' is still inside flush_to_ldisc()! The buffer that 
got added will be overwritten by the old one, and now tail and head no 
longer match. Or another flush_to_ldisc() comes in, and now it won't be a 
no-op any more, and it will find the new data, and run ->receive_buf 
concurrently with the old receive_buf from thread1.

And the whole reason was that there were some very odd locking rules: 
buf.head=NULL meant "don't flush", and "TTY_FLUSHING is set" meant "don't 
clear 'buf.head'", and but the "don't flush" case still cleared 
TTY_FLUSHING (after not flushing), and it all messed up.

I could just have fixed it (move the "clear_bit(TTY_FLUSHING)" but up, but 
the fact is, once you fix that, it then becomes obvious that 
"buf.head=NULL" really is the wrong thing to test in the first place, and 
we should just use TTY_FLUSHING instead, and simply _remove_ the odd 
"buf.head=NULL is special" case. Which is what my patch did

> Your statement that the locking is too clever/subtle is
> clearly true since I am struggling to work this out again.

I have to say that the only case I could make up that is _clearly_ a bug 
is the above very contrieved example. I don't really think something like 
the above happens in reality. But it's an example of bad locking, and what 
happens when the locking logic isn't obvious.

There may be other cases where the locking fails, and I just didn't find 
them. 

Or the patch may simply not fix anything in practice, and nobody has ever 
actually triggered the bad locking in real life. I dunno. I just do know 
that the locking was too damn subtle.

Any time people do ad-hoc locking with "clever" schemes, it's almost 
invariably buggy. So the rule is: just don't do that. Make the locking 
rules "obvious".  Don't have subtle rules about "if head is NULL, then 
we're not going to add any new buffers to it, except if tail is also 
NULL". Because look above what happens, and see how complicated it was to 
even see the bug.

			Linus
