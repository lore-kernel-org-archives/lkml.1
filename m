Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXA1Nft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXA1Nft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXA1Nfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:35:48 -0500
Received: from [217.111.56.2] ([217.111.56.2]:55140 "EHLO semtex.sncag.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932545AbXA1Nfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:35:47 -0500
To: Greg KH <greg@kroah.com>
Cc: Rainer Weikusat <rweikusat@sncag.com>, torvalds@linux-foundation.org,
       bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
In-Reply-To: <20070126174828.GA28890@kroah.com> (Greg KH's message of "Fri, 26 Jan 2007 09:48:28 -0800")
References: <877ivb2kvc.fsf@semtex.sncag.com>
	<20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com>
	<20070126174828.GA28890@kroah.com>
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Sun, 28 Jan 2007 14:34:56 +0100
Message-ID: <87d54z1dhb.fsf@semtex.sncag.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> On Fri, Jan 26, 2007 at 11:43:22AM +0100, Rainer Weikusat wrote:
>> Greg KH <greg@kroah.com> writes:
>> > On Thu, Jan 25, 2007 at 04:20:55PM +0100, Rainer Weikusat wrote:
>> >> 2.6.19 introduced changes to the UHCI handling of interrupt URBs that
>> >> caused at least some keyspan USB-to-serial converters to fail,
>> 
>> [...]
>> 
>> > I copied you when this patch was added to my tree,
>> 
>> The only thing I received was a 'this patch has been dropped from
>> the MM-tree because something happened' message.
>
> You were also copied on the patch when it was added to my tree.  Email
> was sent to your rweikusat@sncag.com address.

It certainly never arrived at the MTA running on my working machine.

>> > as I had reworked it to be a bit more acceptable (no pointer
>> > arithmatic, proper coding style, use the newer macros for endpoint
>> > detection, etc.),
>> 
>> You have basically done a couple of (functionally) totally pointless
>> changes, like
>> 
>> 	- not using iterator-style array traversals, but indexed ones
>>           instead
>
> Which is the better way to document exactly how you are walking through
> all of the endpoints.

But the code does not walk trough the endpoints anymore, that's what
it did before the change. Now, it is walking through a certain subset
of the set of integral numbers, using the numbers from those set as
offset to indirectly address something. Additionally, it is harder to
read because it contains more 'noise characters' that are not
pronouncable. Arguing about this is not really reasonable, though,
because this is mostly a matter of aesthetics and a decent compiler
will generate identical code for both, ie remove the indexing
automatically again. A sensible way to enforce regulations of code
aesthetic would be to document them.

>> 	- doing the calculation to determine the endpoint type in
>>           three different places instead of in one place, because the
>>           somewhat silly endpoint classification interfaces enforces
>>           this
>
> 3 places?  You mean in the if call?

Exactly. The 'interface' that is used here does not provide a way to
ask for the type, only to ask if the type is type X. At the source
level, this means

	if ((value & mask) == x) {
        	.
                .
                .
	} else if ((value & mask) == y) {
        	.
                .
                .
	else printf("%u\n", values & mask);

A decent compiler will again probably catch this and do CSE-removal,
but this doesn't make the algorithm more sensible as it is written
down (C is not 'math', and C-expressions don't represent equal states,
like equations would do, but request that the CPU performs certain
calcluations).

>> 	- not using a single switch-statement but an if-else-cascade,
>>           again due to limitations of that interface
>
> This really isn't a problem.

It did not claim this was 'a problem' (except insofar 'clumsiness' can
be construed to be one). It is just a code change for the sake of
having changed the code.

>> 	- replacing the while-loop with an identical for-loop
>
> Again, this is the better way to walk through all of the endpoints for a
> device.

This may be the way you happen to like more and a lot of people will
probably agree with that. But the device does not care and they are
both functionally identical, only the 'textual complexity' of using
for is higher.

>> The net effect of these changes is that an optimizing compiler will
>> have to work somewhat more to remove all the redundant stuff that
>> was added.
>
> This is initialization code, it's better to be obvious as to what you
> are trying to do here than trying to do the compiler's job for it.

The claim that the meaning of something with a lower signal-to-noise
ratio is more obvious in itself is somewhat absurd: If I have to
understand the code, I have to read it and think about it and I may
reach the conclusion that certain calculations are actually
meaningless, but I still need to understand them first.

[...]

> The _main_ coding style difference is that it was not obvious as to what
> you were doing while walking the list of endpoints in the device.

That is not 'a coding style difference'. It basically just means that
you didn't understand a text not written by yourself without reading
it first.

[...]

>> > I this patch does not work, please let me know, and I will be glad
>> > to work to fix it.
>> 
>> I think I'll just resend the working one in this case. But the logic
>> appears to be identical, so I do not so a reason why it shouldn't.
>
> Please work to see what is wrong with the existing patch.  Is there
> anything that I can do to help you out?

This thing has consumed something like sixteen hours of my life in
total, with a gain-to-be-expected of exactly zero (I don't need to run
'current' kernels on my work machine, I have just grown into the habit
of doing so) and those sixteen hours cannot come back (and I even have
had these type of discussions around 'should it rather look like math
or rather like text' in sufficent quantities :->), so, except that I
would be very much obliged to you if a fix for this issue could go
into the 'official' tree rather sooner than later, no.

Apart from that, I make a (fairly miserable) living by adapting open
source code to be usable in specific situations (ie adding or
modifying features, fixing bugs, writing drivers etc) and I
ocassionally have dreams in C (this is not a joke :-), ie understand
it fairly well, no matter who was the author.
