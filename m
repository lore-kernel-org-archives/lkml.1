Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXCEPuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXCEPuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933554AbXCEPuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:50:18 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45746 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551AbXCEPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:50:16 -0500
Subject: Re: 2.6.21-rc2-git3 Unstable for me
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1173108985.9109.11.camel@kleikamp.austin.ibm.com>
References: <20070305150317.57e62d70@disher.kickcrew>
	 <45EC3058.2010903@redhat.com>
	 <1173108985.9109.11.camel@kleikamp.austin.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 09:50:11 -0600
Message-Id: <1173109811.9109.17.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 09:36 -0600, Dave Kleikamp wrote:
> On Mon, 2007-03-05 at 09:59 -0500, Chuck Ebbert wrote:
> > Will Trives wrote:
> > 
> > [adding JFS maintainer to cc:]
> 
> Thanks for adding me to the thread.
> 
> > Some kind of JFS problem?
> 
> I don' t know yet.  I was notified of the problem through bugzilla:
> http://bugzilla.kernel.org/show_bug.cgi?id=8128
> 
> The problem appears that a non-uptodate page has been marked dirty.  I
> haven't found much in the way of changes between 2.6.20 and the current
> git tree to explain this.  There's this one:
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22c8ca78f20724676b6006232bf06cc3e9299539
> 
> I'm looking for for a caller to ->prepare_write() which marks the page
> dirty without calling ->commit_write().

I think I just found it:

nobh_truncate_page():

	ret = a_ops->prepare_write(NULL, page, offset, to);
	if (ret == 0) {
		kaddr = kmap_atomic(page, KM_USER0);
		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
		flush_dcache_page(page);
		kunmap_atomic(kaddr, KM_USER0);
		set_page_dirty(page);
	}
	unlock_page(page);
	page_cache_release(page);

> 
> Will, could you try reverting that patch?  If that fails, narrowing the
> problem down with git-bisect would be helpful, if you have the time.

Better yet, try this patch:

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux-orig/fs/buffer.c linux/fs/buffer.c
--- linux-orig/fs/buffer.c	2007-02-22 07:59:01.000000000 -0600
+++ linux/fs/buffer.c	2007-03-05 09:47:07.000000000 -0600
@@ -2466,6 +2466,7 @@ int nobh_truncate_page(struct address_sp
 		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
 		flush_dcache_page(page);
 		kunmap_atomic(kaddr, KM_USER0);
+		SetPageUptodate(page);
 		set_page_dirty(page);
 	}
 	unlock_page(page);

-- 
David Kleikamp
IBM Linux Technology Center

