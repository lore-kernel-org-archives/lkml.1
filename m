Return-Path: <linux-kernel-owner+w=401wt.eu-S1030918AbXD1CQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030918AbXD1CQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030932AbXD1CQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:16:25 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:24896 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030919AbXD1CQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:16:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fNi2FerFGN/hHxtwnbdQ89iKiYq/7UOM9HhEawMkwO1InnBzJiP2mIzWgmqP5TTLOAKbfPTmw5jGN9Wr0deHAs4sa9ENk+pvf01gGthvnrWUBWixuZjGeWsrPPCkKi59FDxH+QVVW9Tq+GkCRDZt6VFPFrBMM2R41sRWaq0M6D0=  ;
X-YMail-OSG: QX9syr0VM1n0DYiuN1kP1qrguU3_Sw7Y4opWFo1yyAvOK2NzLBYCy4TPA.Xwn2nYA6Z9nJcJsw--
Message-ID: <4632AE64.90900@yahoo.com.au>
Date: Sat, 28 Apr 2007 12:16:04 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org> <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com> <4631E49C.2030501@yahoo.com.au> <Pine.LNX.4.64.0704271437570.14794@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704271437570.14794@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 27 Apr 2007, Nick Piggin wrote:
> 
>>But that's because of ia64's cache coherency implementation. I don't really
>>follow the documentation to know whether it should be one way or the other,
>>but surely it should be done either before or after the set_pte_at, not both.
>>
>>Anyway, how about fremap or mprotect, for example?
>>... 
>>
>>OK, I'm still not sure that I understand why lazy_mmu_prot_update should be
>>used rather than flush_icache_page (in concept, not ia64 implementation).
>>Sure, flush_icache_page isn't given the pte, but let's assume we can change
>>that.
> 
> 
> You're asking lots of good questions.  I wish the ia64 people would
> know the answers, but from the length of time the "lazy_mmu_prot_update"
> stuff took to get into the tree, and the length of time it's taken to be
> found defective, I suspect they don't, and we'll have to guess for them.
> 
> Some guesses I'm working with...
> 
> I presume Mike and Anil are correct, that it needs to be done before
> putting pte into page table, not left until after: but as you've
> guessed, that needs to be done everywhere, not just in the two
> places so far identified.
> 
> When it was discussed last year (in connection with Peter's page
> cleaning patches) it was thought to be a variant of update_mmu_cache()
> (after setting pte), and we added the fremap one to accompany it;
> but now it looks to be a variant of flush_icache_page() (before
> setting pte).

Right. I think.


> I believe lazy_mmu_prot_update(pteval) came into existence primarily
> for mprotect's change_pte_range() case.  If ia64 filled in its
> flush_icache_page(vma, page), that could have been used there
> (checking 'vm_flags & VM_EXEC' instead of pte_exec): but that would
> involve a relatively expensive(?) pte_page() in a place which doesn't
> need to know the struct page for other cases.

Well, I think we could always add a pte argument to flush_icache_page...
Then, there might be logic to have a flush_lazy_icache_page when
changing protections, but that operation (currently called
lazy_mmu_prot_update) really doesn't seem like it should be called in
all the other places that it is, flush_icache_page should be used for
that.

But AFAIKS, if we really want correctness, flush_icache_page should go
away and be implemented in flush_dcache_page.


> Well, not pte_page(), it needs to be vm_normal_page() doesn't it?
> and ia64's current lazy_mmu_prot_update is unsafe when !pfn_valid.
> 
> Some flush_icache_pages are already in place, others are not: do
> we need to add some?  But those architectures which have a non-empty
> flush_icache_page seem to have survived without the additional calls
> - so they might be unnecessarily slowed down by additional calls.

Well flush_icache seems to be intended solely to bring icache in sync
with dcache modifications, but they try to skimp out on most of the
flushes required to handle dcache aliases... but really, I don't think
that is possible to do 100% correctly.

-- 
SUSE Labs, Novell Inc.
