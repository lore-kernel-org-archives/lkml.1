Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbZFROgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbZFROgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZFROgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:36:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbZFROgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:36:44 -0400
Date: Thu, 18 Jun 2009 17:35:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090618143547.GA19408@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com> <200906181446.31373.rusty@rustcorp.com.au> <20090618064908.GB11155@redhat.com> <4A3A2C67.4030406@novell.com> <20090618122219.GE16838@redhat.com> <4A3A4938.60604@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3A4938.60604@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 10:03:36AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Thu, Jun 18, 2009 at 08:00:39AM -0400, Gregory Haskins wrote:
> >   
> >> Michael S. Tsirkin wrote:
> >>     
> >>
> >>> BTW, Gregory, this can be used to fix the race in the design: create a
> >>> thread and let it drop the module reference with module_put_and_exit.
> >>>   
> >>>       
> >> I had thought of doing something like this initially too, but I think
> >> its racy as well.  Ultimately, you need to make sure the eventfd
> >> callback is completely out before its safe to run, and deferring to a
> >> thread would not change this race.  The only sane way I can see to do
> >> that is to have the caller infrastructure annotate the event somehow
> >> (either directly with a module_put(), or indirectly with some kind of
> >> state transition that can be tracked with something like
> >> synchronize_sched().
> >>     
> >
> > Here's what one could do: create a thread for each irqfd, and increment
> > module ref count, put that thread to sleep.  When done with
> > irqfd, don't delete it and don't decrement module refcount, wake thread
> > instead.  thread kills irqfd and calls module_put_and_exit.
> >
> > I don't think it's racy
> 
> 
> I believe it is. How would you prevent the thread from doing the
> module_put_and_exit() before the eventfd callback thread is known to
> have exited the relevant .text section?

Right.

> All this talk does give me an idea, tho.  Ill make a patch.

OK, but ask yourself whether this bag of tricks is worth it, and whether
we'll find another hole later. Let's reserve the trickiness for
fast-path, where it's needed, and keep at least the assign/deassign simple.

> >   
> >>> Which will work, but I guess at this point we should ask ourselves
> >>> whether all the hearburn with srcu, threads and module references is
> >>> better than just asking the user to call and ioctl.
> >>>   
> >>>       
> >> I am starting to agree with you, here. :)
> >>
> >> Note one thing: the SRCU stuff is mostly orthogonal from the rest of the
> >> conversation re: the module_put() races.  I only tied it into the
> >> current thread because the eventfd_notifier_register() thread gave me a
> >> convenient way to hook some other context to do the module_put().  In
> >> the long term, the srcu changes are for the can_sleep() stuff.  So on
> >> that note, lets see if I can convince Davide that the srcu stuff is not
> >> so evil before we revert the POLLHUP patches, since the module_put() fix
> >> is trivial once that is in place.
> >>     
> >
> > Can this help with DEASSIGN as well? We need it for migration.
> >   
> 
> No, but afaict you do not need this for migration anyway.  Migrate the
> GSI and re-call kvm_irqfd() on the other side.  Would the fd even be
> relevant across a migration anyway?  I would think not, but admittedly I
> know little about how qemu/kvm migration actually works.

Yes but that's not live migration. For live migration, the trick is that
you are running locally but send changes to remote guest.  For that, we
need to put qemu in the middle between the device and the guest, so it
can detect activity and update the remote side.

And the best way to do that is to take poll eventfd that device assigns
and push eventfd that kvm polls. To switch between this setup
and the one where kvm polls the ventfd from device directly,
you need deassign.

-- 
MST
