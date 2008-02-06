Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYBFUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYBFUf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbYBFUfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:35:09 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53587 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564AbYBFUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:35:06 -0500
Date: Wed, 6 Feb 2008 20:33:07 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Matt Helsley <matthltc@us.ibm.com>, Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
In-Reply-To: <20080203182135.GA5827@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802062023100.32204@blonde.site>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
 <20080130172646.GA2355@tv-sign.ru> <1201987065.9062.6.camel@localhost.localdomain>
 <20080203182135.GA5827@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008, Oleg Nesterov wrote:
> 
> So I have to try to find another bug ;) Suppose that ->load_binary() does
> a series of do_mmap(MAP_EXECUTABLE). It is possible that mmap_region() can
> merge 2 vmas. In that case we "leak" ->num_exe_file_vmas. Unless I missed
> something, mmap_region() should do removed_exe_file_vma() when vma_merge()
> succeds (near fput(file)).

Or there's the complementary case of a VM_EXECUTABLE vma being
split in two, for example by an mprotect of a part of it.

Sorry, Matt, I don't like your patch at all.  It seems to add a fair
amount of ugliness and unmaintainablity, all for a peculiar MVFS case
(you've tried to argue other advantages, but not always convinced!).

And I found it quite hard to see where the crucial difference comes.
I guess it's that MVFS changes vma->vm_file in its ->mmap?  Well, if
MVFS does that, maybe something else does that too, but precisely to
rely on the present behaviour of /proc/pid/exe - so in fixing for
MVFS, we'd be breaking that hypothetical other?

I can understand patches to avoid mmap_sem for /proc/pid/exe, but
this one just seems too messy for too special an out-of-tree case.
(I've no last word on this, but that's my opinion.)

Hugh
