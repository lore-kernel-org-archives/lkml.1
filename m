Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZJ0OCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZJ0OCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZJ0OCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbZJ0OCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:02:53 -0400
Date: Tue, 27 Oct 2009 16:02:37 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
Message-ID: <20091027140237.GM29477@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net>
 <20091026162157.23704.12420.stgit@dev.haskins.net>
 <20091027064529.GJ29477@redhat.com>
 <4AE6F7F7.1010302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE6F7F7.1010302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 09:39:03AM -0400, Gregory Haskins wrote:
> Gleb Natapov wrote:
> > On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
> >> The current code suffers from the following race condition:
> >>
> >> thread-1                                    thread-2
> >> -----------------------------------------------------------
> >>
> >> kvm_set_irq() {
> >>    rcu_read_lock()
> >>    irq_rt = rcu_dereference(table);
> >>    rcu_read_unlock();
> >>
> >>                                        kvm_set_irq_routing() {
> >>                                           mutex_lock();
> >>                                           irq_rt = table;
> >>                                           rcu_assign_pointer();
> >>                                           mutex_unlock();
> >>                                           synchronize_rcu();
> >>
> >>                                           kfree(irq_rt);
> >>
> >>    irq_rt->entry->set(); /* bad */
> >>
> > This is not what happens. irq_rt is never accessed outside read-side
> > critical section.
> 
> Sorry, I was generalizing to keep the comments short.  I figured it
> would be clear what I was actually saying, but realize in retrospect
> that I was a little ambiguous.
> 
A little is underestimation :) There is not /* bad */ line in the code!

> Yes, irq_rt is not accessed outside the RSCS.  However, the entry
> pointers stored in the irq_rt->map are, and this is equally problematic
> afaict.
The pointer is in text and can't disappear without kvm_set_irq()
disappearing too.

> 
> In this particular case we seem to never delete entries at run-time once
> they are established.  Therefore, while perhaps sloppy, its technically
> safe to leave them unprotected from this perspective.  The issue is more
> related to shutdown since a kvm_set_irq() caller could be within the
> aforementioned race-region and call entry->set() after the guest is
> gone.  Or did I miss something?
> 
The caller of kvm_set_irq() should hold reference to kvm instance, so it
can't disappear while you are inside kvm_set_irq(). RCU protects only
kvm->irq_routing not kvm structure itself.

> > Data is copied from irq_rt onto the stack and this copy is accessed
> > outside critical section.
> 
> As mentioned above, I do not believe this really protect us.  And even
I don't see the prove it doesn't, so I assume it does.

> if it did, the copy is just a work-around to avoid sleeping within the
It is not a work-around. There was two solutions to the problem one is
to call ->set() outside rcu critical section another is to use SRCU. I
decided to use the first one. This way the code is much simpler and I
remember asking Paul what are the disadvantages of using SRCU and there
was something.

> standard RCU RSCS, which is what SRCU is designed for.  So rather than
> inventing an awkward two-phased stack based solution, it's better to
> reuse the provided tools, IMO.
> 
> To flip it around:  Is there any reason why an SRCU would not work here,
> and thus we were forced to use something like the stack-copy approach?
> 
If SRCU has no disadvantage comparing to RCU why not use it always? :)

--
			Gleb.
