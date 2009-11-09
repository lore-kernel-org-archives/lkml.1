Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbZKIFrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbZKIFrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZKIFri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:47:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:33803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZKIFri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:47:38 -0500
Message-ID: <4AF7ACCC.2050208@kernel.org>
Date: Mon, 09 Nov 2009 14:46:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH percpu#for-linus] percpu: fix possible deadlock via irq lock
 inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com>	 <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu>	 <4AF28D7A.6020209@kernel.org>	 <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>	 <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu>	 <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu>	 <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu>	 <4AF3E3D1.7010101@kernel.org>	 <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>	 <4AF45109.7070503@kernel.org>	 <alpine.DEB.1.10.0911061159450.5187@V090114053VZO-1> <1257610412.4108.3.camel@laptop>
In-Reply-To: <1257610412.4108.3.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep caught the following irq lock inversion which can lead to
deadlock.

 =========================================================
 [ INFO: possible irq lock inversion dependency detected ]
 2.6.32-rc5-tip-04815-g12f0f93-dirty #745
 ---------------------------------------------------------
 hub 1-3:1.0: state 7 ports 2 chg 0000 evt 0004
 ksoftirqd/65/199 just changed the state of lock:
  (pcpu_lock){..-...}, at: [<ffffffff81130e04>] free_percpu+0x38/0x104
 but this lock took another, SOFTIRQ-unsafe lock in the past:
  (vmap_area_lock){+.+...}

 and interrupts could create inverse lock ordering between them.

This happens because pcpu_lock is allowed to be acquired from irq
context for free_percpu() path and alloc_percpu() path may call
vfree() with pcpu_lock held.  As vmap_area_lock isn't irq safe, if an
IRQ occurs while vmap_area_lock is held and the irq handler calls
free_percpu(), locking order inversion occurs.

As the nesting only occurs in the alloc path which isn't allowed to be
called from irq context, A->B->A deadlock won't occur but A->B B->A
deadlock is still possible.

The only place where vmap_area_lock is nested under pcpu_lock is while
extending area_map to free old map.  Break the locking order by
temporarily releasing pcpu_lock when freeing old map.  This is safe to
do as allocation path is protected with outer pcpu_alloc_mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
If nobody objects, I'll push it to Linus tomorrow.  Thanks.

 mm/percpu.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

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

