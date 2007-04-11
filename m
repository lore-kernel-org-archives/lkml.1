Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXDKEJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXDKEJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXDKEJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:09:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:32947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030384AbXDKEJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rabQhb85o9f71kmB3Q2GSFgRIWoV3BcmcH4YLjRm+w3UKkH8R/EJTyA1VflN4KSmq/tGNZce0/p78HhHA5bJPP4fvHutHfsHLE5qQKkQlbGca5XTjCUqQGXf9iVch7deWXQubiyM0XKFvDBnvBD4Jxrr5Qrics7ZkjugQVQMmnM=
Message-ID: <3b44d3fb0704102109g380bbb04v3579a94e1b6dabe1@mail.gmail.com>
Date: Wed, 11 Apr 2007 09:39:16 +0530
From: "Milind Arun Choudhary" <milindchoudhary@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [KJ] remove SPIN_LOCK_UNLOCKED
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, kernelnewbies@nl.linux.org,
       kernel-janitors@lists.osdl.org, "Roland Dreier" <rdreier@cisco.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070410220804.GI26692@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410181654.GA10525@arun.site>
	 <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
	 <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
	 <Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr>
	 <ada7isjq52p.fsf@cisco.com>
	 <Pine.LNX.4.64.0704101743520.24794@CPE00045a9c397f-CM001225dbafb6>
	 <20070410220804.GI26692@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Apr 10, 2007 at 05:45:07PM -0400, Robert P. J. Day wrote:
> > that works fine if you're defining a single spinlock, but what do you
> > do in cases like this:
> >
> > arch/sparc/lib/atomic32.c:      [0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
> >
> > that is, when you're assigning an array of them?  you still need some
> > kind of generic, unnamed spinlock in those circumstances, no?
>
> That's a special case for architecture-only code.  It's not to be used
> by drivers.
as per my understanding, [which i should have keyed in earlier]
different places where SPIN_LOCK_UNLOCKED currently appears are

1. static spinlock_t foobar = SPIN_LOCK_UNLOCKED;
needs to be replaced bye DEFINE_SPINLOCK

e.g  linux-core/drm_memory_debug.h
-static spinlock_t drm_mem_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(drm_mem_lock);

there are very few occurrences left in the tree i see

2. allocating a data structure dynamically
& initializing the spinlock embedded within

use spin_lock_init()
e.g   linux-core/via_dmablit.c

-               blitq->blit_lock = SPIN_LOCK_UNLOCKED;
+               spin_lock_init(&blitq->blit_lock);

3. static initialization of structure members
struct foo bar ={
.
.
.
.lock = SPIN_LOCK_UNLOCKED,
.
}
use
struct foo bar ={
.
.
.
.lock = __SPIN_LOCK_UNLOCKED(bar.lock),
.
}

e.g arch/i386/kernel/traps.c
-		.lock =			SPIN_LOCK_UNLOCKED,
+		.lock =			__SPIN_LOCK_UNLOCKED(die.lock),

plenty of these are still there
may be some patches queued


4. arrays of spinlocks
e.g arch/cris/arch-v32/kernel/smp.c

-spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] =
SPIN_LOCK_UNLOCKED};
+raw_spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] =
__RAW_SPIN_LOCK_UNLOCKED};


my question is still there in the original post
about spin_lock_init()

CMIIW
Refer:
http://lkml.org/lkml/2005/6/20/47
http://lkml.org/lkml/2007/1/16/90
http://lists.openwall.net/linux-kernel/2007/02/01/258
-- 
Milind Arun Choudhary
