Return-Path: <linux-kernel-owner+w=401wt.eu-S1161003AbXBGGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003AbXBGGQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161012AbXBGGQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:16:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:34184 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161003AbXBGGQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DQIBwPK24RqRLvC+Ca323bIXj4TSfaGq9YDUd637KAWOwS8ChyWaht2FCfQWqsEplTl2fJWxrP82qobNoJXQO/iE4C5pmkKG1QAMa0a7ewtkf/EmQvF7K/NHyeqFvaDRqzECCjdnxTAqxkvHO/0pz+S1/PqB7f4OquiZ4JlIQvY=
Message-ID: <f2b55d220702062216n6b6757e5h10701851b422bc62@mail.gmail.com>
Date: Tue, 6 Feb 2007 22:16:46 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>,
       "Kent Overstreet" <kent.overstreet@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070207004443.GE32307@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
	 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
	 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
	 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
	 <20070206233907.GW32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
	 <20070207000626.GC32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
	 <20070207004443.GE32307@ca-server1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Joel Becker <Joel.Becker@oracle.com> wrote:
>         Not everything is in-cache.  Databases will be doing O_DIRECT
> and will expect that 90% of their I/O calls will block.  Why should they
> have to iterate this list every time?  If this is the API, they *have*
> to.  If there's an efficient way to get "just the ones that didn't
> block", then it's not a problem.

It's usually efficient, especially in terms of programmer effort, for
the immediate path to resemble as nearly as possible what you would
have done with the synchronous equivalent.  (If there's some value in
parallelizing the query across multiple CPUs, you probably don't want
the kernel guessing how to partition it.)  But what's efficient for
the delayed path is to be tightly bound to the arrival of the AIO
result, and to do little more than schedule it into the appropriate
event queue or drop it if it is stale.  The immediate and delayed
paths will often share part, but not all, of their implementation, and
most of the shared part is probably data structure setup that can
precede the call itself.  The rest of the delayed path is where the
design effort should go, because it's the part that has the sort of
complex impact on system performance that is hard for application
programmers to think clearly about.

Oracle isn't the only potential userspace user of massively concurrent
AIO with a significant, but not dominant, fraction of cache hits.  I'm
familiar with a similar use case in network monitoring, in which one
would like to implement the attribute tree and query translation more
or less as a userspace filesystem, while leaving both the front-end
caching and the back-end throttling, retries, etc. to in-kernel state
machines.  When 90% of the data requested by the front end (say, a
Python+WxWidgets GUI) is available from the VFS cache, only the other
10% should actually carry the AIO overhead.

Let's look at that immediately available fraction from the GUI
programmer's perspective.  He wants to look up some attributes from a
whole batch of systems, and wants to present all immediately available
results to the user, with the rest grayed out or something.  Each
request for data that is available from cache should result
immediately in a call to his (perhaps bytecode-language) callback,
which fills in a slot in the data structure that he's going to present
wholesale.  There's no reason why the immediate version of the
callback should be unable to allocate memory, poke at thread-local
structures, etc.; and in practice there's little to be gained by
parallelizing this fraction (or even aggressively delivering AIOs that
complete quickly) because you'd need to thread-safe that data
structure, which probably isn't worth it in performance and certainly
isn't in programmer effort and likelihood of Heisenbugs.

Delayed results, on the other hand, probably have to use the GUI's
event posting mechanism to queue the delivered data (probably in a
massaged form) into a GUI update thread.  Hence the delayed callback
can be delivered in some totally other context if it's VM- and
scheduler-efficient to do so; it's probably just doing a couple of
memcpys and a sem_post or some such.  The only reason it isn't a
totally separate chunk of code is that it uses the same context layout
as the immediate path, and may have to poke at some of the same
pre-allocated places to update completion statistics, etc.

(I implemented something similar to this in userspace using Python
generators for the closure-style callbacks, in the course of rewriting
a GUI that had a separate protocol translator process in place of the
userspace filesystem.  The thread pool that serviced responses from
the protocol translator operated much like Zach's fibrils, and used a
sort of lookup by request cookie to retrieve the closure and feed it
the result, which had the side effect of posting the appropriate
event.  It worked, fast, and it was more or less comprehensible to
later maintainers despite the use of Python's functional features,
because the AIO delivery was kept separate from both the plain-vanilla
immediate-path code and the GUI-idiom event queue processing.)

The broader issue here is that only the application developer really
knows how the AIO results ought to be funneled into the code that
wants them, which could be a database query engine or a GUI update
queue or Murphy knows what.  This "application AIO closure" step is
distinct from the application-neutral closure that needs to run in a
kernel "fibril" (extracting stat() results from an NFS response, or
whatever).  So it seems to me that applications ought to be able to
specify a userspace closure to be executed on async I/O completion (or
timeout, error, etc.), and this closure should be scheduled
efficiently on completion of the kernel bit.

