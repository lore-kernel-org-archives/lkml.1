Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZJNSfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZJNSfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZJNSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:35:38 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:62420 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbZJNSfh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:35:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Wed, 14 Oct 2009 20:34:56 +0200
User-Agent: KMail/1.9.9
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910141510.11059.elendil@planet.nl> <20091014154026.GC5027@csn.ul.ie>
In-Reply-To: <20091014154026.GC5027@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910142034.58826.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 18:34:59.0479 (UTC) FILETIME=[08FE2270:01CA4CFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some initial results; all negative I'm afraid.

On Wednesday 14 October 2009, Mel Gorman wrote:
> This is what I found. The following were the possible commits that might
> be causing the problem.

> 56e49d2..f166777 -- reclaim
>         I would have considered this strong candidates except again, the
>         last good commit happened after this point. If other obvious
>         candidates don't crop up, it might be worth double checking
>         within this range, particularly commit 56e49d2 vmscan: evict
>         use-once pages first as it is targeted at streaming-IO workloads
>         which would include your music workload.

Reverted 56e49d2 on top of .31.1; no change.

> 5c87ead..e9bb35d -- inactive ratio changes
>         These patches should be harmless but just in case, please
>         compare the output of
>         # grep inactive_ratio /proc/zoneinfo
>         on 2.6.30 and 2.6.31 and make sure the ratios are the same.

The same for both (and for .32). DMA: 1; DMA32: 3

>         Commit b70d94e altered how zonelists were selected during
>         allocation. This was tested fairly heavily but if the testing
>         missed something, it would mean that some allocations are not
>         using the zones they should be.

Reverted on top of .31.1; no change.

>         Commit bc75d33 is totally harmless but it mentions
>         min_free_kbytes. I checked on my machine to make sure
>         min_free_kbytes was the same on both 2.6.30 and 2.6.31. Can you
>         check that this is true for your machine? If min_free_kbytes
>         decreased, it could explain GFP_ATOMIC failures.

Virtually identical. .30: 5704; .31/.32: 5711

> After this point, your analysis indicates that things are already broken
> but lets look at some of the candidates anyway.  Out of curiousity,
> was CONFIG_UNEVICTABLE_LRU unset in your .config for 2.6.30? I could
> only find your 2.6.31 .config. If it was, it might be worth reverting
> 6837765963f1723e80ca97b1fae660f3a60d77df and unsetting it in 2.6.31 and
> seeing what happens.

CONFIG_UNEVICTABLE_LRU was set and during bisections I've always accepted 
the default, which was "y".

> Commit ee993b135ec75a93bd5c45e636bb210d2975159b altered how lumpy
> reclaim works but it should have been harmless. It does not cleanly
> revert but it's easy to manually revert.

Reverted on top of .31.1; no change.

I'll do some more digging in the 'akpm' merge.
