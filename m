Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZHMRdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZHMRdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZHMRdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:33:22 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:22584 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088AbZHMRdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:33:22 -0400
X-Trace: 245891504/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.105.228/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.105.228
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEALPqg0pQKWnk/2dsb2JhbACBUtNGhBkF
X-IronPort-AV: E=Sophos;i="4.43,375,1246834800"; 
   d="scan'208";a="245891504"
Date: Thu, 13 Aug 2009 18:33:06 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: William R Speirs <bill.speirs@gmail.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: vma_merge issue
In-Reply-To: <4A83694F.6090809@gmail.com>
Message-ID: <Pine.LNX.4.64.0908131820500.13350@sister.anvils>
References: <a1b36c3a0908101347t796dedbat2ecb0535c32f325b@mail.gmail.com> 
 <Pine.LNX.4.64.0908121841550.14314@sister.anvils>
 <a1b36c3a0908121204q1b59df1fk86afec9d05ec16dc@mail.gmail.com>
 <Pine.LNX.4.64.0908122038360.18426@sister.anvils> <4A83694F.6090809@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, William R Speirs wrote:
> Hugh Dickins wrote:
> > 
> > MADV_DONTNEED: brilliant idea, what a shame it doesn't work for you.
> > I'd been on the point of volunteering a bugfix to it to do what you
> > want, it would make sense; but there's a big but... we have sold
> > MADV_DONTNEED as an madvise that only needs non-exclusive access
> > to the mmap_sem, which means it can be used concurrently with faulting,
> > which has made it much more useful to glibc (I believe).  If we were
> > to fiddle with vmas and accounting and merging in there, it would go
> > back to needing exclusive mmap_sem, which would hurt important users.
> 
> For my own edification, hurt these users how? Performance? Serializing access
> during a MADV_DONTNEED? I wonder how big the "hurt" would be?

Performance, yes: serializing, yes.

I forget the details, others will have paid closer attention, I may
be making this up!  But it was something like garbage collection when
when freeing mallocs: it pays off if faults elsewhere in the address
space can occur concurrently, but bad news if exclusive mmap_sem
locks out those faults.  Big enough hurt to show up very badly in
some reallife multithreaded apps, and benchmarks hitting the issue.

> > A "refinement" to that suggestion is to put the file on tmpfs:
> > you will then get charged for RAM+swap as you use it, but you can
> > use madvise MADV_REMOVE to unmap pages, punching holes in the file,
> > freeing up those charges.  A little baroque, but I think it does
> > amount to a way of doing exactly what you wanted in the first place.
> 
> I like this (the refined) idea a lot. I coded it up and works as expected,
> and the way I initially want.
> 
> Thanks for taking the time and providing the solution... I appreciate it.

I'm very glad to hear that worked out: thanks for reporting back.

Hugh
