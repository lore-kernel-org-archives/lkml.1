Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYBROdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYBROdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYBROdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:33:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYBROdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:33:07 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Larry Woodman <lwoodman@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: Problem with /proc/sys/vm/lowmem_reserve_ratio ???
References: <47B5A699.7010509@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 18 Feb 2008 09:33:05 -0500
In-Reply-To: <47B5A699.7010509@redhat.com> (Larry Woodman's message of "Fri,
	15 Feb 2008 09:50:01 -0500")
Message-ID: <x49wsp272se.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Woodman <lwoodman@redhat.com> writes:

> balance_pgdat() calls zone_watermark_ok() three times, the first call
> passes a zero(0) in as the 4th argument.  This 4th argument is the
> classzone_idx which is used as the index into the
> zone->lowmem_reserve[] array.  Since setup_per_zone_lowmem_reserve()
> always sets the zone->lowmem_reserve[0] = 0(because there is nothing
> below the DMA zone), zone_watermark_ok() will not consider the
> lowmem_reserve pages when zero is passed as the 4th arg.  Shouldnt this
> 4th argument be either "i" or "nr_zones - 1" ???

That certainly looks like the intent of this code.  I'd say patch 1,
passing i in as the 4th arg.  Rik, what do you think?

Cheers,

Jeff

>
> -------------------------------------------------------------------------
> --- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
> 11:14:55.000000000 -0500
> +++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:15:02.000000000
> -0500
> @@ -1375,7 +1375,7 @@ loop_again:
>                                continue;
>
>                        if (!zone_watermark_ok(zone, order, zone->pages_high,
>
> -                                              0, 0)) {
> +                                              i, 0)) {
>                                end_zone = i;
>                                break;
> -------------------------------------------------------------------------
> --- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
> 11:14:55.000000000 -0500
> +++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:16:35.000000000
> -0500
> @@ -1375,7 +1375,7 @@ loop_again:
>                                continue;
>
>                        if (!zone_watermark_ok(zone, order, zone->pages_high,
>
> -                                              0, 0)) {
> +                                              nr_zones - 1, 0)) {
>                                end_zone = i;
>                                break;
>                        }
> -------------------------------------------------------------------------
