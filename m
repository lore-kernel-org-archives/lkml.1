Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZHDMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZHDMZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZHDMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:25:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbZHDMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:25:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Tue, 4 Aug 2009 14:24:54 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1249306755.8358.8.camel@wall-e> <200908032100.35892.arnd@arndb.de> <1249328898.5106.44.camel@wall-e>
In-Reply-To: <1249328898.5106.44.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041424.54472.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+51osQ1VCMjtgApwsevfXqc/ql8V8qFLXmae4
 IkK1hPR6mZgQSN58ESnA3sK7yQGjRL4FGSJFbDchXSD0bhx2IH
 QkEEUh9Q7XWqf+Ob2qKNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Stefani Seibold wrote:
> Am Montag, den 03.08.2009, 21:00 +0200 schrieb Arnd Bergmann:
> 
> DECLARE_KFIFO looks for me more useful, because i can use it inside a
> struct decalaration. And then i need INIT_KFIFO for initializing this.
> 
> BTW: DECLARE_...., DEFINE_..... and INIT_..... are linux style. Habe a
> look at workqueue.h, wait.h, types.h, semaphore.h, rwsem-spinlock.h,
> interrupt.h, completion.h, seqlock.h and so on....

Yes, you are right. I realized that myself after I sent out my
comments.

> > 1. you can no longer use preallocated buffers, which limits the possible
> > users to those that are unrestricted to the type of allocation.
> > 2. The size of the buffer is no longer power-of-two. In fact, it's guaranteed
> > to be non-power-of-two because kmalloc gives you a power-of-two allocation
> > but now you also put the struct kfifo in there.
> > 
> > Users that need a power-of-two buffer (the common case) now waste almost
> > 50% of the space.
> > 
> 
> Okay, give me a thought about this....... yes you are right ;-( But what
> is with vmalloc? 128 MB should be enough?

vmalloc also has performance problems on some architectures that can
access the linear mapping faster than paged memory and it is
rather wasteful if you have 64kb pages.

I don't think the total size matters, the 128 MB limit only exists
if you have a 32 bit CPU and 1GB or more of memory, which is hopefully
getting rarer and already causes other problems (highmem...).

kmalloc currently limits the kfifo size to something like 128kb (arch
specific), if you need more than that, you need alloc_pages(), which
is limited to a power-of-two amount of pages.

> > The requirement for power-of-two also meant a much faster __kfifo_off
> > function on certain embedded platforms that don't have an integer division
> > instruction in hardware.
>
> Yes i know this argument, but since the day of the 6502 and Z80 i have
> never seen this kind of CPU. Okay i forgot to mention the stupid ARM
> CPU, but newer ARM cores have a hardware division support.

I think this is actually more relevant than the vmalloc limit you mentioned,
demand for tiny processors will probably stay because of cost reasons.
Architectures that we support in Linux without integer divide include
arm, blackfin, h8300, ia64 (!), m68k, microblaze, sh and xtensa.

Your first version with the non-power-of-two buffers also had a bug
in the handling because it would not handle 32 bit integer overflows
correctly. To get those right, you need an extra branch every time you
add to the counter.

Your second version is ok in this regard because it uses the original
size logic.

	Arnd <><
