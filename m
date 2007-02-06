Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXBFCJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXBFCJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965434AbXBFCJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:09:18 -0500
Received: from mail.suse.de ([195.135.220.2]:42755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965433AbXBFCJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:09:17 -0500
Date: Tue, 6 Feb 2007 03:09:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070206020916.GA31476@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site> <20070204063833.23659.55105.sendpatchset@linux.site> <20070204014445.88e6c8c7.akpm@linux-foundation.org> <Pine.LNX.4.64.0702041036420.24838@hermes-1.csi.cam.ac.uk> <20070204031039.46b56dbb.akpm@linux-foundation.org> <Pine.LNX.4.64.0702041737110.19190@hermes-1.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702041737110.19190@hermes-1.csi.cam.ac.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 05:40:35PM +0000, Anton Altaparmakov wrote:
> On Sun, 4 Feb 2007, Andrew Morton wrote:
> > truncate's OK: we're holding i_mutex.
> 
> How about excluding readpage() (in addition to truncate if Nick is right  
> and some cases of truncate do not hold i_mutex) with an extra page flag as
> I proposed for truncate exclusion?  Then it would not matter that
> prepare_write might have allocated blocks and might expose stale data.    
> It would go to sleep and wait on the bit to be cleared instead of trying  
> to bring the page uptodate.  It can then lock the page and either find it 
> uptodate (because commit_write did it) or not and then bring it uptodate.
> 
> Then we could safely fault in the page, copy from it into a temporary 
> page, then lock the destination page again and copy into it.
> 
> This is getting more involved as a patch again...  )-:  But at least it   
> does not affect the common case except for having to check the new page 
> flag in every readpage() and truncate() call.  But at least the checks 
> could be with an "if (unlikely(newpageflag()))" so should not be too bad.
> 
> Have I missed anything this time?

Yes. If you have a flag to exclude readpage(), then you must also
exclude filemap_nopage, in which case it is still deadlocky.

