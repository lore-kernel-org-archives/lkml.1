Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbXLKKea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbXLKKea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKKeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:34:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:42436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbXLKKeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:34:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,150,1196668800"; 
   d="scan'208";a="431985861"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: x86, ptrace: support for branch trace store(BTS)
Date: Tue, 11 Dec 2007 10:34:28 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071210202052.GA26002@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86, ptrace: support for branch trace store(BTS)
thread-index: Acg7arh5GN5IhpPFQFmwNFfCWA3p6AAXc9sA
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markut.t.metzger@intel.com>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 11 Dec 2007 10:34:17.0764 (UTC) FILETIME=[61FBEE40:01C83BE1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Montag, 10. Dezember 2007 21:21

>here's the current proposed API:
>
>+       case PTRACE_BTS_MAX_BUFFER_SIZE:
>+       case PTRACE_BTS_ALLOCATE_BUFFER:
>+       case PTRACE_BTS_GET_BUFFER_SIZE:
>+       case PTRACE_BTS_READ_RECORD:
>+       case PTRACE_BTS_CONFIG:
>+       case PTRACE_BTS_STATUS:
>
>i can see a couple of open questions:
>
>1) PTRACE_BTS_MAX_BUFFER_SIZE
>
>why is a trace buffer size limit visible to user-space? It's 4000 
>entries right now:
>
>     #define PTRACE_BTS_BUFFER_MAX 4000
>
>it would be more flexible if user-space could offer arbitrary sized 
>buffers, which the kernel would attempt to mlock(). Then those pages 
>could be fed to the BTS MSR. I.e. there should be no hard limit in the 
>API, other than a natural resource limit.


That would be a variation on Andi's zero-copy proposal, wouldn't it?

The user supplies the BTS buffer and the kernel manages DS.

Andi further suggested a vDSO to interpret the data and translate the
hardware format into a higher level user format.

I take it that you would leave that inside ptrace.

I need to look more into mlock. So far, I found a system call in
/usr/include/sys/mman.h and two functions sys_mlock() and
user_shm_lock() in the kernel. Is there a memory expert around who could
point me to some interesting places to look at?

Can we distinguish kernel-locked memory from user-locked memory?
I could imagine a malicious user to munlock() the buffer he provided to
ptrace. 

Is there a real difference between mlock()ing user memory and allocating
kernel memory? There would be if we could page out mlock()ed memory when
the user thread is not running. We would need to disable DS before
paging out, and page in before enabling it. If we cannot, then kernel
allocated memory would require less space in physical memory.



>2) struct bts_struct
>
>the structure of it is hardwired:
>
>the basic unit is an array of bts_struct:
>
> +struct bts_struct {
> +       enum bts_qualifier qualifier;
> +       union {
> +               /* BTS_BRANCH */
> +               struct {
> +                       long from_ip;
> +                       long to_ip;
> +               } lbr;
> +               /* BTS_TASK_ARRIVES or
> +                  BTS_TASK_DEPARTS */
> +               unsigned long long timestamp;
> +       } variant;
> +};
>
>while other CPUs (on other architectures, etc.) might have a different 
>raw format for the trace entries. So it would be better to 
>implement BTS 
>support in kernel/ptrace.c with a general trace format, and to 
>provide a 
>cross-arch API (only implemented by arch/x86 in the beginning) to 
>translate the 'raw' trace entries into the general format.


The bts_struct is already an abstraction from the raw hardware format.
The hardware uses:

struct bts_netburst {
    void* from;
    void* to;
    long :4;
    long predicted :1;
}; 
struct bts_core2 {
    u64 from;
    u64 to;
    u64 :64;
};

I encode timestamps in the raw hardware format. This puts the timestamps
at the correct places and frees me from any efforts to correlate
separate timestamp data and branch record data (which is getting ugly
when the BTS buffer overflows).

Now, arch/x86/kernel/ds.c already needs to abstract from the raw
hardware format. I chose to add timestamps to that abstraction. This
makes the DS interface general enough to be directly used by ptrace
(causing some misunderstanding, I'm afraid).

If new architectures would eliminate the extra word, I would have to
merge the qualifier and the escape address, i.e. have some (probably the
least significant) bits of the escape address encode the qualifier. The
interface would remain stable.

Other architectures would at least need to encode the source and
destination address. Thus, we should have enough room to support
timestamps for other architectures, as well. If they choose a more
compact encoding, the interface might no longer be usable.


I could instead use
struct ds_bts {
    void* from;
    void* to;
};
for the DS interface and move timestamps and their encoding in the DS
BTS format to ptrace.
This would move the DS interface closer to the hardware (yet still
abstract from details) and move anything extra to its users - currently
only ptrace.

On the down side, other users of DS (kernel tracing, for example) would
have to invent their own method to encode additional information into
the BTS buffer.

I saw benefit in making the DS interface more powerful.


>3)
>
>it would certainly be useful for some applications to have a large 
>"virtual" trace buffer and a small "real" trace buffer. The 
>kernel would 
>use BTS high-watermark interrupts to feed the real trace 
>buffer into the 
>larger "virtual" trace buffer. This way we wouldnt even have to use 
>mlock() to pin down the trace buffer.

I see two ways this could be done wrt disentangling trace:
1. keep a small per-thread buffer
2. use a per-cpu buffer

The first alternative would allow us to disentangle the per-thread trace
easily by simply reconfiguring the DS on a context switch (similar to
how it is currently done).

The second alternative would require us to memcpy() the BTS buffer at
each context switch. This would be a huge overhead at a performance
critical place.

I would therefore keep the per-thread buffer. This costs one mlock()ed
or kalloc()ed page per traced thread.

In addition to that, we need the (pageable) memory to hold the virtual
buffer.
Thus, it only pays off if the virtual buffer is significantly bigger
than the real buffer (we're paying one page extra).


Let's look at the interrupt routine.
It would need to disable tracing, page in the memory, memcpy() the BTS
buffer, and reenable tracing. This is again a big overhead and might
take some time. 

AFAIK, the interrupt routine would schedule the work and return
immediately. A kernel thread would later pick up the work and do the
copying. 

The traced thread would need to be suspended until the copying is done
(unless we have a table of buffers that we cycle through and thus can
provide a fresh buffer to the thread immediately). 

Thus, its timeslice would effectively be reduced to the amount of work
it gets done in a single 'real' BTS buffer. 

I am not familiar with the new scheduler and how this would impact
(system) performance. I could imagine that either the traced task
virtually starves or that it receives an unfairly big amount of system
resources. But then, I'm only guessing. I'm sure you can give a precise
answer.


Overall, this looks like a lot more effort and a lot more things that
could go wrong and bring down the entire system. Compared to an almost
trivial and reasonably safe implementation.

And it only starts paying off when the virtual buffer is getting
reasonably big; up to a few pages, we should be better off simply
mlock()ing the entire buffer.

For use in debuggers to show the debuggee's execution trace to the user,
I think that this is unnecessarily complicated. For all the use cases
that I can think of today, a single page of memory should suffice.

>From my own experience (debugging compilers on XScale), by far the most
interesting information is the last handful of branch records. I cannot
say how far users would want to look back in the trace history or how
far they can look back and still make some sense out of what they see.

Besides, all this would be hidden behind the ptrace interface. We might
add this functionality when there is demand.


thanks and regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
