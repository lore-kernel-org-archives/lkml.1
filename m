Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbYFGOc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbYFGOc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbYFGOct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:32:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbYFGOcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=DY6vRUjq2my8vgSZu/Nfq1FiqJ/0rcbbyiAl6r1U1mn2+7cIS4gVj7SnvkG2xY9RRy
         k9sMLyd2ocXp8kZKSUx4f2S/X5j6ahKE6xROPotJZxVy3xllBxyyQ5Yzo0zXU84oYFjj
         W9lxd64UwiuV/exeAgTlu5t9NPdLq2kzhHT7c=
Date: Sat, 7 Jun 2008 16:32:42 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: don't track pages allocated with interrupts
	disabled
Message-ID: <20080607143242.GA2893@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that I was wrong regarding the set_memory_4k() approach. It seems
to only have worked because we were lucky. We may later reinstate the code
to disable PSE, but this time not unconditionally, perhaps with a config
option or boot-time option.

That a new page needs to be allocated with interrupts disabled is probably
rare enough that we can get away with this without losing too many pages
that could otherwise have been tracked.

Again, this is overall nicer than unconditionally disabling PSE, since
that incurs a much larger overhead in the case where kmemcheck is enabled
in the config but disabled by default. (Ingo, you previously indicated that
it would be nice if kernels could be configured in this way by default.)


Vegard


From: Vegard Nossum <vegardno@ben.ifi.uio.no>
Date: Sat, 7 Jun 2008 16:18:29 +0200
Subject: [PATCH] kmemcheck: don't track pages allocated with interrupts disabled

Because large physical pages need to be split to 4k-sized pages after
the slab page has been allocated, and this needs to flush the page
tables, we cannot track any pages that were allocated while interrupts
were disabled.

This fixes a boot crash that seems to depend on timing to appear.

Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
---
 mm/kmemcheck.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index 4efdf1e..b337374 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -10,6 +10,14 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	int pages;
 	int i;
 
+	/*
+	 * It's sad, but it's true. If interrupts are enabled while making
+	 * this allocation, it means that we can't split the large page
+	 * because it would require flushing the page tables.
+	 */
+	if (irqs_disabled())
+		return;
+
 	pages = 1 << order;
 
 	/*
-- 
1.5.3.1

