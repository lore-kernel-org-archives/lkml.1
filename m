Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXLLFMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXLLFMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXLLFLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:11:53 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58279 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXLLFLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:11:52 -0500
Subject: Re: [rfc] lockless get_user_pages for dio (and more)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ken Chen <kenchen@google.com>, Badari Pulavarty <pbadari@gmail.com>,
       linux-mm <linux-mm@kvack.org>, tony.luck@intel.com,
       Adam Litke <agl@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200712121557.20807.nickpiggin@yahoo.com.au>
References: <20071008225234.GC27824@linux-os.sc.intel.com>
	 <200710152225.11433.nickpiggin@yahoo.com.au>
	 <1197322257.11805.15.camel@norville.austin.ibm.com>
	 <200712121557.20807.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 05:11:46 +0000
Message-Id: <1197436306.6367.12.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-12 at 15:57 +1100, Nick Piggin wrote:
> On Tuesday 11 December 2007 08:30, Dave Kleikamp wrote:

> > Nick,
> > I've played with the fast_gup patch a bit.  I was able to find a problem
> > in follow_hugetlb_page() that Adam Litke fixed.  I'm haven't been brave
> > enough to implement it on any other architectures, but I did add  a
> > default that takes mmap_sem and calls the normal get_user_pages() if the
> > architecture doesn't define fast_gup().  I put it in linux/mm.h, for
> > lack of a better place, but it's a little kludgy since I didn't want
> > mm.h to have to include sched.h.  This patch is against 2.6.24-rc4.
> > It's not ready for inclusion yet, of course.
> 
> Hi Dave,
> 
> Thanks so much. This makes it much more a complete patch (although
> still missing the "normal page" detection).
> 
> I think I missed -- or forgot -- what was the follow_hugetlb_page
> problem?

Badari found a problem running some tests and handed it off to me to
look at.  I didn't share it publicly.  Anyway, we were finding that
fastgup was taking the slow path almost all the time with huge pages.
The problem was that follow_hugetlb_page was failing to fault on a
non-writable page when it needed a writable one.  So we'd keep seeing a
non-writable page over and over.  This is fixed in 2.6.24-rc5.

> Anyway, I am hoping that someone will one day and test if this and
> find it helps their workload, but on the other hand, if it doesn't
> help anyone then we don't have to worry about adding it to the
> kernel ;) I don't have any real setups that hammers DIO with threads.
> I'm guessing DB2 and/or Oracle does?

I'll try to get someone to run a DB2 benchmark and see what it looks
like.
-- 
David Kleikamp
IBM Linux Technology Center

