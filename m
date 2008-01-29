Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbYA2QHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbYA2QHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbYA2QHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:07:42 -0500
Received: from relay1.sgi.com ([192.48.171.29]:51045 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756617AbYA2QHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:07:41 -0500
Date: Tue, 29 Jan 2008 10:07:37 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080129160737.GV3058@sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.609249585@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128202923.609249585@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am going to seperate my comments into individual replies to help
reduce the chance they are lost.

> +void mmu_notifier_release(struct mm_struct *mm)
...
> +		hlist_for_each_entry_safe_rcu(mn, n, t,
> +					  &mm->mmu_notifier.head, hlist) {
> +			if (mn->ops->release)
> +				mn->ops->release(mn, mm);
> +			hlist_del(&mn->hlist);

This is a use-after-free issue.  The hlist_del_rcu needs to be done before
the callout as the structure containing the mmu_notifier structure will
need to be freed from within the ->release callout.

Thanks,
Robin
