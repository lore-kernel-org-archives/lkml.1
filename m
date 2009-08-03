Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZHCTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZHCTA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZHCTA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:00:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZHCTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:00:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Mon, 3 Aug 2009 21:00:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1249306755.8358.8.camel@wall-e>
In-Reply-To: <1249306755.8358.8.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908032100.35892.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cpJyzPxGzPw6H1ECVYzlmsclqtwaFgxoJwHz
 SsXBj7h1PAKKcwSvCi2MVWePA0X+qzyuceQlBFaMGvEbd4wD4I
 OEBx/39vWtMw+Pa9jL1vw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going through your list again:

On Monday 03 August 2009, Stefani Seibold wrote:
> - Generic usage: For kernel internal use or device driver

no change here, right?

> - Linux style habit: DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros

DEFINE_KFIFO looks useful, but I probably wouldn't expose
the other macros, so you could define them as __KFIFO_* or
integrate them into a larger DEFINE_KFIFO.

> - Ability to handle variable length records. Three type of records are
>   supported:
>   - Records between 0-255 bytes, with a record size field of 1 bytes
>   - Records between 0-65535 bytes, with a record size field of 2 bytes
>   - Byte stream, which no record size field
>   Inside a fifo this record types it is not a good idea to mix them together.

Not sure if having both 1 and 2 byte record lengths really helps.
If you want to avoid mixing the two, maybe just leave the existing
API for byte streams in a compatible, and provide extra functions
for records with a definite length.

> - Direct copy_to_user from the fifo and copy_from_user into the fifo.

Sounds useful, as mentioned.

> - Single structure: The fifo structure contains the management variables and
>   the buffer. No extra indirection is needed to access the fifo buffer.

I see two problems here:

1. you can no longer use preallocated buffers, which limits the possible
users to those that are unrestricted to the type of allocation.
2. The size of the buffer is no longer power-of-two. In fact, it's guaranteed
to be non-power-of-two because kmalloc gives you a power-of-two allocation
but now you also put the struct kfifo in there.

Users that need a power-of-two buffer (the common case) now waste almost
50% of the space.

The requirement for power-of-two also meant a much faster __kfifo_off
function on certain embedded platforms that don't have an integer division
instruction in hardware.

> - Lockless access: if only one reader and one writer is active on the fifo,
>   which is the common use case, there is no additional locking necessary.

The existing API already provides this, you can simply call __kfifo_put()
and __kfifo_get() directly, rather than their wrappers, which are just
helpers to make the code more robust. Half the existing users do that
already.

	Arnd <><
