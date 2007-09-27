Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXI0XAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXI0XAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbXI0XAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:00:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948AbXI0XAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:00:11 -0400
Date: Thu, 27 Sep 2007 15:59:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kswapd should only wait on IO if there is IO
Message-Id: <20070927155907.a4dce0d8.akpm@linux-foundation.org>
In-Reply-To: <20070927185027.1a1b4c13@bree.surriel.com>
References: <20070927170816.055548fd@bree.surriel.com>
	<20070927144702.a9124c7a.akpm@linux-foundation.org>
	<20070927181325.21aae460@bree.surriel.com>
	<20070927152121.3f5b6830.akpm@linux-foundation.org>
	<20070927185027.1a1b4c13@bree.surriel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 18:50:27 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Thu, 27 Sep 2007 15:21:21 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Nope, sc.nr_io_pages will also be incremented when the code runs into
> > > pages that are already PageWriteback.
> > 
> > yup, I didn't think of that.  Hopefully someone else will be in there
> > working on that zone too.  If this caller yields and defers to kswapd
> > then that's very likely.  Except we just took away the ability to do that..
> 
>                 if (PageDirty(page)) {
>                         if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
>                                 goto keep_locked;
>                         if (!may_enter_fs)
>                                 goto keep_locked;
> 
> I think we can fix that problem by adding a sc->nr_io_pages++
> between the last if and the goto keep_locked in shrink_page_list.
> 
> That way !GFP_IO or !GFP_FS tasks will cause themselves to sleep
> if there are pages that need to be written out, even if those
> pages are not in flight to disk yet.

yeah, that's prudent I guess.

> I have also added the comment you wanted.

And lost the changelog ;)

> -		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
> +		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
> +				sc.nr_io_pages > sc.swap_cluster_max)

I do think this design decision needs a bit of explanation too.

>  			congestion_wait(WRITE, HZ/10);
>  	}
>  	/* top priority shrink_caches still had more to do? don't OOM, then */
> @@ -1315,6 +1330,7 @@ loop_again:
>  		if (!priority)
>  			disable_swap_token();
>  
> +		sc.nr_io_pages = 0;
>  		all_zones_ok = 1;
>  
>  		/*
> @@ -1398,7 +1414,8 @@ loop_again:
>  		 * OK, kswapd is getting into trouble.  Take a nap, then take
>  		 * another pass across the zones.
>  		 */
> -		if (total_scanned && priority < DEF_PRIORITY - 2)
> +		if (total_scanned && priority < DEF_PRIORITY - 2 &&

As did that one.  Ho hum :(  Maybe it's in the git history somewhere.

