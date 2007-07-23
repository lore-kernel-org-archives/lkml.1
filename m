Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXGWGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXGWGrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbXGWGrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:47:08 -0400
Received: from gw.goop.org ([64.81.55.164]:41559 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbXGWGrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:47:06 -0400
Message-ID: <46A44EB4.3070501@goop.org>
Date: Sun, 22 Jul 2007 23:46:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Jeff Garzik <jeff@garzik.org>,
       xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/net/xen-netfront.c: bogus code
References: <20070722232618.GO26212@stusta.de>
In-Reply-To: <20070722232618.GO26212@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The Coverity checker spotted the following bogus code
> in drivers/net/xen-netfront.c:
>
> <--  snip  -->
>
> ...
> static void xennet_alloc_rx_buffers(struct net_device *dev)
> {
> ...
>         for (nr_flips = i = 0; ; i++) {
>                 skb = __skb_dequeue(&np->rx_batch);
>                 if (skb == NULL)
>                         break;
>
>                 skb->dev = dev;
>
>                 id = xennet_rxidx(req_prod + i);
>
>                 BUG_ON(np->rx_skbs[id]);
>                 np->rx_skbs[id] = skb;
>
>                 ref = gnttab_claim_grant_reference(&np->gref_rx_head);
>                 BUG_ON((signed short)ref < 0);
>                 np->grant_rx_ref[id] = ref;
>
>                 pfn = page_to_pfn(skb_shinfo(skb)->frags[0].page);
>                 vaddr = page_address(skb_shinfo(skb)->frags[0].page);
>
>                 req = RING_GET_REQUEST(&np->rx, req_prod + i);
>                 gnttab_grant_foreign_access_ref(ref,
>                                                 np->xbdev->otherend_id,
>                                                 pfn_to_mfn(pfn),
>                                                 0);
>
>                 req->id = id;
>                 req->gref = ref;
>         }
>
>         if (nr_flips != 0) {
> ...
>
> <--  snip  -->
>
> Note that "nr_flips" is always 0 in the last line.
>   

Thanks.  That's probably a residual from me removing the page-flipping
code.  I'll give it another pass.

    J
