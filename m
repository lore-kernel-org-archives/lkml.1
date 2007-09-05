Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbXIEAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbXIEAr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 20:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbXIEArv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 20:47:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:28616 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754959AbXIEAru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 20:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,209,1186383600"; 
   d="scan'208";a="293424524"
Subject: tbench regression - Why process scheduler has impact on tbench and
	why small per-cpu slab (SLUB) cache creates the scenario?
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: clameter@sgi.com, mingo@elte.hu
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Sep 2007 08:46:58 +0800
Message-Id: <1188953218.26438.34.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Tbench has about 30% regression in kernel 2.6.23-rc4 than 2.6.22.
2.6.23-rc1 has about 10% regression. I investigated 2.6.22 and 2.6.23-rc4.
2) Testing environment: x86_64, qual-core, 2 physical processors, totally
8 cores. 8GB memory. Kernel enables CONFIG_SLUB=y and CONFIG_SLUB_DEBUG=y.
3) Under my environment, I started CPU_NUMBER*2 tbench sub processes and
server processes. So 16 tbench and 16 tbench_srv processes are running
based on 1:1 mapping. Tbench communicates with tbench_srv in an interactive
mode by tcp socket.
4) Collected oprofile data and showed __slab_alloc is about 15% in
2.6.23-rc4 and 3.8% in 2.6.22;
5) Collected slabinfo and found kmalloc-4096 and skbuff_head_cache are
proactive. Other slabs are mostly quiet.
6) Collect data about slab_alloc: data consists of
	a) number to call slab_alloc
	b) number to get objects from slab per cpu cache;
	c) number to get objects from a new slab and a partial slab;
	d) number to free objects from non-perCPU cache;
        These data showed skbuff_head_cache allocation mostly succeeds in
        per-cpu cache, so it won’t cause too much __slab_alloc. kmalloc-4096
        is the slab which causes too most __slab_alloc callings.
        
        On 2.6.22, about 58% kmalloc-4096 succeeds in per-cpu slab cache.
        On 2.6.23-rc4, about 12.5% kmalloc-4096 succeeds in per-cpu slab cache.

7) By instrumenting kernel, I captured kernel allocates kmalloc-4096 always
at tcp_sendmsg=>sk_stream_alloc_psk and frees it at
tcp_ack=>tcp_clean_rtx_queue=>sk_stream_free_skb. When tbench client
communicates with tbench_srv, the sender will allocate a kmalloc-4096 and the
receiver will free it.
8) kmalloc-4096 order is 1 which means one slab consists of 2 objects. So a
partial slab always consists one free object. In the other hand, slub only
allocates 1 slab for every cpu. If a tbench client process gets a kmalloc-4096
object from a partial page on a cpu and put the slab as the per-cpu cache,
this slab will have no free objects. So late another tbench process also
applies for a kmalloc-4096 on the same cpu, it couldn’t get a free object
from per-CPU cache. It will get an object, mostly from another partial slab
and replace the per-cpu slab cache, although the new slab also hasn’t free objects then.
9) I collected more data about cpu to see if the cpu on which kernel allocates
the object is the cpu which kernel frees the same object. The result showed both
kernel 2.6.22 and 2.6.23-rc3, very mostly, an object will be allocated and freed
on the same cpu. That means tbench client and tbench_srv process who communicate
with each other are mostly running on the same cpu.

10) I ran both kernel with boot parameter maxcpus=1 and found the regression becomes
about 10%.
11) On my machines, averagely, 1 cpu has 2 tbench client process and 2 tbench_srv
processes. So there are a couple of scenario of process scheduling:
	a) Client 1 allocates a 4096 object and updates the per-CPU slab with
the new non-free slab. The tbench_srv 1 consumes the data and free the 4096 object
on the same cpu, so the per-cpu slab cache slab has free object now. Then,
tbench_srv 1 replies to client 1 by allocating a new 4096 again, or client 2
allocates a 4096 object from the per-cpu slab cache to communicate with tbench_srv 2.
This good scenario is ideal.
	b) Client 1 allocates a 4096 object and updates the per-CPU slab with the
new non-free slab, then sleep to wait tbench_srv 1 to reply. But client 2 allocates
a 4096 object and finds the per-cpu slab cache has no free object, so allocates the
object from a partial slab and updates the per-CPU slab with the new non-free slab.
Then, tbench_srv 1 is scheduled in and frees the kmalloc-4096 object to a partial
slab, because previous slab already isn’t per-cpu cache. Then, tbench_srv 1 tries
to allocate a new kmalloc-4096 to reply to client 1. But because the per-cpu slab
hasn’t free object, so it also needs get the free object from a partial slab and
update per-cpu slab cache. This scenario is very bad.
        Under both scenarios, I think schedule wakes up sleeping processes on the same
        cpu. In scenario 1, the waken process will be scheduled to run on cpu quickly
        (immediately?). In In scenario 2, the waken process will be scheduled later.
        
   I think kernel 2.6.22 creates scenario 1 and 2.6.23-rc4 creates scenario 2.

12) How to resolve the issue? There are 2 directions.
	a) Change process scheduler to schedule waken processes firstly.
	b) Change SLUB per-cpu slab cache, to cache more slabs instead of only one
slab. This way could use page->lru to creates a list linked in kmem_cache->cpu_slab[]
whose members need to be changed to as list_head. As for how many slabs could be in
a per-cpu slab cache, it might be implemented as a sysfs parameter under /sys/slab/XXX/.
Default could be 1 to satisfy big machines.

--yanmin
