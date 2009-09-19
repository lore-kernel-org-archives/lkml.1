Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZISBxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZISBxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 21:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZISBxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 21:53:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:12805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZISBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 21:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,412,1249282800"; 
   d="scan'208";a="189355030"
Date: Sat, 19 Sep 2009 09:53:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090919015334.GA14883@localhost>
References: <1253121768-20673-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253121768-20673-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Thu, Sep 17, 2009 at 01:22:48AM +0800, Jan Kara wrote:
> If all inodes are under writeback (e.g. in case when there's only one inode
> with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> write anything.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

I can confirm this works. The traces before/after patch show that many
the fruitless loops are eliminated. Note that the busy loops can
happen _before_ and _during_ block io queue congestion, so it looks
like a very competitive alternative to the old congestion_wait().

Thanks,
Fengguang
---

writeback traces for

        cp /dev/zero /mnt/test/zero0 &
        dd if=/dev/zero of=/mnt/test/zero1 &

BEFORE
[  315.025469] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  315.043293] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  320.065739] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  320.072397] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 391050 written 0
[  325.081930] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  325.087874] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  328.752015] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  328.769780] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  328.795771] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  328.814094] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  330.848860]  sda: sda1 sda2
[  330.877501] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  330.895610] global dirty 1 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  330.920078] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  330.938017] global dirty 1 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  330.982888] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  331.000240] global dirty 1 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  331.009272] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  331.015196] global dirty 1 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  335.962649] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  335.980258] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  336.022632] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  336.040266] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  341.002978] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  341.011937] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  341.062940] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  341.071762] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  346.023053] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  346.030616] global dirty 3818 writeback 167 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  346.051762] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 16384
[  346.058400] global dirty 3438 writeback 227 nfs 0 flags _M towrite 0 skipped 0 file 0 written 16384
[  347.283567] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 16384
[  347.290027] global dirty 13054 writeback 70 nfs 0 flags _M towrite 0 skipped 0 file 0 written 16384
[  347.877429] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 16384
[  347.884693] global dirty 3902 writeback 1622 nfs 0 flags _M towrite 0 skipped 0 file 0 written 16384
[  348.124756] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 6967
[  348.131689] global dirty 2 writeback 1702 nfs 0 flags __ towrite 9417 skipped 0 file 0 written 6967
[  348.141112] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  348.146952] global dirty 2 writeback 1672 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  348.911029] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 15479
[  348.918377] global dirty 1 writeback 1233 nfs 0 flags __ towrite 905 skipped 0 file 0 written 15479
[  351.039556] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  351.045437] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  353.923671] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  353.941259] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  356.063781] fs/fs-writeback.c 776 wb_writeback: flush-0:15(1527) 0
[  356.081537] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0
[  358.963986] fs/fs-writeback.c 776 wb_writeback: flush-8:0(2824) 0
[  358.981406] global dirty 0 writeback 0 nfs 0 flags __ towrite 16384 skipped 0 file 0 written 0


