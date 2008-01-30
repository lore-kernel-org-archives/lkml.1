Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYA3PiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYA3PiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYA3Ph5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:37:57 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44599
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbYA3Ph4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:37:56 -0500
Date: Wed, 30 Jan 2008 16:37:49 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080130153749.GN7233@v2.random>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130022944.236370194@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 06:29:10PM -0800, Christoph Lameter wrote:
> +void mmu_notifier_release(struct mm_struct *mm)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n, *t;
> +
> +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> +		rcu_read_lock();
> +		hlist_for_each_entry_safe_rcu(mn, n, t,
> +					  &mm->mmu_notifier.head, hlist) {
> +			hlist_del_rcu(&mn->hlist);

This will race and kernel crash against mmu_notifier_register in
SMP. You should resurrect the per-mmu_notifier_head lock in my last
patch (except it can be converted from a rwlock_t to a regular
spinlock_t) and drop the mmap_sem from
mmu_notifier_register/unregister.
