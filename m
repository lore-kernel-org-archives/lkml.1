Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbXHVOni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbXHVOni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXHVOna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:43:30 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20947 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXHVOn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:43:29 -0400
Message-ID: <46CC4AD2.2080306@openvz.org>
Date: Wed, 22 Aug 2007 18:40:18 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: Can't create
 pid_1 cachep
References: <46CC3F94.4050609@linux.vnet.ibm.com>
In-Reply-To: <46CC3F94.4050609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:

The creation of this cache consists of allocating ~30
bytes and creating a new kmem cache. This looks strange
that one of these allocation falied...

Could you please check what has happened with this patch:

diff --git a/kernel/pid.c b/kernel/pid.c
index d267775..9d594eb 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -458,15 +458,22 @@ static struct kmem_cache *create_pid_cac
 			goto out;
 
 	pcache = kmalloc(sizeof(struct pid_cache), GFP_KERNEL);
-	if (pcache == NULL)
+	if (pcache == NULL) {
+		printk("Can't alloc pcache size %d\n",
+				sizeof(struct pid_cache));
 		goto err_alloc;
+	}
 
 	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
 	cachep = kmem_cache_create(pcache->name,
 			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
 			0, SLAB_HWCACHE_ALIGN, NULL);
-	if (cachep == NULL)
+	if (cachep == NULL) {
+		printk("Can't create cachep size %d\n",
+				sizeof(struct pid) +
+				(nr_ids - 1) * sizeof(struct upid));
 		goto err_cachep;
+	}
 
 	pcache->nr_ids = nr_ids;
 	pcache->cachep = cachep;



> Hi Andrew,
> 
> Following Kernel panic is raised while booting up with 2.6.23-rc3-mm1 
> kernel.
> 
> ============================================================
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing HighMem for node 0 (00038000:001fbe00)
> Initializing HighMem for node 1 (00200000:003fbe00)
> Initializing HighMem for node 2 (00400000:005fbe00)
> Initializing HighMem for node 3 (00600000:007fbe00)
> Memory: 32480436k/33554432k available (2146k kernel code, 278984k 
> reserved, 1203k data, 216k init, 31842304k highmem)
> virtual kernel memory layout:
>    fixmap  : 0xffe1a000 - 0xfffff000   (1940 kB)
>    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
>    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>      .init : 0xc134c000 - 0xc1382000   ( 216 kB)
>      .data : 0xc12189e1 - 0xc1345758   (1203 kB)
>      .text : 0xc1000000 - 0xc12189e1   (2146 kB)
> Checking if this processor honours the WP bit even in supervisor mode... 
> Ok.
> SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=16, CPUs=16, Nodes=16
> Calibrating delay using timer specific routine.. 1401.55 BogoMIPS 
> (lpj=2803105)
> Kernel panic - not syncing: Can't create pid_1 cachep
> 
> 
> Thanks & Regards,
> Kamalesh Babulal.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

