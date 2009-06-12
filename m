Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZFLPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZFLPk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZFLPkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:40:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60192 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZFLPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:40:53 -0400
Date: Fri, 12 Jun 2009 18:40:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       cl@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       benh@kernel.crashing.org
Subject: [PATCH 1/3] slab: fix gfp flag in setup_cpu_cache()
Message-ID: <Pine.LNX.4.64.0906121840230.5491@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fixes the following warning during bootup when compiling with CONFIG_SLAB:

  [    0.000000] ------------[ cut here ]------------
  [    0.000000] WARNING: at kernel/lockdep.c:2282 lockdep_trace_alloc+0x91/0xb9()
  [    0.000000] Hardware name:
  [    0.000000] Modules linked in:
  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30 #491
  [    0.000000] Call Trace:
  [    0.000000]  [<ffffffff81087d84>] ? lockdep_trace_alloc+0x91/0xb9
  [    0.000000]  [<ffffffff81061764>] warn_slowpath_common+0x7c/0xa9
  [    0.000000]  [<ffffffff810617a5>] warn_slowpath_null+0x14/0x16
  [    0.000000]  [<ffffffff81087d84>] lockdep_trace_alloc+0x91/0xb9
  [    0.000000]  [<ffffffff810f5b03>] kmem_cache_alloc_node_notrace+0x26/0xdf
  [    0.000000]  [<ffffffff81487f4e>] ? setup_cpu_cache+0x7e/0x210
  [    0.000000]  [<ffffffff81487fe3>] setup_cpu_cache+0x113/0x210
  [    0.000000]  [<ffffffff810f73ff>] kmem_cache_create+0x409/0x486
  [    0.000000]  [<ffffffff818131c1>] kmem_cache_init+0x232/0x593
  [    0.000000]  [<ffffffff8180987c>] ? mem_init+0x156/0x161
  [    0.000000]  [<ffffffff817f8aae>] start_kernel+0x1cc/0x3b9
  [    0.000000]  [<ffffffff817f829a>] x86_64_start_reservations+0xaa/0xae
  [    0.000000]  [<ffffffff817f837f>] x86_64_start_kernel+0xe1/0xe8
  [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index f46b65d..cd76964 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2102,7 +2102,7 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 			for_each_online_node(node) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
-						GFP_KERNEL, node);
+						gfp, node);
 				BUG_ON(!cachep->nodelists[node]);
 				kmem_list3_init(cachep->nodelists[node]);
 			}
-- 
1.6.0.4

