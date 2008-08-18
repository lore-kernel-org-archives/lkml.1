Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYHRKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYHRKhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHRKgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:36:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46276 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYHRKgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:36:51 -0400
Date: Mon, 18 Aug 2008 19:34:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: kosaki.motohiro@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080818190407.60D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <48A5DC22.5010507@linux-foundation.org> <20080818190407.60D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080818193143.60D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Christoph Lameter wrote:
> > 
> > > Setting remote_node_defrag_ratio to 100 will make slub always take the remote
> > > slab instead of allocating a new one.
> > 
> > As pointed out by Adrian D. off list:
> > 
> > The max remote_node_defrag_ratio is 99.
> > 
> > Maybe we need to change the comparison in remote_node_defrag_ratio_store() to
> > allow 100 to switch off any node local allocs?
> 
> Hmmm, 
> it doesn't change any behavior.

Ah, ok.
I did mistakes.

new patch is here.

Index: b/mm/slub.c
===================================================================
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1326,9 +1326,11 @@ static struct page *get_any_partial(stru
         * expensive if we do it every time we are trying to find a slab
         * with available objects.
         */
+#if 0
        if (!s->remote_node_defrag_ratio ||
                        get_cycles() % 1024 > s->remote_node_defrag_ratio)
                return NULL;
+#endif

        zonelist = node_zonelist(slab_node(current->mempolicy), flags);
        for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {


new result is here.

% cat /proc/meminfo
MemTotal:        7701504 kB
MemFree:         5986432 kB
Buffers:            7872 kB
Cached:            38208 kB
SwapCached:            0 kB
Active:           120256 kB
Inactive:          14656 kB
Active(anon):      90304 kB
Inactive(anon):        0 kB
Active(file):      29952 kB
Inactive(file):    14656 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2031488 kB
SwapFree:        2031488 kB
Dirty:               448 kB
Writeback:             0 kB
AnonPages:         89088 kB
Mapped:            31360 kB
Slab:              69952 kB
SReclaimable:      13376 kB
SUnreclaim:        56576 kB
PageTables:        11648 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5882240 kB
Committed_AS:     453440 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       29312 kB
VmallocChunk:   17592177626112 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB


% slabinfo
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
:at-0000016               4096      16    65.5K          0/0/1 4096 0   0 100 *a
:at-0000024              21840      24   524.2K          0/0/8 2730 0   0  99 *a
:at-0000032               2048      32    65.5K          0/0/1 2048 0   0 100 *Aa
:at-0000088               2976      88   262.1K          0/0/4  744 0   0  99 *a
:at-0000096               4774      96   458.7K          0/0/7  682 0   0  99 *a
:t-0000016               32768      16   524.2K          0/0/8 4096 0   0 100 *
:t-0000024               21840      24   524.2K          0/0/8 2730 0   0  99 *
:t-0000032               34806      32     1.1M          9/1/8 2048 0   5  99 *
:t-0000040               14279      40   851.9K          5/5/8 1638 0  38  67 *
:t-0000048                5460      48   262.1K          0/0/4 1365 0   0  99 *
:t-0000064               10224      64   655.3K          2/1/8 1024 0  10  99 *
:t-0000072               29109      72     2.0M         26/4/6  910 0  12  99 *
:t-0000080               16379      80     1.3M         12/1/8  819 0   5  99 *
:t-0000096                5456      96   524.2K          0/0/8  682 0   0  99 *
:t-0000128               27831     128     3.6M         48/8/8  512 0  14  97 *
:t-0000256               15401     256     9.8M       143/96/8  256 0  63  39 *
:t-0000384                1360     352   524.2K          0/0/8  170 0   0  91 *A
:t-0000512                2307     512     1.2M         11/3/8  128 0  15  94 *
:t-0000768                 755     768   720.8K          3/3/8   85 0  27  80 *A
:t-0000896                 728     880   851.9K          5/4/8   73 0  30  75 *A
:t-0001024                1810    1024     1.9M         21/4/8   64 0  13  97 *
:t-0002048                2621    2048     5.5M        34/15/8   64 1  35  97 *
:t-0004096                 775    4096     3.4M          5/2/8   64 2  15  93 *
anon_vma                 10920      40   524.2K          0/0/8 1365 0   0  83
bdev_cache                 192    1008   196.6K          0/0/3   64 0   0  98 Aa
blkdev_queue               140    1864   262.1K          0/0/2   70 1   0  99
blkdev_requests           1720     304   524.2K          0/0/8  215 0   0  99
buffer_head               8020     104     2.7M        34/32/8  585 0  76  30 a
cfq_io_context            3120     168   524.2K          0/0/8  390 0   0  99
cfq_queue                 3848     136   524.2K          0/0/8  481 0   0  99
dentry                    3798     224     2.5M        31/30/8  292 0  76  33 a
ext3_inode_cache          1127    1016     2.7M        34/34/8   64 0  80  41 a
fat_inode_cache             77     840    65.5K          0/0/1   77 0   0  98 a
file_lock_cache           2289     192   458.7K          0/0/7  327 0   0  95
hugetlbfs_inode_cache       83     776    65.5K          0/0/1   83 0   0  98
idr_layer_cache            944     544   524.2K          0/0/8  118 0   0  97
inode_cache               1044     744   786.4K          4/0/8   87 0   0  98 a
kmalloc-16384              160   16384     2.6M          0/0/5   32 3   0 100
kmalloc-192               3883     192     1.0M          8/8/8  341 0  50  71
kmalloc-32768              128   32768     4.1M          0/0/8   16 3   0 100
kmalloc-65536               32   65536     2.0M          0/0/8    4 2   0 100
kmalloc-8                65536       8   524.2K          0/0/8 8192 0   0 100
kmalloc-8192               512    8192     4.1M          0/0/8   64 3   0 100
kmem_cache_node           3276      80   262.1K          0/0/4  819 0   0  99 *
mqueue_inode_cache          56    1064    65.5K          0/0/1   56 0   0  90 A
numa_policy                248     264    65.5K          0/0/1  248 0   0  99
proc_inode_cache           653     792   655.3K          2/2/8   81 0  20  78 a
radix_tree_node           1221     552   983.0K          7/7/8  117 0  46  68 a
shmem_inode_cache         1218    1000     1.3M         12/3/8   65 0  15  92
sighand_cache              416    1608   851.9K          5/3/8   39 0  23  78 A
sigqueue                  3272     160   524.2K          0/0/8  409 0   0  99
sock_inode_cache           758     832   786.4K          4/3/8   73 0  25  80 Aa
TCP                        180    1712   327.6K          0/0/5   36 0   0  94 A
vm_area_struct            4054     176   851.9K          5/5/8  372 0  38  83



