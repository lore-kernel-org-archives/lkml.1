Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbZDAXCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbZDAXCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZDAXCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:02:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbZDAXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:02:23 -0400
Date: Wed, 1 Apr 2009 15:57:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ngupta@vflare.org
Cc: nitingupta910@gmail.com, penberg@cs.helsinki.fi, cl@linux-foundation.org,
       edt@aei.ca, linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] compressed in-memory swapping take5
Message-Id: <20090401155743.685e2c1e.akpm@linux-foundation.org>
In-Reply-To: <49D0DBA2.20101@vflare.org>
References: <49D0DBA2.20101@vflare.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 20:18:02 +0530
Nitin Gupta <nitingupta910@gmail.com> wrote:

> Hi,
> 
> Project home: http://compcache.googlecode.com
> 
> It allows creating a RAM based block device which acts as swap disk.
> Pages swapped to this device are compressed and stored in memory itself.
> This is a big win over swapping to slow hard-disk which are typically used
> as swap disk. For flash, these suffer from wear-leveling issues when used
> as swap disk - so again its helpful. For swapless systems, it allows more
> apps to run.
> 
> * Changelog: take5 vs take4
> xvmalloc changes:
>   - Use kzalloc() instead of kmalloc() + memset().
>   - Remove redundant initialization of pool freelists to 0.
> 
> * Changelog: take4 vs take3
> xvmalloc changes:
>   - Fixed regression in take3 that caused ramzswap write failures.
>     This happened due to error in find_block() where we did not do
>     explicit cast to 'unsigned long' when checking for bits set in
>     bitmap. Now changed it to use kernel build-in test_bit().
>   - Fix divide by zero error in proc read function.
> ramzswap changes:
>   - Forward write requests to backing swap device if allocation for
>     compressed page fails.
>   - Code cleanups.
> 
> * Changelog: take3 vs take2
> xvmalloc changes:
>   - Use kernel defined macros and constants in xvmalloc and remove
>     equivalent defines for ALIGN, roundup etc.
>   - Use kernel bitops (set_bit, clear_bit)
>   - Moved it to drivers/block since its not clear if it has any other
>     user.
> ramzswap changes:
>   - All instances of compcache renamed to ramzswap.
>     Also renamed module to ramzswap
>   - Renamed "backing_dev" parameter to "backing_swap"
>   - Documentation changes to reflect above changes.
>   - Remove "table index" from object header (4 bytes). This will be
>     needed when memory defragmentation is implemented. So, avoid this
>     (small) overhead for now.
> 
> * Changelog: take2 vs initial revision:
> xvmalloc changes:
>   - Use Linux kernel coding style for xvmalloc
>   - Collapse all individual flag test/set/get to generic {test_set_get}_flag
>   - Added BLOCK_NEXT() macro to reach next contiguous block
>   - Other minor cleanups - no functional changes
> compcache block device code:
>   - compcache core changes due to change in xvmalloc interface names
> 
> * Testing notes:
>   - Multiple cycles of 'scan' benchmark available at:
> http://linux-mm.org/PageReplacementTesting
> It does scans of anonymous mapped memory, both cyclic and use once.
> 
> Config:
> Arch: x86 and x64
> CPUs: 1/2, RAM: 512MB
> backing swap: 768MB, ramzswap memlimit: 76MB (15% of RAM).
> 
> Continuously run 'scan' till it triggers 200K R/W operations on ramzswap.
> Any incompressible pages were correctly forwarded to backing swap device.
> cmd: ./scan 450 20 # scan over 450MB, 20 times.
> 
>   - Links to more performance numbers, use cases can be found at:
> http://lkml.org/lkml/2009/3/17/116

The sole, whole, entire point of this patchset is performance.  Yet
after chasing a few scruffy links, the only data we have to justify
merging _any_ of this stuff is, and I quote,

 - The time of paging down one pdf page was reduced to 1/4~1/100
 - The time of switching from one firefox tab to another was reduced to 1/6
 - The capacity of kpdf was be increased from 2 pdf files to 11 pdf files.
 - The capacity of firefox was increased from 6 web pages to 15 web pages.

that isn't very compelling!

So would it be possible for you to come up with some more concrete
testing results to help convince us that we should make this change to
Linux?  And include them front-and-centre in the changelog, and
maintain it?

We would also be interested in seeing the performance _loss_ from these
patches.  There must be some cost somewhere.  Find a worstish-case test
case and run it and include its results in the changelog too, so we
better understand the tradeoffs involved here.


I'm really reluctant to go and merge a complete new memory allocator
just on behalf of an obscure driver.  Oh well, perhaps hiding it down
in drivers/block was the right thing to do.

As the patchset adds five tightly-related files, perhaps it should all
live in drivers/block/rmazswap/?

