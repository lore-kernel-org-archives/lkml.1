Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZECNJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZECNJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 09:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZECNJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 09:09:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:65122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZECNJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 09:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,286,1239001200"; 
   d="scan'208";a="138633877"
Date: Sun, 3 May 2009 21:08:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] PM: Drop shrink_all_memory (rev. 2) (was: Re:
	[PATCH 3/3] PM/Hibernate: Use memory allocations to free memory)
Message-ID: <20090503130818.GC9661@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905021346.34967.rjw@sisk.pl> <20090502104947.2720f173.akpm@linux-foundation.org> <200905030220.57933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905030220.57933.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rafael,

I happened to be doing some benchmarks on the older shrink_all_memory(),
Hopefully it can be a useful reference point for the new design.

The current swsusp_shrink_memory()/shrink_all_memory() are terribly
inefficient: it takes 7-9s to free up 1.4G memory:

[  131.899389] PM: Freed 1413380 kbytes in 7.03 seconds (201.04 MB/s)
[  732.757916] PM: Freed 1490116 kbytes in 9.37 seconds (159.03 MB/s)

Below are the logs I collected by injecting printks. There are
basically two major problems:
- swsusp_shrink_memory() scans the whole 2G memory again and again;
- shrink_all_memory() is slow. It won't reclaim pages at all with
  small priority values, because it's batching size is 10000 pages.

I wonder if it's possible to free up the memory within 1s at all.
(Maybe the slowness is due to too much enabled debugging options...)

Thanks,
Fengguang
---

vanilla 2.6.30-rc2-next-20090417:

[  124.516187] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[  124.523087] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  124.530060] PM: Basic memory bitmaps created
[  124.534421] PM: Syncing filesystems ... done.
[  124.842282] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  124.849800] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  124.857571] PM: Shrinking memory...  tmp=471584, size=491906, highmem_size=0
[  124.939103] shrink_all_memory: pages=10000
[  125.019543] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  125.027636]-tmp=451770, size=481986, highmem_size=0
[  125.107571] shrink_all_memory: pages=10000
[  125.139928] shrink_all_zones: pass=0, prio=7, lru=Normal.2, pages=10000, reclaimed=8500
[  125.280940] shrink_all_zones: pass=0, prio=6, lru=DMA32.2, pages=1500, reclaimed=1500
[  125.547990] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=10000
[  125.556135]\tmp=411598, size=461898, highmem_size=0
[  125.637414] shrink_all_memory: pages=10000
[  125.716890] shrink_all_zones: pass=0, prio=7, lru=Normal.2, pages=10000, reclaimed=10000
[  125.725092]|tmp=391507, size=451854, highmem_size=0
[  125.806935] shrink_all_memory: pages=10000
[  125.886317] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  125.894531]/tmp=371481, size=441841, highmem_size=0
[  125.976823] shrink_all_memory: pages=10000
[  126.104367] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  126.112572]-tmp=351715, size=431952, highmem_size=0
[  126.195178] shrink_all_memory: pages=10000
[  126.274586] shrink_all_zones: pass=0, prio=6, lru=DMA32.2, pages=10000, reclaimed=10000
[  126.282698]\tmp=331949, size=422063, highmem_size=0
[  126.365743] shrink_all_memory: pages=10000
[  126.445851] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  126.453968]|tmp=311858, size=412019, highmem_size=0
[  126.537417] shrink_all_memory: pages=10000
[  126.616980] shrink_all_zones: pass=0, prio=9, lru=Normal.2, pages=10000, reclaimed=10000
[  126.625180]/tmp=291751, size=401975, highmem_size=0
[  126.709066] shrink_all_memory: pages=10000
[  126.788665] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  126.796833]-tmp=271725, size=391962, highmem_size=0
[  126.880997] shrink_all_memory: pages=10000
[  127.008443] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  127.016667]\tmp=251716, size=381949, highmem_size=0
[  127.101581] shrink_all_memory: pages=10000
[  127.181588] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  127.189728]|tmp=231673, size=371936, highmem_size=0
[  127.275105] shrink_all_memory: pages=10000
[  127.354799] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  127.363003]/tmp=211599, size=361892, highmem_size=0
[  127.448750] shrink_all_memory: pages=10000
[  127.528252] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  127.536385]-tmp=191621, size=351910, highmem_size=0
[  127.622369] shrink_all_memory: pages=10000
[  127.750093] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  127.758295]\tmp=171539, size=341866, highmem_size=0
[  127.844867] shrink_all_memory: pages=10000
[  127.925614] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  127.933758]|tmp=151465, size=331822, highmem_size=0
[  128.020878] shrink_all_memory: pages=10000
[  128.100580] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  128.108803]/tmp=131391, size=321778, highmem_size=0
[  128.196312] shrink_all_memory: pages=10000
[  128.275643] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  128.283769]-tmp=111413, size=311796, highmem_size=0
[  128.371814] shrink_all_memory: pages=10000
[  128.501803] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=10000
[  128.510007]\tmp=91339, size=301752, highmem_size=0
[  128.597726] shrink_all_memory: pages=10000
[  128.677138] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  128.685277]|tmp=71296, size=291739, highmem_size=0
[  128.774061] shrink_all_memory: pages=10000
[  128.855940] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=10000
[  128.864145]/tmp=51259, size=281726, highmem_size=0
[  128.953486] shrink_all_memory: pages=10000
[  129.033417] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  129.041553]-tmp=31172, size=271682, highmem_size=0
[  129.131233] shrink_all_memory: pages=10000
[  129.210693] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=10000
[  129.218994]\tmp=11146, size=261669, highmem_size=0
[  129.309142] shrink_all_memory: pages=10000
[  129.388523] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  129.396648]|tmp=-8880, size=251656, highmem_size=0
[  129.487193] shrink_all_memory: pages=10000
[  129.614831] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=10000
[  129.623059]/tmp=-28954, size=241612, highmem_size=0
[  129.714055] shrink_all_memory: pages=10000
[  129.794104] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=10000
[  129.802246]-tmp=-48932, size=231630, highmem_size=0
[  129.893893] shrink_all_memory: pages=10000
[  129.973667] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=10000, reclaimed=10000
[  129.981892]\tmp=-69020, size=221586, highmem_size=0
[  130.073916] shrink_all_memory: pages=10000
[  130.154620] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=10000
[  130.162853]|tmp=-89156, size=211511, highmem_size=0
[  130.255274] shrink_all_memory: pages=10000
[  130.334612] shrink_all_zones: pass=0, prio=8, lru=DMA32.2, pages=10000, reclaimed=10000
[  130.342750]/tmp=-109182, size=201498, highmem_size=0
[  130.435551] shrink_all_memory: pages=10000
[  130.515074] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=10000
[  130.523305]-tmp=-129273, size=191454, highmem_size=0
[  130.616714] shrink_all_memory: pages=10000
[  130.696350] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=10000
[  130.704490]\tmp=-149299, size=181441, highmem_size=0
[  130.798322] shrink_all_memory: pages=10000
[  130.877834] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=10000
[  130.886038]|tmp=-169325, size=171428, highmem_size=0
[  130.980312] shrink_all_memory: pages=10000
[  131.107844] shrink_all_zones: pass=0, prio=3, lru=DMA32.2, pages=10000, reclaimed=10000
[  131.115982]/tmp=-189351, size=161415, highmem_size=0
[  131.210530] shrink_all_memory: pages=10000
[  131.291223] shrink_all_zones: pass=0, prio=7, lru=Normal.2, pages=10000, reclaimed=10000
[  131.299433]-tmp=-209459, size=151371, highmem_size=0
[  131.394488] shrink_all_memory: pages=10000
[  131.474123] shrink_all_zones: pass=0, prio=3, lru=Normal.2, pages=10000, reclaimed=10000
[  131.482344]\tmp=-229420, size=141389, highmem_size=0
[  131.577910] shrink_all_memory: pages=10000
[  131.657376] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=10000
[  131.665498]|tmp=-249511, size=131345, highmem_size=0
[  131.761676] shrink_all_memory: pages=3345
[  131.791048] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=3345, reclaimed=3345
[  131.799085]/tmp=-256256, size=127966, highmem_size=0
[  131.895290]done (353345 pages freed)
[  131.899389] PM: Freed 1413380 kbytes in 7.03 seconds (201.04 MB/s)


