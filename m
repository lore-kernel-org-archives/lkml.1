Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZFRQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZFRQ6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZFRQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZFRQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:58:09 -0400
Date: Thu, 18 Jun 2009 09:57:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
 citizen
Message-Id: <20090618095729.d2f27896.akpm@linux-foundation.org>
In-Reply-To: <2015.1245341938@redhat.com>
References: <32411.1245336412@redhat.com>
	<20090517022327.280096109@intel.com>
	<2015.1245341938@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 17:18:58 +0100 David Howells <dhowells@redhat.com> wrote:

> 
> Okay, after dropping all my devel patches, I got the OOM to happen again;
> fresh trace attached.  I was running LTP and an NFSD, and I was spamming the
> NFSD continuously from another machine (mount;tar;umount;repeat).
> 
>
> ...
>
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> CPU    1: hi:    0, btch:   1 usd:   0
> DMA32 per-cpu:
> CPU    0: hi:  186, btch:  31 usd:  57
> CPU    1: hi:  186, btch:  31 usd:   0
> Active_anon:70104 active_file:1 inactive_anon:6557
>  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
>  free:4062 slab:41969 mapped:541 pagetables:59663 bounce:0

77000 pages in anonymous memory, no swap online.

42000 pages in slab.  Maybe this is a leak?

60000 pagetable pages.  Seems rather a lot?

179000 pages accounted for above

> DMA free:3920kB min:60kB low:72kB high:88kB active_anon:2268kB inactive_anon:428kB active_file:0kB inactive_file:0kB unevictable:0kB present:15364kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 968 968 968
> DMA32 free:12328kB min:3948kB low:4932kB high:5920kB active_anon:278148kB inactive_anon:25800kB active_file:4kB inactive_file:0kB unevictable:0kB present:992032kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> DMA: 8*4kB 0*8kB 1*16kB 1*32kB 2*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3920kB
> DMA32: 2474*4kB 56*8kB 8*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 12328kB

present memory: 15364 + 992032 = 1007396kB.  250000 pages.  It's a 1GB
box, yes?

> 1660 total pagecache pages
> 0 pages in swap cache
> Swap cache stats: add 0, delete 0, find 0/0
> Free swap  = 0kB
> Total swap = 0kB
> 255744 pages RAM
> 5588 pages reserved
> 255749 pages shared
> 215785 pages non-shared
> Out of memory: kill process 6838 (msgctl11) score 152029 or a child
> Killed process 8850 (msgctl11)

afacit, 70000 pages are unaccounted for (leaked?)


