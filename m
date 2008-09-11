Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYIKLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYIKLK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYIKLKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:10:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56032 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYIKLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:10:13 -0400
Date: Thu, 11 Sep 2008 20:11:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: [RFC] [PATCH 1/9] memcg:make root no limit
Message-Id: <20080911201139.32bf59a2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make root cgroup of memory resource controller to have no limit.

By this, users cannot set limit to root group. This is for making root cgroup
as a kind of trash-can.

For accounting pages which has no owner, which are created by force_empty,
we need some cgroup with no_limit. A patch for rewriting force_empty will
will follow this one.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 Documentation/controllers/memory.txt |    4 ++++
 mm/memcontrol.c                      |    7 +++++++
 2 files changed, 11 insertions(+)

Index: mmtom-2.6.27-rc5+/mm/memcontrol.c
===================================================================
--- mmtom-2.6.27-rc5+.orig/mm/memcontrol.c
+++ mmtom-2.6.27-rc5+/mm/memcontrol.c
@@ -136,6 +136,9 @@ struct mem_cgroup {
 };
 static struct mem_cgroup init_mem_cgroup;
 
+#define is_root_cgroup(cgrp)	((cgrp) == &init_mem_cgroup)
+
+
 /*
  * We use the lower bit of the page->page_cgroup pointer as a bit spin
  * lock.  We need to ensure that page->page_cgroup is at least two
@@ -937,6 +940,10 @@ static int mem_cgroup_write(struct cgrou
 
 	switch (cft->private) {
 	case RES_LIMIT:
+		if (is_root_cgroup(memcg)) {
+			ret = -EINVAL;
+			break;
+		}
 		/* This function does all necessary parse...reuse it */
 		ret = res_counter_memparse_write_strategy(buffer, &val);
 		if (!ret)
Index: mmtom-2.6.27-rc5+/Documentation/controllers/memory.txt
===================================================================
--- mmtom-2.6.27-rc5+.orig/Documentation/controllers/memory.txt
+++ mmtom-2.6.27-rc5+/Documentation/controllers/memory.txt
@@ -121,6 +121,9 @@ The corresponding routines that remove a
 a page from Page Cache is used to decrement the accounting counters of the
 cgroup.
 
+The root cgroup is not allowed to be set limit but usage is accounted.
+For controlling usage of memory, you need to create a cgroup.
+
 2.3 Shared Page Accounting
 
 Shared pages are accounted on the basis of the first touch approach. The
@@ -172,6 +175,7 @@ We can alter the memory limit:
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
+Note: root cgroup is not able to be set limit.
 
 # cat /cgroups/0/memory.limit_in_bytes
 4194304

