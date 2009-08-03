Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZHCTsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZHCTsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZHCTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:48:30 -0400
Received: from www84.your-server.de ([213.133.104.84]:42976 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZHCTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:48:30 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200908032100.35892.arnd@arndb.de>
References: <1249306755.8358.8.camel@wall-e>
	 <200908032100.35892.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 21:48:18 +0200
Message-Id: <1249328898.5106.44.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.08.2009, 21:00 +0200 schrieb Arnd Bergmann:
> Going through your list again:
> 
> On Monday 03 August 2009, Stefani Seibold wrote:
> > - Generic usage: For kernel internal use or device driver
> 
> no change here, right?
> 
> > - Linux style habit: DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros

> DEFINE_KFIFO looks useful, but I probably wouldn't expose
> the other macros, so you could define them as __KFIFO_* or
> integrate them into a larger DEFINE_KFIFO.
> 

DECLARE_KFIFO looks for me more useful, because i can use it inside a
struct decalaration. And then i need INIT_KFIFO for initializing this.

BTW: DECLARE_...., DEFINE_..... and INIT_..... are linux style. Habe a
look at workqueue.h, wait.h, types.h, semaphore.h, rwsem-spinlock.h,
interrupt.h, completion.h, seqlock.h and so on....

> > - Ability to handle variable length records. Three type of records are
> >   supported:
> >   - Records between 0-255 bytes, with a record size field of 1 bytes
> >   - Records between 0-65535 bytes, with a record size field of 2 bytes
> >   - Byte stream, which no record size field
> >   Inside a fifo this record types it is not a good idea to mix them together.
> 
> Not sure if having both 1 and 2 byte record lengths really helps.
> If you want to avoid mixing the two, maybe just leave the existing
> API for byte streams in a compatible, and provide extra functions
> for records with a definite length.
> 

Streams are only a specially case of a very huge record. I personally
never needed records greater than 65535 byte. But i is easy to extend it
to support 3 and 4 byte records length field too. 

And mixing different record size fields makes no sense. If you know that
your records can be create than 255 bytes then use a 2 byte record
field. It is only the recsize parameter, which can be 0, 1 or 2.

0 means byte stream mode, 1 means records size from 0 to 255, and 2
means records size from 0 to 65535. 

It is designed like any other container or lists in the linux kernel.
The developer must know what she is doing ;-) Error checking wastes cpu
rescources.

> > - Direct copy_to_user from the fifo and copy_from_user into the fifo.
> 
> Sounds useful, as mentioned.
> 
> > - Single structure: The fifo structure contains the management variables and
> >   the buffer. No extra indirection is needed to access the fifo buffer.
> 
> I see two problems here:
> 
> 1. you can no longer use preallocated buffers, which limits the possible
> users to those that are unrestricted to the type of allocation.
> 2. The size of the buffer is no longer power-of-two. In fact, it's guaranteed
> to be non-power-of-two because kmalloc gives you a power-of-two allocation
> but now you also put the struct kfifo in there.
> 
> Users that need a power-of-two buffer (the common case) now waste almost
> 50% of the space.
> 

Okay, give me a thought about this....... yes you are right ;-( But what
is with vmalloc? 128 MB should be enough?

> The requirement for power-of-two also meant a much faster __kfifo_off
> function on certain embedded platforms that don't have an integer division
> instruction in hardware.
> 

Yes i know this argument, but since the day of the 6502 and Z80 i have
never seen this kind of CPU. Okay i forgot to mention the stupid ARM
CPU, but newer ARM cores have a hardware division support.

Stefani <\_,
         ^ ^