The delayed path through the userspace closure would partly resemble a
signal handler in that it shouldn't touch thread or heap context, just
poke at pre-allocated process-global memory locations and/or
synchronization primitives.  (A closer parallel, for those familiar
with it, would be the "event handlers" of O/S's with cooperative
multitasking and a single foreground application; MacOS 6.x with
MultiFinder and PalmOS 4.x come to mind.)

What if we share a context+stack page between kernel and userspace to
be used by both the kernel "I/O completion" closure and the userspace
"event handler" closure?  After all, these are the pieces that
cooperatively multitask with one another.  Pop the kernel AIO closure
scheduler into the tasklet queue right after the softirq tasklet --
surely 99% of "fibrils" would become runnable due to something that
happens in a softirq, and it would make at least as much sense to run
there as in the task's schedule() path.  The event handler would be
scheduled in most respects like a signal handler in a POSIX threaded
process -- running largely in the context of some application thread
(on syscall exit or by preemption), and limited in the set of APIs it
can call.

In this picture, the ideal peristalsis would usually be ISR exit path
-> softirq -> kernel closure (possibly not thread-like at all, just a
completion scheduled from a tasklet) -> userspace closure ->
application thread.  The kernel and userspace closures could actually
share a stack page which also contains the completion context for
both.  Linus's async_stat() example is a good one, I think.  Here is
somewhat fuller userspace code, without the syntactic sugar that could
easily be used to make the callbacks more closure-ish:

/* linux/aeiou.h */
       typedef void (*aeiou_stat_cb_t) (int, struct aeiou_stat *);

       struct aeiou_stat __ALIGN_ME_PROPERLY__ {
               aeiou_stat_cb_t cb;        /* userspace completion hook */
               struct stat stat_buf;
               union {
                       int filedes;
                       char name[NAME_MAX+1];
               } u;
#ifdef __KERNEL__
               ... completion context for the kernel AIO closure ...
#endif
       }

       /* The returned pointer is the cookie for all */
       /* subsequent aeiou calls in this request group. */
       void *__aeiou_alloc_aeiou_stat(size_t uctx_bytes);

       #define aeiou_begin(ktype, utype, field) \
               (utype *)(__aeiou_alloc_##ktype(offsetof(utype, field))

/* foo.c */
       struct one_entry {
               ... closure context for the userspace event handler ...
               struct aeiou_stat s;
       }

       static void my_cb(int is_delayed, struct aeiou_stat *as) {
               struct one_entry *my_context = container_of(as, struct
one_entry, s);
               ... code that runs in userspace "event handler" context ...
       }

...

       struct one_entry *entry = aeiou_begin(aeiou_stat, struct one_entry, s);
       struct dirent *de;

       entry->s.cb = my_cb;
       /* set up some process-global data structure to hold */
       /* the results of this burst of async_stat calls */

       while ((de = readdir(dir)) != NULL) {
               strcpy(entry->s.u.name, de->d_name);
               /* set up any additional application context */
               /* in *entry for this individual async_stat call */

               aeiou_stat(entry);
       }
       /* application tracks outstanding AIOs using data structure */
       /* there could also be an aeiou_checkprogress(entry) */
       ...
       aeiou_end(entry);

(The use of "aeiou_stat" rather than a more general class of async I/O
calls is for illustration purposes.)

If the stat data is immediately available when aeiou_stat() is called,
the struct stat gets filled in and the callback is run immediately in
the current stack context.  If not, the contents of *entry are copied
to a new page (possibly using COW VM magic), and the syscall returns.
On the next trip through the scheduler (or when a large enough batch
of AIOs have been queued to be worth initiating them at the cost of
shoving the userspace code out of cache), the kernel closures are set
up in the opaque trailer to aeiou_stat in the copies, and the AIOs are
initiated.

The signature of aeiou_stat is deliberately limited to a single
pointer, since all of its arguments are likely to be interesting to
one or both closures.  There is no need to pass the offset to the
kernel parameter sub-struct into calls after the initial aeiou_begin;
the kernel has to check the validity of the "entry" pointer/cookie
anyway, so it had best keep track of the enclosing allocation bounds,
offset to the syscall parameter structure, etc. in a place where
userspace can't alter it.  Both kernel and userspace closures
eventually run with their stack in the shared page, after the closure
context area.  The userspace closure has to respect
signal-handler-like limitations on its powers if is_delayed is true;
it will run in the right process context but has no particular thread
context and can't call anything that could block or allocate memory.

I think this sort of interface might work well for both GUI event
frameworks and real-time streaming media playback/mixing, which are
two common ways for AIO to enter the mere userspace programmer's
sphere of concern (and also happen to be areas where I have some
expertise).  Would it work for the Oracle use case?

Cheers,
- Michael
