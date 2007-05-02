Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXEBAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXEBAgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992562AbXEBAgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:36:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20912 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992565AbXEBAgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:36:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:reply-to:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=W1lLZtvIQa+4rQASp7Uijpp/EWTzKRfsokuNPBoogaItHTxp1U1s6tv6+ELrlrQjp
	LSuWCWHNJzkJE5EvXP/ag==
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
From: Rohit Seth <rohitseth@google.com>
Reply-To: rohitseth@google.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46372706.5030609@yahoo.com.au>
References: <200704281757.l3SHvUrs026921@smtp.corp.google.com>
	 <46372706.5030609@yahoo.com.au>
Content-Type: text/plain
Organization: Google Inc
Date: Tue, 01 May 2007 17:36:18 -0700
Message-Id: <1178066178.19466.67.camel@galaxy.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 21:39 +1000, Nick Piggin wrote:
> Rohit Seth wrote:

> > 
> > If a user is requesting kernel to do (for example) write on a page that is
> > already mapped with execute and write permissions then it should be treated
> > as if the user space is doing modifications to that page.  There is no
> > change in protections so lazy_prot_mmu_update shouldn't be called even
> > though PG_arch_1 is (I think) set.  Does it answer your concern?
> 
> I'm not sure that I would agree. For direct modifications of memory via
> a passed in user virtual address, perhaps. For operations on pagecache,
> we may not even have a handle to issue the flush cache instruction on (ie.
> a user virtual address), let alone know whether anyone else is mapping
> the page.
> 

Can you please describe the page cache scenario in more detail?  IMO, if
a page is user mapped with at least one execute and write permission
then the responsibility of update caches lies with user.

> >>What if you were to say remove all the PG_arch_1 code, and do 
> >>something really simple like flush icache in 
> >>flush_dcache_page? Would performance suffer horribly?
> > 
> > 
> > On Itanium, I think it will have some performance penalty (horrible or not I
> > don't know) as you will be invalidating the caches more often.  And they
> > alsways look for last 0.1% performance that they can get.
> 
> Sure, but if we _only_ flushed when page_mapcount was raised,

You will need this every time there is change in protection (e.g.
mprotect) not only when page_mapcount is raised.

-rohit


