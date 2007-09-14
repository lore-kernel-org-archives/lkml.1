Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXINS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXINS1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXINS1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:27:46 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:40098 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXINS1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:27:44 -0400
X-Greylist: delayed 4195 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 14:27:44 EDT
Date: Fri, 14 Sep 2007 20:17:46 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Subject: Re: kernel 2.6.22: what IS the VM doing?
Message-ID: <20070914171746.7bbx2te5646zcdpr@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rik van Riel <riel@redhat.com>
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com> <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi> <46DED83A.8070104@redhat.com> <20070905173332.dzwkm5ofdvtjcal4@m.safari.iki.fi> <46DF3253.6030007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DF3253.6030007@redhat.com>
User-Agent: Mutt/1.5.16 (2007-09-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 18:48:51 -0400, Rik van Riel wrote:
> Sami Farin wrote:
>> On Wed, Sep 05, 2007 at 12:24:26 -0400, Rik van Riel wrote:
>> ...
>>>> *shrug*
>>> The attached patch should make sure kswapd does not free an
>>> excessive number of pages in zone_normal just because the
>>> pages in zone_highmem are difficult to free.
>>>
>>> It does give kswapd a large margin to continue putting equal
>>> pressure on all zones in normal situations.
>>>
>>> Sami, could you try out this patch to see if it helps your
>>> situation?
>>
>> Thanks, Rik.  bzImage is ready, I probably reboot inside one
>> month for a reason or other 8-)
>
> The more I look at the bug, the more I see that it is probably
> not very easy to reproduce on demand.  I have, however, a full

Well, I now booted to x86_64 kernel.

I can still reproduce this.
When I unload ipset modules, kernel resumes "normal" operation, i.e.,
not swapping like mad.

sysrq-m, normal operation:

[172074.989053] SysRq : Show Memory
[172074.989063] Mem-info:
[172074.989071] DMA per-cpu:
[172074.989078] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[172074.989083] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[172074.989089] DMA32 per-cpu:
[172074.989094] CPU    0: Hot: hi:  186, btch:  31 usd: 153   Cold: hi:   62, btch:  15 usd:  10
[172074.989101] CPU    1: Hot: hi:  186, btch:  31 usd:  34   Cold: hi:   62, btch:  15 usd:  14
[172074.989109] Active:123048 inactive:55194 dirty:5 writeback:0 unstable:0
[172074.989111]  free:15001 slab:27961 mapped:15063 pagetables:2996 bounce:0
[172074.989118] DMA free:5560kB min:32kB low:40kB high:48kB active:404kB inactive:736kB present:8620kB pages_scanned:0 all_unreclaimable? no
[172074.989124] lowmem_reserve[]: 0 968 968
[172074.989143] DMA32 free:54444kB min:3964kB low:4952kB high:5944kB active:491788kB inactive:220040kB present:991996kB pages_scanned:0 all_unreclaimable? no
[172074.989150] lowmem_reserve[]: 0 0 0
[172074.989166] DMA: 276*4kB 121*8kB 30*16kB 6*32kB 0*64kB 0*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 5560kB
[172074.989205] DMA32: 9467*4kB 1222*8kB 121*16kB 22*32kB 3*64kB 1*128kB 1*256kB 3*512kB 0*1024kB 1*2048kB 0*4096kB = 54444kB
[172074.989249] Swap cache: add 613353, delete 556659, find 441592/473681, race 0+5
[172074.989255] Free swap  = 2751640kB
[172074.989260] Total swap = 3911784kB
[172074.989265] Free swap:       2751640kB
[172074.993693] 255744 pages of RAM
[172074.993699] 6060 reserved pages
[172074.993702] 79933 pages shared
[172074.993706] 56719 pages swap cached

then it goes bad:

[172373.542933] net/ipv4/netfilter/ip_set_nethash.c: retry: rehashing of set blockedp2pnew triggered: hashsize grows from 262144 to 288358
[172373.554837] net/ipv4/netfilter/ip_set_nethash.c: retry: rehashing of set blockedp2pnew triggered: hashsize grows from 262144 to 317193
[172373.561167] net/ipv4/netfilter/ip_set_nethash.c: retry: rehashing of set blockedp2pnew triggered: hashsize grows from 262144 to 348912
[172373.569375] net/ipv4/netfilter/ip_set_nethash.c: retry: rehashing of set blockedp2pnew triggered: hashsize grows from 262144 to 383803
[172394.471570] SysRq : Show Memory
[172394.471580] Mem-info:
[172394.471583] DMA per-cpu:
[172394.471586] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[172394.471590] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[172394.471593] DMA32 per-cpu:
[172394.471597] CPU    0: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  58
[172394.471601] CPU    1: Hot: hi:  186, btch:  31 usd: 108   Cold: hi:   62, btch:  15 usd:  52
[172394.471606] Active:46934 inactive:23643 dirty:0 writeback:17112 unstable:0
[172394.471608]  free:133942 slab:16510 mapped:7826 pagetables:3004 bounce:0
[172394.471613] DMA free:8460kB min:32kB low:40kB high:48kB active:0kB inactive:0kB present:8620kB pages_scanned:0 all_unreclaimable? yes
[172394.471616] lowmem_reserve[]: 0 968 968
[172394.471623] DMA32 free:527308kB min:3964kB low:4952kB high:5944kB active:187736kB inactive:94572kB present:991996kB pages_scanned:92 all_unreclaimable? no
[172394.471627] lowmem_reserve[]: 0 0 0
[172394.471631] DMA: 154*4kB 133*8kB 78*16kB 29*32kB 12*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 8464kB
[172394.471644] DMA32: 47127*4kB 24614*8kB 7110*16kB 751*32kB 29*64kB 2*128kB 0*256kB 2*512kB 1*1024kB 0*2048kB 0*4096kB = 527372kB
[172394.471658] Swap cache: add 659497, delete 623328, find 442788/475174, race 0+5
[172394.471661] Free swap  = 2571424kB
[172394.471664] Total swap = 3911784kB
[172394.471666] Free swap:       2571424kB
[172394.476322] 255744 pages of RAM
[172394.476325] 6060 reserved pages
[172394.476327] 61683 pages shared
[172394.476329] 36197 pages swap cached

