Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYAIRDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYAIRDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYAIRDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:03:03 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:36771 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbYAIRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:03:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGiNhEdMROHU/2dsb2JhbACBV6gm
Date: Wed, 9 Jan 2008 11:52:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, hch@lst.de, airlied@linux.ie,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       pq@iki.fi, jbeulich@novell.com, linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
Message-ID: <20080109165254.GA4912@Krystal>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie> <20080109071945.GB10695@lst.de> <20080108.232311.79648776.davem@davemloft.net> <20080109104149.GB8041@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080109104149.GB8041@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:39:52 up 66 days, 21:45,  4 users,  load average: 0.53, 0.63,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> (kprobes folks Cc:-ed)
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Christoph Hellwig <hch@lst.de>
> > Date: Wed, 9 Jan 2008 08:19:45 +0100
> > 
> > > On Wed, Jan 09, 2008 at 03:55:20AM +0000, Dave Airlie wrote:
> > > > now because Linus said send him a patch to revert regressions rather than 
> > > > just complain,
> > > 
> > > this is not a regression by any definition.  You were abusing 
> > > exported symbols for out of tree junk, so you'll lose.
> > 
> > And furthermore, they don't even need it, use a kprobe.
> 
> i agree. There a few practical complication on x86: the do_page_fault() 
> function is currently excluded from kprobe probing, for recursion 
> reasons. handle_mm_fault() can be probed OTOH - but that does not catch 
> vmalloc()-ed faults. The middle of do_page_fault() [line 348] should 
> work better [the point after notify_page_fault()] - but it's usually 
> more fragile to insert probes to such middle-of-the-function places.
> 
> So probing pagefaults is not as easy as it should/could be. We should 
> put a practical NOP marker to around line 348, to make it easier (and 
> faster) for systemtap to probe there.
> 
> (__kprobes is a highly confusing newspeak name btw - it should be 
> __noprobe instead.)
> 
> 	Ingo


Probing vmalloc faults is _really_ tricky : it also implies that the
handler (let's call it probe) connected to the probe point (marker or
kprobe) should _never_ cause a vmalloc page fault, it should therefore
never touch vmalloc'd memory, which is a very restrictive constraint,
especially for tracing which may need large buffers (the only sane
alternative is to allocate the buffers statically before the kernel
boots).

As for the location of the probe point, we have to determine how we want
to handle a OOPSing probe. If we put the probe point too soon in the
do_page_fault function, we will end up doing recursive page_fault rather
than a OOPS, which may make things harder to debug.

In the LTTng instrumentation, I volountarily excluded the
bad_area and bad_area_nosemaphore paths from the page fault
instrumentation for this exact reason.

Currently, I have markers around the handle_mm_fault call :

        trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
                14, instruction_pointer(regs));
        fault = handle_mm_fault(mm, vma, address, write);
        trace_mark(kernel_arch_trap_exit, MARK_NOARGS);

I also instrument handle_mm_fault, but I leave these markers in
do_page_fault to get the architecture specific trap id (the "trap_entry"
and "trap_exit" events) and the instruction pointer causing the fault.


My handle_mm_fault instrumentation :

(note that handle_mm_fault is also called by get_user_pages, not only
do_page_fault)

int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
                unsigned long address, int write_access)
{
        int res;
        pgd_t *pgd;
        pud_t *pud;
        pmd_t *pmd;
        pte_t *pte;

        trace_mark(mm_handle_fault_entry,
                "address %lu ip #p%ld write_access %d",
                address, KSTK_EIP(current), write_access);

        __set_current_state(TASK_RUNNING);

        count_vm_event(PGFAULT);

        if (unlikely(is_vm_hugetlb_page(vma))) {
                res = hugetlb_fault(mm, vma, address, write_access);
                goto end;
        }

        pgd = pgd_offset(mm, address);
        pud = pud_alloc(mm, pgd, address);
        if (!pud) {
                res = VM_FAULT_OOM;
                goto end;
        }
        pmd = pmd_alloc(mm, pud, address);
        if (!pmd) {
                res = VM_FAULT_OOM;
                goto end;
        }
        pte = pte_alloc_map(mm, pmd, address);
        if (!pte) {
                res = VM_FAULT_OOM;
                goto end;
        }

        res = handle_pte_fault(mm, vma, address, pte, pmd, write_access);
end:
        trace_mark(mm_handle_fault_exit, MARK_NOARGS);
        return res;
}

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
