Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZHMOko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZHMOko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZHMOkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:40:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZHMOkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:40:43 -0400
Date: Thu, 13 Aug 2009 17:39:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813143922.GA5080@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <200908121959.47222.arnd@arndb.de> <20090813060615.GC3029@redhat.com> <200908131538.44465.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131538.44465.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 03:38:43PM +0200, Arnd Bergmann wrote:
> On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> > On Wed, Aug 12, 2009 at 07:59:47PM +0200, Arnd Bergmann wrote:
> > > The trick is to swap the virtqueues instead. virtio-net is actually
> > > mostly symmetric in just the same way that the physical wires on a
> > > twisted pair ethernet are symmetric (I like how that analogy fits).
> > 
> > You need to really squint hard for it to look symmetric.
> > 
> > For example, for RX, virtio allocates an skb, puts a descriptor on a
> > ring and waits for host to fill it in. Host system can not do the same:
> > guest does not have access to host memory.
> > 
> > You can do a copy in transport to hide this fact, but it will kill
> > performance.
> 
> Yes, that is what I was suggesting all along. The actual copy operation
> has to be done by the host transport, which is obviously different from
> the guest transport that just calls the host using vring_kick().
> 
> Right now, the number of copy operations in your code is the same.
> You are doing the copy a little bit later in skb_copy_datagram_iovec(),
> which is indeed a very nice hack. Changing to a virtqueue based method
> would imply that the host needs to add each skb_frag_t to its outbound
> virtqueue, which then gets copied into the guests inbound virtqueue.

Which is a lot more code than just calling skb_copy_datagram_iovec.

> Unfortunately, this also implies that you could no longer simply use the
> packet socket interface as you do currently, as I realized only now.
> This obviously has a significant impact on your user space interface.
> 
> 	Arnd <><

And, it will remove our ability to implement zero copy
down the road (when raw sockets support it).

-- 
MST
