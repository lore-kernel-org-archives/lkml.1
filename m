Return-Path: <linux-kernel-owner+w=401wt.eu-S1422956AbXCOQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422956AbXCOQ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422957AbXCOQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:29:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:37348 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422956AbXCOQ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:29:45 -0400
Date: Thu, 15 Mar 2007 17:29:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Ashif Harji <asharji@cs.uwaterloo.ca>, linux-mm@kvack.org,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070315162944.GI8321@wotan.suse.de>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <45F96CCB.4000709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F96CCB.4000709@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:56:59AM -0400, Chuck Ebbert wrote:
> Ashif Harji wrote:
> > 
> > This patch unconditionally calls mark_page_accessed to prevent pages,
> > especially for small files, from being evicted from the page cache
> > despite frequent access.
> > 
> > Signed-off-by: Ashif Harji <asharji@beta.uwaterloo.ca>
> > 
> 
> I like mine better -- it leaves the comment:

How about this? It also doesn't break the use-once heuristic.

--
A change to make database style random read() workloads perform better, by
calling mark_page_accessed for some non-page-aligned reads broke the case of
< PAGE_CACHE_SIZE files, which will not get their prev_index moved past the
first page.

Combine both heuristics for marking the page accessed.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -929,7 +929,7 @@ page_ok:
 		 * When (part of) the same page is read multiple times
 		 * in succession, only mark it as accessed the first time.
 		 */
-		if (prev_index != index)
+		if (prev_index != index || !offset)
 			mark_page_accessed(page);
 		prev_index = index;
 
