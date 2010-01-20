Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449Ab0ATUPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0ATUPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092Ab0ATUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:15:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60809 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0ATUPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:15:16 -0500
Message-ID: <4B57641E.5060303@zytor.com>
Date: Wed, 20 Jan 2010 12:14:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home>
In-Reply-To: <alpine.DEB.2.00.1001201333430.15175@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:49 AM, Christoph Lameter wrote:
> On Tue, 19 Jan 2010, H. Peter Anvin wrote:
> 
>> Could you do this in the standard sequencing for unification patches:
>> first patch the two pieces of code so they are identical, and then
>> mechanically unifying them?  Otherwise it's almost impossible to see
>> what has changed.
> 
> Hmmm... Okay I better do that on top of your patches then.
> 
>>> This is also a good preparatory patch for getting the rwsem XADD stuff
>>> to work on x86_64.
>>
>> Have you tried the tip:x86/rwsem branch (Linus' work with a few
>> additions of mine) and had it not work for you?
> 
> No I just saw it. Linus first patch increases the 64/32 bit separation by
> creating yet another 64 bit specific file. Can we avoid that and have
> code that is shared as much as possible between 32 and 64 bit?

The ABI is completely different between 32 and 64 bits.  The stubs avoid
keeping track of *those* differences in each and every inline.  It might
be possible with macros, but there is something that really is very
different: for x86-32, there are only three function-clobbered
registers, which we pretty much need to use anyway.  For x86-64, there
are a lot more -- which means that each callsite would end up having gcc
generate save/restore code that would be in the fast path.  Linus' patch
pushes that into the slow path, which seems significantly better to me.

The new file seems like a very good way to deal with the ABI/register
set differences here.

> Then there is another that does the %z0 trick while we already have the
> proper definitions for that in include/asm/asm.h. Seems that you have
> switched to using those. Was that done consistently?

The %z0 trick would have been type-safe.  Unfortunately some versions of
gcc simply generate incorrect code with it, which is why I switched back
to the <asm/asm.h> macros (and yes, I got rid of all the %z's by sheer
necessity.)

> Why have a rwsem_count_t when a simple long would do in both cases? Just
> make sure that long is consistently used.

The motivation for rwsem_count_t seemed to be making it easier to switch
over.  I leave it up to Linus to motivate the typedef... I have to say,
though, that using a typedef also tells you want the number is for.

> __downgrade_write:  Why use the inc trick instead of the add
> like in 32 bit? There is not much difference and it results in much
> stabler code.

Because you can't do an add with a 64-bit immediate!  Yes, we could have
loaded it into a register, but that would have required an additional
10-byte(!) instruction for no good reason.

>>> x86_64 gains the FRAME/ENDFRAME handling that i386 has (not sure what the
>>> point is of having that there).
>>
>> Presumably it's so you can have frame pointers everywhere.
> 
> For a small code segment that does not do any subroutine calls?

It's kind of redundant, yes, but that was presumably the logic.

	-hpa
