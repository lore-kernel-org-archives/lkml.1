Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZGaHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZGaHP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZGaHP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:15:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55166 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZGaHPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:15:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 31 Jul 2009 16:13:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH 3/3] unmap vmalloc area after hide it
Message-Id: <20090731161337.7c517937.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vmap area should be purged after vm_struct is removed from the list
because vread/vwrite etc...believes the range is valid while it's on
vm_struct list.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.31-rc4/mm/vmalloc.c
===================================================================
--- linux-2.6.31-rc4.orig/mm/vmalloc.c	2009-07-31 15:51:56.000000000 +0900
+++ linux-2.6.31-rc4/mm/vmalloc.c	2009-07-31 15:52:42.000000000 +0900
@@ -1256,17 +1256,21 @@
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->private;
 		struct vm_struct *tmp, **p;
-
-		vmap_debug_free_range(va->va_start, va->va_end);
-		free_unmap_vmap_area(va);
-		vm->size -= PAGE_SIZE;
-
+		/*
+		 * remove from list and disallow access to this vm_struct
+		 * before unmap. (address range confliction is maintained by
+		 * vmap.)
+		 */
 		write_lock(&vmlist_lock);
 		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
 			;
 		*p = tmp->next;
 		write_unlock(&vmlist_lock);
 
+		vmap_debug_free_range(va->va_start, va->va_end);
+		free_unmap_vmap_area(va);
+		vm->size -= PAGE_SIZE;
+
 		return vm;
 	}
 	return NULL;

