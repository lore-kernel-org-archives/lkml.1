Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXLSGzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXLSGzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 01:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXLSGzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 01:55:25 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54212 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750802AbXLSGzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 01:55:24 -0500
Message-ID: <398047328.03778@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 19 Dec 2007 14:55:17 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] readahead: clean up and simplify the code for
	filemap page fault readahead
References: <20071216115927.986126305@mail.ustc.edu.cn> <20071216120417.748714367@mail.ustc.edu.cn> <20071218081907.GB32114@wotan.suse.de> <E1J4ay1-0000ak-3e@localhost> <20071218235423.GB20838@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218235423.GB20838@wotan.suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J4spp-0001pR-JQ@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 12:54:23AM +0100, Nick Piggin wrote:
> On Tue, Dec 18, 2007 at 07:50:33PM +0800, Fengguang Wu wrote:
> > On Tue, Dec 18, 2007 at 09:19:07AM +0100, Nick Piggin wrote:
> > > On Sun, Dec 16, 2007 at 07:59:30PM +0800, Fengguang Wu wrote:
> > 
> > > > +	read_lock_irq(&mapping->tree_lock);
> > > > +	page = radix_tree_lookup(&mapping->page_tree, offset);
> > > > +	if (likely(page)) {
> > > > +		int got_lock, uptodate;
> > > > +		page_cache_get(page);
> > > > +
> > > > +		got_lock = !TestSetPageLocked(page);
> > > > +		uptodate = PageUptodate(page);
> > > > +		read_unlock_irq(&mapping->tree_lock);
> > > 
> > > If we could avoid open coding tree_lock here (and expanding its coverage
> > > to PageUptodate), that would be nice. I don't think it gains us too much.
> > 
> > To use find_get_page()? That would be nice to me, too.
> 
> Exactly.

Done. Also I think it's better not to split the `found' case into
the two cases of 'found & lock-ok' and 'found & wait-lock' for now.
That would reduce some more code:

-/*
- * A successful mmap hit is when we didn't need any IO at all,
- * and got an immediate lock on an up-to-date page. There's not
- * much to do, except decide on whether we want to trigger read-
- * ahead.
- *
- * We currently do the same thing as we did for a locked page
- * that we're waiting for.
- */
-static void do_mmap_hit(struct vm_area_struct *vma,
-			struct file_ra_state *ra,
-			struct file *file,
-			struct page *page,
-			pgoff_t offset)
-{
-	do_async_mmap_readahead(vma, ra, file, page, offset);
-}
-
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1411,28 +1396,13 @@
 		return VM_FAULT_SIGBUS;
 
 	/*
-	 * Do we have something in the page cache already that
-	 * is unlocked and already up-to-date?
+	 * Do we have something in the page cache already?
 	 */
 	page = find_get_page(mapping, offset);
 	if (likely(page)) {
-		if (likely(!TestSetPageLocked(page))) {
-			/*
-			 * Previous IO error? No read-ahead, but try to
-			 * re-do a single read.
-			 */
-			if (unlikely(!PageUptodate(page)))
-				goto page_not_uptodate;
-
-			do_mmap_hit(vma, ra, file, page, offset);
-			goto found_it;
-		}
-
 		/*
-		 * We found the page, but it was locked..
-		 *
-		 * So do async readahead and wait for it to
-		 * unlock.
+		 * We found the page, so try async readahead before
+		 * waiting for the lock.
 		 */
 		do_async_mmap_readahead(vma, ra, file, page, offset);
 		lock_page(page);

