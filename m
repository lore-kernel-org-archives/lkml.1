Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYL2Vlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYL2Vlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYL2Vlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:41:31 -0500
Received: from mga06.intel.com ([134.134.136.21]:31877 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752739AbYL2Vla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:41:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,297,1228118400"; 
   d="scan'208";a="374508390"
Message-ID: <49594411.60000@linux.intel.com>
Date: Mon, 29 Dec 2008 22:41:37 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, ying.huang@intel.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
In-Reply-To: <20081227225102.GA17822@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

>>> A far more useful design for handling MCE events would be to feed them 
>>> into printk logging.
>> If there's ASCII logging it should be separate from normal printk.
> 
> Well, why? 

Mostly because the problem is not a kernel issue. Especially large systems
with a lot of memory can generate a lot of corrected events (one bit
flips in DIMMs are not that uncommon) and it's not
good to mix that all up into other kernel messages. It also makes it more
clear that it's not a kernel problem, but a hardware problem. I've
got feedback over the years that confirm this sight.

> Hm, such as? Right now i see mcelog as a facility that gets used only in 
> the rarest of circumstances. 99% of the time mcelog is just used in mcelog 
> --ascii mode to decode something quirky that the kernel could have (and 
> should have) printed out in a much more human-accessible format.

Nope, it's used all the time without --ascii to report corrected by hardware
errors, like for example single bit errors in memory or cache.
With the current trend in hardware (more and more memory, more and
more transistors) corrected errors are getting more common all the time.

Another case is handling uncorrected exceptions with tolerant == 3: while that
sounds obscure it's used in practice by a large user base.

> You should not assume that administrators/users reading kernel crash 
> messages are dumb. (an ordinary user wont see it most of the time anyway) 

It has nothing to do with dumb, it's not a useful level of detail
and doesn't provide the information needed to fix the problem.
In particular it says nothing about which hardware component failed,
which is the main important information. mcelog goes to some effort
to provide more information, like for example trying to figure
out which DIMM actually failed [unfortunately there are a couple
of problems with this too, so its WIP, but it's improving]

Then you're right the panics are often hidden by X currently, but there are
ways to address this. The most simple one I'm consider is to make a panic
timeout default for machine checks. Then with a warm reboot the mces
can be logged after reboot because they stay around in the CPU register.

The other is with kernel mode setting it's actually possible to report
a MCE (or a oops) on top of the X server [my old PPC ibook did this
 >6 years ago, but finally x86 has caught up]. However the soft reboot
method above is better in my opinion because it doesn't require
anyone to scribble anything down.

There are a couple of other approaches to solve this that are also
getting explored to keep the information over reboot.


> The usage patterns i see is that admins who get an MCE crash often fail to 
> write down the whole MCE message (not realizing that it is important) and 
> have to go back and reproduce the MCE crash once again before they can get 
> any meaningful information.

Most MCEs are not panics but corrected (by hardware) errors, currently
/dev/mcelog + mcelog is primarily for this case (but also for the "log event after warm
reboot" case and of course the tolerant==3 case)

Now the reasons why ASCII MCE logging is problematic:

- First when I started the 64bit mce.c some years ago I started with NMI
safe ASCII logging. But I found it personally quite difficult to write
a well performing correct lockless variable record length buffer that
handles all the corner cases well.

Using fixed size records simplified the problem considerably [although the
current mce_log() implementation still has issues, but Ying has a rewrite in
the pipeline)
This is probably solvable with some effort, but it's not easy, especially
when you want to make sure the result is fully correct.

- Then mce/nmi logging has different requirements from a standard printk.
In particular it requires tail dropping instead of the usual head dropping
[the first events are more important than the later ones]. While
this could be probably done in a generic implementation, it's an awkward
special case there.

- Then to do a generic lockless buffer you need a suitable atomic primitive.
Currently that's CMPXCHG, but that's not available on all architectures,
so you can't easily make it a generic facility. You would likely need
different implementations for different architectures.

- Even if you only consider x86 there is only
CMPXCHG4/8 generally available on x86, severly limiting the maximum buffer
size in the most obvious variable record sized buffer. It might be possible
to write a buffer with something else (like XADD), but it would be hard
(and definitely unportable)

Ying's new mcelog implementation uses a per CPU buffer. That avoids
some problems with the old implementation, in particular scalability
with a lot of CPUs.

- But there is some concern about the size of the per CPU buffer. It requires
a minimum margin per CPU (16+ events/CPU) ASCII will be a lot more bloated so it would
require more memory per CPU.
That's not a serious concern, but I don't like it particularly.

- Then lockless buffering has a couple of drawbacks, in particular it's slower
in the worst case [at least my implementation was] and they are more prone
to livelock and harder to verify. And ultimatively there are very few
loggers who really need full NMI semantics, because the dominating
majority code runs fine with standard interrupt locking rules. And I suspect
that code majority will be more happy with a better performing locked
buffer facility.

- Then we have a machine check injector upcoming for inclusion which turned out to
be essential for debugging and improving the mce code. The injector
right now is just a write() on mcelog with an internal struct mce storage
that is then faked on MSR accesses.  That's nice and simple and small
enough that it doesn't need much CONFIGery.
If the interface was switched to ASCII we would first need a ASCII
parser and then some internal storage that would be equivalent to
struct mce. So you would still need struct mce anyways.
And while it's possible to write a parser of course it would
be large (and likely somewhat ugly) code and make the injector code a lot more
complicated.

So at least for the injector I think binary /dev/mcelog should be kept

- Full decoding is a lot of code.

First modern mcelog does a lot more than decoding bits. It has a database
to keep track of errors per component, can decode addresses to DIMMs and some
other things. Some of this (like the database) clearly doesn't belong
into kernel space, and even the other bits are quite a lot of code combined.

Even basic decoding can be quite complicated (not that this is not even
complete, e.g. Atom support is missing currently):

  text    data     bss     dec     hex filename
    1267    1424       0    2691     a83 core2.o
     791       0       0     791     317 bitfield.o
    1290    1008       0    2298     8fa dunnington.o
    3999     544      64    4607    11ff p4.o
    2169    1856       0    4025     fb9 nehalem.o
     239       0       0     239      ef intel.o
    3783    1264      64    5111    13f7 k8.o

About 20k code alone. If you add all the other related
decoding code you're going towards 40k. I expect it also
to become more complicated in the future.

That would be quite a lot of kernel bloat.

- One of the upcoming changes for the main MC exception handler
is Monarch support, aka synchronizing machine checks
over all CPUs. This is required to correctly handle the error containment
model in the hardware and also allows avoiding a couple of other issues.
The Monarch code requires different CPUs to communicate their
machine check information to others. While they don't need all of struct mce, they
need several fields of it. At least a subset of it would be still
needed. It's also convenient in this code to just copy the single
data structure around.

- The requirements for printing a panic is different from talking to mcelog
(or some other user backend). For a panic you should do at least some
decoding and add some information (like the HARDWARE ERROR header),
but when talking to another program that's in the way.

- Then machine check events are relatively complicated as far as kernel
events go. They are structured records with multiple fields with
different semantics. They also require extensibility (the current
/dev/mcelog interface is fully extensible with full backwards
compatibility in both directions). So it's not just writing a single
string out, you would need a record with start/end markers and a
special version which his different from a "human cooked" version.
I'm not suggesting it needs XML @), but at least some elements
of it (e.g. some nested format) would be probably needed.
I don't think it would be very nice.

- Then mcelog in some cases poll()s for events. This is useful
in the tolerant==3 case for example when it wants to run as quickly
as possible.  But the variable length records above do not really
fit well into a poll() interface (or into the sysfs frame work
in general). You would probably need at least a nasty state
machine in the kernel poll handler and some buffer preallocation.
It's doable of course, but the code would be ugly I think

- Finally the currently only known user of /dev/mcelog (or whatever
interface is there to communicate MC events) uses struct mce internally.
So if this was changed to an ASCII interface it would just parse
it and then put it back into the same structure. The only
known user wouldn't benefit from this change. Would seem a little
bit like a waste.

It's also not really an interface that is expected to be used
by a lot of different programs.

- Then a lot of people run old mcelog and I would be opposed to
breaking compatibility, so the old interface would need to be kept
for some time. That's especially important because mcelog breaks
not very obviously, and silent breakages are always bad.

None of the points above are real show stoppers for an ASCII interface,
but I think with all of this above together considered it's not really an
attractive change.

I think what could be done is:

- Investigate how to make the panic message more information without adding full
decoders.
- Implement the default panic timeout method described above to get automatic
on disk logging in common cases.

Would that address your concerns?

-Andi


