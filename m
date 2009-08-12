Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZHLQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZHLQn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZHLQn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:43:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZHLQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:43:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 0/7] new kfifo API
Date: Wed, 12 Aug 2009 18:43:21 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
References: <1250029873.17599.98.camel@wall-e> <200908121658.16689.arnd@arndb.de> <1250090902.21135.26.camel@wall-e>
In-Reply-To: <1250090902.21135.26.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121843.21123.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iHP2+xd20EReR6KV2b8HsVVCmJdhJD33wk46
 b0BhpdjYXwDNgYtnppwMqvpaIXGLnOCQvkf6F/VMWnoFHpk2om
 XAwZGsa3ZVz3zLPClvpVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Stefani Seibold wrote:
> Am Mittwoch, den 12.08.2009, 16:58 +0200 schrieb Arnd Bergmann:
> > On Wednesday 12 August 2009, Stefani Seibold wrote:
> > > This is a proposal of a new generic kernel FIFO implementation.

> > Making the fifo itself a member of the data structure is
> > a very good idea, which should be what the changeset
> > comment describes (why that is done, not how of course).
> > 
> > The other change in here is that you add a 'spinlock_t *'
> > argument to kfifo_alloc and kfifo_init. AFAICT this is
> > unrelated, and it gets reverted by the next patch, so it
> > would be more straightforward to leave that change out.
> > 
> 
> That is the problem: If i do to much in one patch set it is bad... but
> if i try to make smaller patch which are viable, than i need some
> intermediate steps. So what is the right way???

In general, smaller patches are better. As I said above, your
patch 1 actually does two things when it should just do one.

Since the patch immediately following it undoes one of the two
changes, the right option is to not do that part at all.
   
> > >  Part 2: Move out spinlock
> > 
> > I don't see this one as worthwhile, but I don't mind
> > either. The contents look correct. 
> 
> Andrew like the idea too, because it gibe the user the freedom of choice
> which locking he needs, in most case no locking is required.

Well, the original code already gives you the option by calling
__kfifo_get instead of __kfifo_put, as a number of drivers do.
Your patch does not change that, it only means that you save a few
bytes in the kfifo struct if you don't use a lock.

This was one of the options suggested for the initial submission
of the kfifo API back in 2004, and it was not chosen for some reason.
As I said, I don't mind much either way, but ideally you would try
to find out what the reason for doing it the other way initially
was, and describing in your patch what has changed now.

I suppose something along the lines of "we used to think that most
users would need the lock, it turned out that most actually don't,
so let's safe a tiny bit of space and time for the common case" would
do.

> > That one is new, right?
> > 
> > It's probably better to have this, just to make sure everyone
> > understands that the API is different now and no (out of tree)
> > drivers or patches accidentally break.
> 
> Yes, it new. It was your suggestion to make the new API miss use save. I
> like the idea, but i am not very happy with the names. The old names was
> much more logical.

Well, it's probably bad to move to a less logical naming, so if you
can't come up with something that is as good as the old one but still
different, you might want to leave this change out after all.

> > >  Part 7: add record handling functions (does some reorg)
> > 
> > This one adds a lot of extra complexity in unused code.
> > I'll add my Acked-by to the first six patches if you do the
> > minor modifications I mention above, but for the last one,
> > I suggest you either add an actual user of that code, or find
> > someone else to advocate its inclusion.
> 
> Thats the reason why i made a separate patch for this. But i fixed a lot
> of your objections since last time. Please have a look on it. It solves
> much of the use case needed by the current users.
> 
> a.) It doesn't copy anything if the FIFO supply not enough data
> b.) It doesn't copy anything if the target buffer has not enough space
> c.) It returns the number of bytes which could not copied, or 0 if okay.
> This makes error handling much easier.
> d.) It gives device driver developer more flexibility to store variable
> length data into the FIFO.
> e.) It also gives a better support for fixed record size entries.

ok, good. I'll have another look the next time you submit this.

> I still have an actual user for this... a lot of my device drivers
> depend on it and some of them are also interesting for the community,
> like my USB NRP-Sensor (Rohde&Schwarz) driver. 

Ok, fair enough, that's all I was asking for. So I guess you should just
leave out this patch from the current series and submit it together with
one of your drivers using the interface. That will make it much clearer
how the code is used.

	Arnd <><
