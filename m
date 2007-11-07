Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXKGC4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXKGC4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXKGCz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:55:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbXKGCz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:55:56 -0500
Date: Tue, 6 Nov 2007 21:55:52 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/10] define page_file_cache
Message-ID: <20071106215552.4ab7df81@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
	<20071103185516.24832ab0@bree.surriel.com>
	<Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 18:23:44 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 3 Nov 2007, Rik van Riel wrote:
> 
> > Define page_file_cache() function to answer the question:
> > 	is page backed by a file?
> 
> Well its not clear what is meant by a file in the first place.
> By file you mean disk space in contrast to ram based filesystems?

Yes.  I have improved the comment over page_file_cache() a bit:

/**
 * page_file_cache(@page)
 * Returns !0 if @page is page cache page backed by a regular filesystem,
 * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
 *
 * We would like to get this info without a page flag, but the state
 * needs to survive until the page is last deleted from the LRU, which
 * could be as far down as __page_cache_release.
 */

> I think we could add a flag to the bdi to indicate wheter the backing 
> store is a disk file. In fact you can also deduce if if a device has
> no writeback capability set in the BDI.
> 
> > Unfortunately this needs to use a page flag, since the
> > PG_swapbacked state needs to be preserved all the way
> > to the point where the page is last removed from the
> > LRU.  Trying to derive the status from other info in
> > the page resulted in wrong VM statistics in earlier
> > split VM patchsets.
> 
> The bdi may avoid that extra flag.

The bdi will no longer be accessible by the time a page
makes it to free_hot_cold_page, which is one place in the
kernel where this information is needed.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
