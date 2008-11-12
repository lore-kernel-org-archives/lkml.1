Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYKLPTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYKLPTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYKLPTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:19:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYKLPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:19:15 -0500
Date: Wed, 12 Nov 2008 16:28:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] [4/4] SCHED: Use a lookup array in sd_level_to_string
Message-ID: <20081112152828.GM3810@one.firstfloor.org>
References: <20081112145.328971960@firstfloor.org> <20081112124512.6EEF63E6610@basil.firstfloor.org> <20081112144709.GB2672@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112144709.GB2672@cmpxchg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 03:47:09PM +0100, Johannes Weiner wrote:
> > +#define T(x) [SD_LV_ ## x ] = #T
> 
> Shouldn't                         ^ that be x?

Yes good point. Thanks. Revised patch appended.

-Andi

---

SCHED: Use a lookup array in sd_level_to_string v2

Generates better/shorter code. Doesn't matter much because it's only
a SCHED_DEBUG function. 

v2: Fix stupid typo thanks to Johannes Weiner

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

Index: linux-2.6.28-rc4-test/kernel/sched.c
===================================================================
--- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-12 16:35:02.000000000 +0100
+++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 16:35:48.000000000 +0100
@@ -6629,24 +6629,17 @@
 
 static inline const char *sd_level_to_string(enum sched_domain_level lvl)
 {
-	switch (lvl) {
-	case SD_LV_NONE:
-			return "NONE";
-	case SD_LV_SIBLING:
-			return "SIBLING";
-	case SD_LV_MC:
-			return "MC";
-	case SD_LV_CPU:
-			return "CPU";
-	case SD_LV_NODE:
-			return "NODE";
-	case SD_LV_ALLNODES:
-			return "ALLNODES";
-	case SD_LV_MAX:
-			return "MAX";
-
-	}
-	return "MAX";
+	static const char *lva[] = {
+#define T(x) [SD_LV_ ## x ] = #x
+		T(NONE),
+		T(SIBLING),
+		T(MC),
+		T(CPU),
+		T(NODE),
+		T(ALLNODES),
+#undef T
+	};
+	return (unsigned)lvl < ARRAY_SIZE(lva) ? lva[lvl] : "MAX";
 }
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
