Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbXBVFqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbXBVFqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXBVFqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:46:50 -0500
Received: from 1wt.eu ([62.212.114.60]:2505 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXBVFqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:46:49 -0500
Date: Thu, 22 Feb 2007 06:42:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
Message-ID: <20070222054233.GA14236@1wt.eu>
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070221173445.GA16071@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20070221173445.GA16071@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Feb 21, 2007 at 09:34:45AM -0800, Greg KH wrote:
> On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.??a??lar Onur wrote:
> > 21 ??ub 2007 ??ar tarihinde, Greg KH ??unlar?? yazm????t??: 
> > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > received after that time might be too late.
> > 
> > We have still some CVEish patches in our package which maybe you want to 
> > consider adding into -stable.
> > 
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-4814
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5749
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5823
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6053
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6054
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006
> 
> Do you have a pointer to the patches for these fixes anywhere?
> 
> And are you sure they are all for 2.6.18?  The first one above is for
> the 2.4 kernel tree :)

No, in fact the CVE description is not precise enough. Maybe we should
propose an update to Steven, I don't know how CVE descriptions are
supposed to evolve.

The patch merged in 2.4 was a backport by Hugh Dickins of Linus' 2.6 patch,
which itself was composed of three successive fixes :

  2f77d107050abc14bc393b34bdb7b91cf670c250
  4fb23e439ce09157d64b89a21061b9fc08f2b495
  825020c3866e7312947e17a0caa9dd1a5622bafc

I attach all of them to this mail for your convenience. I noticed that
Linus recently applied other changes to mincore, though I'm not sure
they are security-related.

Hoping this helps,
Willy


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Fix-incorrect-user-space-access-locking-in-mincore.txt"

>From 2f77d107050abc14bc393b34bdb7b91cf670c250 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@woody.osdl.org>
Date: Sat, 16 Dec 2006 09:44:32 -0800
Subject: Fix incorrect user space access locking in mincore()

Doug Chapman noticed that mincore() will doa "copy_to_user()" of the
result while holding the mmap semaphore for reading, which is a big
no-no.  While a recursive read-lock on a semaphore in the case of a page
fault happens to work, we don't actually allow them due to deadlock
schenarios with writers due to fairness issues.

Doug and Marcel sent in a patch to fix it, but I decided to just rewrite
the mess instead - not just fixing the locking problem, but making the
code smaller and (imho) much easier to understand.

