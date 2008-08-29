Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYH2P2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYH2P2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYH2P2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:28:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42642 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYH2P2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:28:33 -0400
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
From: Adam Litke <agl@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <Pine.LNX.4.64.0808281724300.11072@blonde.site>
	 <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 29 Aug 2008 10:28:33 -0500
Message-Id: <1220023713.14358.173.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 08:35 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > > I think VM_RESERVED default dumping bahavior is good,
> > > then I'd like to add coredump_filter mask.
> > > 
> > > This patch doesn't change dafault behavior.
> > 
> > This seems very reasonable to me
> > (though I've little use for coredumps or hugepages myself).
> 
> Thanks a lot.
> 
> > One caution though: how well does it behave when coredumping a large
> > area of hugepages which have not actually been instantiated prior to
> > the coredump?  We have that funny FOLL_ANON ZERO_PAGE code in
> > follow_page() to avoid wasting memory on large uninstantiated anon
> > areas, but hugepages won't go that way.  If the dump hangs waiting for
> > memory to be freed, or OOMkills other processes, that wouldn't be good;
> > whereas if hugepage reservations (I've not followed what happens with
> > them) or whatever just make it skip when no more, that should be okay.
> 
> I think hugepage reservation pages always exist when hugepage COW happend.
> Then, hugepage access never cause try_to_free_pages() nor OOM.

(Mel, since you wrote the private reservation hugetlb code, would you
care to verify the following:)

Well, reserved huge pages _almost_ always exist.  The notable exception
happens when a process creates a MAP_PRIVATE hugetlb mapping and then
forks.  No guarantees are made to the children for access to that
hugetlb mapping.  So if such a child were to core dump an unavailable
huge page, follow_hugetlb_page() would fail.  I think that case is
harmless since it looks like elf_coredump() will replace it with a
zeroed page?

The part of Hugh's email that does deserve more attention is the part
about FOLL_ANON and the ZERO_PAGE.  It seems like an awful waste to zero
out and instantiate huge pages just for a core dump.  I think it would
be worth adding a flag to follow_hugetlb_page() so that it can be
instructed to not fault in un-instantiated huge pages.  This would take
some investigating as to whether it is even valid for
follow_hugetlb_page() to return the ZERO_PAGE().

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

