Return-Path: <linux-kernel-owner+w=401wt.eu-S1767643AbXDFNlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767643AbXDFNlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXDFNlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:41:09 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:31535 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932750AbXDFNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:41:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ShbAK7ta6n46DMsM+O1CHEZG5ZQmWbS8dIIO9B/Li9uZ/O0+8Yu3Z4j3i/tiXbBMUd5BewzwyYb+jbNYm7mJNp7odL0oz+bu3xLrJevGgKMtZdTeAJ/DK+Yc/ziHQq03iQIgJvvB+4CVbjM6aq6UXNL/+Izfpsuqi3N0tgU2xFQ=  ;
X-YMail-OSG: YXG5bJAVM1mHTZKoVAqxFP1BSGRliaVZA4qBWX3FvwH1vMd7FFVG3ok.l3b3N764nN491U1qQw--
Message-ID: <46164DE4.1080609@yahoo.com.au>
Date: Fri, 06 Apr 2007 23:40:52 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Hugh Dickins <hugh@veritas.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
Subject: Re: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
References: <20060808070708.GA3931@localhost.localdomain>	 <200608090826.28249.dada1@cosmosbay.com>	 <200608090843.52893.dada1@cosmosbay.com>	 <200703152010.35614.dada1@cosmosbay.com>	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	 <20070405194942.1414c030.dada1@cosmosbay.com>	 <1175862369.6483.173.camel@twins>	 <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>	 <461647F5.5040206@yahoo.com.au> <1175865764.6483.190.camel@twins>
In-Reply-To: <1175865764.6483.190.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2007-04-06 at 23:15 +1000, Nick Piggin wrote:

>>>>or given a key:
>>>>
>>>>- lookup the page from key.shared.inode->i_mapping by key.shared.pgoff
>>>>  possibly loading the page using mapping->a_ops->readpage().
>>
>>For shared futexes, wouldn't i_mapping be worse, because you'd be
>>ping-ponging the tree_lock between processes, rather than have each
>>use their own mmap_sem?
> 
> 
> Your lockless pagecache work would solve most of that, no?

Yeah it would.

>>That also only helps for the wakeup case too, doesn't it? You have
>>to use the vmas to find out which inode to use to do the wait, I think?
>>(unless you introduce a new shared futex API).
> 
> 
> one could do something like this:
> 
>  struct address_space *mapping = page_mapping(page);
>  if (!mapping || mapping == &swapper_space)
>    do_private_futex();
>  else
>    do_shared_futex(mapping->host, page->index, addr % PAGE_SIZE);
> 
> 
> But alas, it seems I overlooked that the mmap_sem also protects the page
> tables as pointed out by Hugh, so this is all in fain it seems.
> 
> A well.

Well if it turned out to be a real problem, we _could_ introduce a new
futex API that takes a file descriptor+offset.

The old futex API is basically just a shorthand for choosing between
shared and private, depending on what the vma at the given address
happens to be.

-- 
SUSE Labs, Novell Inc.
