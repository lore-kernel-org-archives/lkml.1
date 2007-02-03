Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXBCR4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXBCR4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXBCR4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:56:44 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:47882 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbXBCR4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:56:43 -0500
Date: Sat, 3 Feb 2007 09:56:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <20070203005316.eb0b4042.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203005316.eb0b4042.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Andrew Morton wrote:

> I wonder if it can be simpler.  Make two changes:

Would be great if this could get simpler.

> a) If the scanner encounters an mlocked page on the LRU, take it off.

The current patch takes them off when mlock is set (which may not work 
since the page may be off the LRU) and then has the scanner taking them 
off. We could just remove the early one but what would this bring us?

> b) munlock() adds all affected pages to the LRU.

Hmmm... You mean without checking all the vmas of a page for VM_LOCKED? So they 
are going to be removed again on the next pass? Ok. I see that makes it 
simpler but it requires another reclaim scan.

> doesn't consume a page flag.  Optional (and arguable) extension: scan the
> vmas during munmap, don't add page to LRU if it's still mlocked.
> 
> Why _does_ your patch add a new page flag?  That info is available via a
> vma scan.

The page flag allows a clean state transition of a page and accurate 
keeping of statistics for MLOCKed pages. There were objections against the 
fuzzy counting in the earlier incarnation and it was proposed that a page 
flag be introduced. Without the flag we cannot know that the page is 
already mapped by a VM_LOCKED vma without scanning over all vmas 
referencing the page.

> > 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.
> 
> Ow.  How were you thinking of fixing that?

I thought someone else could come up with something. Maybe the one that 
told me to use another page flag?

> > 2. Since mlocked pages are now off the LRU page migration will no longer
> >    move them.
> 
> Ow.  That could be a right pain when we get around to using migration for
> memory-unplug?

We need to expand page migration anyways to allow the gerneral migration 
of non-LRU pages.
