Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYKHMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYKHMtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYKHMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:49:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYKHMtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:49:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Date: Sat, 8 Nov 2008 13:53:33 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081353.34442.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This would be good to have in .28 IMO.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y

Fix macro __pfn_to_page(pfn) so that it doesn't evaluate its
argument twice in the CONFIG_DISCONTIGMEM=y case, because 'pfn' may
be a result of a funtion call having side effects.

For example, the hibernation code applies pfn_to_page(pfn) to the
result of a function returning the pfn corresponding to the next set
bit in a bitmap and the current bit position is modified on each
call.  This leads to "interesting" failures for CONFIG_DISCONTIGMEM=y
due to the current behavior of __pfn_to_page(pfn).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
---
 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/asm-generic/memory_model.h
===================================================================
--- linux-2.6.orig/include/asm-generic/memory_model.h
+++ linux-2.6/include/asm-generic/memory_model.h
@@ -34,7 +34,7 @@
 
 #define __pfn_to_page(pfn)			\
 ({	unsigned long __pfn = (pfn);		\
-	unsigned long __nid = arch_pfn_to_nid(pfn);  \
+	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
 	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
 })
 
