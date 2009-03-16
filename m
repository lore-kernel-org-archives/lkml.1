Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZCPROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZCPROR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZCPROA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:14:00 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53359 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbZCPROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:14:00 -0400
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <1236367186.10626.84.camel@nimitz>
References: <1236367186.10626.84.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 16 Mar 2009 17:12:43 +0000
Message-Id: <1237223563.19000.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2009 17:13:09.0381 (UTC) FILETIME=[7AC5A350:01C9A65A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> On Fri, 2009-03-06 at 18:00 +0000, Catalin Marinas wrote:
> > > I think you should be more worried about consistency rather than missing
> > > entries.  Take these two lines of code:
> > >
> > >       start_pfn = node->node_start_pfn;
> > >       /* hotplug occurs here */
> > >       end_pfn = start_pfn + node->node_spanned_pages;
> > >
> > > What if someone comes in and adds memory to the node, at the beginning
> > > of the node, after you have calculated start_pfn?  Try to think of what
> > > value you'll get for end_pfn and whether it is consistent and was *ever*
> > > valid at all.  Would that oops the kernel?
> >
> > I assume pfn_valid() should handle this and kmemleak wouldn't scan the
> > page, unless we need locks around pfn_valid as well but I haven't seen
> > any used in the kernel.
> 
> You assume incorrectly. :(
> 
> Take my above example, and assume that you have two nodes which are
> right next to each other.  You might run over the end of one node and
> into the next one.  Your pages will be pfn_valid() but you will be on
> the wrong node.

OK, thanks for taking the time to explain this. I currently added a
dependency on !MEMORY_HOTPLUG for kmemleak since holding the lock while
traversing the page structures is not really feasible.

> You could probably also use the memory hotplug mutex found here:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2008-November/018884.html

That would be a better option for kmemleak as well.

-- 
Catalin

