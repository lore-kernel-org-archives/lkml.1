Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXCEXDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXCEXDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXCEXDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:03:51 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42325 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXCEXDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:03:50 -0500
Subject: Re: [PATCH] fs: nobh_truncate_page() fix
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
References: <20070305150317.57e62d70@disher.kickcrew>
	 <45EC3058.2010903@redhat.com>
	 <1173108985.9109.11.camel@kleikamp.austin.ibm.com>
	 <1173109811.9109.17.camel@kleikamp.austin.ibm.com>
	 <1173128289.9109.36.camel@kleikamp.austin.ibm.com>
	 <Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:02:01 -0600
Message-Id: <1173135721.9109.78.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 13:43 -0800, Linus Torvalds wrote:
> 
> On Mon, 5 Mar 2007, Dave Kleikamp wrote:
> > 
> > This fixes a regression caused by 22c8ca78f20724676b6006232bf06cc3e9299539.
> > 
> > nobh_prepare_write() no longer marks the page uptodate, so
> > nobh_truncate_page() needs to do it.
> 
> I'm not convinced...

I should have described the problem better.  Assuming Nick's patch
(22c8ca78f20724676b6006232bf06cc3e9299539) makes sense by moving the
SetPageUptodate() from nobh_prepare_write() to nobh_commit_write(), it
follows that nobh_truncate_page(), which doesn't call
nobh_commit_write() needs to call SetPageUpdate().

> If the page wasn't up-to-date from before, it's *not* necessarily 
> up-to-date after the truncate either! So why do we have that at all?

> The same comment is true of "nobh_commit_write()" (which _does_ have the 
> SetPageUptodate() there).

> So I have three questions:
> 
>  - why is that valid in the first place (the page is *not* guaranteed to 
>    be up-to-date as far as I can see!)

->prepare_write() guarantees that the parts of the page before offset
(and beyond to) are up-to-date, and nobh_truncate_page() zeros the rest
of the page.

> 
>  - why is it valid to do in "nobh_commit_write()"

->commit_write() is only called after bringing the page up-to-date.

>  - why doesn't "nobh_truncate_page()"
> 	(a) call nobh_prepare_write() through an indirect pointer?

nobh_prepare_write() needs the filesystem's get_block() function, so
a_ops->prepare_write() will call nobh_prepare_write(...,
fs_specific_get_block)

> 	(b) call nobh_commit_write() at all? (Yeah, I realize it's because 
> 	    of brokenness with i_size, so this is more of a "those 
> 	    functions should be factored out properly" statement rather 
> 	    than a question.

It would be more consistent to call ->commit_write().  I assume it does
what it does as an optimization.  The fact that it doesn't call
nobh_commit_write() can be blamed for this bug, since it wasn't clear
that a change to nobh_commit_write() had to be mirrored in
nobh_truncate_page().

> IOW, I'm sure your patch _fixes_ something, but no, it's certainly not 
> obvious to me.  A few added comments would be good.

I've added some comments to the patch below

>  Why is it ok to do 
> this on a page that wasn't up-to-date before (since obviously, if it *was* 
> up-to-date, it's pointless).

Before Nick's patch, nobh_prepare_write() incorrectly marked the page
up-to-date.  (It was just a little bit too early.)  His patch moved
SetPageUptodate() to a better place, nobh_commit_write(), but it missed
that nobh_truncate_page() cheats by not calling nobh_commit_write().

fs: nobh_truncate_page() must set page up to date

This fixes a regression caused by 22c8ca78f20724676b6006232bf06cc3e9299539.

nobh_prepare_write() no longer marks the page uptodate, so
nobh_truncate_page() needs to do it.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux-orig/fs/buffer.c linux/fs/buffer.c
--- linux-orig/fs/buffer.c	2007-02-22 07:59:01.000000000 -0600
+++ linux/fs/buffer.c	2007-03-05 16:56:24.000000000 -0600
@@ -2365,6 +2365,10 @@ failed:
 }
 EXPORT_SYMBOL(nobh_prepare_write);
 
+/*
+ * Make sure any changes to nobh_commit_write() are reflected in
+ * nobh_truncate_page(), since it doesn't call commit_write().
+ */
 int nobh_commit_write(struct file *file, struct page *page,
 		unsigned from, unsigned to)
 {
@@ -2466,6 +2470,11 @@ int nobh_truncate_page(struct address_sp
 		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
 		flush_dcache_page(page);
 		kunmap_atomic(kaddr, KM_USER0);
+		/*
+		 * It would be more correct to call aops->commit_write()
+		 * here, but this is more efficient.
+		 */
+		SetPageUptodate(page);
 		set_page_dirty(page);
 	}
 	unlock_page(page);

-- 
David Kleikamp
IBM Linux Technology Center

