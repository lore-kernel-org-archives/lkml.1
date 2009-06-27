Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZF0Pw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZF0Pw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 11:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZF0PwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 11:52:19 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62500 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZF0PwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 11:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Uha+RX6l2PjgU9F9VGojgH+GNvhkhxKJaxCYS0mOwBvQxKZYrpN8lAdl95LDGQzkkA
         DF5fMSbCS+ae9Zgg5S0EBHOl6QMFBmxrkepOa2ewA8531tDHZmNvtPaQDlhCRgeyqMD/
         5BmYjBv4tLvx+zas/SmR4nn1kHtf3m0RlKwjU=
MIME-Version: 1.0
In-Reply-To: <20090627125412.GA1667@cmpxchg.org>
References: <3901.1245848839@redhat.com> <20090624023251.GA16483@localhost>
	 <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com>
	 <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com>
	 <20090618095729.d2f27896.akpm@linux-foundation.org>
	 <7561.1245768237@redhat.com> <26537.1246086769@redhat.com>
	 <20090627125412.GA1667@cmpxchg.org>
Date: Sun, 28 Jun 2009 00:52:20 +0900
X-Google-Sender-Auth: 4784b9e577b139d0
Message-ID: <2f11576a0906270852h520fef19p50b77fd441065f67@mail.gmail.com>
Subject: Re: Found the commit that causes the OOMs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Howells <dhowells@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is the patch in question:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7592d8e..879d034 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1570,7 +1570,7 @@ static void shrink_zone(int priority, struct zone *zone,
>         * Even if we did not try to evict anon pages at all, we want to
>         * rebalance the anon lru active/inactive ratio.
>         */
> -       if (inactive_anon_is_low(zone, sc))
> +       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>
>        throttle_vm_writeout(sc->gfp_mask);
>
> When this was discussed, I think we missed that nr_swap_pages can
> actually get zero on swap systems as well and this should have been
> total_swap_pages - otherwise we also stop balancing the two anon lists
> when swap is _full_ which was not the intention of this change at all.
>
> [ There is another one hiding in shrink_zone() that does the same - it
> was moved from get_scan_ratio() and is pretty old but we still kept
> the inactive/active ratio halfway sane without MinChan's patch. ]
>
> This is from your OOM-run dmesg, David:
>
>  Adding 32k swap on swapfile22.  Priority:-21 extents:1 across:32k
>  Adding 32k swap on swapfile23.  Priority:-22 extents:1 across:32k
>  Adding 32k swap on swapfile24.  Priority:-23 extents:3 across:44k
>  Adding 32k swap on swapfile25.  Priority:-24 extents:1 across:32k
>
> So we actually have swap?  Or are those removed again before the OOM?

[grep to ltp source file]

ltp/testcases/kernel/syscalls/swapon/swapon03.c makes a lot of swap,
but it was removed when the test exit.

Then, When OOM happed, David's system don't have any swap. I don't think
your patch strike the target, unfortunately.
