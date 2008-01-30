Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYA3PxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYA3PxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYA3PxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:53:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbYA3PxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:53:09 -0500
Date: Wed, 30 Jan 2008 09:53:06 -0600
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080130155306.GA13746@sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com> <20080130153749.GN7233@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130153749.GN7233@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 04:37:49PM +0100, Andrea Arcangeli wrote:
> On Tue, Jan 29, 2008 at 06:29:10PM -0800, Christoph Lameter wrote:
> > +void mmu_notifier_release(struct mm_struct *mm)
> > +{
> > +	struct mmu_notifier *mn;
> > +	struct hlist_node *n, *t;
> > +
> > +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> > +		rcu_read_lock();
> > +		hlist_for_each_entry_safe_rcu(mn, n, t,
> > +					  &mm->mmu_notifier.head, hlist) {
> > +			hlist_del_rcu(&mn->hlist);
> 
> This will race and kernel crash against mmu_notifier_register in
> SMP. You should resurrect the per-mmu_notifier_head lock in my last
> patch (except it can be converted from a rwlock_t to a regular
> spinlock_t) and drop the mmap_sem from
> mmu_notifier_register/unregister.

Agree.

That will also resolve the problem we discussed yesterday. 
I want to unregister my mmu_notifier when a GRU segment is
unmapped. This would not necessarily be at task termination.

However, the mmap_sem is already held for write by the core
VM at the point I would call the unregister function.
Currently, there is no __mmu_notifier_unregister() defined.

Moving to a different lock solves the problem.


-- jack
