Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbYHAJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbYHAJlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYHAJiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:50 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYHAJit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VHyUu7+IdTrckVZbBNPQzSKXjDQQhA6T6FsbFpo2fjusffcfrOJn19UX++CQdPM7Dx
         M3ZWqdRAV2o2p9F/uqF8biXkb/2WLfPr+YTWKD6vZEbnchTrEipnE4AZ1Fia/bM6EAHW
         M2YbYVysUqXEHpmBpZmmvh1Hl3AoImxVzantw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 13/16] add per_cpu_dyn_array for arch percpu support
Date: Fri,  1 Aug 2008 02:37:41 -0700
Message-Id: <1217583464-28494-14-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 init/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -394,17 +394,19 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 static void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i;
+	unsigned long size, i, old_size;
 	char *ptr;
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	old_size = PERCPU_ENOUGH_ROOM;
+	size = ALIGN(old_size + per_cpu_dyn_array_size(), PAGE_SIZE);
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		per_cpu_alloc_dyn_array(cpu, ptr + old_size);
 		ptr += size;
 	}
 }
