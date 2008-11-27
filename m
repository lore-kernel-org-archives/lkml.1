Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYK0NI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYK0NI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYK0NIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:08:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:34357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYK0NIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:08:19 -0500
Date: Thu, 27 Nov 2008 14:08:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Ying Han <yinghan@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, edwintorok@gmail.com
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Message-ID: <20081127130817.GP28285@wotan.suse.de>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492E6849.6090205@google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 01:28:41AM -0800, Mike Waychison wrote:
> >Hmm. How quantifiable is the benefit? Does it actually matter that you
> >can read the proc file much faster? (this is for some automated workload
> >management daemon or something, right?)
> 
> Correct.  I don't recall the numbers from the pathelogical cases we were 
> seeing, but iirc, it was on the order of 10s of seconds, likely 
> exascerbated by slower than usual disks.  I've been digging through my 
> inbox to find numbers without much success -- we've been using a variant 
> of this patch since 2.6.11.
> 
> Török however identified mmap taking on the order of several 
> milliseconds due to this exact problem:
> 
> http://lkml.org/lkml/2008/9/12/185

Turns out to be a different problem.


> >Would it be possible to reduce mmap()/munmap() activity? eg. if it is
> >due to a heap memory allocator, then perhaps do more batching or set
> >some hysteresis.
> 
> I know our tcmalloc team had made great strides to reduce mmap_sem 
> contention for the heap, but there are various other bits of the stack 
> that really want to mmap files..
> 
> We generally try to avoid such things, but sometimes it a) can't be 
> easily avoided (third party libraries for instance) and b) when it hits 
> us, it affects the overall health of the machine/cluster (the monitoring 
> daemons get blocked, which isn't very healthy).

Are you doing appropriate posix_fadvise to prefetch in the files before
faulting, and madvise hints if appropriate?

