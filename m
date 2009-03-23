Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZCWVNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZCWVNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZCWVNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:13:11 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:63306 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZCWVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:13:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] degrade severity of lockdep printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090323203958.GD19208@bombadil.infradead.org>
References: <20090323201628.GB19208@bombadil.infradead.org>
	 <20090323202054.GA6395@elte.hu>
	 <20090323202831.GC19208@bombadil.infradead.org>
	 <1237840355.24918.80.camel@twins>
	 <20090323203958.GD19208@bombadil.infradead.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 22:12:48 +0100
Message-Id: <1237842768.24918.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 16:39 -0400, Kyle McMartin wrote:
> On Mon, Mar 23, 2009 at 09:32:35PM +0100, Peter Zijlstra wrote:
> > > Although I don't really see how this can be particularly fixed, since
> > > any workload that allocates a struct with a lock, initializes, and then
> > > eventually frees it a whole bunch of times will run out of lock_lists
> > > won't it?
> > 
> > Not if the lock init site doesn't change. Modules are the big exception,
> > cycling modules will run you out of lockdep space..
> > 
> 
> Somewhat confused by this... possibly I'm just being thick and missing
> some subtlety though, but surely the context is equally important?
> I mean, the locks held on entry to, say, a fs_operations struct member
> function could be different on every different possible callpath...

I'm thinking we're not quite understanding each other here, so let me
try and explain things (hopefully more clearly).

Each lock gets a key object, this key object must be in static storage.
Static lock objects: eg.

static spinlock_t my_lock;

can use the spinlock_t iteslf as key, dynamic objects:

 struct my_struct {
   spinlock_t lock;
   ...
 };

 struct my_struct *my_obj = kmalloc(sizeof(*my_obj), GFP_KERNEL);
 spin_lock_init(&my->obj->lock);

will use a static storage associated with the init site:

# define spin_lock_init(lock)                                   \
do {                                                            \
        static struct lock_class_key __key;                     \
                                                                \
        __spin_lock_init((lock), #lock, &__key);                \
} while (0)

So, no matter how many my_struct instances you allocate/free, it will
not be more or less objects for lockdep. All that matters are the static
key objects.

Each key object creates a lock-class. And these lock_list thingies which
we're running low on are used to encode the relationships between such
classes.

This relation is again, purely static, its a property of the code. And
unless we have an in-kernel JIT, that doesn't change (only thing is,
we're detecting them dynamically -- but their structure is already
encoded in the code).

Now the second thing you mention, callpaths -- distinctly different from
structure instances -- these are static and predetermined at compile
time.


Now, since we're detecting these things are run-time, since we have to
deduce them from our code structure, we need this allocation stuff, and
it might turn out our estimates were too low, or alternatively, our lock
dependencies have bloated over time (certainly possible).


All this gets messed up with module unloading, we find all keys in the
module space we're about to unload and destroy all related and derived
information we had about them -- _NOT_ releasing anything back to these
static pools like the list_entries[] array.

So a module load/unload cycle will eat lockdep storage like crazy.

We could possibly fix that, but it will add complexity, which imho isn't
worth it -- just say no to modules :-)

