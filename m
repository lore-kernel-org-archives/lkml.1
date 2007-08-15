Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbXHOA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbXHOA3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXHOA3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:29:42 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46481 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755055AbXHOA3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:29:41 -0400
Message-ID: <387137777.28890@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 08:29:36 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Berthels <jjberthels@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PSS(proportional set size) accounting in smaps
Message-ID: <20070815002936.GA8982@mail.ustc.edu.cn>
Mail-Followup-To: Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Berthels <jjberthels@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070814013350.GA9182@mail.ustc.edu.cn> <20070814061940.GU30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814061940.GU30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 01:19:40AM -0500, Matt Mackall wrote:
> On Tue, Aug 14, 2007 at 09:33:50AM +0800, Fengguang Wu wrote:
> > The "proportional set size" (PSS) of a process is the count of pages it has in
> > memory, where each page is divided by the number of processes sharing it. So if
> > a process has 1000 pages all to itself, and 1000 shared with one other process,
> > its PSS will be 1500.
> >                - lwn.net: "ELC: How much memory are applications really using?"
> > 
> > The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
> > memory footprint. So collect and export it via /proc/<pid>/smaps.
> > 
> > Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job,
> > providing pretty much details.  But for PSS, let's do it in a simple way. 
> 
> Yes, if people actually want to use this particular metric a lot (and
> I obviously personally think it makes a lot of sense), then it should
> be done in kernel like this.

Thank you for the acknowledge, Matt.

> > Cc: Matt Mackall <mpm@selenic.com>
> > Cc: John Berthels <jjberthels@gmail.com>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  fs/proc/task_mmu.c |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > --- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
> > +++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
> > @@ -319,6 +319,7 @@ const struct file_operations proc_maps_o
> >  struct mem_size_stats
> >  {
> >  	unsigned long resident;
> > +	u64 	      pss;	/* proportional set size: my share of rss */
> 
> 64 bits?

Yes, to accommodate the extra 12 bits for error shifting.

> >  	unsigned long shared_clean;
> >  	unsigned long shared_dirty;
> >  	unsigned long private_clean;
> > @@ -341,6 +342,7 @@ static int smaps_pte_range(pmd_t *pmd, u
> >  	pte_t *pte, ptent;
> >  	spinlock_t *ptl;
> >  	struct page *page;
> > +	int mapcount;
> >  
> >  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> >  	for (; addr != end; pte++, addr += PAGE_SIZE) {
> > @@ -357,16 +359,19 @@ static int smaps_pte_range(pmd_t *pmd, u
> >  		/* Accumulate the size in pages that have been accessed. */
> >  		if (pte_young(ptent) || PageReferenced(page))
> >  			mss->referenced += PAGE_SIZE;
> > -		if (page_mapcount(page) >= 2) {
> > +		mapcount = page_mapcount(page);
> > +		if (mapcount >= 2) {
> >  			if (pte_dirty(ptent))
> >  				mss->shared_dirty += PAGE_SIZE;
> >  			else
> >  				mss->shared_clean += PAGE_SIZE;
> > +			mss->pss += (PAGE_SIZE << 12) / mapcount;
> 
> Hmm, what's that shift for? Oh, you're doing fixed-point math.
> 
> 64-bit divisions are quite expensive on some platforms. The compiler
> might be able to do something smarter with common constants like:
> 
>    if (mapcount == 1)
>       mss->pss += PAGE_SIZE;
>    else if (mapcount == 2)
>       mss->pss += PAGE_SIZE / 2;
>    else if (mapcount == 3)
>       mss->pss += PAGE_SIZE / 3;
>    else if (mapcount == 4)
>       mss->pss += PAGE_SIZE / 4;
>    else
>       mss->pss += PAGE_SIZE / mapcount;
> 
> ..but I don't know. I suspect we'll at least want to special-case
> mapcount == 1 though.

Don't worry, the PAGE_SIZE being divided is unsigned long. So there's
no 64bit division on 32bit CPU :) And we do avoid the division for
the common case of mapcount == 1.

> > +		   sarg.mss.resident      >> 10,
> > +		   (unsigned long)(mss->pss >> 22),
> 
> And then you're throwing away 22 bits of precision. 10 bits wasn't
> enough? Hmmm.. Looks like the worst case is sharing a 4k page 2049
> ways, where we'll be off by .999 bytes per 4k page for nearly 50%
> error. Your extra 12 bits drops this to .2% error, so I suppose it's
> worth it.
> 
> But it probably needs a comment.

OK, I introduced PSS_ERROR_BITS=12, and some comments for it.
Note that the output unit of 1KB could be the most significant source
of errors :)

> > -		   sarg.mss.referenced >> 10);
> > +		   sarg.mss.referenced    >> 10);
> 
> Unrelated change.

Ok, removed it.

Thank you,
Fengguang
===

PSS(proportional set size) accounting in smaps

The "proportional set size" (PSS) of a process is the count of pages it has in
memory, where each page is divided by the number of processes sharing it. So if
a process has 1000 pages all to itself, and 1000 shared with one other process,
its PSS will be 1500.
               - lwn.net: "ELC: How much memory are applications really using?"

The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
memory footprint. So collect and export it via /proc/<pid>/smaps.

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job.
They are comprehensive tools. But for PSS, let's do it in the simple way. 


Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -324,6 +324,27 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+
+	/*
+	 * Proportional Set Size(PSS): my share of RSS.
+	 *
+	 * PSS of a process is the count of pages it has in memory, where each
+	 * page is divided by the number of processes sharing it.  So if a
+	 * process has 1000 pages all to itself, and 1000 shared with one other
+	 * process, its PSS will be 1500. (lwn.net)
+	 */
+	u64 	      pss;
+	/*
+	 * To keep (accumulated) division errors low, we adopt 64bit pss and
+	 * use some low bits for division errors. So (pss >> PSS_ERROR_BITS)
+	 * would be the real byte count.
+	 *
+	 * A shift of 12 before division means(assuming 4K page size):
+	 * 	- 1M 3-user-pages add up to 8KB errors;
+	 * 	- supports mapcount up to 2^24, or 16M;
+	 * 	- supports PSS up to 2^52 bytes, or 4PB.
+	 */
+#define PSS_ERROR_BITS	12
 };
 
 struct smaps_arg
@@ -341,6 +362,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -357,16 +379,19 @@ static int smaps_pte_range(pmd_t *pmd, u
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
 			mss->referenced += PAGE_SIZE;
-		if (page_mapcount(page) >= 2) {
+		mapcount = page_mapcount(page);
+		if (mapcount >= 2) {
 			if (pte_dirty(ptent))
 				mss->shared_dirty += PAGE_SIZE;
 			else
 				mss->shared_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_ERROR_BITS) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_ERROR_BITS);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);
@@ -395,6 +420,7 @@ static int show_smap(struct seq_file *m,
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
 		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
 		   "Shared_Clean:   %8lu kB\n"
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
@@ -402,6 +428,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   sarg.mss.resident >> 10,
+		   (unsigned long)(sarg.mss.pss >> (10 + PSS_ERROR_BITS)),
 		   sarg.mss.shared_clean  >> 10,
 		   sarg.mss.shared_dirty  >> 10,
 		   sarg.mss.private_clean >> 10,