1/30 memory being mapped, vanilla 2.6.30-rc2-next-20090417:

AnonPages:         38684 kB
Mapped:            66940 kB

[  722.944082] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[  722.956215] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  722.963053] PM: Basic memory bitmaps created
[  722.967365] PM: Syncing filesystems ... done.
[  723.361274] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  723.369310] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  723.377342] PM: Shrinking memory...  tmp=508165, size=510179, highmem_size=0
[  723.563602] shrink_all_memory: pages=10000
[  723.648921] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9766
[  723.733064] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19581
[  723.741225]-tmp=468972, size=490587, highmem_size=0
[  723.821406] shrink_all_memory: pages=10000
[  723.902912] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9804
[  723.987433] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19617
[  723.995565]\tmp=429714, size=470964, highmem_size=0
[  724.077458] shrink_all_memory: pages=10000
[  724.160394] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9808
[  724.261056] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19610
[  724.269482]|tmp=390489, size=451341, highmem_size=0
[  724.353672] shrink_all_memory: pages=10000
[  724.556153] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9806
[  724.669591] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19636
[  724.677770]/tmp=351365, size=431780, highmem_size=0
[  724.762188] shrink_all_memory: pages=10000
[  724.923372] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9805
[  725.037897] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19620
[  725.046501]-tmp=312189, size=412188, highmem_size=0
[  725.133452] shrink_all_memory: pages=10000
[  725.371199] shrink_all_zones: pass=0, prio=5, lru=DMA32.2, pages=10000, reclaimed=9781
[  725.519983] shrink_all_zones: pass=0, prio=5, lru=Normal.2, pages=10000, reclaimed=19585
[  725.528233]\tmp=273061, size=392627, highmem_size=0
[  725.616020] shrink_all_memory: pages=10000
[  725.801211] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9804
[  725.954523] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19617
[  725.962685]|tmp=233885, size=373035, highmem_size=0
[  726.051775] shrink_all_memory: pages=10000
[  726.296589] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9804
[  726.449150] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19682
[  726.457342]/tmp=194507, size=353350, highmem_size=0
[  726.548053] shrink_all_memory: pages=10000
[  726.759180] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9803
[  726.940475] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19561
[  726.948638]-tmp=155396, size=333789, highmem_size=0
[  727.040362] shrink_all_memory: pages=10000
[  727.257478] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9804
[  727.442356] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19544
[  727.450548]\tmp=116319, size=314259, highmem_size=0
[  727.543609] shrink_all_memory: pages=10000
[  727.755346] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9804
[  727.894707] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19555
[  727.902910]|tmp=77256, size=294729, highmem_size=0
[  727.997018] shrink_all_memory: pages=10000
[  728.170973] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9799
[  728.332426] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19545
[  728.341152]/tmp=38210, size=275199, highmem_size=0
[  728.437625] shrink_all_memory: pages=10000
[  728.673862] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9773
[  728.812572] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19517
[  728.820738]-tmp=-852, size=255669, highmem_size=0
[  728.917360] shrink_all_memory: pages=10000
[  729.110178] shrink_all_zones: pass=0, prio=4, lru=DMA32.2, pages=10000, reclaimed=9839
[  729.266243] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=19610
[  729.274407]\tmp=-40045, size=236077, highmem_size=0
[  729.372371] shrink_all_memory: pages=10000
[  729.553743] shrink_all_zones: pass=0, prio=4, lru=Normal.2, pages=10000, reclaimed=9741
[  729.673174] shrink_all_zones: pass=0, prio=3, lru=DMA.2, pages=259, reclaimed=256
[  729.681224] shrink_all_zones: pass=0, prio=3, lru=DMA32.0, pages=259, reclaimed=256
[  729.693997] shrink_all_zones: pass=0, prio=3, lru=DMA32.2, pages=259, reclaimed=513
[  730.006423] shrink_all_zones: pass=0, prio=2, lru=DMA32.2, pages=9487, reclaimed=9296
[  730.177563] shrink_all_zones: pass=0, prio=2, lru=Normal.2, pages=9487, reclaimed=18626
[  730.185640]|tmp=-98138, size=207022, highmem_size=0
[  730.285280] shrink_all_memory: pages=10000
[  730.484499] shrink_all_zones: pass=0, prio=3, lru=DMA32.2, pages=10000, reclaimed=9807
[  730.637792] shrink_all_zones: pass=0, prio=3, lru=Normal.2, pages=10000, reclaimed=19613
[  730.645975]/tmp=-137343, size=187430, highmem_size=0
[  730.746709] shrink_all_memory: pages=10000
[  730.754374] shrink_all_zones: pass=0, prio=5, lru=Normal.0, pages=10000, reclaimed=0
[  731.101101] shrink_all_zones: pass=0, prio=3, lru=DMA32.2, pages=10000, reclaimed=9777
[  731.257243] shrink_all_zones: pass=0, prio=3, lru=Normal.2, pages=10000, reclaimed=19582
[  731.265411]-tmp=-176567, size=167807, highmem_size=0
[  731.367111] shrink_all_memory: pages=10000
[  731.567779] shrink_all_zones: pass=0, prio=3, lru=DMA32.2, pages=10000, reclaimed=9811
[  731.803019] shrink_all_zones: pass=0, prio=3, lru=Normal.2, pages=10000, reclaimed=19615
[  731.811189]\tmp=-215837, size=148184, highmem_size=0
[  731.913738] shrink_all_memory: pages=10000
[  732.123893] shrink_all_zones: pass=0, prio=2, lru=DMA32.2, pages=10000, reclaimed=9808
[  732.312075] shrink_all_zones: pass=0, prio=2, lru=Normal.2, pages=10000, reclaimed=19580
[  732.320234]|tmp=-254948, size=128623, highmem_size=0
[  732.423776] shrink_all_memory: pages=623
[  732.432862] shrink_all_zones: pass=0, prio=12, lru=DMA.2, pages=623, reclaimed=617
[  732.441782] shrink_all_zones: pass=0, prio=12, lru=Normal.0, pages=623, reclaimed=617
[  732.453341] shrink_all_zones: pass=0, prio=11, lru=DMA.0, pages=6, reclaimed=0
[  732.460712] shrink_all_zones: pass=0, prio=11, lru=DMA32.0, pages=6, reclaimed=0
[  732.468390] shrink_all_zones: pass=0, prio=11, lru=DMA32.2, pages=6, reclaimed=6
[  732.488091] shrink_all_zones: pass=0, prio=6, lru=DMA32.2, pages=623, reclaimed=617
[  732.508256] shrink_all_zones: pass=0, prio=6, lru=Normal.2, pages=623, reclaimed=1233
[  732.516202]/tmp=-258774, size=126704, highmem_size=0
[  732.753869]done (372529 pages freed)
[  732.757916] PM: Freed 1490116 kbytes in 9.37 seconds (159.03 MB/s)

