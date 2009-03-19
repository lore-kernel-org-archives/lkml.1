Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZCSAqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZCSAqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 20:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZCSAqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 20:46:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZCSAqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 20:46:01 -0400
Date: Thu, 19 Mar 2009 09:44:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] memcg remvoe redundant message at swapon
Message-Id: <20090319094433.709edb9e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0903162217030.3560@blonde.anvils>
References: <20090310100707.e0640b0b.nishimura@mxp.nes.nec.co.jp>
	<20090310160856.77deb5c3.akpm@linux-foundation.org>
	<20090311085326.403a211d.kamezawa.hiroyu@jp.fujitsu.com>
	<isapiwc.d14e3c29.6b18.49b7092b.9bc73.52@mail.jp.nec.com>
	<20090311094739.3123b05d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090311120427.2467bd14.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0903111041260.16964@blonde.anvils>
	<20090312084623.e98d80b9.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0903162217030.3560@blonde.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on this thread http://marc.info/?l=linux-mm&m=123724233418715&w=2
against the mmotm.
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's pointed out that swap_cgroup's message at swapon() is nonsense.
Because
  * It can be calculated very easily if all necessary information is
    written in Kconfig.
  * It's not necessary to annoying people at every swapon().

In other view, now, memory usage per swp_entry is reduced to 2bytes
from 8bytes(64bit) and I think it's reasonably small.

Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar11/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.29-Mar11.orig/mm/page_cgroup.c
+++ mmotm-2.6.29-Mar11/mm/page_cgroup.c
@@ -426,13 +426,6 @@ int swap_cgroup_swapon(int type, unsigne
 	}
 	mutex_unlock(&swap_cgroup_mutex);
 
-	printk(KERN_INFO
-		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
-		" and %ld bytes to hold mem_cgroup information per swap ents\n",
-		array_size, length * PAGE_SIZE);
-	printk(KERN_INFO
-	"swap_cgroup can be disabled by noswapaccount boot option.\n");
-
 	return 0;
 nomem:
 	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
Index: mmotm-2.6.29-Mar11/init/Kconfig
===================================================================
--- mmotm-2.6.29-Mar11.orig/init/Kconfig
+++ mmotm-2.6.29-Mar11/init/Kconfig
@@ -603,6 +603,8 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  is disabled by boot option, this will be automatically disabled and
 	  there will be no overhead from this. Even when you set this config=y,
 	  if boot option "noswapaccount" is set, swap will not be accounted.
+	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
+	  size is 4096bytes, 512k per 1Gbytes of swap.
 
 endif # CGROUPS
 

