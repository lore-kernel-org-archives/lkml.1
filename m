Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbZIXMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbZIXMuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIXMuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:50:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZIXMuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:50:19 -0400
Message-ID: <4ABB6AF1.10305@kernel.org>
Date: Thu, 24 Sep 2009 21:49:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tony Vroon <tony@linx.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] percpu: make allocation failures more verbose
References: <4ABAC2F1.3020302@kernel.org>
In-Reply-To: <4ABAC2F1.3020302@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:49:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn and dump stack when percpu allocation fails.  percpu allocator is
still young and unchecked NULL percpu pointer usage can result in
random memory corruption when combined with the pointer shifting in
access macros.  Allocation failures should be rare and the warning
message will be disabled after certain times.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Another patch to make things more verbose when things don't go too
well.

Thanks.

 mm/percpu.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1043,7 +1043,9 @@ static struct pcpu_chunk *alloc_pcpu_chu
  */
 static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 {
+	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
+	const char *err;
 	int slot, off;

 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
@@ -1059,11 +1061,14 @@ static void *pcpu_alloc(size_t size, siz
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 		if (size > chunk->contig_hint ||
-		    pcpu_extend_area_map(chunk) < 0)
+		    pcpu_extend_area_map(chunk) < 0) {
+			err = "failed to extend area map of reserved chunk";
 			goto fail_unlock;
+		}
 		off = pcpu_alloc_area(chunk, size, align);
 		if (off >= 0)
 			goto area_found;
+		err = "alloc from reserved chunk failed";
 		goto fail_unlock;
 	}

@@ -1080,6 +1085,7 @@ restart:
 			case 1:
 				goto restart;	/* pcpu_lock dropped, restart */
 			default:
+				err = "failed to extend area map";
 				goto fail_unlock;
 			}

@@ -1093,8 +1099,10 @@ restart:
 	spin_unlock_irq(&pcpu_lock);

 	chunk = alloc_pcpu_chunk();
-	if (!chunk)
+	if (!chunk) {
+		err = "failed to allocate new chunk";
 		goto fail_unlock_mutex;
+	}

 	spin_lock_irq(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
@@ -1107,6 +1115,7 @@ area_found:
 	if (pcpu_populate_chunk(chunk, off, size)) {
 		spin_lock_irq(&pcpu_lock);
 		pcpu_free_area(chunk, off);
+		err = "failed to populate";
 		goto fail_unlock;
 	}

@@ -1119,6 +1128,13 @@ fail_unlock:
 	spin_unlock_irq(&pcpu_lock);
 fail_unlock_mutex:
 	mutex_unlock(&pcpu_alloc_mutex);
+	if (warn_limit) {
+		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
+			   "%s\n", size, align, err);
+		dump_stack();
+		if (!--warn_limit)
+			pr_info("PERCPU: limit reached, disable warning\n");
+	}
 	return NULL;
 }

