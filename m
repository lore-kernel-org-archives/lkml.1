Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYB2BHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYB2BHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYB2A5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:57:13 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267AbYB2A5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:57:11 -0500
Date: Thu, 28 Feb 2008 16:56:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v7
Message-Id: <20080228165608.de7c8ae4.akpm@linux-foundation.org>
In-Reply-To: <20080229004001.GN8091@v2.random>
References: <20080219084357.GA22249@wotan.suse.de>
	<20080219135851.GI7128@v2.random>
	<20080219231157.GC18912@wotan.suse.de>
	<20080220010941.GR7128@v2.random>
	<20080220103942.GU7128@v2.random>
	<20080221045430.GC15215@wotan.suse.de>
	<20080221144023.GC9427@v2.random>
	<20080221161028.GA14220@sgi.com>
	<20080227192610.GF28483@v2.random>
	<Pine.LNX.4.64.0802281456200.1152@schroedinger.engr.sgi.com>
	<20080229004001.GN8091@v2.random>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 01:40:01 +0100 Andrea Arcangeli <andrea@qumranet.com> wrote:

> > > +#define mmu_notifier(function, mm, args...)				\
> > > +	do {								\
> > > +		struct mmu_notifier *__mn;				\
> > > +		struct hlist_node *__n;					\
> > > +									\
> > > +		if (unlikely(!hlist_empty(&(mm)->mmu_notifier.head))) { \
> > > +			rcu_read_lock();				\
> > > +			hlist_for_each_entry_rcu(__mn, __n,		\
> > > +						 &(mm)->mmu_notifier.head, \
> > > +						 hlist)			\
> > > +				if (__mn->ops->function)		\
> > > +					__mn->ops->function(__mn,	\
> > > +							    mm,		\
> > > +							    args);	\
> > > +			rcu_read_unlock();				\
> > > +		}							\
> > > +	} while (0)
> > 
> > Andrew recomended local variables for parameters used multile times. This 
> > means the mm parameter here.
> 
> I don't exactly see what "buggy macro" meant?

multiple refernces to the argument, so

	mmu_notifier(foo, bar(), zot);

will call bar() either once or twice.

Unlikely in this case, but bad practice.  Easily fixable by using another
temporary.

