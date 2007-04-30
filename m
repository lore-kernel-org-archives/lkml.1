Return-Path: <linux-kernel-owner+w=401wt.eu-S1946622AbXD3WmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946622AbXD3WmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946869AbXD3WmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:42:12 -0400
Received: from gw.goop.org ([64.81.55.164]:50695 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946622AbXD3WmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:42:10 -0400
Message-ID: <463670D1.3000003@goop.org>
Date: Mon, 30 Apr 2007 15:42:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <m18xc9344o.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xc9344o.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I think I'd prefer to have the domain builder decompress/relocate the
>> kernel from the bzImage and start it directly, rather than have it
>> decompress/relocate itself, but I'm not really set on that.
>>     
>
> We can change a lot more implementation details arbitrarily if you don't
> know what needs to happen for decompression and relocation.

Yes, and if it can be made to work, it ultimately means less work for me ;)

> We have to avoid the writes decompressor-prinnt routines 

At worst, we could set up chunk of memory as a dummy framebuffer.  That
might be useful for debugging anyway.

> and 
> possibly the reload of the segment registers.  But otherwise
> we should be fine.  I don't see any other privileged instructions
> in arch/i386/boot/compressed/{head.S, misc.c}
>   

Xen will start the domain with a GDT loaded, and all the segment
registers loaded with flat segments.  I guess boot/compressed/head.S
could do the %cs ring check before deciding to do privileged operations.

I presume bzImage jumps straight to startup_32 on the newly decompressed
kernel?

>> It depends
>> on how well it can deal with having paging enabled and being in ring 1. 
>> Looks like it might just be a matter of starting up with "enough" memory
>> mapped.
>>     
>
> Yes.  I think so.  There is an additional issue of exactly how do we
> get the fixmap region allocated so we can use it but that is minor.
>   

I haven't checked if it already has this, but it would be nice if the
bzImage had a memory range/list of memory ranges it needs mapped to get
the kernel on its feet, so that the domain builder can just go and map
those areas for it (either P==V mappings, or with a constant offset;
whichever is more useful).

Also, if its a PAE kernel, Xen will start with PAE mode enabled, so
bzImage will have to deal with that.  But if its not touching
pagetables, it won't matter.

> What I really want to do is go back to sticking an ELF header on the
> bzImage.  We still can't support multiple entry points that way but we
> can include ELF notes fairly easily.
>   

That's OK.  We'll be able to use the boot info to go into the
Xen-specific path shortly after startup_32 anyway.

BTW, the test for a non-ring 0 %cs won't always be a good test for
paravirtualization; we're likely to start seeing hybrid execution models
where we run a largely paravirtualized kernel in a SVM/VT container.  If
we can just unconditionally use the bootloader arch definition to
determine the entry path into the kernel, it will clean things up nicely.

> It looks like for the next version of booting lguest and Xen are
> actually coming closer together again.  Yea.
>
> For boot protocol. 2.0.7  We currently need a subarchitecture field (16bits?).
> default == 0, Xen, lguest, voyager?, visws?, numaq?, efi?
>
> We need a subarchitecture data pointer field (32bits).
>   

Do we want to support starting a 64-bit guest in 64-bit mode?

> We need to target .23 because it is to late for .22.

Yes.  I'll need to do a moderate amount of work on the Xen side to make
this work, I think.

    J
