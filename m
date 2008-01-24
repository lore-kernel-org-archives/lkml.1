Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYAXEhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYAXEhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYAXEhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:37:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYAXEhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:37:05 -0500
Date: Wed, 23 Jan 2008 20:36:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org
Cc: flamingice@sourmilk.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, reinette.chatre@intel.com
Subject: [patch] lockdep: fix kernel crash on module unload
Message-ID: <20080123203650.17b31d55@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Peter, Ingo,

we're seeing a VERY repeatable oops on module unload on the Intel
wireless drivers with lockdep enabled; turns out Michael Wu had already
rootcaused this type of crash (see URL below), however the fix he has
would increase the structure size of the lockdep metadata a lot; a much
simpler fix for the  oops is in the patch below; the lockdep module
unload code just was not agressive enough in  detecting which metadata
structures to nuke. With this patch a very repeatable oops on unload
went away (Reinette tested it and it survived > 100 unload cycles now).

The oops happens even in 2.6.24-rc8 and the fix is rather obvious, so
it might even be 2.6.24 material (or for 24-stable just after that)

--------

Subject: lockdep: fix kernel crash on module unload
From: Arjan van de Ven <arjan@linux.intel.com>

Michael Wu noticed in his lkml post at
http://marc.info/?l=linux-kernel&m=119396182726091&w=2
that certain wireless drivers ended up having their name 
in module memory, which would then crash the kernel on module
unload.

The patch he proposed was a bit clumsy in that it increased the
size of a lockdep entry significantly; the patch below tries another
approach, it checks, on module teardown, if the name of a class is
in module space and then zaps the class. This is very similar to what
we already do with keys that are in module space.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/lockdep.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc8/kernel/lockdep.c
===================================================================
--- linux-2.6.24-rc8.orig/kernel/lockdep.c
+++ linux-2.6.24-rc8/kernel/lockdep.c
@@ -2932,7 +2932,7 @@ static void zap_class(struct lock_class 
 
 }
 
-static inline int within(void *addr, void *start, unsigned long size)
+static inline int within(const void *addr, void *start, unsigned long size)
 {
 	return addr >= start && addr < start + size;
 }
@@ -2954,9 +2954,12 @@ void lockdep_free_key_range(void *start,
 		head = classhash_table + i;
 		if (list_empty(head))
 			continue;
-		list_for_each_entry_safe(class, next, head, hash_entry)
+		list_for_each_entry_safe(class, next, head, hash_entry) {
 			if (within(class->key, start, size))
 				zap_class(class);
+			else if (within(class->name, start, size))
+				zap_class(class);
+		}
 	}
 
 	graph_unlock();


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
