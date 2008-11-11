Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYKKVgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYKKVgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYKKVg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:36:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33960 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYKKVg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:36:29 -0500
Date: Tue, 11 Nov 2008 22:35:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
	one page into another
Message-ID: <20081111213552.GI10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <4919F1C0.2050009@redhat.com> <Pine.LNX.4.64.0811111520590.27767@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811111520590.27767@quilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:21:45PM -0600, Christoph Lameter wrote:
> What do you mean by kernel page? The kernel can allocate a page and then
> point a user space pte to it. That is how page migration works.

Just to make an example, remove_migration_pte adds the page back to
rmap layer. We can't do that right now as rmap for the ksm pages will
be built inside ksm, or alternatively rmap.c will have to learn to
handle nonlinear anon-vma.

Migration simply migrates the page. The new page is identical to the
original one, just backed by different physical memory.

For us the new page is an entirely different beast that we build
ourself (we can't let migrate.c to pretend dealing with the newpage
like if it resembled the old page like it's doing now).

We replace a linear anon page with something that isn't an anonymous
page at all right now (in the future it may become a nonlinear anon
page if VM learns about it, or still an unknown page
external-rmappable if we go the external-rmap way).

There's clearly something to share, but the replace_page seem to be
the one that could be called from migrate.c. What is different is that
we don't need the migration pte placeholder, we never block releasing
locks, all atomic with pte wrprotected, and a final pte_same check
under PT lock before we replace the page. There isn't a whole lot to
share after all, but surely it'd be nice to share if we can. Us
calling into migrate.c isn't feasible right now without some
significant change to migrate.c where it would be misplaced IMHO as to
share we'd need migrate.c to call into VM core instead.
