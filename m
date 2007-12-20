Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXLTNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXLTNwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbXLTNvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:51:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759940AbXLTNvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:51:52 -0500
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in
	free_hot_cold_page
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
	 <1198084473.15321.48.camel@localhost>
	 <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 14:51:42 +0100
Message-Id: <1198158702.6821.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 13:14 +0000, Hugh Dickins wrote:
> On Wed, 19 Dec 2007, Dave Hansen wrote:
> > > --- linux-2.6.24-rc5/mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page     2007-12-19 11:31:46.000000000 +0530
> > > +++ linux-2.6.24-rc5-balbir/mm/page_alloc.c     2007-12-19 11:33:45.000000000 +0530
> > > @@ -995,7 +995,7 @@ static void fastcall free_hot_cold_page(
> > >  
> > >         if (!PageHighMem(page))
> > >                 debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
> > > -       page_assign_page_cgroup(page, NULL);
> > > +       VM_BUG_ON(page_get_page_cgroup(page));
> > >         arch_free_page(page, 0);
> > >         kernel_map_pages(page, 1, 0); 
> > 
> > Hi Balbir,
> > 
> > You generally want to do these like:
> > 
> > 	foo = page_assign_page_cgroup(page, NULL);
> > 	VM_BUG_ON(foo);
> > 
> > Some embedded people have been known to optimize kernel size like this:
> > 
> > 	#define VM_BUG_ON(x) do{}while(0)
> 
> Balbir's patch looks fine to me: I don't get your point there, Dave.

There was a lengthy discussion here:
  http://lkml.org/lkml/2007/12/14/131

on the merit of debug statements with side effects. But looking at our
definition:

#ifdef CONFIG_DEBUG_VM
#define VM_BUG_ON(cond) BUG_ON(cond)
#else
#define VM_BUG_ON(condition) do { } while(0)
#endif

disabling CONFIG_DEBUG_VM breaks the code as proposed by Balbir in that
it will no longer acquire the reference.

