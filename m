Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZHLRsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZHLRsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZHLRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:48:23 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:32823 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZHLRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:48:22 -0400
Date: Wed, 12 Aug 2009 10:48:21 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090812174821.GD24151@ovro.caltech.edu>
References: <cover.1249930169.git.mst@redhat.com> <20090810185340.GC13924@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812171921.GC24151@ovro.caltech.edu> <20090812173104.GB29966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812173104.GB29966@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 12 Aug 2009 10:48:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 08:31:04PM +0300, Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 10:19:22AM -0700, Ira W. Snyder wrote:

[ snip out code ]

> > > 
> > > We discussed this before, and I still think this could be directly derived
> > > from struct virtqueue, in the same way that vring_virtqueue is derived from
> > > struct virtqueue. That would make it possible for simple device drivers
> > > to use the same driver in both host and guest, similar to how Ira Snyder
> > > used virtqueues to make virtio_net run between two hosts running the
> > > same code [1].
> > > 
> > > Ideally, I guess you should be able to even make virtio_net work in the
> > > host if you do that, but that could bring other complexities.
> > 
> > I have no comments about the vhost code itself, I haven't reviewed it.
> > 
> > It might be interesting to try using a virtio-net in the host kernel to
> > communicate with the virtio-net running in the guest kernel. The lack of
> > a management interface is the biggest problem you will face (setting MAC
> > addresses, negotiating features, etc. doesn't work intuitively).
> 
> That was one of the reasons I decided to move most of code out to
> userspace. My kernel driver only handles datapath,
> it's much smaller than virtio net.
> 
> > Getting
> > the network interfaces talking is relatively easy.
> > 
> > Ira
> 
> Tried this, but
> - guest memory isn't pinned, so copy_to_user
>   to access it, errors need to be handled in a sane way
> - used/available roles are reversed
> - kick/interrupt roles are reversed
> 
> So most of the code then looks like
> 
> 	if (host) {
> 	} else {
> 	}
> 	return
> 
> 
> The only common part is walking the descriptor list,
> but that's like 10 lines of code.
> 
> At which point it's better to keep host/guest code separate, IMO.
> 

Ok, that makes sense. Let me see if I understand the concept of the
driver. Here's a picture of what makes sense to me:

guest system
---------------------------------
| userspace applications        |
---------------------------------
| kernel network stack          |
---------------------------------
| virtio-net                    |
---------------------------------
| transport (virtio-ring, etc.) |
---------------------------------
               |
               |
---------------------------------
| transport (virtio-ring, etc.) |
---------------------------------
| some driver (maybe vhost?)    | <-- [1]
---------------------------------
| kernel network stack          |
---------------------------------
host system

>From the host's network stack, packets can be forwarded out to the
physical network, or be consumed by a normal userspace application on
the host. Just as if this were any other network interface.

In my patch, [1] was the virtio-net driver, completely unmodified.

So, does this patch accomplish the above diagram? If so, why the
copy_to_user(), etc? Maybe I'm confusing this with my system, where the
"guest" is another physical system, separated by the PCI bus.

Ira
