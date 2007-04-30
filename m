Return-Path: <linux-kernel-owner+w=401wt.eu-S1422936AbXD3XLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936AbXD3XLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423387AbXD3XLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:11:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59501 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422936AbXD3XLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:11:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
	<m18xc9344o.fsf@ebiederm.dsl.xmission.com> <463670D1.3000003@goop.org>
Date: Mon, 30 Apr 2007 17:10:59 -0600
In-Reply-To: <463670D1.3000003@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 30 Apr 2007 15:42:25 -0700")
Message-ID: <m14pmx31bw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>>> I think I'd prefer to have the domain builder decompress/relocate the
>>> kernel from the bzImage and start it directly, rather than have it
>>> decompress/relocate itself, but I'm not really set on that.
>>>     
>>
>> We can change a lot more implementation details arbitrarily if you don't
>> know what needs to happen for decompression and relocation.
>
> Yes, and if it can be made to work, it ultimately means less work
> for me ;)

Now you are beginning to sound like a bootloader author.
Make it work and forget about it :)

>> We have to avoid the writes decompressor-prinnt routines 
>
> At worst, we could set up chunk of memory as a dummy framebuffer.  That
> might be useful for debugging anyway.

I'm trying to recall how we handle this on the LinuxBIOS side.
Because we have machines without a framebuffer setup.  Oh yeah,
we started in 32bit mode...

I do have some parameters to parse the command line in misc.c that
would accomplish this goal.

>> and 
>> possibly the reload of the segment registers.  But otherwise
>> we should be fine.  I don't see any other privileged instructions
>> in arch/i386/boot/compressed/{head.S, misc.c}
>>   
>
> Xen will start the domain with a GDT loaded, and all the segment
> registers loaded with flat segments.  I guess boot/compressed/head.S
> could do the %cs ring check before deciding to do privileged
> operations.

I'm tempted to just reload the segments in setup.S, but that might
break loadlin support or one of the other bootloaders that starts the
kernel in 32bit mode so we need to be careful.


> I presume bzImage jumps straight to startup_32 on the newly decompressed
> kernel?

Straight isn't the way I would but it but yes. startup_32 in arch/i386/head.S
is the first piece of code that outside of the decompressor that it runs.

> I haven't checked if it already has this, but it would be nice if the
> bzImage had a memory range/list of memory ranges it needs mapped to get
> the kernel on its feet, so that the domain builder can just go and map
> those areas for it (either P==V mappings, or with a constant offset;
> whichever is more useful).

P==V mappings I suspect.

> Also, if its a PAE kernel, Xen will start with PAE mode enabled, so
> bzImage will have to deal with that.  But if its not touching
> pagetables, it won't matter.

Exactly.

>> What I really want to do is go back to sticking an ELF header on the
>> bzImage.  We still can't support multiple entry points that way but we
>> can include ELF notes fairly easily.
>>   
>
> That's OK.  We'll be able to use the boot info to go into the
> Xen-specific path shortly after startup_32 anyway.

Yes.

> BTW, the test for a non-ring 0 %cs won't always be a good test for
> paravirtualization; we're likely to start seeing hybrid execution models
> where we run a largely paravirtualized kernel in a SVM/VT container.  If
> we can just unconditionally use the bootloader arch definition to
> determine the entry path into the kernel, it will clean things up nicely.

Yes.  That is why we need a distinct field for this and not overloading
the bootloader id.  That way if the field is non-zero we need to do
something special.

>> It looks like for the next version of booting lguest and Xen are
>> actually coming closer together again.  Yea.
>>
>> For boot protocol. 2.0.7 We currently need a subarchitecture field (16bits?).
>> default == 0, Xen, lguest, voyager?, visws?, numaq?, efi?
>>
>> We need a subarchitecture data pointer field (32bits).
>>   
>
> Do we want to support starting a 64-bit guest in 64-bit mode?

It's the only way that will be sane.  When I was doing my ELF header on
bzImage work I had that working.  But it got dropped due to some unexplained,
unreproducible testing failures and not really being necessary at the
time.  We also need that if we want to be certain we don't play with
page tables.

The other thing the ELF headers gave was a precise accounting of where
the kernel was, which is essentially what needs to be mapped at boot
time.

The hard part I suspect is going to be handling Xen when setup the
physical == virtual page tables

>> We need to target .23 because it is to late for .22.
>
> Yes.  I'll need to do a moderate amount of work on the Xen side to make
> this work, I think.

I think we all will but the upside if we design this carefully is
something that we won't have to change.

Eric

