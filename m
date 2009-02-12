Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZBLHUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZBLHUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZBLHUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:20:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52085 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZBLHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:20:40 -0500
Date: Thu, 12 Feb 2009 16:19:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       davem@davemlloft.net, heiko.carstens@de.ibm.com
Subject: [PATCH 0/2] fix memmap init for handling memory hole v2
Message-Id: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set is a replacement for

mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch (dropped)

I think this version is much cleaner than previous one.

This is a fix for routines in boot, so this can add a terrible error.
Please test when you have time. I tested on x86-64+fake NUMA.

-Kame
== from this problem.

What's happening is that the assertion in mm/page_alloc.c:move_freepages()
is triggering:

	BUG_ON(page_zone(start_page) != page_zone(end_page));

Once I knew this is what was happening, I added some annotations:

	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
		printk(KERN_ERR "move_freepages: Bogus zones: "
		       "start_page[%p] end_page[%p] zone[%p]\n",
		       start_page, end_page, zone);
		printk(KERN_ERR "move_freepages: "
		       "start_zone[%p] end_zone[%p]\n",
		       page_zone(start_page), page_zone(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
		       page_to_pfn(start_page), page_to_pfn(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_nid[%d] end_nid[%d]\n",
		       page_to_nid(start_page), page_to_nid(end_page));
 ...

And here's what I got:

	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
	move_freepages: start_nid[1] end_nid[0]

My memory layout on this box is:

[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0081ff5d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00020000
[    0.000000]     1: 0x00800000 -> 0x0081f7ff
[    0.000000]     1: 0x0081f800 -> 0x0081fe50
[    0.000000]     1: 0x0081fed1 -> 0x0081fed8
[    0.000000]     1: 0x0081feda -> 0x0081fedb
[    0.000000]     1: 0x0081fedd -> 0x0081fee5
[    0.000000]     1: 0x0081fee7 -> 0x0081ff51
[    0.000000]     1: 0x0081ff59 -> 0x0081ff5d

So it's a block move in that 0x81f600-->0x81f7ff region which triggers
the problem.

