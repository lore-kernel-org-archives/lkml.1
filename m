Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbYEHTUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbYEHTUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYEHTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:19:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59190 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYEHTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:19:51 -0400
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
CC: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm: fix infinite loop in filemap_fault
Message-Id: <E1JuBeb-0008Hr-0q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 May 2008 21:19:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is a pretty obvious fix.  The only thing I don't
understand, is how did this manage to go unnoticed for almost a year.
Are persistent read errors *that* rare?


----
From: Miklos Szeredi <mszeredi@suse.cz>

filemap_fault will go into an infinite loop if ->readpage() fails
asynchronously.

AFAICS the bug was introduced by this commit, which removed the wait
after the final readpage:

   commit d00806b183152af6d24f46f0c33f14162ca1262a
   Author: Nick Piggin <npiggin@suse.de>
   Date:   Thu Jul 19 01:46:57 2007 -0700

       mm: fix fault vs invalidate race for linear mappings

Fix by reintroducing the wait_on_page_locked() after ->readpage() to
make sure the page is up-to-date before jumping back to the beginning
of the function.

I've noticed this while testing nfs exporting on fuse.  The patch
fixes it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Nick Piggin <npiggin@suse.de>
---
 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux.git/mm/filemap.c
===================================================================
--- linux.git.orig/mm/filemap.c	2008-05-08 08:17:22.000000000 +0200
+++ linux.git/mm/filemap.c	2008-05-08 11:55:42.000000000 +0200
@@ -1461,6 +1461,11 @@ page_not_uptodate:
 	 */
 	ClearPageError(page);
 	error = mapping->a_ops->readpage(file, page);
+	if (!error) {
+		wait_on_page_locked(page);
+		if (!PageUptodate(page))
+			error = -EIO;
+	}
 	page_cache_release(page);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)
