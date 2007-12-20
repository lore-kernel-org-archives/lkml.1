Return-Path: <linux-kernel-owner+w=401wt.eu-S1764642AbXLTOfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764642AbXLTOfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbXLTOUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:20:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41678 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818AbXLTOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:20:20 -0500
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in
	free_hot_cold_page
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
	 <1198084473.15321.48.camel@localhost>
	 <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
	 <1198158702.6821.8.camel@twins>
	 <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 15:20:10 +0100
Message-Id: <1198160410.6821.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 14:16 +0000, Hugh Dickins wrote:
> On Thu, 20 Dec 2007, Peter Zijlstra wrote:
> > On Thu, 2007-12-20 at 13:14 +0000, Hugh Dickins wrote:
> > > On Wed, 19 Dec 2007, Dave Hansen wrote:
> > > > > -       page_assign_page_cgroup(page, NULL);
> > > > > +       VM_BUG_ON(page_get_page_cgroup(page));
> > > > 
> > > > Hi Balbir,
> > > > 
> > > > You generally want to do these like:
> > > > 
> > > > 	foo = page_assign_page_cgroup(page, NULL);
> > > > 	VM_BUG_ON(foo);
> > > > 
> > > > Some embedded people have been known to optimize kernel size like this:
> > > > 
> > > > 	#define VM_BUG_ON(x) do{}while(0)
> > > 
> > > Balbir's patch looks fine to me: I don't get your point there, Dave.
> > 
> > There was a lengthy discussion here:
> >   http://lkml.org/lkml/2007/12/14/131
> > 
> > on the merit of debug statements with side effects.
> 
> Of course, but what's the relevance?
> 
> > But looking at our definition:
> > 
> > #ifdef CONFIG_DEBUG_VM
> > #define VM_BUG_ON(cond) BUG_ON(cond)
> > #else
> > #define VM_BUG_ON(condition) do { } while(0)
> > #endif
> > 
> > disabling CONFIG_DEBUG_VM breaks the code as proposed by Balbir in that
> > it will no longer acquire the reference.
> 
> But what reference?
> 
> struct page_cgroup *page_get_page_cgroup(struct page *page)
> {
> 	return (struct page_cgroup *)
> 		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
> }
> 
> I guess the issue is that often a "get" function has a complementary
> "put" function, but this isn't one of them.  Would page_page_cgroup
> be a better name, perhaps?  I don't know.

Ah, yes, I mistakenly assumed it was a reference get. In that case I
stand corrected and do not have any objections.

