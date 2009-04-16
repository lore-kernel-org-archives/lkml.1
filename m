Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZDPSEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZDPSEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZDPSEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:04:43 -0400
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:40316 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755992AbZDPSEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:04:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] block/genhd.c: fix sparse warning
Date: Thu, 16 Apr 2009 14:03:39 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8F6D@mi8nycmail19.Mi8.com>
In-Reply-To: <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] block/genhd.c: fix sparse warning
Thread-Index: Acm+TlJsOPUNtDdxRZmcQpF5RIb0qAAa8Qjg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com> <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 18:04:39.0760 (UTC) FILETIME=[CF964D00:01C9BEBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 15, 2009 9:47 PM, Vegard Nossum wrote:
>> Fix sparse warning in block/genhd.c.
>>
>>        warning: symbol '__mptr' shadows an earlier one
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Hi,
>
> Just a heads up: There seems to be some sort of consensus that
> this type of patch title is not a very good one. (What about
> "remove variable shadowing"?)

Sorry, I wasn't aware of that. I just started using sparse and was
cleaning up some warnings in the arch/arm/mach-ep93xx branch. I
noticed this warning and it seemed like a simple fix.

> It would also be nice to have an explanation of where the __mptr
> symbol comes into play, because it doesn't even appear in the
> patch, and reviewers would likely have an easier job if they
> knew where to look it up.

The only __mptr symbol in the source is in the container_of() macro
in include/linux/kernel.h:

	#define container_of(ptr, type, member) ({			\
		const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
		(type *)( (char *)__mptr - offsetof(type,member) );})

The sparse warning shows up when a macro expansion ends up with
something like:

	type1 val = container_of(container_of(ptr2, type2, member2),
						type1, member1);

> Was this warning harmless, or was the code in fact broken?

Should be harmless, the scope of __mptr should only be in the macro.

> Can we rewrite container_of() to not use an extra variable (__mptr),
> or perhaps using an inline function for part of the computation?

Maybe something like:

	#define container_of(ptr, type, member) ({			\
		const typeof( ((type *)0)->member ) *__m_##ptr = (ptr);	\
		(type *)( (char *)__m_##ptr - offsetof(type,member) );})

I don't know if that actually works. ;-)


> Do we also have this problem in expressions like max(max(x, y), z)?

That should generate the same sparse warning since each max() has a
couple of local variables (_min1 and _min2).

> Thanks :-)

Not a problem. Just trying to help!

Regards,
Hartley
