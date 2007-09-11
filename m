Return-Path: <linux-kernel-owner+w=401wt.eu-S965784AbXIKKUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784AbXIKKUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbXIKKTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:19:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58531 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761832AbXIKKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:19:50 -0400
Date: Tue, 11 Sep 2007 19:19:15 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch] Fix panic of cpu online with memory less node
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070911191152.F13B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a cpu is onlined on memory-less-node box, kernel panics due to
touch NULL pointer of pgdat->kswapd. Current kswapd runs only
nodes which have memory. So, calling of set_cpus_allowed()
is not necessary for memory-less node.

This is fix for it.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2007-09-03 16:36:18.000000000 +0900
+++ current/mm/vmscan.c	2007-09-11 13:02:20.000000000 +0900
@@ -1843,9 +1843,11 @@ static int __devinit cpu_callback(struct
 {
 	pg_data_t *pgdat;
 	cpumask_t mask;
+	int nid;
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
-		for_each_online_pgdat(pgdat) {
+		for_each_node_state(nid, N_HIGH_MEMORY) {
+			pgdat = NODE_DATA(nid);
 			mask = node_to_cpumask(pgdat->node_id);
 			if (any_online_cpu(mask) != NR_CPUS)
 				/* One of our CPUs online: restore mask */

-- 
Yasunori Goto 


