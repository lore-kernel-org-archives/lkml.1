Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZGGMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZGGMs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZGGMss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:48:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35813 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZGGMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:48:47 -0400
Date: Tue, 7 Jul 2009 15:48:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
Message-ID: <20090707124810.GD3647@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A533C4C.7020202@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A533C4C.7020202@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:15:08AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > Some comments below. Sorry, I know it's late in the series, but
> > previously I've been too confused with complicated locking to notice
> > anything else :(.
> >
> > On Mon, Jul 06, 2009 at 04:33:21PM -0400, Gregory Haskins wrote:
> >   
> >
> >> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1) /* is a pio (otherwise mmio) */
> >> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
> >> +
> >> +struct kvm_iosignalfd {
> >> +	__u64 trigger;
> >>     
> >
> > for length <8, it's the 8*len least significant bits that are used, right?
> > That's a bit ugly ... Maybe just put an 8 byte array here instead, then
> > the first len bytes are valid.
> >   
> 
> The original series uses an array that I kmalloc'ed to size, or left it
> NULL for a wildcard.  Avi didn't like this and requested a u64 for all
> values.  I don't care either way, but since you two are asking for
> conflicting designs, I will let you debate.

It turns out the io bus will be changed in the future.
Let's just document the usage, and check that unused bits
are zeroed.

> >> +	struct kvm_io_device dev;
> >> +	int                  wildcard:1;
> >>     
> >
> > don't use bitfields
> >   
> 
> bool?

sure

> >> +}
> >> +
> >> +/*
> >> + * MMIO/PIO writes trigger an event if the addr/val match
> >> + */
> >>     
> >
> > single line comment can look like this:
> > /* MMIO/PIO writes trigger an event if the addr/val match */
> >
> >   
> Ack
> 
> >> +static int
> >> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
> >> +		 const void *val)
> >> +{
> >> +	struct _iosignalfd *p = to_iosignalfd(this);
> >> +
> >> +	if (!iosignalfd_in_range(p, addr, len, val))
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	eventfd_signal(p->eventfd, 1);
> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * This function is called as KVM is completely shutting down.  We do not
> >> + * need to worry about locking just nuke anything we have as quickly as possible
> >> + */
> >> +static void
> >> +iosignalfd_destructor(struct kvm_io_device *this)
> >> +{
> >> +	struct _iosignalfd *p = to_iosignalfd(this);
> >> +
> >> +	iosignalfd_release(p);
> >> +}
> >> +
> >> +static const struct kvm_io_device_ops iosignalfd_ops = {
> >> +	.write      = iosignalfd_write,
> >> +	.destructor = iosignalfd_destructor,
> >> +};
> >> +
> >> +static bool
> >> +iosignalfd_overlap(struct _iosignalfd *lhs, struct _iosignalfd *rhs)
> >>     
> >
> > this checks both region overlap and data collision.
> > better split into two helpers?
> >
> >   
> Why?

Because it says iosignalfd_overlap but that's not what it does?

> >> +{
> >> +	/*
> >> +	 * Check for completely non-overlapping regions.  We can simply
> >> +	 * return "false" for non-overlapping regions and be done with
> >> +	 * it.
> >> +	 */
> >>     
> >
> > done with it -> ignore the value
> >
> >   
> I think that is a valid expression (at least here in the states),

I'm always interested in improving my english :) here's what I thought:

"done with it" says we skip the rest of the function. "ignore the value"
says skip the value check. So I was trying to say let's be more
specific.

Isn't that what it means?

> but
> ok.  Note that "false" means we are accepting the request, not ignoring
> any value.  I will construct a better comment either way.

Maybe name a function in a way that makes this explicit?

> >> +
> >> +	if ((lhs->addr + lhs->length) <= rhs->addr)
> >>     
> >
> > this math can overflow.
> >
> >   
> Well, we should probably have vetted that during assign since
> addr+length that overflows is not a valid region.  I will put a check in
> for that.

add = ~0x0ULL, len = 1 should be valid.
You'll have to make the math not overflow.

> >> +
> >> +	/*
> >> +	 * If we get here, we know there is *some* overlap, but we don't
> >> +	 * yet know how much.
> >>     
> >
> > how much?
> >   
> Well, as stated we don't know yet.

So why tell me :)?
What I mean is this statement (especially the the part of the statement
after the comma) does not add useful information.

> >   
> >>  Make sure its a "precise" overlap, or
> >>     
> >
> > precise overlap -> address/len pairs match
> >
> >   
> 
> Precisely.

so say so :)

> >> +	 * its rejected as incompatible
> >> +	 */
> >>     
> >
> > "rejected" does not seem to make sense in the context of a boolean
> > function
> >
> >   
> 
> Why?  true = rejected, false = accepted.  Seems boolean to me.

How should I know that? Rename it to iosignalfd_rejected?

>  Whats
> wrong with that?

If you want to return 0 on success, != 0 on failure,
make the function int.

> >> +
> >> +/* assumes kvm->slots_lock write-lock held */
> >>     
> >
> > it seems you only need read lock?
> >
> >   
> 
> The caller needs write-lock, so we just inherit that state.  I can
> update the comment though (I just ran a find/replace on "kvm->lock held"
> while updating to your new interface, thus the vague comment)

I guess so.

> >> +static bool
> >> +iosignalfd_check_collision(struct kvm *kvm, struct _iosignalfd *p)
> >> +{
> >> +	struct _iosignalfd *_p;
> >> +
> >> +	list_for_each_entry(_p, &kvm->iosignalfds, list)
> >> +		if (iosignalfd_overlap(_p, p))
> >>     
> >
> > This looks wrong: let's assume I want one signal with length 1 and one
> > with length 2 at address 0. They never trigger together, so it should
> > be ok to have 2 such devices.
> >   
> 
> We have previously decided to not support mis-matched overlaps.  It's
> more complicated to handle, and there isn't a compelling use-case for it
> that I am aware of.

That's not what I propose. By all means len = X should only catch
len = X and not len = X - 1.

However, I think it makes sense to
allow both len = 2 and len = 1 at the same address even though
they seem to overlap. And all you really need to do is simplify
the code: replace the tricky overlap logic with simple

if (rhs->addr == lhs->addr && rhs->len == lhs->len)
	reject
else
	accept

(+add wildcard thing)

> >> +		if (p->eventfd != eventfd)
> >> +			continue;
> >>     
> >
> > So for deassign, you ignore all arguments besides fd?  Is this
> > intentional? Looks strange - think of multiple addresses triggering a
> > single eventfd. But if so, it's better to have a different ioctl with
> > just the fields we need.
> >   
> 
> Hmm... I suspect the check for a range-match got lost along the way.  I
> agree we should probably qualify this with more than just the eventfd.
> 
> >   
> >> +
> >> +		__kvm_io_bus_unregister_dev(bus, &p->dev);
> >> +		iosignalfd_release(p);
> >>     
> >
> > a single deassign removed multiple irqfds? Looks ugly.
> >   
> 
> Avi requested this general concept.

Really? Avi, could you explain? I would think each
assign needs to be matched with 1 deassign. No?

-- 
MST