Cc: Doug Chapman <dchapman@redhat.com>
Cc: Marcel Holtmann <holtmann@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
---
 mm/mincore.c |  190 ++++++++++++++++++++++++++--------------------------------
 1 files changed, 86 insertions(+), 104 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 7289078..b44d7f8 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -1,7 +1,7 @@
 /*
  *	linux/mm/mincore.c
  *
- * Copyright (C) 1994-1999  Linus Torvalds
+ * Copyright (C) 1994-2006  Linus Torvalds
  */
 
 /*
@@ -38,46 +38,60 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static long mincore_vma(struct vm_area_struct * vma,
-	unsigned long start, unsigned long end, unsigned char __user * vec)
+/*
+ * Do a chunk of "sys_mincore()". We've already checked
+ * all the arguments, we hold the mmap semaphore: we should
+ * just return the amount of info we're asked for.
+ */
+static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages)
 {
-	long error, i, remaining;
-	unsigned char * tmp;
+	unsigned long i, nr, pgoff;
+	struct vm_area_struct *vma = find_vma(current->mm, addr);
 
-	error = -ENOMEM;
-	if (!vma->vm_file)
-		return error;
-
-	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (end > vma->vm_end)
-		end = vma->vm_end;
-	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	/*
+	 * find_vma() didn't find anything: the address
+	 * is above everything we have mapped.
+	 */
+	if (!vma) {
+		memset(vec, 0, pages);
+		return pages;
+	}
 
-	error = -EAGAIN;
-	tmp = (unsigned char *) __get_free_page(GFP_KERNEL);
-	if (!tmp)
-		return error;
+	/*
+	 * find_vma() found something, but we might be
+	 * below it: check for that.
+	 */
+	if (addr < vma->vm_start) {
+		unsigned long gap = (vma->vm_start - addr) >> PAGE_SHIFT;
+		if (gap > pages)
+			gap = pages;
+		memset(vec, 0, gap);
+		return gap;
+	}
 
-	/* (end - start) is # of pages, and also # of bytes in "vec */
-	remaining = (end - start),
+	/*
+	 * Ok, got it. But check whether it's a segment we support
+	 * mincore() on. Right now, we don't do any anonymous mappings.
+	 */
+	if (!vma->vm_file)
+		return -ENOMEM;
 
-	error = 0;
-	for (i = 0; remaining > 0; remaining -= PAGE_SIZE, i++) {
-		int j = 0;
-		long thispiece = (remaining < PAGE_SIZE) ?
-						remaining : PAGE_SIZE;
+	/*
+	 * Calculate how many pages there are left in the vma, and
+	 * what the pgoff is for our address.
+	 */
+	nr = (vma->vm_end - addr) >> PAGE_SHIFT;
+	if (nr > pages)
+		nr = pages;
 
-		while (j < thispiece)
-			tmp[j++] = mincore_page(vma, start++);
+	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	pgoff += vma->vm_pgoff;
 
-		if (copy_to_user(vec + PAGE_SIZE * i, tmp, thispiece)) {
-			error = -EFAULT;
-			break;
-		}
-	}
+	/* And then we just fill the sucker in.. */
+	for (i = 0 ; i < nr; i++, pgoff++)
+		vec[i] = mincore_page(vma, pgoff);
 
-	free_page((unsigned long) tmp);
-	return error;
+	return nr;
 }
 
 /*
@@ -107,82 +121,50 @@ static long mincore_vma(struct vm_area_s
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 	unsigned char __user * vec)
 {
-	int index = 0;
-	unsigned long end, limit;
-	struct vm_area_struct * vma;
-	size_t max;
-	int unmapped_error = 0;
-	long error;
-
-	/* check the arguments */
- 	if (start & ~PAGE_CACHE_MASK)
-		goto einval;
-
-	limit = TASK_SIZE;
-	if (start >= limit)
-		goto enomem;
-
-	if (!len)
-		return 0;
+	long retval;
+	unsigned long pages;
+	unsigned char *tmp;
 
-	max = limit - start;
-	len = PAGE_CACHE_ALIGN(len);
-	if (len > max || !len)
-		goto enomem;
-
-	end = start + len;
+	/* Check the start address: needs to be page-aligned.. */
+ 	if (start & ~PAGE_CACHE_MASK)
+		return -EINVAL;
 
-	/* check the output buffer whilst holding the lock */
-	error = -EFAULT;
-	down_read(&current->mm->mmap_sem);
+	/* ..and we need to be passed a valid user-space range */
+	if (!access_ok(VERIFY_READ, (void __user *) start, len))
+		return -ENOMEM;
 
-	if (!access_ok(VERIFY_WRITE, vec, len >> PAGE_SHIFT))
-		goto out;
+	/* This also avoids any overflows on PAGE_CACHE_ALIGN */
+	pages = len >> PAGE_SHIFT;
+	pages += (len & ~PAGE_MASK) != 0;
 
