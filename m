Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZBDTLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZBDTLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBDTLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:11:24 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:5335 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZBDTLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:11:23 -0500
X-IronPort-AV: E=Sophos;i="4.37,380,1231113600"; 
   d="scan'208";a="133034273"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
	<20090203222601.747ca8b7.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 11:11:22 -0800
In-Reply-To: <20090203222601.747ca8b7.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 3 Feb 2009 22:26:01 -0800")
Message-ID: <adad4dym2zp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 19:11:22.0583 (UTC) FILETIME=[5E205E70:01C986FC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  > 	huge_page_size(page_hstate(page))

 > > That would suit.  I assume the intention is for that to be usable by
 > > driver modules on any architecture?

 > erm, you overestimate the amount of planning and forethought which goes
 > into these things ;)

 > The lack of any EXPORT_SYMBOL(size_to_hstate) is a broadish hint.

Heh.  Looking into the implementation, it seems that I could actually do

	PAGE_SIZE << compound_order(page)

directly (since there's no reason to go from size to hstate and back to
size.  I don't know all the details of these VM internals, but that
seems to only work on the first (small) page of a giant page?  Which
causes problems for what we're trying to do here...

To summarize the goal, we are mapping user memory to a device that has
its own page tables, where the device's page tables can also use
multiple page sizes.  Using big pages on the device leads to similar
efficiencies as hugetlb pages do on the CPU, and in fact if a user has
used hugetlb pages for the memory they're giving to the device, that's a
very strong hint that the device should use big pages too.

But one valid situation we have to handle in the driver is if, say,
userspace has a hugetlb mapped at virtual address 0x200000, and wants to
map 0x80000 bytes at 0x280000 to the device.  In that case, we're going
to do essentially

	get_user_pages(..., 0x280000, 0x80000 / PAGE_SIZE, ...)

and get_user_pages() is going to give us a bunch of normal PAGE_SIZE
pages starting at offset 0x800000 within the compound page that makes up
the huge page mapped at 0x200000.

get_user_pages() also gives us the vma back, and we can see from
is_vm_hugetlb_page() (-- BTW can I just say that a function
is_xxx_page() that operates on vmas is horribly misnamed --) that these
pages all come from a hugetlb mapping, but figuring out the size of that
mapping is I guess a challenge.

 - R.
