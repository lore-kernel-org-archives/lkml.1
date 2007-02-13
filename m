Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXBMWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXBMWZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXBMWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:25:08 -0500
Received: from neon.samage.net ([83.149.67.130]:34997 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXBMWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:25:06 -0500
Message-ID: <4715.81.207.0.53.1171405496.squirrel@secure.samage.net>
In-Reply-To: <20070213214335.GC22104@elte.hu>
References: <20070213142024.GC638@elte.hu>
    <4390.81.207.0.53.1171397879.squirrel@secure.samage.net>
    <20070213214335.GC22104@elte.hu>
Date: Tue, 13 Feb 2007 23:24:56 +0100 (CET)
Subject: Re: [patch 02/11] syslets: add syslet.h include file,
      user API/ABI definitions
From: "Indan Zupancic" <indan@nul.nu>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: d3d6c6694e059b137bd8e4e2c0542d46
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, February 13, 2007 22:43, Ingo Molnar wrote:
> * Indan Zupancic <indan@nul.nu> wrote:
>>   A
>>   |
>>   B<--.
>>   |   |
>>   C---'
>>
>> What will be the previous atom of B here? It can be either A or C, but
>> their return values can be different and incompatible, so what flag
>> should B set?
>
> previous here is the previously executed atom, which is always a
> specific atom. Think of atoms as 'instructions', and these condition
> flags as the 'CPU flags' like 'zero' 'carry' 'sign', etc. Syslets can be
> thought of as streams of simplified instructions.

In the diagram above the previously executed atom, when handling atom B,
can be either atom A or atom C. So B doesn't know what kind of return value
to expect, because it depends on the previous atom's kind of syscall, and
not on B's return type. So I think you would want to move those return value
flags one atom earlier, in this case to A and C. So each atom will have a
flag telling what to to depending on its own return value.

>> > +/*
>> > + * Special modifier to 'stop' handling: instead of stopping the
>> > + * execution of the syslet, the linearly next syslet is executed.
>> > + * (Normal execution flows along atom->next, and execution stops
>> > + *  if atom->next is NULL or a stop condition becomes true.)
>> > + *
>> > + * This is what allows true branches of execution within syslets.
>> > + */
>> > +#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000080
>> > +
>>
>> Might rename this to SYSLET_SKIP_NEXT_ON_STOP too then.
>
> but that's not what it does. It really 'skips to the next one on a stop
> event'. I.e. if you have three consecutive atoms (consecutive in linear
> memory):
>
> 	atom1 returns 0
> 	atom2 has SYSLET_STOP_ON_ZERO|SYSLET_SKIP_NEXT_ON_STOP set
> 	atom3
>
> then after atom1 returns 0, the SYSLET_STOP_ON_ZERO condition is
> recognized as a 'stop' event - but due to the SYSLET_SKIP_NEXT_ON_STOP
> flag execution does not stop (i.e. we do not return to user-space or
> complete the syslet), but we continue execution at atom3.
>
> this flag basically avoids having to add an atom->else pointer and keeps
> the data structure more compressed. Two-way branches are sufficiently
> rare, so i wanted to avoid the atom->else pointer.

The flags are smart, they're just at the wrong place I think.

In your example, if atom3 has a 'next' pointing to atom2, atom2 wouldn't
know which return value it's checking: The one of atom1, or the one of
atom3? You're spreading syscall specific knowledge over multiple atoms
while that isn't necessary.

What I propose:

	atom1 returns 0, has SYSLET_STOP_ON_ZERO|SYSLET_SKIP_NEXT_ON_STOP set
	atom2
	atom3

(You've already used my SYSLET_SKIP_NEXT_ON_STOP instead of
SYSLET_SKIP_TO_NEXT_ON_STOP. ;-)

Perhaps it's even more clear when splitting that SYSLET_STOP_* into a
SYSLET_STOP flag, and specific SYSLET_IF_* flags. Either that, or go
all the way and introduce seperate SYSLET_SKIP_NEXT_ON_*.

	atom1 returns 0, has SYSLET_SKIP_NEXT|SYSLET_IF_ZERO set
	atom2
	atom3

Greetings,

Indan


