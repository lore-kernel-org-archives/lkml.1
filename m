Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZDKAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZDKAUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZDKAUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:20:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbZDKAUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:20:35 -0400
Date: Fri, 10 Apr 2009 17:16:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: vst@vlnb.net, jens.axboe@oracle.com, jmoyer@redhat.com,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] readahead: introduce context readahead algorithm
Message-Id: <20090410171652.96bceb90.akpm@linux-foundation.org>
In-Reply-To: <20090410131359.121195441@intel.com>
References: <20090410131247.764370473@intel.com>
	<20090410131359.121195441@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 21:12:50 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Introduce page cache context based readahead algorithm.
> This is to better support concurrent read streams in general.
> 
> RATIONALE
> ---------
> The current readahead algorithm detects interleaved reads in a _passive_ way.
> Given a sequence of interleaved streams 1,1001,2,1002,3,4,1003,5,1004,1005,6,...
> By checking for (offset == prev_offset + 1), it will discover the sequentialness
> between 3,4 and between 1004,1005, and start doing sequential readahead for the
> individual streams since page 4 and page 1005.
> 
> The context readahead algorithm guarantees to discover the sequentialness no
> matter how the streams are interleaved. For the above example, it will start
> sequential readahead since page 2 and 1002.
> 
> The trick is to poke for page @offset-1 in the page cache when it has no other
> clues on the sequentialness of request @offset: if the current requenst belongs
> to a sequential stream, that stream must have accessed page @offset-1 recently,
> and the page will still be cached now. So if page @offset-1 is there, we can
> take request @offset as a sequential access.
> 
> BENEFICIARIES
> -------------
> - strictly interleaved reads  i.e. 1,1001,2,1002,3,1003,...
>   the current readahead will take them as silly random reads;
>   the context readahead will take them as two sequential streams.
> 
> - seeky _column_ iterations on a huge matrix
>   Yes it can be regard as _massively_ interleaved streams!
>   Context readahead could transform the 1-page IOs (@offset+@size):
> 	0+1, 1000+1, 2000+1, 3000+1, ...,
> 	1+1, 1001+1, 2001+1, 3001+1, ...,
> 	2+1, 1002+1, 2002+1, 3002+1, ...
>   into larger sized IOs:
> 	0+1, 1000+1, 2000+1, 3000+1, ...,
> 	1+4, 1001+4, 2001+4, 3001+4, ...,
> 	5+8, 1005+8, 2005+8, 3005+8, ...
> 
> - cooperative IO processes   i.e. NFS and SCST
>   They create a thread pool, farming off (sequential) IO requests to different
>   threads which will be performing interleaved IO.
> 
>   It was not easy(or possible) to reliably tell from file->f_ra all those
>   cooperative processes working on the same sequential stream, since they will
>   have different file->f_ra instances. And NFSD's file->f_ra is particularly
>   unusable, since their file objects are dynamically created for each request.
>   The nfsd does have code trying to restore the f_ra bits, but not satisfactory.
> 
>   The new scheme is to detect the sequential pattern via looking up the page
>   cache, which provides one single and consistent view of the pages recently
>   accessed. That makes sequential detection for cooperative processes possible.
> 
> USER REPORT
> -----------
> Vladislav recommends the addition of context readahead as a result of his SCST
> benchmarks. It leads to 6%~40% performance gains in various cases and achieves
> equal performance in others.                http://lkml.org/lkml/2009/3/19/239
> 
> OVERHEADS
> ---------
> In theory, it introduces one extra page cache lookup per random read.  However
> the below benchmark shows context readahead to be slightly faster, wondering..
> 
> Randomly reading 200MB amount of data on a sparse file, repeat 20 times for
> each block size. The average throughputs are:
> 
>                        	original ra	context ra	gain
>  4K random reads:	 65.561MB/s	 65.648MB/s	+0.1%
> 16K random reads:	124.767MB/s	124.951MB/s	+0.1%
> 64K random reads: 	162.123MB/s	162.278MB/s	+0.1%
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Tested-by: Vladislav Bolkhovitin <vst@vlnb.net>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

> ---
>  mm/readahead.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> --- mm.orig/mm/readahead.c
> +++ mm/mm/readahead.c
> @@ -330,6 +330,59 @@ static unsigned long get_next_ra_size(st
>   */
>  
>  /*
> + * Count continuously cached pages from @offset-1 to @offset-@max,

You meant "contiguously" here, yes?

> + * this count is a conservative estimation of
> + * 	- length of the sequential read sequence, or
> + * 	- thrashing threshold in memory tight systems
> + */
> +static unsigned long count_history_pages(struct address_space *mapping,
> +					 struct file_ra_state *ra,
> +					 pgoff_t offset, unsigned long max)
> +{
> +	pgoff_t head;
> +
> +	rcu_read_lock();
> +	head = radix_tree_prev_hole(&mapping->page_tree, offset - 1, max);
> +	rcu_read_unlock();
> +
> +	return offset - 1 - head;
> +}

Doesn't matter much, but perhaps this should return pgoff_t.

> +/*
> + * page cache context based read-ahead
> + */
> +static int try_context_readahead(struct address_space *mapping,
> +				 struct file_ra_state *ra,
> +				 pgoff_t offset,
> +				 unsigned long req_size,
> +				 unsigned long max)
> +{
> +	unsigned long size;

And this could be pgoff_t too.

> +	size = count_history_pages(mapping, ra, offset, max);
> +
> +	/*
> +	 * no history pages:
> +	 * it could be a random read
> +	 */
> +	if (!size)
> +		return 0;
> +
> +	/*
> +	 * starts from beginning of file:
> +	 * it is a strong indication of long-run stream (or whole-file-read)
> +	 */
> +	if (size >= offset)
> +		size *= 2;
> +
> +	ra->start = offset;
> +	ra->size = get_init_ra_size(size + req_size, max);
> +	ra->async_size = ra->size;
> +
> +	return 1;
> +}
> +
> +/*
>   * A minimal readahead algorithm for trivial sequential/random reads.
>   */
>  static unsigned long
> @@ -395,6 +448,13 @@ ondemand_readahead(struct address_space 
>  		goto initial_readahead;
>  
>  	/*
> +	 * Query the page cache and look for the traces(cached history pages)
> +	 * that a sequential stream would leave behind.
> +	 */
> +	if (try_context_readahead(mapping, ra, offset, req_size, max))
> +		goto readit;
> +
> +	/*
>  	 * standalone, small random read
>  	 * Read as is, and do not pollute the readahead state.
>  	 */
> 
> -- 
