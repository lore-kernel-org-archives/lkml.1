Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZFVR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZFVR14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZFVR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:27:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZFVR1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:27:46 -0400
Date: Mon, 22 Jun 2009 20:27:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
Message-ID: <20090622172720.GC15228@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FB156.3030301@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 12:29:10PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
> >   
> >> Michael S. Tsirkin wrote:
> >>     
> >>> It seems that a lot of complexity and trickiness with iosignalfd is
> >>> handling the group/item relationship, which comes about because kvm does
> >>> not currently let a device on the bus claim a write transaction based on the
> >>> value written.  This could be greatly simplified if the value written
> >>> was passed to the in_range check for write operation.  We could then
> >>> simply make each kvm_iosignalfd a device on the bus.
> >>>
> >>> What does everyone think of the following lightly tested patch?
> >>>   
> >>>       
> >> Hi Michael,
> >>   Its interesting, but I am not convinced its necessary.  We created the
> >> group/item layout because iosignalfds are unique in that they are
> >> probably the only IO device that wants to do some kind of address
> >> aliasing.
> >>     
> >
> > We actually already have aliasing: is_write flag is used for this
> > purpose.
> 
> Yes, but read/write address aliasing is not the same thing is
> multi-match data aliasing.

What's the big difference?

> Besides, your proposal also breaks

s/break/removes limitation/ :)

> some of
> the natural relationship models
> (e.g. all the aliased iosignal_items
> always belong to the same underlying device.  io_bus entries have an
> arbitrary topology).

iosignal_item is an artifact, they are not seen by user -
they are just a work around an API limitation.

And they are only grouped if the same PIO offset is used for all accesses.
Why is not always the case. If a device uses several PIO offsets
(as virtio does), you create separate devices for a single guest device too.

> 
> >  Actually, it's possible to remove is_write by passing
> > a null pointer in write_val for reads. I like this a bit less as
> > the code generated is less compact ... Avi, what do you think?
> >
> >   
> >>  With what you are proposing here, you are adding aliasing
> >> support to the general infrastructure which I am not (yet) convinced is
> >> necessary.
> >>     
> >
> > Infrastructure is a big name for something that adds a total of 10 lines to kvm.
> > And it should at least halve the size of your 450-line patch.
> >   
> 
> Your patch isn't complete until some critical missing features are added
> to io_bus, though, so its not really just 10 lines.
>  For one, it will
> need to support much more than 6 devices.

Isn't this like a #define change? With the item patch we are still
limited in the number of groups we can create.

What we gain is a simple array/list instead of a tree of
linked lists that makes cheshire cheese out of CPU data cache.

>  It will also need to support
> multiple matches.

What, signal many fds on the same address/value pair?
I see this as a bug. Why is this a good thing to support?
Just increases the chance of leaking this fd.

> Also you are proposing an general interface change
> that doesn't make sense to all but one device type.  So now every
> io-device developer that comes along will scratch their head at what to
> do with that field.

What do they do with is_write now? Ignore it. It's used in a whole
of 1 place.

> 
> None of these are insurmountable hurdles, but my point is that today the
> complexity is encapsulated in the proper place IMO.

It's better to get rid of complexity than encapsulate it.

>  E.g. The one and
> only device that cares to do this "weird" thing handles it behind an
> interface that makes sense to all parties involved.
> >   
> >> If there isn't a use case for other devices to have
> >> aliasing, I would think the logic is best contained in iosignalfd.  Do
> >> you have something in mind?
> >>     
> >
> > One is enough :)
> >   
> 
> I am not convinced yet. ;)  It appears to me that we are leaking
> iosignalfd-isms into the general code.  If there is another device that
> wants to do something similar, ok.  But I can't think of any.

You never know. is_write was used by a whole of 1 user: coalesced_mmio,
then your patch comes along ...


> > Seriously, do you see that this saves you all of RCU, linked lists and
> > counters?
> 
> Well, also keep in mind we will probably be converting io_bus to RCU
> very soon, so we are going the opposite direction ;)
> 
> Kind Regards,
> -Greg
> 

Same direction. Let's put RCU in iobus, we don't need another one on
top of it. That's encapsulating complexity.

