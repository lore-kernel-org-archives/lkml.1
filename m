Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZJ0OFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZJ0OFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZJ0OFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:05:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZJ0OFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:05:30 -0400
Date: Tue, 27 Oct 2009 16:05:07 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
Message-ID: <20091027140507.GN29477@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net>
 <20091026162157.23704.12420.stgit@dev.haskins.net>
 <20091027064529.GJ29477@redhat.com>
 <4AE6F7F7.1010302@gmail.com>
 <4AE6FCEF.8030607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE6FCEF.8030607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:00:15AM -0400, Gregory Haskins wrote:
> Gregory Haskins wrote:
> > Gleb Natapov wrote:
> >> On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
> >>> The current code suffers from the following race condition:
> >>>
> >>> thread-1                                    thread-2
> >>> -----------------------------------------------------------
> >>>
> >>> kvm_set_irq() {
> >>>    rcu_read_lock()
> >>>    irq_rt = rcu_dereference(table);
> >>>    rcu_read_unlock();
> >>>
> >>>                                        kvm_set_irq_routing() {
> >>>                                           mutex_lock();
> >>>                                           irq_rt = table;
> >>>                                           rcu_assign_pointer();
> >>>                                           mutex_unlock();
> >>>                                           synchronize_rcu();
> >>>
> >>>                                           kfree(irq_rt);
> >>>
> >>>    irq_rt->entry->set(); /* bad */
> >>>
> >> This is not what happens. irq_rt is never accessed outside read-side
> >> critical section.
> > 
> > Sorry, I was generalizing to keep the comments short.  I figured it
> > would be clear what I was actually saying, but realize in retrospect
> > that I was a little ambiguous.
> 
> Here is a revised problem statement
> 
>     thread-1                                    thread-2
>     -----------------------------------------------------------
> 
>     kvm_set_irq() {
>        rcu_read_lock()
>        irq_rt = rcu_dereference(table);
>        entry_cache = get_entries(irq_rt);
>        rcu_read_unlock();
> 
>                                             invalidate_entries(irq_rt);
> 
>        for_each_entry(entry_cache)
> 	  entry->set(); /* bad */
> 
>     -------------------------------------------------------------
> 
> 
> "invalidate_entries()" may be any operation that deletes an entry at
> run-time (doesn't exist today), or as the guest is shutting down.  As
> far as I can tell, the current code does not protect us from either
> condition, and my proposed patch protects us from both.  Did I miss
> anything?
> 
Yes. What happened to irq_rt is completely irrelevant at the point you
marked /* bad */.

--
			Gleb.
