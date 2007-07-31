Return-Path: <linux-kernel-owner+w=401wt.eu-S1763984AbXGaWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763984AbXGaWnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXGaWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:43:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35768 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbXGaWnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:43:13 -0400
Subject: Re: /proc/$pid/pagemap troubles
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731213718.GW11115@waste.org>
References: <1185914174.18414.184.camel@localhost>
	 <20070731213718.GW11115@waste.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 15:43:10 -0700
Message-Id: <1185921790.18414.223.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 16:37 -0500, Matt Mackall wrote:
> 
> > So, a couple of questions.  Don't we need to support
> non-sizeof(unsigned
> > long)-aligned reads?
> 
> Why? We should obviously never return more data than we were asked for
> (that's clearly a bug), but lots of things refuse to read or write
> stuff that isn't well sized and aligned. 

For the 1-byte stuff at the beginning of the file, I think it makes
perfect sense:

	char __big_endian;
	int big_endian;
	read(fd, &__big_endian, 1);
	big_endian = __big_endian;

> > Do we _really_ need that header in each and every file?
> 
> Well there's either a header or there isn't.

I just mean that perhaps we should be putting some of that stuff in a
global file.  I think there's some added simplicity both in the kernel
and in the userspace programs if we just let "*ppos << PAGE_SHIFT ==
vaddr".

I was going to send you a patch, but since you're updating anyway, could
you add some symbolic names like this:

#define PAGEMAP_ENTRY_SIZE_BYTES        sizeof(unsigned long)
#define PAGEMAP_HEADER_SIZE_BYTES       sizeof(unsigned long)
#define PAGEMAP_MAX_VIRT_PFN            (((~0UL) >> PAGE_SHIFT) + 1)
#define PAGEMAP_BUFFER_SLOTS		(PAGE_SIZE/PAGEMAP_ENTRY_SIZE_BYTES)
#define PAGEMAP_UNPOPULATED_PAGE	(-1UL)

+       evpfn = min((src + count) / sizeof(unsigned long),
+                   ((~0UL) >> PAGE_SHIFT) + 1);

Should that hunk of code be any different for 32-bit processes on a
64-bit kernel?  Do we want to use TASK_SIZE_OF() or restrict these to
actual virtual address space (which is only 48 bits on x86_64).

It also seems that we need some replacement for the CONFIG_HIGHPTE
#ifdefs.  What is the basic reason for those?  The copy_to_user() called
by add_to_pagemap()->flush_pagemap() conflicts with the kmap_atomic()
from pte_offset_map()?

Perhaps we should have the page table walker code return -EAGAIN when it
needs to flush.  Then, it will fall all the way out to read_pagemap()
where we could do the actual flush outside of the kmaps and restart the
walker.

Or, we could just call the walker only for ranges that we know will fit
into the buffer that we have.  If there was no header on the file, we
could determine this completely by the address that we were currently
walking.

As I think about it, do we really even need to walk the VMA list at all?
We don't do anything differently if an address is inside a VMA.  We just
save time by not walking the pagetables for areas that we know are
zeroed.  But, we won't be able to walk down to the PTE level in most
cases, anyway.  So, it probably won't waste _that_ much time.

+struct pagemapread {
+       struct mm_struct *mm;
+       unsigned long next;
+       unsigned long *buf;
+       pte_t *ptebuf;
+       unsigned long pos;
+       size_t count;
+       int index;
+       char __user *out;
+};

Just looking at the structure, it's _really_ hard to tell what fields go
with other fields, and it took me a while to unravel it all.  There's
also some redundancy in it, which I find a bit confusing.

"->next" shouldn't be necessary at all, unless the page table walker is
called twice with overlapping page ranges.  I modified pagemap_fill() to
return the number of pagemap entries written.  It uses "->next" heavily
but doesn't really need to if you simply pass an address range into it.

"->pos" isn't necessary as long as we keep an original copy of the "buf"
pagemap_read() argument around.

"->index" is necessary, but goes with the "->buf" field and should
probably go next to it.  The same goes for "->count" and "->out".

I ended up with a structure that looks like this:

struct pagemapread {
        struct mm_struct *mm;
        pte_t *ptebuf;

        unsigned long *buf;
        int next_buf_slot;
        size_t slots_to_fill; /* not strictly necessary with the
                               * "bytes_to_write" field here */

        /*
         * We need this because the page table walking
         * code doesn't really tell us how far it walked.
         * It is internal and not to be used otherwise.
         */
        unsigned long __last_vaddr_filled;

        char __user *user_buffer;
        size_t userspace_bytes_left_to_write;
};



-- Dave

