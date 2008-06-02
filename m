Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYFBGyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYFBGyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYFBGy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:54:29 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:56678 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYFBGy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:54:28 -0400
X-ME-UUID: 20080602065426199.30BDF1C0050E@mwinf2027.orange.fr
Message-ID: <48439916.2070108@cosmosbay.com>
Date: Mon, 02 Jun 2008 08:54:14 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] vmallocinfo: Add NUMA informations 
Content-Type: multipart/mixed;
 boundary="------------030600080309050702090802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030600080309050702090802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christoph recently added /proc/vmallocinfo file to get information about 
vmalloc allocations.

This patch adds NUMA specific information, giving number of pages 
allocated on each memory node.

This should help to check that vmalloc() is able to respect NUMA policies.

Example of output on a four nodes machine (one cpu per node)

1) network hash tables are evenly spreaded on four nodes (OK)
   (Same point for inodes and dentries hash tables)
2) iptables tables (x_tables) are correctly allocated on each cpu node (OK).
3) sys_swapon() allocates its memory from one node only.
4) each loaded module is using memory on one node.

Sysadmins could tune their setup to change points 3) and 4) if necessary.

grep "pages="  /proc/vmallocinfo
0xffffc20000000000-0xffffc20000201000 2101248 
alloc_large_system_hash+0x204/0x2c0 pages=512 vmalloc N0=128 N1=128 
N2=128 N3=128
0xffffc20000201000-0xffffc20000302000 1052672 
alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 
N3=64
0xffffc2000031a000-0xffffc2000031d000   12288 
alloc_large_system_hash+0x204/0x2c0 pages=2 vmalloc N1=1 N2=1
0xffffc2000031f000-0xffffc2000032b000   49152 
cramfs_uncompress_init+0x2e/0x80 pages=11 vmalloc N0=3 N1=3 N2=2 N3=3
0xffffc2000033e000-0xffffc20000341000   12288 sys_swapon+0x640/0xac0 
pages=2 vmalloc N0=2
0xffffc20000341000-0xffffc20000344000   12288 
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N0=2
0xffffc20000344000-0xffffc20000347000   12288 
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N1=2
0xffffc20000347000-0xffffc2000034a000   12288 
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N2=2
0xffffc2000034a000-0xffffc2000034d000   12288 
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N3=2
0xffffc20004381000-0xffffc20004402000  528384 
alloc_large_system_hash+0x204/0x2c0 pages=128 vmalloc N0=32 N1=32 N2=32 
N3=32
0xffffc20004402000-0xffffc20004803000 4198400 
alloc_large_system_hash+0x204/0x2c0 pages=1024 vmalloc vpages N0=256 
N1=256 N2=256 N3=256
0xffffc20004803000-0xffffc20004904000 1052672 
alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 
N3=64
0xffffc20004904000-0xffffc20004bec000 3047424 sys_swapon+0x640/0xac0 
pages=743 vmalloc vpages N0=743
0xffffffffa0000000-0xffffffffa000f000   61440 
sys_init_module+0xc27/0x1d00 pages=14 vmalloc N1=14
0xffffffffa000f000-0xffffffffa0014000   20480 
sys_init_module+0xc27/0x1d00 pages=4 vmalloc N0=4
0xffffffffa0014000-0xffffffffa0017000   12288 
sys_init_module+0xc27/0x1d00 pages=2 vmalloc N0=2
0xffffffffa0017000-0xffffffffa0022000   45056 
sys_init_module+0xc27/0x1d00 pages=10 vmalloc N1=10
0xffffffffa0022000-0xffffffffa0028000   24576 
sys_init_module+0xc27/0x1d00 pages=5 vmalloc N3=5
0xffffffffa0028000-0xffffffffa0050000  163840 
sys_init_module+0xc27/0x1d00 pages=39 vmalloc N1=39
0xffffffffa0050000-0xffffffffa0052000    8192 
sys_init_module+0xc27/0x1d00 pages=1 vmalloc N1=1
0xffffffffa0052000-0xffffffffa0056000   16384 
sys_init_module+0xc27/0x1d00 pages=3 vmalloc N1=3
0xffffffffa0056000-0xffffffffa0081000  176128 
sys_init_module+0xc27/0x1d00 pages=42 vmalloc N3=42
0xffffffffa0081000-0xffffffffa00ae000  184320 
sys_init_module+0xc27/0x1d00 pages=44 vmalloc N3=44
0xffffffffa00ae000-0xffffffffa00b1000   12288 
sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00b1000-0xffffffffa00b9000   32768 
sys_init_module+0xc27/0x1d00 pages=7 vmalloc N0=7
0xffffffffa00b9000-0xffffffffa00c4000   45056 
sys_init_module+0xc27/0x1d00 pages=10 vmalloc N3=10
0xffffffffa00c6000-0xffffffffa00e0000  106496 
sys_init_module+0xc27/0x1d00 pages=25 vmalloc N2=25
0xffffffffa00e0000-0xffffffffa00f1000   69632 
sys_init_module+0xc27/0x1d00 pages=16 vmalloc N2=16
0xffffffffa00f1000-0xffffffffa00f4000   12288 
sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00f4000-0xffffffffa00f7000   12288 
sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 mm/vmalloc.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+)



--------------030600080309050702090802
Content-Type: text/plain;
 name="vmallocinfo_numa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmallocinfo_numa.patch"

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6e45b0f..d1e6594 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -931,6 +931,27 @@ static void s_stop(struct seq_file *m, void *p)
 	read_unlock(&vmlist_lock);
 }
 
+static void show_numa_infos(struct seq_file *m, struct vm_struct *v)
+{
+	if (NUMA_BUILD) {
+		unsigned int *counters, nr;
+
+		counters = kzalloc(MAX_NUMNODES * sizeof(unsigned int),
+				   GFP_KERNEL);
+		if (!counters)
+			return;
+
+		for (nr = 0; nr < v->nr_pages; nr++)
+			counters[page_to_nid(v->pages[nr])]++;
+
+		for (nr = 0; nr < MAX_NUMNODES; nr++)
+			if (counters[nr])
+				seq_printf(m, " N%u=%u", nr, counters[nr]);
+
+		kfree(counters);
+	}
+}
+
 static int s_show(struct seq_file *m, void *p)
 {
 	struct vm_struct *v = p;
@@ -967,6 +988,7 @@ static int s_show(struct seq_file *m, void *p)
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	show_numa_infos(m, v);
 	seq_putc(m, '\n');
 	return 0;
 }

--------------030600080309050702090802--


