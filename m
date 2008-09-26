Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYIZINF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYIZINF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYIZIMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:12:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbYIZIMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:12:47 -0400
Date: Fri, 26 Sep 2008 10:12:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch] ioremap sanity check to catch mapping requests
	exceeding the BAR sizes
Message-ID: <20080926081226.GA8556@elte.hu>
References: <20080926014334.GF15609@linux-os.sc.intel.com> <20080926073902.GA30041@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926073902.GA30041@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > +		printk(KERN_WARNING "resource map sanity check conflict "
> > +		       " 0x%llx 0x%llx 0x%llx 0x%llx %s\n",
> > +		       addr, addr + size - 1, p->start, p->end, p->name);

needed two build fixes (and the printk type checking annoyances keep 
littering the tree):

>From 13eb83754b40bf01dc84e52a08d4196d1b719a0e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 26 Sep 2008 10:10:12 +0200
Subject: [PATCH] IO resources, x86: ioremap sanity check to catch mapping requests exceeding, fix

fix this build error:

 kernel/resource.c: In function 'iomem_map_sanity_check':
 kernel/resource.c:842: error: implicit declaration of function 'r_next'
 kernel/resource.c:842: warning: assignment makes pointer from integer without a cast

r_next() was only available if CONFIG_PROCFS was enabled.

and fix this build warning:

 kernel/resource.c:855: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
 kernel/resource.c:855: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
 kernel/resource.c:855: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
 kernel/resource.c:855: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'

resource_t can be 32 bits.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/resource.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 1d003a5..7797dae 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -38,10 +38,6 @@ EXPORT_SYMBOL(iomem_resource);
 
 static DEFINE_RWLOCK(resource_lock);
 
-#ifdef CONFIG_PROC_FS
-
-enum { MAX_IORES_LEVEL = 5 };
-
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -53,6 +49,10 @@ static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 	return p->sibling;
 }
 
+#ifdef CONFIG_PROC_FS
+
+enum { MAX_IORES_LEVEL = 5 };
+
 static void *r_start(struct seq_file *m, loff_t *pos)
 	__acquires(resource_lock)
 {
@@ -852,7 +852,11 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 			continue;
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
-		       addr, addr + size - 1, p->start, p->end, p->name);
+		       (unsigned long long)addr,
+		       (unsigned long long)(addr + size - 1),
+		       (unsigned long long)p->start,
+		       (unsigned long long)p->end,
+		       p->name);
 		err = -1;
 		break;
 	}
