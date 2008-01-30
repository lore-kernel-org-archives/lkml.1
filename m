Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbYA3RKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbYA3RKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYA3RKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:10:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYA3RKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:10:40 -0500
Subject: Re: [patch 1/6] mmu_notifier: Core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080130153749.GN7233@v2.random>
References: <20080130022909.677301714@sgi.com>
	 <20080130022944.236370194@sgi.com>  <20080130153749.GN7233@v2.random>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 18:10:32 +0100
Message-Id: <1201713032.28547.234.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 16:37 +0100, Andrea Arcangeli wrote:
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

Agreed, sorry for this oversight.

