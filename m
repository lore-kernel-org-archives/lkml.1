Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZHZOAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZHZOAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZHZOAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:00:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbZHZOAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:00:01 -0400
Date: Wed, 26 Aug 2009 16:58:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hpa@zytor.com, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090826135759.GA21988@redhat.com>
References: <cover.1250693417.git.mst@redhat.com> <200908252140.41295.rusty@rustcorp.com.au> <20090825175016.GA15790@redhat.com> <200908261540.59900.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908261540.59900.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 03:40:59PM +0200, Arnd Bergmann wrote:
> On Tuesday 25 August 2009, Michael S. Tsirkin wrote:
> > >  I'd like to avoid that here,
> > > though it's kind of ugly.  We'd need VHOST_GET_FEATURES (and ACK) to take a
> > > struct like:
> > > 
> > >       u32 feature_size;
> > >       u32 features[];
> 
> Hmm, variable length ioctl arguments, I'd rather not go there.
> The ioctl infrastructure already has a length argument encoded
> in the ioctl number. We can use that if we need more, e.g.
> 
> /* now */
> #define VHOST_GET_FEATURES     _IOR(VHOST_VIRTIO, 0x00, __u64)
> /*
>  * uncomment if we run out of feature bits:
> 
> struct vhost_get_features2 {
> 	__u64 bits[2];
> };
> #define VHOST_GET_FEATURES2     _IOR(VHOST_VIRTIO, 0x00, \
> 			struct  vhost_get_features2)
>  */
> 
> > Thinking about this proposal some more, how will the guest
> > determine the size to supply the GET_FEATURES ioctl?
> 
> Wait, the *guest*?

Sorry. the userspace hypervisor.

> Maybe I misunderstood something in a major way here, but
> I expected the features to be negotiated between host
> user space (qemu) and host kernel, as well as between
> guest and qemu (as they are already), but never between
> guest and kernel.

Yes.

> I would certainly expect the bits to be distinct from
> the virtio-net feature bits. E.g. stuff like TAP frame
> format opposed to TCP socket frame format (length+date)
> is something we need to negotiate here but that the
> guest does not care about.

My idea is to use virtio format for things I share with virtio (e.g.
mergeable buffers).  Since we are a kind of transport, I thought that I
will use the transport bits, that is bits 28 and up for vhost things.

> > Since we are a bit tight in 32 bit space already,
> > let's just use a 64 bit integer and be done with it?
> 
> Can't hurt, but don't use a struct unless you think
> we are going to need more than 64 bits.
> 
> 	Arnd <><

