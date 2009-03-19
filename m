Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbZCSXKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbZCSXKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZCSXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:10:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZCSXKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:10:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=CwT1J2EE5yUvqnL75hZRm80viYRjAn/9apVc1uLmcM8ItzEyeIvEEB7ROEY+wd9WW
	LQZJUEV9OQdWv2ElqhMGQ==
Date: Thu, 19 Mar 2009 16:09:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch] vmscan: print shrink_slab symbol name on negative shrinker
 objects
Message-ID: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a shrinker has a negative number of objects to delete, the symbol
name of the shrinker should be printed, not shrink_slab.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmscan.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -40,6 +40,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/kallsyms.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -214,8 +215,12 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
-			printk(KERN_ERR "%s: nr=%ld\n",
-					__func__, shrinker->nr);
+			char symname[KSYM_NAME_LEN];
+
+			if (lookup_symbol_name((unsigned long)shrinker->shrink,
+					       symname) > 0)
+				printk(KERN_ERR "shrink_slab: %s nr=%ld\n",
+				       symname, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
