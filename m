Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbYF3SVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbYF3SVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763651AbYF3SVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:21:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763847AbYF3SVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:21:01 -0400
Date: Mon, 30 Jun 2008 20:20:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [git pull] core kernel fixes
Message-ID: <20080630182038.GA32211@elte.hu>
References: <20080630153200.GA22360@elte.hu> <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Mon, Jun 30, 2008 at 5:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> > index a76a5e1..85b18d7 100644
> > --- a/lib/debugobjects.c
> > +++ b/lib/debugobjects.c
> > @@ -68,6 +68,7 @@ static int fill_pool(void)
> >  {
> >        gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
> >        struct debug_obj *new;
> > +       unsigned long flags;
> >
> >        if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
> >                return obj_pool_free;
> > @@ -81,10 +82,10 @@ static int fill_pool(void)
> >                if (!new)
> >                        return obj_pool_free;
> >
> > -               spin_lock(&pool_lock);
> > +               spin_lock_irqsave(&pool_lock, flags);
> >                hlist_add_head(&new->node, &obj_pool);
> >                obj_pool_free++;
> > -               spin_unlock(&pool_lock);
> > +               spin_unlock_irqrestore(&pool_lock, flags);
> >        }
> >        return obj_pool_free;
> >  }
> > @@ -110,16 +111,13 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
> >  }
> >
> >  /*
> > - * Allocate a new object. If the pool is empty and no refill possible,
> > - * switch off the debugger.
> > + * Allocate a new object. If the pool is empty, switch off the debugger.
> >  */
> >  static struct debug_obj *
> >  alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
> >  {
> >        struct debug_obj *obj = NULL;
> > -       int retry = 0;
> >
> > -repeat:
> >        spin_lock(&pool_lock);
> >        if (obj_pool.first) {
> >                obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
> > @@ -141,9 +139,6 @@ repeat:
> >        }
> >        spin_unlock(&pool_lock);
> >
> > -       if (fill_pool() && !obj && !retry++)
> > -               goto repeat;
> > -
> >        return obj;
> >  }
> >
> > @@ -261,6 +256,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
> >        struct debug_obj *obj;
> >        unsigned long flags;
> >
> > +       fill_pool();
> > +
> >        db = get_bucket((unsigned long) addr);
> >
> >        spin_lock_irqsave(&db->lock, flags);
> > --
> 
> Hm. I have to wonder where this patch came from.
> 
> This was my (faulty) patch: http://lkml.org/lkml/2008/6/14/193
> and Daniel J Blueman followed up with this: http://lkml.org/lkml/2008/6/15/27
> 
> ..but this one looks different from both. I am guessing the last bits 
> were added (or removed?) by Thomas?
> 
> I am wondering if the final patch was tested with the reproducible 
> test case (if so, by whom?) and whether should be credited to Daniel 
> (or Thomas?) instead...

You can use "git log -1 -p --pretty=fuller 50db04dd9c" to see the exact 
details of the commit:

----------
| commit 50db04dd9c74178e68a981a7127c37252ffb3242
| Author:     Vegard Nossum <vegard.nossum@gmail.com>
| AuthorDate: Sun Jun 15 00:47:36 2008 +0200
| Commit:     Thomas Gleixner <tglx@linutronix.de>
| CommitDate: Wed Jun 18 11:09:54 2008 +0200
|
| [...]
|
|   [ daniel.blueman@gmail.com: pool_lock needs to be taken irq safe in fill_pool ]
|
|   Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
|   Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
|   Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
----------

As you can see it from the Commit line, it was committed by Thomas.

The "[ daniel.blueman: pool_lock ... ]" line shows that Thomas - instead 
of creating two commits - merged the two fixes into a single commit and 
credited Daniel for the irq-safe fix. This is the standard technique to 
squash small patches and to make fixes multi-authored.

The patch was tested with our standard tests so it's certainly good in 
practice - but i havent specifically tried your testcase (maybe Thomas 
has). Can you see any problem with the fix?

	Ingo
