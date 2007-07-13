Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXGMVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXGMVTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXGMVTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:19:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbXGMVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:19:46 -0400
Message-ID: <4697EC66.2030404@zytor.com>
Date: Fri, 13 Jul 2007 14:19:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RE : Re: x86 setup code rewrite in C - revised
References: <700342.61011.qm@web26915.mail.ukl.yahoo.com>
In-Reply-To: <700342.61011.qm@web26915.mail.ukl.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain wrote:
> --- "H. Peter Anvin" <hpa@zytor.com> wrote:
>> Chuck Ebbert wrote:
> 
>   Wrong name.
> 
>>>>  Have fun, this code:
>>>>  - do not open the fast A20 gate before checking if the slow A20 gate is open or
>> closed.
>>
>> As does the current code; this is highly intentional behaviour since
>> there are machines (in particular a whole series of machines made by
>> Olivetti) which lock up if you do it differently.
> 
>  There was some discussion on this list about some machine which would not wake-up
> correctly if slow A20 was not closed, long time ago. I did not really follow
> the code after that discussion.
>  I wonder if you should do a "outb(0xFF, 0x64);" after "outb(0xdf, 0x60);" like
> the HIMEM.SYS driver, to force an immediate update of the I/O ports - I think
> I also read that in this initial chip docs, long time ago also.

Well, the code we have now has worked for quite some years as-is.  This
code is not an algorithmic change.  I haven't seen any machines which
need outb(0xff, 0x64) -- I wonder if that has the same effect as our
io_delay() or if it is actually potent.  I shall look into it.

>>>>  - Does not save and restore %ds when printing a char on the screen (%ds is
>>>>  destroyed only when the content of the screen scroll - only for some video cards)
>> %ds?  Aren't you confusing it with the old bug which would destroy %bp?
>>  If you have any references to %ds being destroyed I would be very
>> surprised.  I can guarantee that very little if any assembly code I've
>> ever seen that deals with INT 10h -- and I've seen a lot of it -- guards
>> against %ds being randomly trashed.
>>
>> However, the trashing of %bp is a well-known bug (although only for
>> machines older than the ones that can run Linux) -- the Interrupt List has:
>>
>> BUGS:   some implementations (including the original IBM PC) have a bug
>>  	which destroys BP
> 
>  That is on Trident cards, old card but may still be used, and BIOS may have
> been copied to other cards.
>  Detected and documented on Gujin (boot.c and vgabios.h scroll)

Are you talking about BP or DS?  As I said, the BP is well-known, and
the code accounts for it in the form of the INT10 macro.

>>>>  and probably few other problems - just seen those by reading the patches (the
>>>>  asm("") are inlined in the C code - I find it more difficult to check).
>>>>
>>>>  Also, I do not know if "m" is right in here:
>>>> static inline u8 rdfs8(addr_t addr)
>>>> {
>>>> 	u8 v;
>>>> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
>>>> 	return v;
>>>> }
>> The "m" is correct right there.
> 
>  strange, "g" would mean anything can go there - and this assembly instruction
> should accept every access modes.

Not with an %fs: prefix.  It would also allow the compiler to do a move
into a register "on its own", which would be disastrous, since it would
lack the prefix.  So "m" is correct.

	-hpa
