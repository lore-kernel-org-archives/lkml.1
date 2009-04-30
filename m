Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZD3CjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZD3CjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZD3CjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:39:14 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:47330 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbZD3CjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:39:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYFAJCp+ElMQW1W/2dsb2JhbACBULx8CJBdgiUWCIEyBQ
Date: Wed, 29 Apr 2009 22:34:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, nickpiggin@yahoo.com.au, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       thomas.pi@arcor.dea, ylalym@gmail.com, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430023407.GA19875@Krystal>
References: <20090429232546.GB15782@Krystal> <20090429165940.094efd0a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090429165940.094efd0a.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:25:33 up 60 days, 22:51,  1 user,  load average: 0.05, 0.25,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 29 Apr 2009 19:25:46 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Basically, the following execution :
> > 
> > dd if=/dev/zero of=/tmp/testfile
> > 
> > will slowly fill _all_ ram available without taking into account memory
> > pressure.
> > 
> > This is because the dirty page accounting is incorrect in
> > redirty_page_for_writepage.
> > 
> > This patch adds missing dirty page accounting in redirty_page_for_writepage().
> 
> The patch changes __set_page_dirty_nobuffers(), not
> redirty_page_for_writepage().
> 
> __set_page_dirty_nobuffers() has a huge number of callers.
> 

Right.

> > --- linux-2.6-lttng.orig/mm/page-writeback.c	2009-04-29 18:14:48.000000000 -0400
> > +++ linux-2.6-lttng/mm/page-writeback.c	2009-04-29 18:23:59.000000000 -0400
> > @@ -1237,6 +1237,12 @@ int __set_page_dirty_nobuffers(struct pa
> >  		if (!mapping)
> >  			return 1;
> >  
> > +		/*
> > +		 * Take care of setting back page accounting correctly.
> > +		 */
> > +		inc_zone_page_state(page, NR_FILE_DIRTY);
> > +		inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> > +
> >  		spin_lock_irq(&mapping->tree_lock);
> >  		mapping2 = page_mapping(page);
> >  		if (mapping2) { /* Race with truncate? */
> > 
> 
> But __set_page_dirty_nobuffers() calls account_page_dirtied(), which
> already does the above two operations.  afacit we're now
> double-accounting.
> 

Yes, you are right.

> Now, it's possible that the accounting goes wrong very occasionally in
> the "/* Race with truncate?  */" case.  If the truncate path clears the
> page's dirty bit then it will decrement the dirty-page accounting, but
> this code path will fail to perform the increment of the dirty-page
> accounting.  IOW, once this function has set PG_Dirty, it is committed
> to altering some or all of the page-dirty accounting.
> 
> But afacit your test case will not trigger the race-with-truncate anyway?
> 
> Can you determine at approximately what frequency (pages-per-second)
> this accounting leak is occurring in your test?
> 

0 per minute actually. I've tried adding a printk when the

if (mapping2) {

} else {
  <--
}

case is hit, and it never triggered in my tests.

I am currently trying to figure out if I can reproduce the OOM problems
I had experienced with 2.6.29-rc3. I investigate memory accounting by
turning the memory accounting code into a slow cache-line bouncing
version and by adding some assertions about the fact that per-zone
global counters must never go below zero. Having unbalanced accounting
could have some nasty long-term effects on memory pressure accounting.

But so far the memory accounting code looks solid. It's my bad then. I
cannot reproduce the behavior I noticed with 2.6.29-rc3, so I guess we
should we consider this a non-issue (or code 9 if you prefer). ;)

Thanks for looking into this.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
