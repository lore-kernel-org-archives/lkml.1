Return-Path: <linux-kernel-owner+w=401wt.eu-S1767614AbXDFNPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767614AbXDFNPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767619AbXDFNPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:15:48 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43015 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767614AbXDFNPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:15:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ADPm0Dy9w1ORg6HY5kz60hWIDULiPeg/lFheM4Mg04rxTgai+f27kFMQqlYTQJPBbjRNago/TF75x3R7YPGGY5oZ9+GdAmQcw8WndxyokXtcqHwpMZWYghH/cYqu/Dv9rf9EzFAN1IdgPoTWcaj4NlKO/3f4B+Tl7UqNjo/zBR4=  ;
X-YMail-OSG: DNSgN6wVM1myvuwJIoYdkYYSsBIIpw3pENDzGYQN1HSa__SSJkV9hjaB8Q.00AlP.5T25ronmw--
Message-ID: <461647F5.5040206@yahoo.com.au>
Date: Fri, 06 Apr 2007 23:15:33 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
Subject: Re: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
References: <20060808070708.GA3931@localhost.localdomain>  <200608090826.28249.dada1@cosmosbay.com>  <200608090843.52893.dada1@cosmosbay.com>  <200703152010.35614.dada1@cosmosbay.com>  <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>  <20070405194942.1414c030.dada1@cosmosbay.com> <1175862369.6483.173.camel@twins> <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 6 Apr 2007, Peter Zijlstra wrote:
> 
>>some thoughts on shared futexes;
>>
>>Could we get rid of the mmap_sem on the shared futexes in the following
>>manner:

I'd imagine shared futexes would be much less common than private for
threaded programs... I'd say we should reevaluate things once we have
private futexes, and malloc/free stop hammering mmap_sem so hard...

>> - get a page using pfn_to_page (skipping VM_PFNMAP)
>> - get the futex key from page->mapping->host and page->index
>>   and offset from addr % PAGE_SIZE.
>>
>>or given a key:
>>
>> - lookup the page from key.shared.inode->i_mapping by key.shared.pgoff
>>   possibly loading the page using mapping->a_ops->readpage().

For shared futexes, wouldn't i_mapping be worse, because you'd be
ping-ponging the tree_lock between processes, rather than have each
use their own mmap_sem?

That also only helps for the wakeup case too, doesn't it? You have
to use the vmas to find out which inode to use to do the wait, I think?
(unless you introduce a new shared futex API).

-- 
SUSE Labs, Novell Inc.