---------------------------------------

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st
 0  5 1446388 735176      0  21892    3    7    44    55   89    77  5  1 93  1  0
 1  4 1446388 738120      0  21260 1108    0  1416   372  293  2898 16  3 12 69  0
 1  4 1446388 738296      0  21320 2592    0  3516     8  358  3073  3  3 13 82  0
 0  3 1446336 737976      0  21208 2216    0  2644     0  294  3073  1  2  1 97  0
 0  4 1446300 737060      0  22444 1424    0  3128    11  280  2727  2  2  4 91  0
 1  2 1446284 740080      0  21344 1180    0  1804   105  313  3368  5  4 15 77  0
 0  3 1446284 743456      0  21236 1384    0  1584   159  330  2996  2  2 18 77  0
 1  2 1446284 747932      0  19672 1060    0  1388   199  285  3253  2  2 14 82  0
 1  1 1446248 750276      0  18668  628    0   956   111  230  3216  3  2 25 72  0
 0  4 1446184 750124      0  20096  444    0  2280     4  212  2715  2  2 34 64  0
 0  1 1446136 751124      0  21112 1100    0  2068     4  199  3323  3  3 28 65  0
 2  1 1446116 754224      0  20692  128    0   624   350  102  2993  3  5 47 46  0
 3  4 1445976 755952      0  19280  252    0  1176   106  173  3151  1  2 25 73  0

---------------------------------------

-r-------- 1 safari xuser   873 2007-09-14 20:01:07.301793115 +0300 vmstat.1189789266.txt

nr_free_pages 194048
nr_inactive 858
nr_active 14503
nr_anon_pages 9742
nr_mapped 4105
nr_file_pages 15069
nr_dirty 5
nr_writeback 0
nr_slab_reclaimable 3281
nr_slab_unreclaimable 8611
nr_page_table_pages 3005
nr_unstable 0
nr_bounce 0
nr_vmscan_write 561320
pgpgin 14933975
pgpgout 18925891
pswpin 227033
pswpout 559824
pgalloc_dma 653664
pgalloc_dma32 143470730
pgalloc_normal 0
pgfree 144318549
pgactivate 3092540
pgdeactivate 3161637
pgfault 227004020
pgmajfault 119460
pgrefill_dma 162043
pgrefill_dma32 11314403
pgrefill_normal 0
pgsteal_dma 101604
pgsteal_dma32 5116048
pgsteal_normal 0
pgscan_kswapd_dma 123227
pgscan_kswapd_dma32 6984704
pgscan_kswapd_normal 0
pgscan_direct_dma 4405
pgscan_direct_dma32 289888
pgscan_direct_normal 0
pginodesteal 0
slabs_scanned 1495808
kswapd_steal 5098094
kswapd_inodesteal 718
pageoutrun 90325
allocstall 1530
pgrotated 516566

---------------------------------------

-r-------- 1 safari xuser   874 2007-09-14 20:01:55.598448897 +0300 vmstat.1189789312.txt

nr_free_pages 189817
nr_inactive 4660
nr_active 15124
nr_anon_pages 7097
nr_mapped 3407
nr_file_pages 19694
nr_dirty 7
nr_writeback 0
nr_slab_reclaimable 3234
nr_slab_unreclaimable 8428
nr_page_table_pages 3007
nr_unstable 0
nr_bounce 0
nr_vmscan_write 566922
pgpgin 15094259
pgpgout 18948479
pswpin 248898
pswpout 565316
pgalloc_dma 653664
pgalloc_dma32 143514840
pgalloc_normal 0
pgfree 144358437
pgactivate 3126391
pgdeactivate 3216750
pgfault 227019864
pgmajfault 123477
pgrefill_dma 162043
pgrefill_dma32 11689820
pgrefill_normal 0
pgsteal_dma 101604
pgsteal_dma32 5151730
pgsteal_normal 0
pgscan_kswapd_dma 123227
pgscan_kswapd_dma32 7150624
pgscan_kswapd_normal 0
pgscan_direct_dma 4405
pgscan_direct_dma32 289888
pgscan_direct_normal 0
pginodesteal 0
slabs_scanned 1495808
kswapd_steal 5133776
kswapd_inodesteal 718
pageoutrun 90979
allocstall 1530
pgrotated 522062

> explanation on why it happens and why the patch should fix it,
> so I will submit it for inclusion in -mm.
>
> Sami, thank you for the detailed bug report.

-- 
Do what you love because life is too short for anything else.

