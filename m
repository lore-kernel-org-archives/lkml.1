Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYA1BrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYA1BrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYA1BrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:47:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:30679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYA1BrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:47:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="508901763"
Subject: Re: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801281243.08849.nickpiggin@yahoo.com.au>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	 <1201241005.24290.5.camel@sli10-desk.sh.intel.com>
	 <20080126220351.a04819f9.akpm@linux-foundation.org>
	 <200801281243.08849.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 09:48:28 +0800
Message-Id: <1201484908.1737.0.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 12:43 +1100, Nick Piggin wrote:
> On Sunday 27 January 2008 17:03, Andrew Morton wrote:
> > > On Fri, 25 Jan 2008 14:03:25 +0800 Shaohua Li <shaohua.li@intel.com>
> > > wrote:
> > >
> > > -	if (!page->mapping)
> > > +	if (!page->mapping) {
> > > +		if (!PageAnon(page) && PagePrivate(page))
> > > +			try_to_release_page(page, GFP_KERNEL);
> > >  		goto rcu_unlock;
> > > +	}
> >
> > We call something(GFP_KERNEL) under rcu_read_lock()?  I've lost track of
> > the myriad flavours of rcu which we purport to support, but I don't think
> > they'll all like us blocking under rcu_read_lock().
> >
> > We _won't_ block, because try_to_release_page() will see the NULL ->mapping
> > and will call the non-blocking try_to_free_buffers().  But still, it looks
> > bad, and will cause problems if someone decides to add a might_sleep_if()
> > to try_to_release_page().
> >
> > So...  I'd suggest that it would be better to add an apologetic comment and
> > call direct into try_to_free_buffers().
> 
> You're right, but can't we just rcu_read_unlock() before try_to_release_page?
or we could move the code above before doing rcu_read_lock()?

