Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZFVNOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZFVNOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZFVNOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:14:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36330 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZFVNOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:14:22 -0400
Date: Mon, 22 Jun 2009 16:13:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
Message-ID: <20090622131351.GE12867@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F8170.7000508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3F8170.7000508@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 09:04:48AM -0400, Gregory Haskins wrote:
> Sorry, Michael.  I missed that you had other comments after the
> grammatical one.  Will answer inline
> 
> Michael S. Tsirkin wrote:
> > On Mon, Jun 22, 2009 at 08:13:48AM -0400, Gregory Haskins wrote:
> >   
> >>>> + * notification when the memory has been touched.
> >>>> + * --------------------------------------------------------------------
> >>>> + */
> >>>> +
> >>>> +/*
> >>>> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which
> >>>> + * aggregates  one or more iosignalfd_items.  Each item points to exactly one
> >>>>         
> >                    ^^                             ^^
> >   
> >>>> + * eventfd, and can be registered to trigger on any write to the group
> >>>> + * (wildcard), or to a write of a specific value.  If more than one item is to
> >>>>         
> >                                                        ^^
> >   
> >>>> + * be supported, the addr/len ranges must all be identical in the group.  If a
> >>>>         
> >                                                                               ^^
> >   
> >>>> + * trigger value is to be supported on a particular item, the group range must
> >>>> + * be exactly the width of the trigger.
> >>>>     
> >>>>         
> >>> Some duplicate spaces in the text above, apparently at random places.
> >>>
> >>>   
> >>>       
> >> -ENOPARSE ;)
> >>
> >> Can you elaborate?
> >>     
> >
> >
> > Marked with ^^
> >
> >   
> >>>> + */
> >>>> +
> >>>> +struct _iosignalfd_item {
> >>>> +	struct list_head     list;
> >>>> +	struct file         *file;
> >>>> +	u64                  match;
> >>>> +	struct rcu_head      rcu;
> >>>> +	int                  wildcard:1;
> >>>> +};
> >>>> +
> >>>> +struct _iosignalfd_group {
> >>>> +	struct list_head     list;
> >>>> +	u64                  addr;
> >>>> +	size_t               length;
> >>>> +	size_t               count;
> >>>> +	struct list_head     items;
> >>>> +	struct kvm_io_device dev;
> >>>> +	struct rcu_head      rcu;
> >>>> +};
> >>>> +
> >>>> +static inline struct _iosignalfd_group *
> >>>> +to_group(struct kvm_io_device *dev)
> >>>> +{
> >>>> +	return container_of(dev, struct _iosignalfd_group, dev);
> >>>> +}
> >>>> +
> >>>> +static void
> >>>> +iosignalfd_item_free(struct _iosignalfd_item *item)
> >>>> +{
> >>>> +	fput(item->file);
> >>>> +	kfree(item);
> >>>> +}
> >>>> +
> >>>> +static void
> >>>> +iosignalfd_item_deferred_free(struct rcu_head *rhp)
> >>>> +{
> >>>> +	struct _iosignalfd_item *item;
> >>>> +
> >>>> +	item = container_of(rhp, struct _iosignalfd_item, rcu);
> >>>> +
> >>>> +	iosignalfd_item_free(item);
> >>>> +}
> >>>> +
> >>>> +static void
> >>>> +iosignalfd_group_deferred_free(struct rcu_head *rhp)
> >>>> +{
> >>>> +	struct _iosignalfd_group *group;
> >>>> +
> >>>> +	group = container_of(rhp, struct _iosignalfd_group, rcu);
> >>>> +
> >>>> +	kfree(group);
> >>>> +}
> >>>> +
> >>>> +static int
> >>>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
> >>>> +			  int is_write)
> >>>> +{
> >>>> +	struct _iosignalfd_group *p = to_group(this);
> >>>> +
> >>>> +	return ((addr >= p->addr && (addr < p->addr + p->length)));
> >>>> +}
> >>>>     
> >>>>         
> >>> What does this test? len is ignored ...
> >>>
> >>>   
> >>>       
> >> Yeah, I was following precedent with other IO devices.  However, this
> >> *is* sloppy, I agree.  Will fix.
> >>
> >>     
> >>>> +
> >>>> +static int
> >>>>     
> >>>>         
> >>> This seems to be returning bool ...
> >>>   
> >>>       
> >> Ack
> >>     
> >>>   
> >>>       
> >>>> +iosignalfd_is_match(struct _iosignalfd_group *group,
> >>>> +		    struct _iosignalfd_item *item,
> >>>> +		    const void *val,
> >>>> +		    int len)
> >>>> +{
> >>>> +	u64 _val;
> >>>> +
> >>>> +	if (len != group->length)
> >>>> +		/* mis-matched length is always a miss */
> >>>> +		return false;
> >>>>     
> >>>>         
> >>> Why is that? what if there's 8 byte write which covers
> >>> a 4 byte group?
> >>>   
> >>>       
> >> v7 and earlier used to allow that for wildcards, actually.   It of
> >> course would never make sense to allow mis-matched writes for
> >> non-wildcards, since the idea is to match the value exactly.  However,
> >> the feedback I got from Avi was that we should make the wildcard vs
> >> non-wildcard access symmetrical and ensure they both conform to the size.
> >>     
> >>>   
> >>>       
> >>>> +
> >>>> +	if (item->wildcard)
> >>>> +		/* wildcard is always a hit */
> >>>> +		return true;
> >>>> +
> >>>> +	/* otherwise, we have to actually compare the data */
> >>>> +
> >>>> +	if (!IS_ALIGNED((unsigned long)val, len))
> >>>> +		/* protect against this request causing a SIGBUS */
> >>>> +		return false;
> >>>>     
> >>>>         
> >>> Could you explain what this does please?
> >>>   
> >>>       
> >> Sure:  item->match is a fixed u64 to represent all group->length
> >> values.  So it might have a 1, 2, 4, or 8 byte value in it.  When I
> >> write arrives, we need to cast the data-register (in this case
> >> represented by (void*)val) into a u64 so the equality check (see [A],
> >> below) can be done.  However, you can't cast an unaligned pointer, or it
> >> will SIGBUS on many (most?) architectures.
> >>     
> >
> > I mean guest access. Does it have to be aligned?
> >   
> 
> In order to work on arches that require alignment, yes.  Note that I
> highly suspect that the pointer is already aligned anyway.  My
> IS_ALIGNED check is simply for conservative sanity.
> > You could memcpy the value...
> >   
> 
> Then you get into the issue of endianness and what pointer to use.
>  Or
> am I missing something?
> 
> >   
> >>> I thought misaligned accesses are allowed.
> >>>   
> >>>       
> >> If thats true, we are in trouble ;)
> >>     
> >
> > I think it works at least on x86:
> > http://en.wikipedia.org/wiki/Packed#x86_and_x86-64
> >   
> 
> Right, understood.  What I meant specifically is that if the (void*)val
> pointer is allowed to be misaligned we are in trouble ;).  I haven't
> studied the implementation in front of the MMIO callback recently, but I
> generally doubt thats the case.  More than likely this is some buffer
> that was kmalloced and that should already be aligned to the machine word.
> 
> Kind Regards,
> -Greg
> 

Yes, from what I saw of the code I think it can be BUG_ON.
Avi?

