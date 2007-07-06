Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbXGFJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbXGFJS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXGFJST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:18:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53985 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXGFJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:18:18 -0400
Date: Fri, 6 Jul 2007 18:19:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: [PATCH] memory unplug v7 - introduction
Message-Id: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a memory unplug base patch set against 2.6.22-rc6-mm1.
called v7 (I skipped v6 post because of my internal patch handling.)

Andrew, could you give me your advice toward next step (merge) ?

Changelog V5->V7
 - reflected all coments on V5 and following threads.

Patch series are following.

(1)migrate_nocontext.patch
(2)lru_page_race_fix.patch
(3)walk_mem_resource.patch
(4)page_isolation_base_v7.patch
(5)page_removal_base_v7.patch
(6)ia64_page_hotremove.patch

I think patch (1) (2) (3) has enough quality and can be merged without
regression.
patch (1) and (2) is for "page migration by the kernel".
patch (3) is cleanup of memory hotplug.

patch (4)(5) depens on Mel's page grouping.
patch (5) will need more work for enhancement for NUMA and stable-removal.
(In current code, a user may have to retry offlining if pages are *very* busy.)
But it works well on my test.

How to use
 - user kernelcore=XXX boot option to create ZONE_MOVABLE.
   Memory unplug itself can work without ZONE_MOVABLE (if you allow retrying..)
   but it will be better to use kernelcore= if your section size is big.
  
 - After bootup, execute following.
     # echo "offline" > /sys/devices/system/memory/memoryX/state
 - you can push back offlined memory by following
     # echo "online" > /sys/devices/system/memory/memoryX/state

TODO
 - more tests.
 - Now, there is no check around ZONE_MOVABLE and bootmem.
   I hope bootmem can treat kernelcore=....
   We have some idea about this.
 - add better logic to allocate memory for migration (for NUMA). 
   Problems here are that we have no way to rememeber "How page is allocated".
   cpusets info and policy info is in "task_struct", which cannot be accessed
   from a page struct..maybe what we can do is (1) add more information to page 
   or (2) use just a simple way. or (3) some magical technique...
 - interface code for other archs. plz request if you want.
 - remove memmap after memory unplug.  (after sparsemem-vmemap inclusion)
 - node hotplug support

Thanks,
-Kame

