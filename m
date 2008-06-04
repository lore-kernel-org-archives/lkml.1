Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYFDPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYFDPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFDPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:01:18 -0400
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:44783
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbYFDPBR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:01:17 -0400
Message-ID: <4846AE30.8000302@cosmosbay.com>
Date: Wed, 04 Jun 2008 17:01:04 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
References: <48439916.2070108@cosmosbay.com>	<20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<4844BC75.8040705@cosmosbay.com> <20080603144054.973284bb.akpm@linux-foundation.org>
In-Reply-To: <20080603144054.973284bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Tue, 03 Jun 2008 05:37:25 +0200
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> [PATCH] vmallocinfo: Add NUMA informations
> 
> Using multipart-mixed MIME makes it a bit hard to handle and reply to a
> patch.

OK, I need to play around with my mailer, sorry.

>> +		counters = kzalloc(nr_node_ids * sizeof(unsigned int),
> 
> This is kcalloc().  If you like that sorts of thing - I think kcalloc()
> is pretty pointless personally.

OK, next patch is using kmalloc() anyway :)

> 
>> +				   GFP_KERNEL);
> 
> We're running under read_lock(&vmlist_lock) here, aren't we?  If so,
> please tape Documentation/SubmitChecklist to the bathroom door.  If
> not, what prevents *v from vanishing?
> 
> Do we actually need dynamic allocation here?  There's a small,
> constant, known-at-compile-time upper bound to the number of nodes IDs?
> 

MAX_NUMNODES can be pretty large so this array cannot be on stack unfortunatly.
So I guess we have to allocate this block in vmalloc_open() and pass it in seq->private.
Adding #ifdef stuf to avoid dynamic allocations for small MAX_NUMNODES would be overkill.

> 
>> +		if (!counters)
>> +			return;
> 
> Will this just lock up until some memory comes free?

Yes, my bad.

Thanks very much Andrew for this review.

Here is an updated patch.

It now allocates the array in vmalloc_open().
If this allocation fails, we just proceed and dont provide NUMA information.

I included missing documentation for /proc/vmallocinfo as well.


[PATCH] vmallocinfo: Add NUMA informations

Christoph recently added /proc/vmallocinfo file to get information about vmalloc allocations.

This patch adds NUMA specific information, giving number of pages allocated on each memory node.

This should help to check that vmalloc() is able to respect NUMA policies.

Example of output on a four nodes machine (one cpu per node)

1) network hash tables are evenly spreaded on four nodes (OK)
 (Same point for inodes and dentries hash tables)
2) iptables tables (x_tables) are correctly allocated on each cpu node (OK).
3) sys_swapon() allocates its memory from one node only.
4) each loaded module is using memory on one node.

Sysadmins could tune their setup to change points 3) and 4) if necessary.

grep "pages="  /proc/vmallocinfo
0xffffc20000000000-0xffffc20000201000 2101248 alloc_large_system_hash+0x204/0x2c0 pages=512 vmalloc N0=128 N1=128 N2=128 N3=128
0xffffc20000201000-0xffffc20000302000 1052672 alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
0xffffc2000031a000-0xffffc2000031d000   12288 alloc_large_system_hash+0x204/0x2c0 pages=2 vmalloc N1=1 N2=1
0xffffc2000031f000-0xffffc2000032b000   49152 cramfs_uncompress_init+0x2e/0x80 pages=11 vmalloc N0=3 N1=3 N2=2 N3=3
0xffffc2000033e000-0xffffc20000341000   12288 sys_swapon+0x640/0xac0 pages=2 vmalloc N0=2
0xffffc20000341000-0xffffc20000344000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N0=2
0xffffc20000344000-0xffffc20000347000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N1=2
0xffffc20000347000-0xffffc2000034a000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N2=2
0xffffc2000034a000-0xffffc2000034d000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N3=2
0xffffc20004381000-0xffffc20004402000  528384 alloc_large_system_hash+0x204/0x2c0 pages=128 vmalloc N0=32 N1=32 N2=32 N3=32
0xffffc20004402000-0xffffc20004803000 4198400 alloc_large_system_hash+0x204/0x2c0 pages=1024 vmalloc vpages N0=256 N1=256 N2=256 N3=256
0xffffc20004803000-0xffffc20004904000 1052672 alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
0xffffc20004904000-0xffffc20004bec000 3047424 sys_swapon+0x640/0xac0 pages=743 vmalloc vpages N0=743
0xffffffffa0000000-0xffffffffa000f000   61440 sys_init_module+0xc27/0x1d00 pages=14 vmalloc N1=14
0xffffffffa000f000-0xffffffffa0014000   20480 sys_init_module+0xc27/0x1d00 pages=4 vmalloc N0=4
0xffffffffa0014000-0xffffffffa0017000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N0=2
0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 pages=10 vmalloc N1=10
0xffffffffa0022000-0xffffffffa0028000   24576 sys_init_module+0xc27/0x1d00 pages=5 vmalloc N3=5
0xffffffffa0028000-0xffffffffa0050000  163840 sys_init_module+0xc27/0x1d00 pages=39 vmalloc N1=39
0xffffffffa0050000-0xffffffffa0052000    8192 sys_init_module+0xc27/0x1d00 pages=1 vmalloc N1=1
0xffffffffa0052000-0xffffffffa0056000   16384 sys_init_module+0xc27/0x1d00 pages=3 vmalloc N1=3
0xffffffffa0056000-0xffffffffa0081000  176128 sys_init_module+0xc27/0x1d00 pages=42 vmalloc N3=42
0xffffffffa0081000-0xffffffffa00ae000  184320 sys_init_module+0xc27/0x1d00 pages=44 vmalloc N3=44
0xffffffffa00ae000-0xffffffffa00b1000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00b1000-0xffffffffa00b9000   32768 sys_init_module+0xc27/0x1d00 pages=7 vmalloc N0=7
0xffffffffa00b9000-0xffffffffa00c4000   45056 sys_init_module+0xc27/0x1d00 pages=10 vmalloc N3=10
0xffffffffa00c6000-0xffffffffa00e0000  106496 sys_init_module+0xc27/0x1d00 pages=25 vmalloc N2=25
0xffffffffa00e0000-0xffffffffa00f1000   69632 sys_init_module+0xc27/0x1d00 pages=16 vmalloc N2=16
0xffffffffa00f1000-0xffffffffa00f4000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00f4000-0xffffffffa00f7000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 Documentation/filesystems/proc.txt |   44 +++++++++++++++++++++++++++
 fs/proc/proc_misc.c                |   15 +++++++--
 mm/vmalloc.c                       |   20 ++++++++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index dbc3c6a..b707d9a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -296,6 +296,7 @@ Table 1-4: Kernel info in /proc
  uptime      System uptime                                     
  version     Kernel version                                    
  video	     bttv info of video resources			(2.4)
