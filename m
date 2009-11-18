Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZKRJ5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZKRJ5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZKRJ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbZKRJ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:57:32 -0500
Subject: Re: [PATCH 06/12] writeback: remove unused nonblocking and
 congestion checks (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091118082846.170413359@intel.com>
References: <20091118082648.140755818@intel.com>
	 <20091118082846.170413359@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 18 Nov 2009 09:59:46 +0000
Message-Id: <1258538386.2904.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

That looks ok to me, modulo the warnings below. The only "non-obvious"
thing in this area which the GFS2 writepage[s] code relies upon is the
assumption that if we have a ->writepages() then ->writepage() will
never be called from a context which requires the fs to actually do a
write (i.e. the fs can refuse this if required). That is also only the
case for journaled data files - normal writes don't have that
requirement.

 CC [M]  fs/gfs2/aops.o
fs/gfs2/aops.c: In function ‘gfs2_write_jdata_pagevec’:
fs/gfs2/aops.c:272: warning: unused variable ‘bdi’
fs/gfs2/aops.c: In function ‘gfs2_write_cache_jdata’:
fs/gfs2/aops.c:336: warning: unused variable ‘bdi’

Once the warnings are fixed:

Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Do you want me to add this patch into my tree, or were you planning to
submit via a different tree?

Steve.

On Wed, 2009-11-18 at 16:26 +0800, Wu Fengguang wrote:
> plain text document attachment
> (writeback-remove-congested-checks-linux_fs_gfs2_aops.patch)
> No one is calling wb_writeback and write_cache_pages with
> wbc.nonblocking=1 any more. And lumpy pageout will want to do
> nonblocking writeback without the congestion wait.
> 
> CC: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/gfs2/aops.c |   10 ----------
>  1 file changed, 10 deletions(-)
> 
> --- linux.orig/fs/gfs2/aops.c	2009-11-06 09:22:35.000000000 +0800
> +++ linux/fs/gfs2/aops.c	2009-11-06 09:52:15.000000000 +0800
> @@ -313,11 +313,6 @@ static int gfs2_write_jdata_pagevec(stru
>  
>  		if (ret || (--(wbc->nr_to_write) <= 0))
>  			ret = 1;
> -		if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -			wbc->encountered_congestion = 1;
> -			ret = 1;
> -		}
> -
>  	}
>  	gfs2_trans_end(sdp);
>  	return ret;
> @@ -348,11 +343,6 @@ static int gfs2_write_cache_jdata(struct
>  	int scanned = 0;
>  	int range_whole = 0;
>  
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		return 0;
> -	}
> -
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> 
> 

