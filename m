Return-Path: <linux-kernel-owner+w=401wt.eu-S1762971AbXGMRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbXGMRe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbXGMReT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:34:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXGMReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:34:18 -0400
X-Greylist: delayed 2508 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 13:34:18 EDT
Message-ID: <4697ADAC.4070009@zytor.com>
Date: Fri, 13 Jul 2007 09:51:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86 setup code rewrite in C - revised
References: <526073.18540.qm@web26902.mail.ukl.yahoo.com> <4697A9E9.3090502@redhat.com>
In-Reply-To: <4697A9E9.3090502@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>>  Have fun, this code:
>>  - do not open the fast A20 gate before checking if the slow A20 gate is open or closed.

As does the current code; this is highly intentional behaviour since
there are machines (in particular a whole series of machines made by
Olivetti) which lock up if you do it differently.

>>  - uses in asm("") inputs which may or may not be set by the compiler in the stack,
>>    after modifying the stack pointer in the asm block: at least has_eflag()

Point.  "g" should be "ri".  I will send a patch.

>>  - The VGA recalc has the same bug as the assembly version where a VGA write protected
>>    register is written (Overflow register) without setting the enable bit (see VGA docs).

OK, that would be a bug ported directly from the assembly version.  The
fact that the bug can be seen now is part of why I did this work.
Please feel free to submit a patch.

>>  - Does not save and restore %ds when printing a char on the screen (%ds is destroyed
>>    only when the content of the screen scroll - only for some video cards)

%ds?  Aren't you confusing it with the old bug which would destroy %bp?
 If you have any references to %ds being destroyed I would be very
surprised.  I can guarantee that very little if any assembly code I've
ever seen that deals with INT 10h -- and I've seen a lot of it -- guards
against %ds being randomly trashed.

However, the trashing of %bp is a well-known bug (although only for
machines older than the ones that can run Linux) -- the Interrupt List has:

BUGS:   some implementations (including the original IBM PC) have a bug
 	which destroys BP

>>  - Has a "dn" for outl() which sliped in instead of "dN"

That's a bug, although currently nonmanifest -- there are no users of
outl() at the present.  I will send a patch.

>>  and probably few other problems - just seen those by reading the patches (the asm("")
>>  are inlined in the C code - I find it more difficult to check).
>>
>>  Also, I do not know if "m" is right in here:
>> static inline u8 rdfs8(addr_t addr)
>> {
>> 	u8 v;
>> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
>> 	return v;
>> }

The "m" is correct right there.

>>   I may repeat me, but to find these kind of problems, it is very nice to have an ELF
>>  file to do a readelf/objdump -D -m i8086 (even after final link).

There is such a file (arch/i386/boot/setup.elf) which is retained, for
exactly this reason.

	-hpa
