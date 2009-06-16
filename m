Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbZFPO5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbZFPO5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZFPO5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:57:06 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57860 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752551AbZFPO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:57:05 -0400
Date: Tue, 16 Jun 2009 09:57:06 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] page_alloc: Oops when setting percpu_pagelist_fraction
Message-ID: <20090616145706.GB14680@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After downing/upping a cpu, an attempt to set
/proc/sys/vm/percpu_pagelist_fraction results in an oops in
percpu_pagelist_fraction_sysctl_handler().

To reproduce this:
  localhost:/sys/devices/system/cpu/cpu6 # echo 0 >online
  localhost:/sys/devices/system/cpu/cpu6 # echo 1 >online
  localhost:/sys/devices/system/cpu/cpu6 # cd /proc/sys/vm
  localhost:/proc/sys/vm # echo 100000 >percpu_pagelist_fraction

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
  IP: [<ffffffff80286946>] percpu_pagelist_fraction_sysctl_handler+0x4a/0x96


This is because the zone->pageset[cpu] value has not been set when the
cpu has been brought back up for unpopulated zones (the "Movable" zone
in the case I'm running into).  Prior to downing/upping the cpu it had
been set to &boot_pageset[cpu].

There are two possible fixes that come to mind.  One is to check for an
unpopulated zone or NULL zone pageset for that cpu in
percpu_pagelist_fraction_sysctl_handler(), and simply not set a pagelist
highmark for that zone/cpu combination.

The other, and the one I'm proposing here, is to set the zone's pageset
back to the boot_pageset when the cpu is brought back up if the zone is
unpopulated.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-06-16 09:25:25.000000000 -0500
+++ linux/mm/page_alloc.c	2009-06-16 09:27:47.000000000 -0500
@@ -2806,7 +2806,11 @@ static int __cpuinit process_zones(int c
 
 	node_set_state(node, N_CPU);	/* this node has a cpu */
 
-	for_each_populated_zone(zone) {
+	for_each_zone(zone) {
+		if (!populated_zone(zone)) {
+			zone_pcp(zone, cpu) = &boot_pageset[cpu];
+			continue;
+		}
 		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
 					 GFP_KERNEL, node);
 		if (!zone_pcp(zone, cpu))
