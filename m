Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYFCDhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYFCDhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 23:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYFCDhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 23:37:43 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:31395 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYFCDhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 23:37:42 -0400
X-ME-UUID: 20080603033740408.63B3F1C0009B@mwinf2129.orange.fr
Message-ID: <4844BC75.8040705@cosmosbay.com>
Date: Tue, 03 Jun 2008 05:37:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
References: <48439916.2070108@cosmosbay.com> <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------050209070605020102020907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050209070605020102020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

KOSAKI Motohiro a =E9crit :
> Hi
>
>  =20
>> Christoph recently added /proc/vmallocinfo file to get information abo=
ut=20
>> vmalloc allocations.
>>
>> This patch adds NUMA specific information, giving number of pages=20
>> allocated on each memory node.
>>
>> This should help to check that vmalloc() is able to respect NUMA polic=
ies.
>>    =20
>
> good patch :)
>
>
>  =20
>> +static void show_numa_infos(struct seq_file *m, struct vm_struct *v)
>> +{
>> +	if (NUMA_BUILD) {
>> +		unsigned int *counters, nr;
>> +
>> +		counters =3D kzalloc(MAX_NUMNODES * sizeof(unsigned int),
>> +				   GFP_KERNEL);
>> +		if (!counters)
>> +			return;
>> +
>> +		for (nr =3D 0; nr < v->nr_pages; nr++)
>> +			counters[page_to_nid(v->pages[nr])]++;
>> +
>> +		for (nr =3D 0; nr < MAX_NUMNODES; nr++)
>> +			if (counters[nr])
>> +				seq_printf(m, " N%u=3D%u", nr, counters[nr]);
>> +
>>    =20
>
> for_each_node_state(n, N_HIGH_MEMORY) is better?
> because MAX_NUMNODES has offten very large value.
>
>
>
>  =20
Yes, good idea, thank you.

I also used nr_node_ids instead of MAX_NUMNODES in this second version :

[PATCH] vmallocinfo: Add NUMA informations

Christoph recently added /proc/vmallocinfo file to get information about =

vmalloc allocations.

This patch adds NUMA specific information, giving number of pages=20
allocated on each memory node.

This should help to check that vmalloc() is able to respect NUMA policies=
=2E

Example of output on a four nodes machine (one cpu per node)

1) network hash tables are evenly spreaded on four nodes (OK)
  (Same point for inodes and dentries hash tables)
2) iptables tables (x_tables) are correctly allocated on each cpu node=20
(OK).
3) sys_swapon() allocates its memory from one node only.
4) each loaded module is using memory on one node.

Sysadmins could tune their setup to change points 3) and 4) if necessary.=


grep "pages=3D"  /proc/vmallocinfo
0xffffc20000000000-0xffffc20000201000 2101248=20
alloc_large_system_hash+0x204/0x2c0 pages=3D512 vmalloc N0=3D128 N1=3D128=
=20
N2=3D128 N3=3D128
0xffffc20000201000-0xffffc20000302000 1052672=20
alloc_large_system_hash+0x204/0x2c0 pages=3D256 vmalloc N0=3D64 N1=3D64 N=
2=3D64=20
N3=3D64
0xffffc2000031a000-0xffffc2000031d000   12288=20
alloc_large_system_hash+0x204/0x2c0 pages=3D2 vmalloc N1=3D1 N2=3D1
0xffffc2000031f000-0xffffc2000032b000   49152=20
cramfs_uncompress_init+0x2e/0x80 pages=3D11 vmalloc N0=3D3 N1=3D3 N2=3D2 =
N3=3D3
0xffffc2000033e000-0xffffc20000341000   12288 sys_swapon+0x640/0xac0=20
pages=3D2 vmalloc N0=3D2
0xffffc20000341000-0xffffc20000344000   12288=20
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=3D2 vmalloc N0=3D2
0xffffc20000344000-0xffffc20000347000   12288=20
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=3D2 vmalloc N1=3D2
0xffffc20000347000-0xffffc2000034a000   12288=20
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=3D2 vmalloc N2=3D2
0xffffc2000034a000-0xffffc2000034d000   12288=20
xt_alloc_table_info+0xfe/0x130 [x_tables] pages=3D2 vmalloc N3=3D2
0xffffc20004381000-0xffffc20004402000  528384=20
alloc_large_system_hash+0x204/0x2c0 pages=3D128 vmalloc N0=3D32 N1=3D32 N=
2=3D32=20
N3=3D32
0xffffc20004402000-0xffffc20004803000 4198400=20
alloc_large_system_hash+0x204/0x2c0 pages=3D1024 vmalloc vpages N0=3D256 =

