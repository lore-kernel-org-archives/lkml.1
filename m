Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZBDILO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZBDILO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZBDIK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:10:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59908 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZBDIK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:10:57 -0500
Date: Wed, 4 Feb 2009 17:09:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       heiko.carstens@de.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] use __GFP_NOWARN in page cgroup allocation
Message-Id: <20090204170944.c93772d2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was recommended in
"kmalloc-return-null-instead-of-link-failure.patch added to -mm tree" thread
in the last month.
Thanks,
-Kame
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

page_cgroup's page allocation at init/memory hotplug uses kmalloc() and
vmalloc(). If kmalloc() failes, vmalloc() is used.

This is because vmalloc() is very limited resource on 32bit systems.
We want to use kmalloc() first.

But in this kind of call, __GFP_NOWARN should be specified.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Feb03/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.29-Feb03.orig/mm/page_cgroup.c
+++ mmotm-2.6.29-Feb03/mm/page_cgroup.c
@@ -114,7 +114,8 @@ static int __init_refok init_section_pag
 		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 		if (slab_is_available()) {
-			base = kmalloc_node(table_size, GFP_KERNEL, nid);
+			base = kmalloc_node(table_size,
+					GFP_KERNEL | __GFP_NOWARN, nid);
 			if (!base)
 				base = vmalloc_node(table_size, nid);
 		} else {

