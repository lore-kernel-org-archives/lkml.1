Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYAaElR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYAaElR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYAaElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:41:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:4058 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYAaElD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KGKmhsKx8cY1MtYfxrS8ObG7+Rtpq9hdtgAvGwmHxqEzCwyeqXonCFeggEo2ektQcg/6JknJ4/fWcOPyxZarH4wL8BThzPpE7UYDSoXpdgL8ITpTG53wxtYlepdLCIh0ufefROLRbXHQhe1QdiPHDxB5+dDa5tp6nNrV9K/zW1s=
Subject: [PATCHv2] slub: fix shadowed variable sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801302027450.25812@schroedinger.engr.sgi.com>
References: <1201753405.23523.8.camel@brick>
	 <Pine.LNX.4.64.0801302027450.25812@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 20:40:58 -0800
Message-Id: <1201754458.23523.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce 'len' at outer level:
mm/slub.c:3406:26: warning: symbol 'n' shadows an earlier one
mm/slub.c:3393:6: originally declared here

No need to declare new node:
mm/slub.c:3501:7: warning: symbol 'node' shadows an earlier one
mm/slub.c:3491:6: originally declared here

No need to declare new x:
mm/slub.c:3513:9: warning: symbol 'x' shadows an earlier one
mm/slub.c:3492:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/slub.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5cc4b7d..93f5c28 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3390,7 +3390,7 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
 static int list_locations(struct kmem_cache *s, char *buf,
 					enum track_item alloc)
 {
-	int n = 0;
+	int len = 0;
 	unsigned long i;
 	struct loc_track t = { 0, 0, NULL };
 	int node;
@@ -3421,54 +3421,54 @@ static int list_locations(struct kmem_cache *s, char *buf,
 	for (i = 0; i < t.count; i++) {
 		struct location *l = &t.loc[i];
 
-		if (n > PAGE_SIZE - 100)
+		if (len > PAGE_SIZE - 100)
 			break;
-		n += sprintf(buf + n, "%7ld ", l->count);
+		len += sprintf(buf + len, "%7ld ", l->count);
 
 		if (l->addr)
-			n += sprint_symbol(buf + n, (unsigned long)l->addr);
+			len += sprint_symbol(buf + len, (unsigned long)l->addr);
 		else
-			n += sprintf(buf + n, "<not-available>");
+			len += sprintf(buf + len, "<not-available>");
 
 		if (l->sum_time != l->min_time) {
 			unsigned long remainder;
 
-			n += sprintf(buf + n, " age=%ld/%ld/%ld",
+			len += sprintf(buf + len, " age=%ld/%ld/%ld",
 			l->min_time,
 			div_long_long_rem(l->sum_time, l->count, &remainder),
 			l->max_time);
 		} else
-			n += sprintf(buf + n, " age=%ld",
+			len += sprintf(buf + len, " age=%ld",
 				l->min_time);
 
 		if (l->min_pid != l->max_pid)
-			n += sprintf(buf + n, " pid=%ld-%ld",
+			len += sprintf(buf + len, " pid=%ld-%ld",
 				l->min_pid, l->max_pid);
 		else
-			n += sprintf(buf + n, " pid=%ld",
+			len += sprintf(buf + len, " pid=%ld",
 				l->min_pid);
 
 		if (num_online_cpus() > 1 && !cpus_empty(l->cpus) &&
-				n < PAGE_SIZE - 60) {
-			n += sprintf(buf + n, " cpus=");
-			n += cpulist_scnprintf(buf + n, PAGE_SIZE - n - 50,
+				len < PAGE_SIZE - 60) {
+			len += sprintf(buf + len, " cpus=");
+			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
 					l->cpus);
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
-				n < PAGE_SIZE - 60) {
-			n += sprintf(buf + n, " nodes=");
-			n += nodelist_scnprintf(buf + n, PAGE_SIZE - n - 50,
+				len < PAGE_SIZE - 60) {
+			len += sprintf(buf + len, " nodes=");
+			len += nodelist_scnprintf(buf + len, PAGE_SIZE - len - 50,
 					l->nodes);
 		}
 
-		n += sprintf(buf + n, "\n");
+		len += sprintf(buf + len, "\n");
 	}
 
 	free_loc_track(&t);
 	if (!t.count)
-		n += sprintf(buf, "No data\n");
-	return n;
+		len += sprintf(buf, "No data\n");
+	return len;
 }
 
 enum slab_stat_type {
@@ -3498,7 +3498,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
 
 	for_each_possible_cpu(cpu) {
 		struct page *page;
-		int node;
 		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
 		if (!c)
@@ -3510,8 +3509,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
 			continue;
 		if (page) {
 			if (flags & SO_CPU) {
-				int x = 0;
-
 				if (flags & SO_OBJECTS)
 					x = page->inuse;
 				else
-- 
1.5.4.rc4.1142.gf5a97



