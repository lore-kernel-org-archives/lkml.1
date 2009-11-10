Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbZKJGEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbZKJGEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZKJGEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:04:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:42738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZKJGEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:04:32 -0500
Message-ID: <4AF90254.40909@kernel.org>
Date: Tue, 10 Nov 2009 15:04:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] percpu fixes for 2.6.32-rc6
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu fix branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

It fixes a possible deadlock caused by lock ordering inversion through
irq.

Thanks.
---
Tejun Heo (1):
      percpu: fix possible deadlock via irq lock inversion

 mm/percpu.c |   17 +++++++++++++++--

diff --git a/mm/percpu.c b/mm/percpu.c
index d907971..30cd343 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -372,7 +372,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 static int pcpu_extend_area_map(struct pcpu_chunk *chunk, unsigned long *flags)
 {
 	int new_alloc;
-	int *new;
+	int *new, *old = NULL;
 	size_t size;

 	/* has enough? */
@@ -407,10 +407,23 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk, unsigned long *flags)
 	 * one of the first chunks and still using static map.
 	 */
 	if (chunk->map_alloc >= PCPU_DFL_MAP_ALLOC)
-		pcpu_mem_free(chunk->map, size);
+		old = chunk->map;

 	chunk->map_alloc = new_alloc;
 	chunk->map = new;
+
+	/*
+	 * pcpu_mem_free() might end up calling vfree() which uses
+	 * IRQ-unsafe lock and thus can't be called with pcpu_lock
+	 * held.  Release and reacquire pcpu_lock if old map needs to
+	 * be freed.
+	 */
+	if (old) {
+		spin_unlock_irqrestore(&pcpu_lock, *flags);
+		pcpu_mem_free(old, size);
+		spin_lock_irqsave(&pcpu_lock, *flags);
+	}
+
 	return 0;
 }

-- 
tejun
