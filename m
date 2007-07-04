Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXGDGb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXGDGb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXGDGbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:31:18 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:44386 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751565AbXGDGbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:31:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZRVRfiIE++YlqsFRq7fZoNwNztXq8dHb+1r44+2wlOe9WfdsGZ2fMqDC+EY5m/UqFGghqUDMIKkRNwSMe2+NXfpSlP/Yvxjn7RqqKiU8jZJtBg4jODaRFBSgoGovzPw0GMUV7cePKR5ARqcTjOMTHhPpllkx6QJIJ9I8PW8v7kM=  ;
X-YMail-OSG: KFtKng0VM1lw_WAdDG8JT3AussVjQxxmvVxbHukTSsg1mo9iabPlPiAGwC28qMyhWGp8JH61YwSQow2tA5IM59V2zo.agB5_cjSqtO1nVN5jlcpbS6w-
Message-ID: <468B3EAA.9070905@yahoo.com.au>
Date: Wed, 04 Jul 2007 16:31:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, Mike.stroya@hp.com,
       GOTO <y-goto@jp.fujitsu.com>, dmosberger@gmail.com, hugh@veritas.com
Subject: Re: [BUGFIX][PATCH] DO flush icache before set_pte() on ia64.
References: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This is a experimental patch for fixing icache flush race of ia64(Montecito).
> 
> Problem Description:
> Montecito, new ia64 processor, has separated L2 i-cache and d-cache,
> and i-cache and d-cache is not consistent in automatic way.
> 
> L1 cache is also separated but L1 D-cache is write-through. Then, before
> Montecito, any changes in L1-dcache is visible in L2-mixed-cache consistently.
> 
> Montecito has separated L2 cache and Mixed L3 cache. But...L2 D-cache is
> *write back*. (See http://download.intel.com/design/Itanium2/manuals/
> 30806501.pdf section 2.3.3)
> 
> Assume : valid data is in L2 d-cache and old data in L3 mixed cache.
> If write-back L2->L3 is delayed, at L2 i-cache miss cpu will fetch old data
> in L3 mixed cache. 
> By this, L2-icache-miss will read wrong instruction from L3-mixed cache.
> (Just I think so, is this correct ?)
> 
> Anyway, there is SIGILL problem in NFS/ia64 and icache flush can fix
> SIGILL problem (in our HPC team test.)
> 
> Following SIGILL issue occurs in current kernel.
> (This was a discussion in this April)
> - http://www.gelato.unsw.edu.au/archives/linux-ia64/0704/20323.html
> Usual file systems uses DMA and it purges cache. But NFS uses copy-by-cpu.
> 
> This is HP-UX's errata comment:
> - http://h50221.www5.hp.com/upassist/itrc_japan/assist2/patchdigest/PHKL_36120.html
> (Sorry for Japanese page...but English comments also written. See PHKL_36120)
> 
> Now, I think icache should be flushed before set_pte().
> This is a patch to try that.
> 
> 1. remove all lazy_mmu_prot_update()...which is used by only ia64.
> 2. implements flush_cache_page()/flush_icache_page() for ia64.
> 
> Something unsure....
> 3. mprotect() flushes cache before removing pte. Is this sane ?
>    I added flush_icache_range() before set_pte() here.
> 
> Any comments and advices ?

Thanks, this is the way I wanted to see it go in the generic code. (ie.
get rid of lazy_mmu_prot_uptdate and actually follow the cacheflush API
instead).

The only thing I noticed when I looked at the code is that some places
may not have flushed icache when they should have? Did you get them all?
Minor nitpick: you have one place where you test VM_EXEC before flushing,
but the flush routine itself contains the same test I think?

Regarding the ia64 code -- I'm not an expert so I can't say whether it
is the right thing to do or not. However I still can't work out what it's
rationale for the PG_arch_1 bit is, exactly. Does it assume that
flush_dcache_page sites would only ever be encountered by pages that are
not faulted in? A faulted in page kind of is "special" because it is
guaranteed uptodate, but is the ia64 arch code relying on that? Should it?
(there could definitely still be flush_dcache_page called on mapped pages,
but it should only be a subset of all possible sites -- I don't know if it
is too clean for ia64 cacheflush code to know that?). [*]

[*] all this is, as usual, predicated by the disclaimer that quirks in mm/
can result in mapped pages not being uptodate (in which case hell often
breaks loose in other ways anyway).

-- 
SUSE Labs, Novell Inc.