N1=3D256 N2=3D256 N3=3D256
0xffffc20004803000-0xffffc20004904000 1052672=20
alloc_large_system_hash+0x204/0x2c0 pages=3D256 vmalloc N0=3D64 N1=3D64 N=
2=3D64=20
N3=3D64
0xffffc20004904000-0xffffc20004bec000 3047424 sys_swapon+0x640/0xac0=20
pages=3D743 vmalloc vpages N0=3D743
0xffffffffa0000000-0xffffffffa000f000   61440=20
sys_init_module+0xc27/0x1d00 pages=3D14 vmalloc N1=3D14
0xffffffffa000f000-0xffffffffa0014000   20480=20
sys_init_module+0xc27/0x1d00 pages=3D4 vmalloc N0=3D4
0xffffffffa0014000-0xffffffffa0017000   12288=20
sys_init_module+0xc27/0x1d00 pages=3D2 vmalloc N0=3D2
0xffffffffa0017000-0xffffffffa0022000   45056=20
sys_init_module+0xc27/0x1d00 pages=3D10 vmalloc N1=3D10
0xffffffffa0022000-0xffffffffa0028000   24576=20
sys_init_module+0xc27/0x1d00 pages=3D5 vmalloc N3=3D5
0xffffffffa0028000-0xffffffffa0050000  163840=20
sys_init_module+0xc27/0x1d00 pages=3D39 vmalloc N1=3D39
0xffffffffa0050000-0xffffffffa0052000    8192=20
sys_init_module+0xc27/0x1d00 pages=3D1 vmalloc N1=3D1
0xffffffffa0052000-0xffffffffa0056000   16384=20
sys_init_module+0xc27/0x1d00 pages=3D3 vmalloc N1=3D3
0xffffffffa0056000-0xffffffffa0081000  176128=20
sys_init_module+0xc27/0x1d00 pages=3D42 vmalloc N3=3D42
0xffffffffa0081000-0xffffffffa00ae000  184320=20
sys_init_module+0xc27/0x1d00 pages=3D44 vmalloc N3=3D44
0xffffffffa00ae000-0xffffffffa00b1000   12288=20
sys_init_module+0xc27/0x1d00 pages=3D2 vmalloc N3=3D2
0xffffffffa00b1000-0xffffffffa00b9000   32768=20
sys_init_module+0xc27/0x1d00 pages=3D7 vmalloc N0=3D7
0xffffffffa00b9000-0xffffffffa00c4000   45056=20
sys_init_module+0xc27/0x1d00 pages=3D10 vmalloc N3=3D10
0xffffffffa00c6000-0xffffffffa00e0000  106496=20
sys_init_module+0xc27/0x1d00 pages=3D25 vmalloc N2=3D25
0xffffffffa00e0000-0xffffffffa00f1000   69632=20
sys_init_module+0xc27/0x1d00 pages=3D16 vmalloc N2=3D16
0xffffffffa00f1000-0xffffffffa00f4000   12288=20
sys_init_module+0xc27/0x1d00 pages=3D2 vmalloc N3=3D2
0xffffffffa00f4000-0xffffffffa00f7000   12288=20
sys_init_module+0xc27/0x1d00 pages=3D2 vmalloc N3=3D2

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 mm/vmalloc.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+)



--------------050209070605020102020907
Content-Type: text/plain;
 name="vmallocinfo_numa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmallocinfo_numa.patch"

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6e45b0f..d2bbd85 100644
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
+		counters = kzalloc(nr_node_ids * sizeof(unsigned int),
+				   GFP_KERNEL);
+		if (!counters)
+			return;
+
+		for (nr = 0; nr < v->nr_pages; nr++)
+			counters[page_to_nid(v->pages[nr])]++;
+
+		for_each_node_state(nr, N_HIGH_MEMORY)
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

--------------050209070605020102020907--


