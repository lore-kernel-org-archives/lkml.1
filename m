Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYDPBRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYDPBRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYDPBR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:17:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:19181 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYDPBRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=inFacuHIoXBwq8BtawNGV0phZNSlTd2U5brJGCvDScA1nVw5IDgY9F3hENQM2M6a7fWwRVFFCZNrLpgeQpIXZ1TH4AijyfKfraLSIquQkj0wGdeVddAslnsKJICbyiJCdmlRdjFt5czSqTrRlUKKeEj+qMJqKejsE+5Tf9q/Kq8=
Message-ID: <86802c440804151817h7b530e95i568e4313c32636c2@mail.gmail.com>
Date: Tue, 15 Apr 2008 18:17:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416010252.GA27499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
	 <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu>
	 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	 <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu>
	 <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
	 <20080416004430.GA26928@elte.hu>
	 <86802c440804151756w45b80052sef5c57a448d00ff1@mail.gmail.com>
	 <20080416010252.GA27499@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 6:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > On Tue, Apr 15, 2008 at 5:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > >
>  > >  > >  +       unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>  > >  > >
>  > >  > >  and also check my analysis whether it is correct and whether it
>  > >  > >  matches the reported bug patterns. But otherwise the fix looks like
>  > >  > >  a safe fix for v2.6.25-final to me - it only filters out values
>  > >  > >  from sparsemem input that are nonsensical in the sparsemem
>  > >  > >  framework anyway.
>  > >  >
>  > >
>  > > > can you check why find_max_pfn() e820_32.c need to call
>  > >  > memory_present? wonder if it can be removed.
>  > >
>  > >  this is the only call to memory_present() we do in 32-bit arch setup, so
>  > >  it's required.
>  > >
>  > >  (the function find_max_pfn() is woefully misnamed, but that's a cleanup
>  > >  - i just fixed this in x86.git.)
>  >
>  > 64 bit is calling that via paging_init
>  > ==>sparse_memory_present_with_active_regions(MAX_NUMNODES).
>  >
>  > and
>  > void __init sparse_memory_present_with_active_regions(int nid)
>
>  yeah - 64-bit is different here and it's not affected by the problem
>  because there SECTION_SIZE_BITS is 27 (==128 MB chunks),
>  MAX_PHYSADDR_BITS is 40 (== 1 TB) - giving 8192 section map entries.
>  Once larger than 1 TB 64-bit x86 systems are created MAX_PHYSADDR_BITS
>  needs to be increased.

also 64 bit
early_node_map[10] active PFN ranges
    0:        0 ->      149
    0:      256 ->   917408
    0:  1048576 ->  8519680
    1:  8519680 -> 16908288
    2: 16908288 -> 25296896
    3: 25296896 -> 33685504
    4: 33685504 -> 42074112
    5: 42074112 -> 50462720
    6: 50462720 -> 58851328
    7: 58851328 -> 67239936

and 32 bit only has one entry
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576

YH
