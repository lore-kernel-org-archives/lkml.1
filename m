Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZHDMol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZHDMol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZHDMol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:44:41 -0400
Received: from www84.your-server.de ([213.133.104.84]:48431 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZHDMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:44:40 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200908041424.54472.arnd@arndb.de>
References: <1249306755.8358.8.camel@wall-e>
	 <200908032100.35892.arnd@arndb.de> <1249328898.5106.44.camel@wall-e>
	 <200908041424.54472.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 14:44:37 +0200
Message-Id: <1249389877.11474.14.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 04.08.2009, 14:24 +0200 schrieb Arnd Bergmann:
> On Monday 03 August 2009, Stefani Seibold wrote:
> > Am Montag, den 03.08.2009, 21:00 +0200 schrieb Arnd Bergmann:
> > 
> > DECLARE_KFIFO looks for me more useful, because i can use it inside a
> > struct decalaration. And then i need INIT_KFIFO for initializing this.
> > 
> > BTW: DECLARE_...., DEFINE_..... and INIT_..... are linux style. Habe a
> > look at workqueue.h, wait.h, types.h, semaphore.h, rwsem-spinlock.h,
> > interrupt.h, completion.h, seqlock.h and so on....
> 
> Yes, you are right. I realized that myself after I sent out my
> comments.
> 
> > > 1. you can no longer use preallocated buffers, which limits the possible
> > > users to those that are unrestricted to the type of allocation.
> > > 2. The size of the buffer is no longer power-of-two. In fact, it's guaranteed
> > > to be non-power-of-two because kmalloc gives you a power-of-two allocation
> > > but now you also put the struct kfifo in there.
> > > 
> > > Users that need a power-of-two buffer (the common case) now waste almost
> > > 50% of the space.
> > > 
> > 
> > Okay, give me a thought about this....... yes you are right ;-( But what
> > is with vmalloc? 128 MB should be enough?
> 
> vmalloc also has performance problems on some architectures that can
> access the linear mapping faster than paged memory and it is
> rather wasteful if you have 64kb pages.
> 
> I don't think the total size matters, the 128 MB limit only exists
> if you have a 32 bit CPU and 1GB or more of memory, which is hopefully
> getting rarer and already causes other problems (highmem...).
> 
> kmalloc currently limits the kfifo size to something like 128kb (arch
> specific), if you need more than that, you need alloc_pages(), which
> is limited to a power-of-two amount of pages.
> 

You are right, i don't like vmalloc too. It was only a first thought ;-)

> > > The requirement for power-of-two also meant a much faster __kfifo_off
> > > function on certain embedded platforms that don't have an integer division
> > > instruction in hardware.
> >
> > Yes i know this argument, but since the day of the 6502 and Z80 i have
> > never seen this kind of CPU. Okay i forgot to mention the stupid ARM
> > CPU, but newer ARM cores have a hardware division support.
> 
> I think this is actually more relevant than the vmalloc limit you mentioned,
> demand for tiny processors will probably stay because of cost reasons.
> Architectures that we support in Linux without integer divide include
> arm, blackfin, h8300, ia64 (!), m68k, microblaze, sh and xtensa.
> 

I'm embedded developer too... so i know what you mean. But for the fifo
this is not really a problem, managing and copying the data will be the
bigger amount. But with my new version i go back to the old power of two
method.

> Your first version with the non-power-of-two buffers also had a bug
> in the handling because it would not handle 32 bit integer overflows
> correctly. To get those right, you need an extra branch every time you
> add to the counter.
> 

Ooops, that was a real bug... Thanks.

> Your second version is ok in this regard because it uses the original
> size logic.

Does it mean you like it now ;-) ???? I think we are on a good way!

> 
> 	Arnd <><

Stefani <\_,