-	/*
-	 * If the interval [start,end) covers some unmapped address
-	 * ranges, just ignore them, but return -ENOMEM at the end.
-	 */
-	error = 0;
-
-	vma = find_vma(current->mm, start);
-	while (vma) {
-		/* Here start < vma->vm_end. */
-		if (start < vma->vm_start) {
-			unmapped_error = -ENOMEM;
-			start = vma->vm_start;
-		}
+	if (!access_ok(VERIFY_WRITE, vec, pages))
+		return -EFAULT;
 
-		/* Here vma->vm_start <= start < vma->vm_end. */
-		if (end <= vma->vm_end) {
-			if (start < end) {
-				error = mincore_vma(vma, start, end,
-							&vec[index]);
-				if (error)
-					goto out;
-			}
-			error = unmapped_error;
-			goto out;
+	tmp = (void *) __get_free_page(GFP_USER);
+	if (!tmp)
+		return -ENOMEM;
+
+	retval = 0;
+	while (pages) {
+		/*
+		 * Do at most PAGE_SIZE entries per iteration, due to
+		 * the temporary buffer size.
+		 */
+		down_read(&current->mm->mmap_sem);
+		retval = do_mincore(start, tmp, max(pages, PAGE_SIZE));
+		up_read(&current->mm->mmap_sem);
+
+		if (retval <= 0)
+			break;
+		if (copy_to_user(vec, tmp, retval)) {
+			retval = -EFAULT;
+			break;
 		}
-
-		/* Here vma->vm_start <= start < vma->vm_end < end. */
-		error = mincore_vma(vma, start, vma->vm_end, &vec[index]);
-		if (error)
-			goto out;
-		index += (vma->vm_end - start) >> PAGE_CACHE_SHIFT;
-		start = vma->vm_end;
-		vma = vma->vm_next;
+		pages -= retval;
+		vec += retval;
+		start += retval << PAGE_SHIFT;
+		retval = 0;
 	}
-
-	/* we found a hole in the area queried if we arrive here */
-	error = -ENOMEM;
-
-out:
-	up_read(&current->mm->mmap_sem);
-	return error;
-
-einval:
-	return -EINVAL;
-enomem:
-	return -ENOMEM;
+	free_page((unsigned long) tmp);
+	return retval;
 }
-- 
1.4.2.4


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Fix-up-mm-mincore.c-error-value-cases.txt"

>From 4fb23e439ce09157d64b89a21061b9fc08f2b495 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@woody.osdl.org>
Date: Sat, 16 Dec 2006 16:01:50 -0800
Subject: Fix up mm/mincore.c error value cases

Hugh Dickins correctly points out that mincore() is actually _supposed_
to fail on an unmapped hole in the user address space, rather than
return valid ("empty") information about the hole.  This just simplifies
the problem further (I had been misled by our previous confusing and
complicated way of doing mincore()).

Also, in the unlikely situation that we can't allocate a temporary
kernel buffer, we should actually return EAGAIN, not ENOMEM, to keep the
"unmapped hole" and "allocation failure" error cases separate.

Finally, add a comment about our stupid historical lack of support for
anonymous mappings.  I'll fix that if somebody reminds me after 2.6.20
is out.

Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
---
 mm/mincore.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index b44d7f8..566b6c2 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -49,29 +49,20 @@ static long do_mincore(unsigned long add
 	struct vm_area_struct *vma = find_vma(current->mm, addr);
 
 	/*
-	 * find_vma() didn't find anything: the address
-	 * is above everything we have mapped.
+	 * find_vma() didn't find anything above us, or we're
+	 * in an unmapped hole in the address space: ENOMEM.
 	 */
-	if (!vma) {
-		memset(vec, 0, pages);
-		return pages;
-	}
-
-	/*
-	 * find_vma() found something, but we might be
-	 * below it: check for that.
-	 */
-	if (addr < vma->vm_start) {
-		unsigned long gap = (vma->vm_start - addr) >> PAGE_SHIFT;
-		if (gap > pages)
-			gap = pages;
-		memset(vec, 0, gap);
-		return gap;
-	}
+	if (!vma || addr < vma->vm_start)
+		return -ENOMEM;
 
 	/*
 	 * Ok, got it. But check whether it's a segment we support
 	 * mincore() on. Right now, we don't do any anonymous mappings.
+	 *
+	 * FIXME: This is just stupid. And returning ENOMEM is 
+	 * stupid too. We should just look at the page tables. But
+	 * this is what we've traditionally done, so we'll just
+	 * continue doing it.
 	 */
 	if (!vma->vm_file)
 		return -ENOMEM;
@@ -142,7 +133,7 @@ asmlinkage long sys_mincore(unsigned lon
 
 	tmp = (void *) __get_free_page(GFP_USER);
 	if (!tmp)
-		return -ENOMEM;
+		return -EAGAIN;
 
 	retval = 0;
 	while (pages) {
-- 
1.4.2.4


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-PATCH-sys_mincore-s-max-min.txt"

>From 825020c3866e7312947e17a0caa9dd1a5622bafc Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@tv-sign.ru>
Date: Sun, 17 Dec 2006 18:52:47 +0300
Subject: [PATCH] sys_mincore: s/max/min/

fix a typo, sys_mincore() needs min().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Linus "I'm a moron" Torvalds <torvalds@osdl.org>
---
 mm/mincore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 566b6c2..8aca6f7 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -142,7 +142,7 @@ asmlinkage long sys_mincore(unsigned lon
 		 * the temporary buffer size.
 		 */
 		down_read(&current->mm->mmap_sem);
-		retval = do_mincore(start, tmp, max(pages, PAGE_SIZE));
+		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE));
 		up_read(&current->mm->mmap_sem);
 
 		if (retval <= 0)
-- 
1.4.2.4


--/04w6evG8XlLl3ft--
