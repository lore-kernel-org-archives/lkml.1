Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZLNGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZLNGy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 01:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZLNGy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 01:54:56 -0500
Received: from ozlabs.org ([203.10.76.45]:55074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZLNGyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 01:54:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Shirley Ma <mashirle@us.ibm.com>
Subject: Re: [PATCH v2 2/4] Defer skb allocation -- new skb_set calls & chain pages in virtio_net
Date: Mon, 14 Dec 2009 17:24:48 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <1258697359.7416.14.camel@localhost.localdomain> <1260534506.30371.6.camel@localhost.localdomain> <1260535382.30371.20.camel@localhost.localdomain>
In-Reply-To: <1260535382.30371.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141724.49034.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 11:13:02 pm Shirley Ma wrote:
> Signed-off-by: Shirley Ma <xma@us.ibm.com>

I don't think there's a good way of splitting this change across multiple
patches.  And I don't think this patch will compile; I don't think we can
get rid of trim_pages yet.

We *could* first split the receive paths into multiple parts as you have
(eg. add_recvbuf_big etc), then actually rewrite them, but that's too much
work to refactor the code twice.  

So just roll all the driver changes into one patch; so you will have two
patches: one which creates the destroy_bufs API for virtio, and one which
uses it in the virtio_net driver.

> +static struct sk_buff *skb_goodcopy(struct virtnet_info *vi, struct page **page,
> +				    unsigned int *len)

This actually allocates an skb, and transfers the first page to it (via copy
and possibly the first fragment).  skb_from_page() perhaps?

> +		hdr_len = sizeof(hdr->hdr);
> +		offset = sizeof(struct padded_vnet_hdr);
> +	}
> +
> +	memcpy(hdr, p, hdr_len);
> +
> +	*len -= hdr_len;

Perhaps you should return NULL here as an error if *len was < hdr_len?

Thanks,
Rusty.