+ vmallocinfo Show vmalloced areas
 ..............................................................................
 
 You can,  for  example,  check  which interrupts are currently in use and what
@@ -550,6 +551,49 @@ VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contigious block of vmalloc area which is free
 
+..............................................................................
+
+vmallocinfo:
+
+Provides information about vmalloced/vmaped areas. One line per area,
+containing the virtual address range of the area, size in bytes,
+caller information of the creator, and optional informations depending
+on the kind of area :
+
+ pages=nr    number of pages
+ phys=addr   if a physical address was specified
+ ioremap     I/O mapping (ioremap() and friends)
+ vmalloc     vmalloc() area
+ vmap        vmap()ed pages
+ user        VM_USERMAP area
+ vpages      buffer for pages pointers was vmalloced (huge area)
+ N<node>=nr  (Only on NUMA kernels)
+             Number of pages allocated on memory node <node>
+
+> cat /proc/vmallocinfo
+0xffffc20000000000-0xffffc20000201000 2101248 alloc_large_system_hash+0x204 ...
+  /0x2c0 pages=512 vmalloc N0=128 N1=128 N2=128 N3=128
+0xffffc20000201000-0xffffc20000302000 1052672 alloc_large_system_hash+0x204 ...
+  /0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
+0xffffc20000302000-0xffffc20000304000    8192 acpi_tb_verify_table+0x21/0x4f...
+  phys=7fee8000 ioremap
+0xffffc20000304000-0xffffc20000307000   12288 acpi_tb_verify_table+0x21/0x4f...
+  phys=7fee7000 ioremap
+0xffffc2000031d000-0xffffc2000031f000    8192 init_vdso_vars+0x112/0x210
+0xffffc2000031f000-0xffffc2000032b000   49152 cramfs_uncompress_init+0x2e ...
+  /0x80 pages=11 vmalloc N0=3 N1=3 N2=2 N3=3
+0xffffc2000033a000-0xffffc2000033d000   12288 sys_swapon+0x640/0xac0      ...
+  pages=2 vmalloc N1=2
+0xffffc20000347000-0xffffc2000034c000   20480 xt_alloc_table_info+0xfe ...
+  /0x130 [x_tables] pages=4 vmalloc N0=4
+0xffffffffa0000000-0xffffffffa000f000   61440 sys_init_module+0xc27/0x1d00 ...
+   pages=14 vmalloc N2=14
+0xffffffffa000f000-0xffffffffa0014000   20480 sys_init_module+0xc27/0x1d00 ...
+   pages=4 vmalloc N1=4
+0xffffffffa0014000-0xffffffffa0017000   12288 sys_init_module+0xc27/0x1d00 ...
+   pages=2 vmalloc N1=2
+0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 ...
+   pages=10 vmalloc N0=10
 
 1.3 IDE devices in /proc/ide
 ----------------------------
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 32dc14c..cfdf9e3 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -461,14 +461,25 @@ static const struct file_operations proc_slabstats_operations = {
 #ifdef CONFIG_MMU
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &vmalloc_op);
+	unsigned int *ptr = NULL;
+	int ret;
+
+	if (NUMA_BUILD)
+		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+	ret = seq_open(file, &vmalloc_op);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = ptr;
+	} else
+		kfree(ptr);
+	return ret;
 }
 
 static const struct file_operations proc_vmalloc_operations = {
 	.open		= vmalloc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 #endif
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6e45b0f..35f2938 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -931,6 +931,25 @@ static void s_stop(struct seq_file *m, void *p)
 	read_unlock(&vmlist_lock);
 }
 
+static void show_numa_info(struct seq_file *m, struct vm_struct *v)
+{
+	if (NUMA_BUILD) {
+		unsigned int nr, *counters = m->private;
+
+		if (!counters)
+			return;
+
+		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
+
+		for (nr = 0; nr < v->nr_pages; nr++)
+			counters[page_to_nid(v->pages[nr])]++;
+
+		for_each_node_state(nr, N_HIGH_MEMORY)
+			if (counters[nr])
+				seq_printf(m, " N%u=%u", nr, counters[nr]);
+	}
+}
+
 static int s_show(struct seq_file *m, void *p)
 {
 	struct vm_struct *v = p;
@@ -967,6 +986,7 @@ static int s_show(struct seq_file *m, void *p)
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	show_numa_info(m, v);
 	seq_putc(m, '\n');
 	return 0;
 }