AFTER (with format changes and 128M MAX_WRITEBACK_PAGES)
[   55.457583] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   55.468583] global dirty=2 writeback=0 nfs=1 flags=__ towrite=32768 skipped=0 file=0 written=0
[   57.835277] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=1
[   57.845211] global dirty=2 writeback=0 nfs=1 flags=__ towrite=32767 skipped=0 file=317634 written=1
[   60.477882] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   60.487177] global dirty=1 writeback=0 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   62.857975] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   62.865541] global dirty=1 writeback=0 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   65.497957] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   65.502201] global dirty=1 writeback=0 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   66.449865] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11437
[   66.454802] global dirty=127 writeback=4820 nfs=2 flags=__ towrite=21331 skipped=0 file=12 written=5589
[   67.089220] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11355
[   67.093548] global dirty=257 writeback=3490 nfs=2 flags=__ towrite=21413 skipped=0 file=12 written=8273
[   67.704613] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11347
[   67.712514] global dirty=227 writeback=1810 nfs=2 flags=__ towrite=21421 skipped=0 file=12 written=8168
[   67.874118] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   67.877341] global dirty=2337 writeback=0 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   68.417686] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11566
[   68.421556] global dirty=357 writeback=5000 nfs=2 flags=__ towrite=21202 skipped=0 file=12 written=8074
[   69.252307] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11994
[   69.266007] global dirty=923 writeback=720 nfs=2 flags=__ towrite=20774 skipped=0 file=12 written=8758
[   69.899959] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11837
[   69.906911] global dirty=300 writeback=3156 nfs=2 flags=__ towrite=20931 skipped=0 file=12 written=8197
[   70.553993] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11504
[   70.560360] global dirty=280 writeback=4256 nfs=2 flags=__ towrite=21264 skipped=0 file=0 written=36
[   70.577045] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   70.585187] global dirty=280 writeback=4126 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   71.323770] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11896
[   71.329727] global dirty=460 writeback=10132 nfs=2 flags=__ towrite=20872 skipped=0 file=12 written=8877
[   72.887085] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   74.189957] global dirty=9632 writeback=5243 nfs=2 flags=__ towrite=32768 skipped=0 file=314386 written=0
[   74.367971] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11987
[   74.396704] global dirty=298 writeback=15315 nfs=2 flags=__ towrite=20781 skipped=0 file=12 written=7758
[   75.249214] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12148
[   75.258805] global dirty=348 writeback=5021 nfs=2 flags=__ towrite=20620 skipped=0 file=12 written=9810
[   76.288875] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=17368
[   76.297156] global dirty=1792 writeback=542 nfs=2 flags=__ towrite=15400 skipped=0 file=0 written=5
[   76.307482] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   76.328242] global dirty=1792 writeback=292 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   76.759708] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11691
[   76.762893] global dirty=230 writeback=3874 nfs=2 flags=__ towrite=21077 skipped=0 file=12 written=7960
[   77.261358] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11851
[   77.267354] global dirty=279 writeback=3373 nfs=2 flags=__ towrite=20917 skipped=0 file=12 written=9484
[   77.767085] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12188
[   77.770236] global dirty=319 writeback=3769 nfs=2 flags=__ towrite=20580 skipped=0 file=12 written=9739
[   78.287216] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11867
[   78.292713] global dirty=416 writeback=2570 nfs=2 flags=__ towrite=20901 skipped=0 file=12 written=9548
[   78.982964] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12784
[   79.050506] global dirty=715 writeback=7312 nfs=2 flags=__ towrite=19984 skipped=0 file=12 written=10122
[   79.217120] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   79.339208] global dirty=2627 writeback=4624 nfs=2 flags=__ towrite=32768 skipped=0 file=391050 written=0
[   79.831759] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12303
[   79.842709] global dirty=350 writeback=12302 nfs=2 flags=__ towrite=20465 skipped=0 file=12 written=9661
[   81.664025] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=20207
[   81.667844] global dirty=2342 writeback=1226 nfs=2 flags=__ towrite=12561 skipped=0 file=12 written=17537
[   81.674537] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   81.679015] global dirty=2342 writeback=976 nfs=2 flags=__ towrite=32768 skipped=0 file=0 written=0
[   82.203041] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12762
[   82.205884] global dirty=496 writeback=3170 nfs=2 flags=__ towrite=20006 skipped=0 file=12 written=9205
[   83.153241] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=17142
[   83.160762] global dirty=1332 writeback=3474 nfs=2 flags=__ towrite=15626 skipped=0 file=12 written=14034
[   83.752083] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=13238
[   83.761354] global dirty=522 writeback=10440 nfs=2 flags=__ towrite=19530 skipped=0 file=12 written=10428
[   84.448215] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   84.514842] global dirty=85 writeback=257 nfs=2 flags=__ towrite=32768 skipped=0 file=309507 written=0
[   84.653061] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11758
[   84.666930] global dirty=475 writeback=1389 nfs=2 flags=__ towrite=21010 skipped=0 file=12 written=8598
[   85.596776] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=15875
[   85.610176] global dirty=1255 writeback=2492 nfs=1 flags=__ towrite=16893 skipped=0 file=12 written=12963
[   86.679880] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=19187
[   86.685391] global dirty=1941 writeback=700 nfs=1 flags=__ towrite=13581 skipped=0 file=12 written=15835
[   86.693720] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   86.732001] global dirty=1941 writeback=440 nfs=1 flags=__ towrite=32768 skipped=0 file=0 written=0
[   87.220513] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12074
[   87.226822] global dirty=280 writeback=3514 nfs=1 flags=__ towrite=20694 skipped=0 file=12 written=7892
[   88.401825] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=18287
[   88.521634] global dirty=1576 writeback=7698 nfs=1 flags=__ towrite=14481 skipped=0 file=12 written=15676
[   88.545912] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=1700
[   88.558696] global dirty=2 writeback=9392 nfs=1 flags=__ towrite=31068 skipped=0 file=12 written=131
[   89.527762] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   89.540987] global dirty=8520 writeback=1 nfs=1 flags=__ towrite=32768 skipped=0 file=317634 written=0
[   90.373312] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=22441
[   90.385804] global dirty=2793 writeback=99 nfs=0 flags=__ towrite=10327 skipped=0 file=12 written=20896
[   90.896688] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11962
[   90.905466] global dirty=172 writeback=6032 nfs=0 flags=__ towrite=20806 skipped=0 file=0 written=4
[   91.539929] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12300
[   91.548079] global dirty=382 writeback=3210 nfs=0 flags=__ towrite=20468 skipped=0 file=12 written=10106
[   92.046175] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12025
[   92.054893] global dirty=320 writeback=8380 nfs=0 flags=__ towrite=20743 skipped=0 file=12 written=9523
[   92.066455] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   92.075349] global dirty=320 writeback=8250 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[   94.606396] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   94.620091] global dirty=18234 writeback=437 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[   94.680711] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=2829 n=1536
[   94.708757] global dirty=18234 writeback=117 nfs=0 flags=_M towrite=0 skipped=0 file=12 written=1536
[   94.845526] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=2829 n=1536
[   94.858110] global dirty=18740 writeback=377 nfs=0 flags=_M towrite=0 skipped=0 file=12 written=1536
[   94.967886] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=2829 n=1536
[   94.986908] global dirty=18232 writeback=825 nfs=0 flags=_M towrite=0 skipped=0 file=12 written=1536
[   95.015415] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=3068
[   95.049828] global dirty=18232 writeback=3287 nfs=0 flags=__ towrite=29700 skipped=0 file=13 written=3068
[   95.992550] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=27637
[   96.123581] global dirty=2 writeback=13998 nfs=0 flags=__ towrite=5131 skipped=0 file=13 written=1864
[   96.397437] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=312
[   96.400451] global dirty=2 writeback=6892 nfs=0 flags=__ towrite=32456 skipped=0 file=13 written=119
[   97.104951] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12686
[   97.193731] global dirty=364 writeback=9422 nfs=0 flags=__ towrite=20082 skipped=0 file=13 written=3420
[   97.216739] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[   97.223789] global dirty=364 writeback=9162 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[   99.158402] mm/page-writeback.c +539 balance_dirty_pages(): comm=dd pid=2830 n=0
[   99.162137] global dirty=27516 writeback=0 nfs=0 flags=_M towrite=1536 skipped=0 file=0 written=0
[   99.185804] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=2829 n=1536
[   99.193891] global dirty=3926 writeback=30 nfs=0 flags=_M towrite=0 skipped=0 file=13 written=1536
[   99.284045] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=2829 n=0
[   99.291527] global dirty=24718 writeback=0 nfs=0 flags=_M towrite=12 skipped=0 file=0 written=0
[   99.415383] mm/page-writeback.c +539 balance_dirty_pages(): comm=dd pid=2830 n=1536
[   99.421834] global dirty=22818 writeback=340 nfs=0 flags=_M towrite=0 skipped=0 file=13 written=1536
[   99.587007] mm/page-writeback.c +539 balance_dirty_pages(): comm=dd pid=2830 n=1536
[   99.598065] global dirty=18574 writeback=1130 nfs=0 flags=_M towrite=0 skipped=0 file=13 written=1536
[   99.679940] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[   99.686266] global dirty=17604 writeback=0 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  100.248582] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=32442
[  100.441214] global dirty=2453 writeback=5776 nfs=0 flags=__ towrite=326 skipped=0 file=12 written=32442
[  102.362534] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=22551
[  102.501230] global dirty=4200 writeback=15770 nfs=0 flags=__ towrite=10217 skipped=0 file=12 written=19081
[  103.255460] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=8602
[  103.527612] global dirty=216 writeback=17970 nfs=0 flags=__ towrite=24166 skipped=0 file=12 written=4099
[  103.541034] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[  103.592828] global dirty=216 writeback=17720 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  104.599401] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11468
[  104.717221] global dirty=169 writeback=19068 nfs=0 flags=__ towrite=21300 skipped=0 file=12 written=8234
[  104.865264] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[  104.963345] global dirty=169 writeback=18048 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  107.321816] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=32768
[  107.334944] global dirty=2598 writeback=16741 nfs=0 flags=_M towrite=0 skipped=0 file=12 written=30241
[  107.510672] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=3350
[  107.524301] global dirty=2 writeback=18041 nfs=0 flags=__ towrite=29418 skipped=0 file=12 written=1072
[  108.391365] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12939
[  108.448731] global dirty=186 writeback=17293 nfs=0 flags=__ towrite=19829 skipped=0 file=12 written=10161
[  108.641344] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[  108.660176] global dirty=186 writeback=15887 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  109.432398] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11167
[  109.519369] global dirty=252 writeback=16768 nfs=0 flags=__ towrite=21601 skipped=0 file=12 written=8985
[  109.964534] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[  110.202144] global dirty=6614 writeback=8453 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  111.449967] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=20458
[  111.497377] global dirty=1244 writeback=14844 nfs=0 flags=__ towrite=12310 skipped=0 file=12 written=19047
[  111.578967] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=1740
[  111.689508] global dirty=4 writeback=13764 nfs=0 flags=__ towrite=31028 skipped=0 file=12 written=0
[  112.402427] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12937
[  112.496227] global dirty=435 writeback=18004 nfs=0 flags=__ towrite=19831 skipped=0 file=12 written=10037
[  113.649987] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12469
[  113.762850] global dirty=417 writeback=8854 nfs=0 flags=__ towrite=20299 skipped=0 file=12 written=9559
[  113.777059] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[  113.819819] global dirty=417 writeback=7380 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  114.469119] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=11468
[  114.477888] global dirty=436 writeback=9377 nfs=0 flags=__ towrite=21300 skipped=0 file=12 written=8719
[  115.205915] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=12628
[  115.235844] global dirty=429 writeback=12730 nfs=0 flags=__ towrite=20140 skipped=0 file=12 written=9233
[  115.286230] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[  115.298967] global dirty=1119 writeback=10552 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  116.607551] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=25306
[  116.617596] global dirty=1264 writeback=15443 nfs=0 flags=__ towrite=7462 skipped=0 file=12 written=22359
[  116.660825] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=1491
[  116.669616] global dirty=6 writeback=15261 nfs=0 flags=__ towrite=31277 skipped=0 file=12 written=213
[  118.348742] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=15753
[  118.495918] global dirty=1126 writeback=5683 nfs=0 flags=__ towrite=17015 skipped=0 file=12 written=14199
[  119.455353] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=8122
[  119.463974] global dirty=0 writeback=8928 nfs=0 flags=__ towrite=24646 skipped=0 file=12 written=5218
[  119.474554] fs/fs-writeback.c +777 wb_writeback(): comm=flush-8:0 pid=2827 n=0
[  119.516772] global dirty=0 writeback=7656 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
[  120.313149] fs/fs-writeback.c +777 wb_writeback(): comm=flush-0:15 pid=1149 n=0
[  120.315446] global dirty=1 writeback=0 nfs=0 flags=__ towrite=32768 skipped=0 file=0 written=0
