Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXKWWwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXKWWwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 17:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXKWWwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 17:52:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:58688 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXKWWwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 17:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=X9IstrqVVBYrSz2ugU3+TV7YxpakFJJq0pvBqCtzuL6mWb07GZY/ckSSGtcldVPoEacaVG8HoNs+t5b8EKTWzxDaPSkinPpX+EPqOPx/Iac9XULl9Ox8vjhZGE7dmXxERQRIu+zlRakHJTQNcpJXl6QdTsK0Qhq7eXkclujd/8I=
Message-ID: <474759B6.4060903@gmail.com>
Date: Sat, 24 Nov 2007 01:52:38 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake пишет:
> Being spoilt by the luxuries of i386/x86_64 I've never really had a good
> grasp on unaligned memory access problems on other architectures and decided
> it was time to figure it out. As a result I've written this documentation
> which I plan to submit for inclusion as
> Documentation/unaligned_memory_access.txt
> 
> Before I do so, any comments on the following?

>From the viewpoint of yours truly (and I am a teacher of operating system classes), this is a long-expected document, which is going to be very useful especially for newbies. My students often make alignment mistakes in their code, and your article will definitely make my job much easier.

Thank you, Daniel, for your work.

Dmitri

> 
> Thanks,
> Daniel
> 
> 
> 
> 
> UNALIGNED MEMORY ACCESSES
> =========================
> 
> Linux runs on a wide variety of architectures which have varying behaviour
> when it comes to memory access. This document presents some details about
> unaligned accesses, why you need to write code that doesn't cause them,
> and how to write such code!
> 
> 
> What's the definition of an unaligned access?
> =============================================
> 
> Unaligned memory accesses occur when you try to read N bytes of data starting
> from an address that is not evenly divisible by N (i.e. addr % N != 0).
> For example, reading 4 bytes of data from address 0x10000004 is fine, but
> reading 4 bytes of data from address 0x10000005 would be an unaligned memory
> access.
> 
> 
> Why unaligned access is bad
> ===========================
> 
> Most architectures are unable to perform unaligned memory accesses. Any
> unaligned access causes a processor exception.
> 
> Some architectures have an exception handler implemented in the kernel which
> corrects the memory access, but this is very expensive and is not true for
> all architectures. You cannot rely on the exception handler to correct your
> memory accesses.
> 
> In summary: if your code causes unaligned memory accesses to happen, your code
> will not work on some platforms, and will perform *very* badly on others.
> 
> You may be wondering why you have never seen these problems on your own
> architecture. Some architectures (such as i386 and x86_64) do not have this
> limitation, but nevertheless it is important for you to write portable code
> that works everywhere.
> 
> 
> Natural alignment
> =================
> 
> The rule we mentioned earlier forms what we refer to as natural alignment:
> When accessing N bytes of memory, the base memory address must be evenly
> divisible by N, i.e. addr % N == 0
> 
> When writing code, assume the target architecture has natural alignment
> requirements.
> 
> Sidenote: in reality, only a few architectures require natural alignment
> on all sizes of memory access. However, again we must consider ALL supported
> architectures; natural alignment is the only way to achieve full portability.
> 
> 
> Code that doesn't cause unaligned access
> ========================================
> 
> At first, the concepts above may seem a little hard to relate to actual
> coding practice. After all, you don't have a great deal of control over
> memory addresses of certain variables, etc.
> 
> Fortunately things are not too complex, as in most cases, the compiler
> ensures that things will work for you. For example, take the following
> structure:
> 
> 	struct foo {
> 		u16 field1;
> 		u32 field2;
> 		u8 field3;
> 	};
> 
> Let us assume that an instance of the above structure resides in memory
> starting at address 0x10000000. With a basic level of understanding, it would
> not be unreasonable to expect that accessing field2 would cause an unaligned
> access. You'd be expecting field2 to be located at offset 2 bytes into the
> structure, i.e. address 0x10000002, but that address is not evenly divisible
> by 4 (remember, we're reading a 4 byte value here).
> 
> Fortunately, the compiler understands the alignment constraints, so in the
> above case it would insert 2 bytes of padding inbetween field1 and field2.
> Therefore, for standard structure types you can always rely on the compiler
> to pad structures so that accesses to fields are suitably aligned (assuming
> you do not cast the field to a type of different length).
> 
> Similarly, you can also rely on the compiler to align variables and function
> parameters to a naturally aligned scheme, based on the size of the type of
> the variable.
> 
> Sidenote: in the above example, you may wish to reorder the fields in the
> above structure so that the overall structure uses less memory. For example,
> moving field3 to sit inbetween field1 and field2 (where the padding is
> inserted) would shrink the overall structure by 1 byte:
> 
> 	struct foo {
> 		u16 field1;
> 		u8 field3;
> 		u32 field2;
> 	};
> 
> Sidenote: it should be obvious by now, but in case it is not, accessing a
> single byte (u8 or char) can never cause an unaligned access, because all
> memory addresses are evenly divisible by 1.
> 
> 
> Code that causes unaligned access
> =================================
> 
> With the above in mind, let's move onto a real life example of a function
> that can cause an unaligned memory access. The following function adapted
> from include/linux/etherdevice.h is an optimized routine to compare two
> ethernet MAC addresses for equality.
> 
> unsigned int compare_ether_addr(const u8 *addr1, const u8 *addr2)
> {
> 	const u16 *a = (const u16 *) addr1;
> 	const u16 *b = (const u16 *) addr2;
> 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;
> }
> 
> In the above function, the reference to a[0] causes 2 bytes (16 bits) to
> be read from memory starting at address addr1. Think about what would happen
> if addr1 was an odd address, such as 0x10000003. (Hint: it'd be an unaligned
> access)
> 
> Despite the potential unaligned access problems with the above function, it
> is included in the kernel anyway but is documented to only work on
> 16-bit-aligned addresses. It is up to the caller to ensure this alignment or
> not use this function at all. This alignment-unsafe function is still useful
> as it is a decent optimization for the cases when you can ensure alignment.
> 
> 
> Here is another example of code that could cause unaligned accesses:
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		*((u32 *) data) = cpu_to_le32(value);
> 		[...]
> 	}
> 
> This code will cause unaligned accesses every time the data parameter points
> to an address that is not evenly divisible by 4.
> 
> 
> Consider the following structure:
> 	struct foo {
> 		u16 field1;
> 		u32 field2;
> 		u8 field3;
> 	} __attribute__((packed));
> 
> It's the same structure as we looked at earlier, but the packed attribute has
> been added. This attribute ensures that the compiler never inserts any padding
> and the structure is laid out in memory exactly as is suggested above.
> 
> The packed attribute is useful when you want to use a C struct to represent
> some data that comes in a fixed arrangement 'off the wire'.
> 
> It should be clear why accessing fields of an instance of that structure could
> cause unaligned accesses in some situations. Even if the instance started at
> an address such as 0x10000000 where accessing field1 would not cause an
> unaligned access, accessing field2 would be reading 4 bytes from 0x10000002,
> which, is an unaligned access. The compiler didn't jump to your rescue and 
> insert padding because you asked it not to.
> 
> 
> In summary, the 3 main scenarios where you may run into unaligned access
> problems involve:
>  1. Recasting variables to types of different lengths
>  2. Pointer arithmetic followed by access to at least 2 bytes of data
>  3. Accessing elements of packed structures
> 
> 
> Avoiding unaligned accesses
> ===========================
> 
> Going back to an earlier example:
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		*((u16 *) data) = cpu_to_le32(value);
> 		[...]
> 	}
> 
> To avoid the unaligned memory access, you could rewrite it as follows:
> 
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		value = cpu_to_le32(value);
> 		memcpy(data, value, sizeof(value));
> 		[...]
> 	}
> 
> It's safe to assume that memcpy will always copy bytewise and hence will
> never cause an unaligned access.
> 
> 
> Recall an example packed structure from earlier:
> 
> 	struct foo {
> 		u16 field1;
> 		u32 field2;
> 		u8 field3;
> 	} __attribute__((packed));
> 
> The following code will potentially cause 2 unaligned accesses: writing to
> field2, then reading from field2:
> 
> 	void myfunc2(u32 some_data)
> 	{
> 		struct foo myinstance;
> 		u32 tmp;
> 
> 		myinstance.field2 = some_data;
> 		tmp = myinstance.field2 * 2;
> 	}
> 
> When writing this code, you should be aware that field2 acccesses are
> potentially unaligned therefore the above will break on some systems. The
> kernel provides two macros to simplify handling of situations such as the
> above:
> 
> 	void myfunc2(u32 some_data)
> 	{
> 		struct foo myinstance;
> 		u32 tmp;
> 
> 		put_unaligned(tmp, &myinstance.field2);
> 		tmp = get_unaligned(&myinstance.field2);
> 	}
> 
> These macros work from pointers to the unaligned data, and work for memory
> accesses of any length (not just 32 bits as in the example above). You could
> even use put_unaligned() rather than memcpy() in order to solve the bug in
> the first example (myfunc()) given above.
> 
> --
> Author: Daniel Drake <dsd@gentoo.org>
> With help from: Johannes Berg, Uli Kunitz.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

