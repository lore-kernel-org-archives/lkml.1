Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbXLTOep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbXLTOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbXLTOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:18:11 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50484 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762992AbXLTOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:18:09 -0500
Date: Thu, 20 Dec 2007 14:16:14 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Dave Hansen <haveblue@us.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
In-Reply-To: <1198158702.6821.8.camel@twins>
Message-ID: <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop> 
 <1198084473.15321.48.camel@localhost>  <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
 <1198158702.6821.8.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, Peter Zijlstra wrote:
> On Thu, 2007-12-20 at 13:14 +0000, Hugh Dickins wrote:
> > On Wed, 19 Dec 2007, Dave Hansen wrote:
> > > > -       page_assign_page_cgroup(page, NULL);
> > > > +       VM_BUG_ON(page_get_page_cgroup(page));
> > > 
> > > Hi Balbir,
> > > 
> > > You generally want to do these like:
> > > 
> > > 	foo = page_assign_page_cgroup(page, NULL);
> > > 	VM_BUG_ON(foo);
> > > 
> > > Some embedded people have been known to optimize kernel size like this:
> > > 
> > > 	#define VM_BUG_ON(x) do{}while(0)
> > 
> > Balbir's patch looks fine to me: I don't get your point there, Dave.
> 
> There was a lengthy discussion here:
>   http://lkml.org/lkml/2007/12/14/131
> 
> on the merit of debug statements with side effects.

Of course, but what's the relevance?

> But looking at our definition:
> 
> #ifdef CONFIG_DEBUG_VM
> #define VM_BUG_ON(cond) BUG_ON(cond)
> #else
> #define VM_BUG_ON(condition) do { } while(0)
> #endif
> 
> disabling CONFIG_DEBUG_VM breaks the code as proposed by Balbir in that
> it will no longer acquire the reference.

But what reference?

struct page_cgroup *page_get_page_cgroup(struct page *page)
{
	return (struct page_cgroup *)
		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
}

I guess the issue is that often a "get" function has a complementary
"put" function, but this isn't one of them.  Would page_page_cgroup
be a better name, perhaps?  I don't know.

Hugh
