Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYJIA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYJIA5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYJIA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:57:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYJIA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:57:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 2/2] virtio_net: Improve the recv buffer allocation scheme
Date: Thu, 9 Oct 2008 11:55:59 +1100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Herbert Xu <herbert.xu@redhat.com>
References: <> <1223494499-18732-1-git-send-email-markmc@redhat.com> <1223494499-18732-2-git-send-email-markmc@redhat.com>
In-Reply-To: <1223494499-18732-2-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810091155.59731.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 06:34:59 Mark McLoughlin wrote:
> From: Herbert Xu <herbert.xu@redhat.com>
>
> If segmentation offload is enabled by the host, we currently allocate
> maximum sized packet buffers and pass them to the host. This uses up
> 20 ring entries, allowing us to supply only 20 packet buffers to the
> host with a 256 entry ring. This is a huge overhead when receiving
> small packets, and is most keenly felt when receiving MTU sized
> packets from off-host.

Hi Mark!

There are three approaches we should investigate before adding YA feature.  
Obviously, we can simply increase the number of ring entries.

Secondly, we can put the virtio_net_hdr at the head of the skb data (this is 
also worth considering for xmit I think if we have headroom) and drop 
MAX_SKB_FRAGS which contains a gratuitous +2.

Thirdly, we can try to coalesce contiguous buffers.  The page caching scheme 
we have might help here, I don't know.  Maybe we should be explicitly trying 
to allocate higher orders.

Now, that said, we might need this anyway.  But let's try the easy things 
first?  (Or as well...)

> The size of the logical buffer is
> returned to the guest rather than the size of the individual smaller
> buffers.

That's a virtio transport breakage: can you use the standard virtio mechanism, 
just put the extended length or number of extra buffers inside the 
virtio_net_hdr?

That makes more sense to me.

> Make use of this support by supplying single page receive buffers to
> the host. On receive, we extract the virtio_net_hdr, copy 128 bytes of
> the payload to the skb's linear data buffer and adjust the fragment
> offset to point to the remaining data. This ensures proper alignment
> and allows us to not use any paged data for small packets. If the
> payload occupies multiple pages, we simply append those pages as
> fragments and free the associated skbs.

> +		char *p = page_address(skb_shinfo(skb)->frags[0].page);
...
> +		memcpy(hdr, p, sizeof(*hdr));
> +		p += sizeof(*hdr);

I think you need kmap_atomic() here to access the page.  And yes, that will 
effect performance :(

A few more comments moved from the patch header into the source wouldn't go 
astray, but I'm happy to do that myself (it's been on my TODO for a while).

Thanks!
Rusty.
