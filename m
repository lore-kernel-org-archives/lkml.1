Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZDJXgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZDJXgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 19:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZDJXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 19:36:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbZDJXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 19:36:44 -0400
Date: Fri, 10 Apr 2009 16:34:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       yinghan@google.com
Subject: Re: [PATCH 7/9] readahead: sequential mmap readahead
Message-Id: <20090410163413.a014bde0.akpm@linux-foundation.org>
In-Reply-To: <20090410061254.719205499@intel.com>
References: <20090410060957.442203404@intel.com>
	<20090410061254.719205499@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 14:10:04 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Auto-detect sequential mmap reads and do readahead for them.
> 
> The sequential mmap readahead will be triggered when
> - sync readahead: it's a major fault and (prev_offset == offset-1);
> - async readahead: minor fault on PG_readahead page with valid readahead state.
> 
> The benefits of doing readahead instead of read-around:
> - less I/O wait thanks to async readahead
> - double real I/O size and no more cache hits
> 
> The single stream case is improved a little.
> For 100,000 sequential mmap reads:
> 
>                                     user       system    cpu        total
> (1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
> (1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
> (2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607
> 
> The patched (2) has smallest total time, since it has no cache hit overheads
> and less I/O block time(thanks to async readahead). Here the I/O size
> makes no much difference, since there's only one single stream.
> 
> Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is 128KB,
> since the half of the read-around pages will be readahead cache hits.
> 
> This is going to make _real_ differences for _concurrent_ IO streams.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/filemap.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- mm.orig/mm/filemap.c
> +++ mm/mm/filemap.c
> @@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
>  	if (VM_RandomReadHint(vma))
>  		return;
>  
> -	if (VM_SequentialReadHint(vma)) {
> +	if (VM_SequentialReadHint(vma) ||
> +			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
>  		page_cache_sync_readahead(mapping, ra, file, offset, 1);
>  		return;
>  	}
> 

We've always believed that readaround was beneficial for more random
access patterns - classically faulting in an executable.  Although I
don't recall that this belief was very well substantiated.

(The best results I ever got was by doing readaround and setting the
size to a few MB, so we slurp the entire executable into memory in one
hit.  lol.)

So my question is: what is the probability that this change will
inadvertently cause a randomish-access workload to fall into readahead
(rather than readaround) mode, and what is the impact when this
happens?


