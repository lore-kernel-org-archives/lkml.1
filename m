Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbXLLJU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbXLLJU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbXLLJUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:20:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:52743 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbXLLJUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:20:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,156,1196668800"; 
   d="scan'208";a="339274760"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: x86, ptrace: support for branch trace store(BTS)
Date: Wed, 12 Dec 2007 09:18:48 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071211145301.GA19427@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86, ptrace: support for branch trace store(BTS)
thread-index: Acg8BvvlhX2i76GxQfKofj5NCWf+iQABZlnw
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@intel.com>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 12 Dec 2007 09:18:50.0508 (UTC) FILETIME=[01F13CC0:01C83CA0]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Dienstag, 11. Dezember 2007 15:53


>In the second use-case (tracing, profiling, call coverage metrics), we 
>could live without zero-copy, as long as the buffer could be 
>made "large 
>enough". The current 4000 records limit seems rather low (and 
>arbitrary) 
>and probably makes the mechanism unsuitable for say call coverage 
>profiling purposes. 

The limit is indeed arbitrary. It was requested by one of my internal
reviewers. The rationale was that we do not want to allow ptrace users
to request that an unlimited amount of memory be allocated in the
kernel.

Andi suggested to make this a sysctl.

Would it be safe to drop the artificial limit and let the limit be the
available memory?


>There's also no real mechanism that i can see to 
>create a guaranteed flow of this information between the debugger and 
>debuggee (unless i missed something), the code appears to overflow the 
>array, and destroy earlier entries, right? That's "by design" for 
>debugging, but quite a limitation for instrumentation which might want 
>to have a reliable stream of the data (and would like the originating 
>task to block until the debugger had an opportunity to siphoon out the 
>data).

That's correct as well. My focus is on debugging. And that's actually
the most useful behavior in that case. I'm not sure what you mean with
'instrumentation'.


Regarding streaming data (the only real use case I can think of would be
path profiling), I think I would rather allocate a bigger buffer and
send a signal when the buffer gets full instead of having the kernel
provide an interrupt service routine and copy the data from a smaller
buffer into a bigger one.

This would leave it to the tracing task which likely wants to write the
data into a file if it really got too big to hold it in physical memory.
We would need another command to reset the DS index, and probably one to
provide the entire buffer at once, and add some configuration bits to
say whether we want the signal or a cyclic buffer.


For debugging, I think this extension is not relevant. Since it could be
implemented as an extension of the current interface, I would leave it,
for now.


>> I need to look more into mlock. So far, I found a system call in 
>> /usr/include/sys/mman.h and two functions sys_mlock() and 
>> user_shm_lock() in the kernel. Is there a memory expert around who 
>> could point me to some interesting places to look at?
>
>sys_mlock() is what i meant - you could just call it internally from 
>ptrace and fail the call if sys_mlock() returns -EPERM. This keeps all 
>the "there's too much memory pinned down" details out of the ptrace 
>code.
>
>> Can we distinguish kernel-locked memory from user-locked memory? I 
>> could imagine a malicious user to munlock() the buffer he 
>provided to 
>> ptrace.
>
>yeah. Once mlock()-ed, you need to "pin it" via get_user_pages(). That 
>gives a permanent reference count to those pages.

sys_mlock() eventually results in a call to get_user_pages().
I have not found the corresponding put_page() call for munlock(),
though.

So you're suggesting to do an additional get_user_pages to prevent the
user from munlock()ing the memory?
So, if the pages are unlocked, they will still be pinned down and cannot
further be unlocked?

Something like:
ptrace_allocate(struct task_struct *child, void *base, size_t size) {
	if (sys_mlock(base, size) < 0)
		return -EPERM;
	get_user_pages(child, ...., base, size, ....);
}


>> Is there a real difference between mlock()ing user memory and 
>> allocating kernel memory? There would be if we could page out 
>> mlock()ed memory when the user thread is not running. We 
>would need to 
>> disable DS before paging out, and page in before enabling it. If we 
>> cannot, then kernel allocated memory would require less space in 
>> physical memory.
>
>mlock() would in essence just give you an easy "does this user have 
>enough privilege to lock this many pages" API. The real 
>pinning would be 
>done by get_user_pages(). Once you have those pages, they wont be 
>swapped out.

The actual physical memory consumption will be worse (or at best equal)
compared to kalloc()ed memory, since we need to pin down entire pages,
whereas kalloc() would allocate just the memory that is actually needed.

Unless we would put_page() and get_user_pages() the pinned down pages on
a context switch. But then, get_user_pages() calls cond_resched(), which
might not be a good think to do during a context switch.


Overall, I think that kalloc() is actually more memory efficient than
mlock(). The only benefit of mlock() would be that we save some
copy_to_user() in the debugger task. This should not be a big deal for
debuggers, but it might become interesting for profilers.

On the other hand, profilers would typically expect a stream of data and
they would either want a terribly big buffer or store the data into a
file. In both cases, they need to do a lot of copying, already.

I would stay with kalloc() for both use cases.


Regarding your other open, are you OK with the DS interface?


Andi suggested in one of his first reviews that the configuration
commands should be combined. 
Something like:
struct bts_config {
	size_t       buffer_size;
	unsigned int flags;
}
The buffer would be reallocated, if its size changed. The flags would be
treated like the current CONFIG command to control last branch recording
and timestamp recording. They would eventually be extended to control
overflow behavior (signal vs. cyclic buffer).

I would expect that the buffer_size does not change too often and that
the flags might change more frequently. This interface would further be
harder to extend in case the struct needs to be extended.
On the up side, it rids us of two commands.


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
