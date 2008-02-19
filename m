Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbYBSX5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbYBSX5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbYBSX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:57:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057AbYBSX5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:57:10 -0500
Date: Tue, 19 Feb 2008 15:55:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Woodman <lwoodman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with /proc/sys/vm/lowmem_reserve_ratio
Message-Id: <20080219155535.bf317d19.akpm@linux-foundation.org>
In-Reply-To: <47BB4BB5.20709@redhat.com>
References: <47BB4BB5.20709@redhat.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 16:35:49 -0500 Larry Woodman <lwoodman@redhat.com> wrote:

> balance_pgdat() calls zone_watermark_ok() three times, the first call
> passes a zero(0) in as the 4th argument.  This 4th argument is the
> classzone_idx which is used as the index into the zone->lowmem_reserve[] 
> array. 
> Since setup_per_zone_lowmem_reserve()
> always sets the zone->lowmem_reserve[0] = 0(because there is nothing
> below the DMA zone), zone_watermark_ok() will not consider the
> lowmem_reserve pages when zero is passed as the 4th arg.   The
> 4th argument must be "i" or balance_pgdat wont even get into the main loop
> when lowmem_reserve_ratio is lowered.
> 
> -------------------------------------------------------------------------
> --- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
> 11:14:55.000000000 -0500
> +++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:15:02.000000000
> -0500
> @@ -1375,7 +1375,7 @@ loop_again:
>                                continue;
> 
>                        if (!zone_watermark_ok(zone, order, 
> zone->pages_high,
> 
> -                                              0, 0)) {
> +                                              i, 0)) {
>                                end_zone = i;
>                                break;

Yes, thanks, this is in my things-to-worry-about-when-i-get-home bucket. 
We should find the changeset which added this and work out if for some
reason it was intentional.
