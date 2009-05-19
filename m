Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZESKUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZESKUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZESKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:20:47 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:41439 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbZESKUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:20:47 -0400
Message-ID: <4A1287FC.9020401@rsk.demon.co.uk>
Date: Tue, 19 May 2009 11:20:44 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for flushing
 data
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1242649192-16263-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> <snip>
> index 2296ff4..76269f8 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -541,7 +530,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		 * been flushed to permanent storage.
>  		 */
>  		if (bdi_nr_reclaimable) {
> -			writeback_inodes(&wbc);
> +			generic_sync_bdi_inodes(NULL, &wbc);
>  			pages_written += write_chunk - wbc.nr_to_write;
>  			get_dirty_limits(&background_thresh, &dirty_thresh,
>  				       &bdi_thresh, bdi);
> @@ -592,7 +581,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
>  					  + global_page_state(NR_UNSTABLE_NFS)
>  					  > background_thresh)))
> -		pdflush_operation(background_writeout, 0);
> +		bdi_start_writeback(bdi, NULL, 0);
>  }
>  
Hi Jens,

I'm interested in this slight change of behaviour, when over the
background dirty limit background_writeout will write any dirty pages
while bdi_start_writeout writes only pages for the current bdi. Are
there any benefits in making this change?

Thinking about the case of 2 apps writing to different bdis. When app A
stops writing, then next time app B goes over the background dirty
threshold it will only be able to write its own pages, leaving any from
app A dirty until they reach their age limit.

So we may be keeping dirty pages for the app that's finished longer than
necessary. Keeping pages for a finished app while flushing pages from a
running app seems a bit strange. I guess this is an odd corner case and
may not be worth worrying about, but I'd be interested to hear what you
think.

Do you think your new code will require any changes to the per bdi dirty
limits? It may be informative & interesting to run some tests writing to
fast & slow devices at the same time.

regards
Richard





