Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXKWKHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXKWKHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXKWKG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:06:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40739 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXKWKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:06:58 -0500
Date: Fri, 23 Nov 2007 11:06:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Daniel Drake <dsd@gentoo.org>
cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Message-ID: <Pine.LNX.4.64.0711231059010.22668@fbirervta.pbzchgretzou.qr>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23 2007 00:15, Daniel Drake wrote:
>
>What's the definition of an unaligned access?
>=============================================
>
>Unaligned memory accesses occur when you try to read N bytes of data starting
>from an address that is not evenly divisible by N (i.e. addr % N != 0).
>For example, reading 4 bytes of data from address 0x10000004 is fine, but
>reading 4 bytes of data from address 0x10000005 would be an unaligned memory
>access.
>
Try shorter numbers, like 0x10005 :)


>Code that doesn't cause unaligned access
>========================================

In written style, not using n't contracted forms might be preferable.


>Sidenote: in the above example, you may wish to reorder the fields in the
>above structure so that the overall structure uses less memory. For example,
>moving field3 to sit inbetween field1 and field2 (where the padding is
>inserted) would shrink the overall structure by 1 byte:
>
>	struct foo {
>		u16 field1;
>		u8 field3;
>		u32 field2;
>	};
>
>Sidenote: it should be obvious by now, but in case it is not, accessing a
>single byte (u8 or char) can never cause an unaligned access, because all
>memory addresses are evenly divisible by 1.

Sidenote: You would want an alignment like this:

	struct foo {
		uint32_t field2;
		uint16_t field1;
		uint8_t field3;
	};


>Consider the following structure:
>	struct foo {
>		u16 field1;
>		u32 field2;
>		u8 field3;
>	} __attribute__((packed));
>
>It's the same structure as we looked at earlier, but the packed attribute has
>been added. This attribute ensures that the compiler never inserts any padding
>and the structure is laid out in memory exactly as is suggested above.
>
>The packed attribute is useful when you want to use a C struct to represent
>some data that comes in a fixed arrangement 'off the wire'.
>
In the packed case, does not GCC automatically output extra instructions to not
run into unaligned access?

>To avoid the unaligned memory access, you could rewrite it as follows:
>
>	void myfunc(u8 *data, u32 value)
>	{
>		[...]
>		value = cpu_to_le32(value);
>		memcpy(data, value, sizeof(value));
>		[...]
>	}
>
>It's safe to assume that memcpy will always copy bytewise and hence will
>never cause an unaligned access.
>
Usually it copies register-size-wise where possible and bytesize at the
left and right edges if they are unaligned. That's how glibc memcpy does it,
not sure how complete the kernel memcpy is in this regard.
