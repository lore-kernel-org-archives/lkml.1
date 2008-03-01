Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYCALp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYCALp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYCALpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:45:20 -0500
Received: from www.tglx.de ([62.245.132.106]:49830 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYCALpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:45:18 -0500
Date: Sat, 1 Mar 2008 12:44:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 1/2] infrastructure to debug (dynamic) objects
In-Reply-To: <20080301025134.d9c74110.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803011215490.11084@apollo.tec.linutronix.de>
References: <20080301100019.640027768@linutronix.de> <20080301100325.593267564@linutronix.de> <20080301025134.d9c74110.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Andrew Morton wrote:
> On Sat, 01 Mar 2008 10:24:56 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:
> > The debug code can be compiled in without being active. The runtime
> > overhead is minimal and could be optimized by asm alternatives. A
> > kernel command line option enables the debugging code.
> > 
> 
> hm.
> 
> The enabled-via-command-line thing is a bit sad.  I guess runtime
> switchability would be hard.

Yes, keeping track of such stuff from some random state is not really
a good idea.
 
> The proof of this pudding is "how many subsystems use it".  If things like
> the fault-injection framework are a guide, the answer is "zero unless
> Thomas does it".  Call me an experienced cynic.

Hey, I'm as much a cynic as you. It just bothered me to hack this
solely into the timer code with the knowledge that there are other
potential users lurking. 

And I want to have it in the timer code for a simple reason: Everytime
when the timer list code explodes due to some stupid timer_list user,
I'm the moron who has to apply hackery to help the users to identify
the root cause. This happened more than 5 times in the last 3 month
and I'm fed up with keeping my ugly debug hackery up to date and
instruct bug reporters how to use it. The delta to get down to the
cause of the problem in the example case is: 

      one mail versus five.
      zero patch vs. finding and updating the old version

I have better ways to waste my sparse leisure time :)

You can be sure, that I will add the specific debug code to other
parts of the kernel whenever I trap over a problem which smells like
the kfree'd or reinitialized timer wreckage.
 
> > +enum debug_obj_op {
> > +	ODEBUG_INIT,
> > +	ODEBUG_ADD,
> > +	ODEBUG_DEL,
> > +	ODEBUG_FREE,
> > +	ODEBUG_TEST,
> > +};
> 
> Interface nit: five different API calls would be preferable to one call
> with a mode argument.

Will do.

> > +enum {
> > +	ODEBUG_TYPE_UNKNOWN,
> > +	ODEBUG_MAX_TYPES
> > +};
> 
> The need for each client to patch this table is regrettable.

I did not bother with a dynamic register interface before getting some
feedback on the idea in general. Will do when there is some agreement
that this is a useful infrastructure in general.

> > --- linux-2.6.orig/include/linux/mm.h
> > +++ linux-2.6/include/linux/mm.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/rbtree.h>
> >  #include <linux/prio_tree.h>
> >  #include <linux/debug_locks.h>
> > +#include <linux/debugobjects.h>
> >  #include <linux/mm_types.h>
> >  
> >  struct mempolicy;
> 
> I suspect this wasn't supposed to be here.

Well, I'm lazy as hell and I found the debug_locks.h include already,
which was added for the same reason: not adding the include to all the
affected files in mm/

Btw. DEBUG_LOCK_ALLOC is a perfect candidate to move over to this as
the current code only detects locks held by the calling thread, while
debugobjects detects also a lock held by any owner.

> > +
> > +#define ODEBUG_HASH_SIZE	4096
> 
> power-of-2 is said to be a very poor size for a hash table.

The hash is not a randomized hash as one would expect. It's purely
generated from the object address to simplify the lookup during the
free check. So the power of 2 size is a good thing :) /me adds
comment.

> > +#define ODEBUG_HASH_MASK	(ODEBUG_HASH_SIZE - 1)
> > +
> > +struct odebug {
> > +	struct list_head list;
> 
> hlist?

Good point.
 
> > +	spinlock_t lock;
> > +};
> > +
> > +static struct odebug obj_hash[ODEBUG_HASH_SIZE];
> > +
> > +static int debug_objects_selftest __read_mostly;
> > +static int debug_objects_maxchain __read_mostly;
> > +static int debug_objects_fixups __read_mostly;
> > +static int debug_objects_enabled __read_mostly;
> > +
> > +static int __init enable_object_debug(char *str)
> > +{
> > +	debug_objects_enabled = 1;
> > +	return 0;
> > +}
> > +
> > +early_param("debug_objects", enable_object_debug);
> 
> I can never remember whether these things need to return 0 or 1 on success.

Same here. As usual I copied it from some other place assuming that it
was correct there. Will check.
 
> <looks at debug_kernel(), quiet_kernel() and loglevel().  Shudders.
> Moves on.>

Hehehe.

Thanks for the review,

       tglx
