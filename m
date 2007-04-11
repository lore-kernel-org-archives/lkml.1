Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXDKC1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXDKC1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXDKC1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:27:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56284 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXDKC1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:27:35 -0400
Date: Tue, 10 Apr 2007 19:27:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-Id: <20070410192722.9e6efc8b.akpm@linux-foundation.org>
In-Reply-To: <20070410155411.GF13445@duck.suse.cz>
References: <20070410155411.GF13445@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 17:54:11 +0200 Jan Kara <jack@suse.cz> wrote:

> Introduce ra.offset and store in it an offset where the previous read ended. This way
> we can detect whether reads are really sequential (and thus we should not mark the page
> as accessed repeatedly) or whether they are random and just happen to be in the same page
> (and the page should really be marked accessed again).

(less columns, please)

OK.  So prev_page and prev_offset are now a complexified representation of a
loff_t, no?  

So why don't we just use a loff_t for this?

Anyway, the asymmetry in our handling of prev_index (sometimes called
prev_page!) and prev_offset is unpleasing.  This:

--- a/mm/filemap.c~readahead-improve-heuristic-detecting-sequential-reads-tidy
+++ a/mm/filemap.c
@@ -933,6 +933,7 @@ page_ok:
 		if (prev_index != index || offset != prev_offset)
 			mark_page_accessed(page);
 		prev_index = index;
+		prev_offset = ra.offset = offset;
 
 		/*
 		 * Ok, we have the page, and it's up-to-date, so
@@ -948,7 +949,6 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
-		prev_offset = ra.offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)

improves things somewhat.  But I think it would be nicer if their handling
was unified, or at least consistent.  We update ra.offset here, and we
update ra.prev_page over there.

And shouldn't offset be called prev_offset?  Or should prev_page be called
page?  Or index?  Or prev_index?  Or Marmaduke?  The naming is all a mess.

Wanna take a look at all of this, please?
