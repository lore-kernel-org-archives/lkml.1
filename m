Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZFYLyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZFYLyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZFYLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:54:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZFYLyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:54:38 -0400
Date: Thu, 25 Jun 2009 14:54:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090625115403.GA7079@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A435F28.3000301@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 07:27:36AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Wed, Jun 24, 2009 at 11:49:01AM +0300, Michael S. Tsirkin wrote:
> >   
> >> On Tue, Jun 23, 2009 at 09:43:31PM -0400, Gregory Haskins wrote:
> >>     
> >>> Michael S. Tsirkin wrote:
> >>>       
> >>>> Remove in_range from kvm_io_device and ask read/write callbacks, if
> >>>> supplied, to perform range checks internally. This allows aliasing
> >>>> (mostly for in-kernel virtio), as well as better error handling by
> >>>> making it possible to pass errors up to userspace. And it's enough to
> >>>> look at the diffstat to see that it's a better API anyway.
> >>>>
> >>>> While we are at it, document locking rules for kvm_io_device.
> >>>>   
> >>>>         
> >>> Hi Michael,
> >>>
> >>> I just tried to apply this to kvm.git/master, and it blew up really
> >>> badly.  What tree should I be using?
> >>>       
> >> Ugh, this is against 2.6.30. I'll post kvm.git version soon.
> >>
> >>     
> >
> > I went ahead and tried to rebase it, to find that it conflicts with
> > recent patch 35b3038961f94e83557944ae0d30c8fa0b5012cf merged in kvm.git:
> > 'KVM: switch irq injection/acking data structures to irq_lock'
> > which now does this:
> > 	lock
> > 	find
> > 	unlock
> > 	write
> >
> > I thought for a while that it might make sense to start small and just
> > add in_range parameter for starters ...
> > However, I just realised that this only works because devices are not
> > added or removed dynamically.
> >
> > The long term fix is to switch to SRCU for bus management.  But if we
> > need to do this for iosignalfd anyway, in_range removal becomes possible
> > again.
> >
> > Short term it might be also possible to go back to keeping kvm lock
> > across both find and read - since the lock is taken, we don't
> > really win anything currently if we drop the lock earlier.
> >
> > Comments?
> >
> >   
> 
> Can we just get iosignalfd merged for now as it is, then?

The patch that adds value to in_range is still okay. We could go that
way for now.  But what I am saying is that groups are still devices, and
the patch that adds kvm_io_bus_unregister_dev seems broken with the new
locking. No?

> Its not like
> we cant patch the group/item code later to clean it up when the time is
> right.
> 
> Regards,
> -Greg
> 

What's the rush?

IMO the best plan is:
- add srcu for io bus, removing kvm lock from that space completely
- apply in_range removal patch on top of this
- iosignalfd on top

Comments?


-- 
MST
