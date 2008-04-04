Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYDDBle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYDDBle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYDDBl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:41:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36177 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYDDBlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:41:25 -0400
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to
	separate zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F58519.1060109@goop.org>
References: <5a397e7f3c1aeb7648b9.1207267541@localhost>
	 <1207271371.943.43.camel@nimitz.home.sr71.net>  <47F58519.1060109@goop.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:41:21 -0700
Message-Id: <1207273281.943.68.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 18:32 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> >> +int prepare_online_pages(unsigned long pfn, unsigned long nr_pages)
> >> +{
> >> +       int ret = notify_going_online(pfn, nr_pages);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       grow_zone_span(pfn, pfn+nr_pages);
> >>         return 0;
> >> +}
> >>     
> >
> > OK, after seeing this used in the Xen driver, I'm even less a fan of the
> > name.  Mostly because it doesn't actually prepare *pages* to be onlined.
> > It prepares the zones/pgdats and notifies that pages might soon be
> > online.  Can you think of any better names?
> >
> > grow_and_notify...??
> 
> Does it even need to be a separately visible function?  Could it just be 
> part of add_memory()?  Is there any reason delay doing it until 
> online_pages()?

Yeah, the add_memory() itself is supposed to be easily able to be rolled
back.  Say the machine didn't actually need the memory, it could just
give the memory back.  No danger of fragmentation or anything.

But, at the same time, we don't want to have this memory sitting there
being unused, but still being accounted for in the VM as real memory.
It's not in use, and making it look in use (by growing the zone spans)
could upset the VM watermarks.

> > It's also a bit funky because you're calling the online notifiers, but
> > you're not actually onlining the pages, yet.  Does that have any
> > repercussions?
> 
> No.  It will always call the GOING_ONLINE notifier, but it will only 
> call the ONLINE notifier if it actually bulk-onlines all the pages.  In 
> my page-by-page case, it will never end up calling the ONLINE notifier.  
> I could call it repeatedly for each page, but I'm not sure how useful 
> that is (the lack of any users of the ONLINE notifier makes it hard to 
> judge).

Ahhh.  You're completely right.  I was confused by ONLINE and
GOING_ONLINE.  Thanks for the reminder!

-- Dave

