Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZKBTDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZKBTDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZKBTDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:03:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZKBTDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:03:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Date: Mon, 2 Nov 2009 20:05:04 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <4AEE0536.6020605@crca.org.au> <20091103002520.886C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091103002520.886C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911022005.04076.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, KOSAKI Motohiro wrote:
> Hi
> 
> Thank you for the reviewing :)
> 
> > > 2) shrink_all_zone() try to shrink all pages at a time. but it doesn't works
> > >   fine on numa system.
> > >   example)
> > >     System has 4GB memory and each node have 2GB. and hibernate need 1GB.
> > > 
> > >     optimal)
> > >        steal 500MB from each node.
> > >     shrink_all_zones)
> > >        steal 1GB from node-0.
> > 
> > I haven't given much thought to numa awareness in hibernate code, but I
> > can say that the shrink_all_memory interface is woefully inadequate as
> > far as zone awareness goes. Since lowmem needs to be atomically restored
> > before we can restore highmem, we really need to be able to ask for a
> > particular number of pages of a particular zone type to be freed.
> 
> Honestly, I am not suspend/hibernation expert. Can I ask why caller need to know
> per-zone number of freed pages information? if hibernation don't need highmem.

It does need highmem.  At least the mainline version does.

> following incremental patch prevent highmem reclaim perfectly. Is it enough?

Thanks,
Rafael

 
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e6ea011..7fb3435 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2265,7 +2265,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
>  {
>  	struct reclaim_state reclaim_state;
>  	struct scan_control sc = {
> -		.gfp_mask = GFP_HIGHUSER_MOVABLE,
> +		.gfp_mask = GFP_KERNEL,
>  		.may_swap = 1,
>  		.may_unmap = 1,
>  		.may_writepage = 1,
