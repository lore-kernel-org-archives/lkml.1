Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbXKOGLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbXKOGLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXKOGKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36476 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXKOGKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:31 -0500
Date: Wed, 14 Nov 2007 22:09:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Duane Griffin <duaneg@dghda.com>, Nick Piggin <npiggin@suse.de>
Subject: [patch 03/13] Remove broken ptrace() special-case code from file
	mapping
Message-ID: <20071115060924.GD7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="remove-broken-ptrace-special-case-code-from-file-mapping.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


stable review patch.  If anyone has any objections, please let us know.

------------------

The kernel has for random historical reasons allowed ptrace() accesses
to access (and insert) pages into the page cache above the size of the
file.

However, Nick broke that by mistake when doing the new fault handling in
commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7 ("mm: merge populate and
nopage into fault (fixes nonlinear)".  The breakage caused a hang with
gdb when trying to access the invalid page.

The ptrace "feature" really isn't worth resurrecting, since it really is
wrong both from a portability _and_ from an internal page cache validity
standpoint.  So this removes those old broken remnants, and fixes the
ptrace() hang in the process.

Noticed and bisected by Duane Griffin, who also supplied a test-case
(quoth Nick: "Well that's probably the best bug report I've ever had,
thanks Duane!").

Cc: Duane Griffin <duaneg@dghda.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1312,7 +1312,7 @@ int filemap_fault(struct vm_area_struct 
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
@@ -1389,7 +1389,7 @@ retry_find:
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -1400,15 +1400,6 @@ retry_find:
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
-outside_data_content:
-	/*
-	 * An external ptracer can access pages that normally aren't
-	 * accessible..
-	 */
-	if (vma->vm_mm == current->mm)
-		return VM_FAULT_SIGBUS;
-
-	/* Fall through to the non-read-ahead case */
 no_cached_page:
 	/*
 	 * We're only likely to ever get here if MADV_RANDOM is in

-- 
