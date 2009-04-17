Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZDQF17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZDQF17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZDQF1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:27:51 -0400
Received: from cmpxchg.org ([85.214.51.133]:36785 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbZDQF1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:27:50 -0400
Date: Fri, 17 Apr 2009 07:27:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback.c: fix sparse warnings
Message-ID: <20090417052730.GA2505@cmpxchg.org>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9049@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F9049@mi8nycmail19.Mi8.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 09:26:35PM -0400, H Hartley Sweeten wrote:
> Fix two sparse warnings in mm/page-writeback.c.

You fixed code rather than warnings, right? ;)

> get_dirty_limits() calls clip_bdi_dirty_limit() and task_dirty_limit()
> with variable pbdi_dirty as one of the arguments. This variable is
> an unsigned long * but both functions expect it to be a long *. This
> causes the following sparse warnings:
> 
>   warning: incorrect type in argument 3 (different signedness)
>      expected long *pbdi_dirty
>      got unsigned long *pbdi_dirty
>   warning: incorrect type in argument 2 (different signedness)
>      expected long *pdirty
>      got unsigned long *pbdi_dirty
> 
> Fix the warnings by changing the long * to unsigned long * in both
> functions.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 30351f0..e40b3e3 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -265,18 +265,20 @@ static void bdi_writeout_fraction(struct
> backing_dev_info *bdi,
>   * This avoids exceeding the total dirty_limit when the floating
> averages
>   * fluctuate too quickly.
>   */
> -static void
> -clip_bdi_dirty_limit(struct backing_dev_info *bdi, long dirty, long
> *pbdi_dirty)

Your patches wrap, please fix your mail client to not do this.

> +static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
> +		unsigned long dirty, unsigned long *pbdi_dirty)
>  {
> -	long avail_dirty;
> +	unsigned long avail_dirty;
> +	unsigned long nr_pages;
>  
> -	avail_dirty = dirty -
> -		(global_page_state(NR_FILE_DIRTY) +
> +	nr_pages = global_page_state(NR_FILE_DIRTY) +
>  		 global_page_state(NR_WRITEBACK) +
>  		 global_page_state(NR_UNSTABLE_NFS) +
> -		 global_page_state(NR_WRITEBACK_TEMP));
> +		 global_page_state(NR_WRITEBACK_TEMP);
>  
> -	if (avail_dirty < 0)
> +	if (nr_pages < dirty)
> +		avail_dirty = dirty - nr_pages;
> +	else
>  		avail_dirty = 0;

No need for a new variable, especially if nr_pages really counts
available dirty pages.

	avail_dirty = global_page_state() + ...
	if (avail_dirty < dirty)
		avail_dirty = dirty - avail_dirty;
	else
		avail_dirty = 0;

Hm?
