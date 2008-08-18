Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYHRKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYHRKKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYHRKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:10:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37878 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYHRKKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:10:06 -0400
Date: Mon, 18 Aug 2008 19:08:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: kosaki.motohiro@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <48A5DC22.5010507@linux-foundation.org>
References: <48A5C9D8.2030507@linux-foundation.org> <48A5DC22.5010507@linux-foundation.org>
Message-Id: <20080818190407.60D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Christoph Lameter wrote:
> 
> > Setting remote_node_defrag_ratio to 100 will make slub always take the remote
> > slab instead of allocating a new one.
> 
> As pointed out by Adrian D. off list:
> 
> The max remote_node_defrag_ratio is 99.
> 
> Maybe we need to change the comparison in remote_node_defrag_ratio_store() to
> allow 100 to switch off any node local allocs?

Hmmm, 
it doesn't change any behavior.

I did ..

1. slub code change (see below)


Index: b/mm/slub.c
===================================================================
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4056,7 +4056,7 @@ static ssize_t remote_node_defrag_ratio_
        if (err)
                return err;

-       if (ratio < 100)
+       if (ratio <= 100)
                s->remote_node_defrag_ratio = ratio * 10;

        return length;


2. change remote defrag ratio
	# echo 100 > /sys/kernel/slab/:t-0000128/remote_node_defrag_ratio
	# cat /sys/kernel/slab/:t-0000128/remote_node_defrag_ratio
	100

3. ran hackbench
4. ./slabinfo

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
:at-0000016               4096      16    65.5K          0/0/1 4096 0   0 100 *a
:at-0000024              21840      24   524.2K          0/0/8 2730 0   0  99 *a
:at-0000032               2048      32    65.5K          0/0/1 2048 0   0 100 *Aa
:at-0000088               4464      88   393.2K          0/0/6  744 0   0  99 *a
:at-0000096               5456      96   524.2K          0/0/8  682 0   0  99 *a
:t-0000016               32768      16   524.2K          0/0/8 4096 0   0 100 *
:t-0000024               21840      24   524.2K          0/0/8 2730 0   0  99 *
:t-0000032               34806      32     1.1M          9/1/8 2048 0   5  99 *
:t-0000040               14417      40   917.5K          6/6/8 1638 0  42  62 *
:t-0000048                5460      48   262.1K          0/0/4 1365 0   0  99 *
:t-0000064               10224      64   655.3K          2/1/8 1024 0  10  99 *
:t-0000072               29120      72     2.0M         26/0/6  910 0   0  99 *
:t-0000080               16376      80     1.3M         12/1/8  819 0   5  99 *
:t-0000096                5456      96   524.2K          0/0/8  682 0   0  99 *
:t-0000128               28917     128     1.3G  21041/21041/8  512 0  99   0 *
:t-0000256               15280     256    31.4M      472/436/8  256 0  90  12 *
:t-0000384                1360     352   524.2K          0/0/8  170 0   0  91 *A
:t-0000512                2388     512     1.3M         12/4/8  128 0  20  93 *
:t-0000768                 851     768   851.9K          5/5/8   85 0  38  76 *A
:t-0000896                 742     880   851.9K          5/4/8   73 0  30  76 *A
:t-0001024                1819    1024    15.1M      223/211/8   64 0  91  12 *
:t-0002048                2641    2048    17.9M      129/116/8   64 1  84  30 *
:t-0004096                 817    4096    57.1M      210/210/8   64 2  96   5 *
anon_vma                 10920      40   524.2K          0/0/8 1365 0   0  83
bdev_cache                 256    1008   262.1K          0/0/4   64 0   0  98 Aa
blkdev_queue               140    1864   262.1K          0/0/2   70 1   0  99
blkdev_requests           1720     304   524.2K          0/0/8  215 0   0  99
buffer_head               7284     104     2.5M        31/30/8  585 0  76  29 a
cfq_io_context            3120     168   524.2K          0/0/8  390 0   0  99
cfq_queue                 3848     136   524.2K          0/0/8  481 0   0  99
dentry                    3775     224     2.5M        31/29/8  292 0  74  33 a
ext3_inode_cache           740    1016     2.4M        30/30/8   64 0  78  30 a
fat_inode_cache             77     840    65.5K          0/0/1   77 0   0  98 a
file_lock_cache           2616     192   524.2K          0/0/8  327 0   0  95
hugetlbfs_inode_cache       83     776    65.5K          0/0/1   83 0   0  98
idr_layer_cache            944     544   524.2K          0/0/8  118 0   0  97
inode_cache               1050     744   851.9K          5/1/8   87 0   7  91 a
kmalloc-16384              160   16384     2.6M          0/0/5   32 3   0 100
kmalloc-192               4578     192    87.5M    1328/1328/8  341 0  99   1
kmalloc-32768              128   32768     4.1M          0/0/8   16 3   0 100
kmalloc-65536               32   65536     2.0M          0/0/8    4 2   0 100
kmalloc-8                65536       8   524.2K          0/0/8 8192 0   0 100
kmalloc-8192               512    8192     4.1M          0/0/8   64 3   0 100
kmem_cache_node           3276      80   262.1K          0/0/4  819 0   0  99 *
mqueue_inode_cache          56    1064    65.5K          0/0/1   56 0   0  90 A
numa_policy                248     264    65.5K          0/0/1  248 0   0  99
proc_inode_cache           655     792   720.8K          3/3/8   81 0  27  71 a
radix_tree_node           1142     552   917.5K          6/6/8  117 0  42  68 a
shmem_inode_cache         1230    1000     1.3M         12/3/8   65 0  15  93
sighand_cache              434    1608   917.5K          6/4/8   39 0  28  76 A
sigqueue                  3272     160   524.2K          0/0/8  409 0   0  99
sock_inode_cache           774     832   851.9K          5/3/8   73 0  23  75 Aa
TCP                        144    1712   262.1K          0/0/4   36 0   0  94 A
vm_area_struct            4034     176   851.9K          5/5/8  372 0  38  83





