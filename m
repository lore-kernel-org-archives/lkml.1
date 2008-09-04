Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYIDTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYIDTFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYIDTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:05:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYIDTFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:05:16 -0400
Date: Thu, 4 Sep 2008 21:04:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
	fix v7
Message-ID: <20080904190457.GB24990@elte.hu>
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> v3: use reserve_region_with_split() instead to hand overlapping
> 	with test case by extend 0xe0000000 - 0xeffffff to 0xdd800000 -
> 	get
> 		e0000000-efffffff : PCI MMCONFIG 0
> 			 e0000000-efffffff : reserved
> 	in /proc/iomem
> 	get
> 		found conflict for reserved [dd800000, efffffff], try to reserve with split
> 		    __reserve_region_with_split: (PCI Bus #80) [dd000000, ddffffff], res: (reserved) [dd800000, efffffff]
> 		    __reserve_region_with_split: (PCI Bus #00) [de000000, dfffffff], res: (reserved) [de000000, efffffff]
> 		initcall pci_subsys_init+0x0/0x121 returned 0 after 381 msecs
> 	in dmesg
> 
> v4: take out __insert_resource and insert_resource_expand_to_fit : Linus already check in.
>     use reserve_region_with_split at the first point
>     use const char *name
> 
> v5: fix checking on overlapping
> 
> v6: only reserve common area in conflict
> 	so got sth in /proc/iomem
> 		d8000000-dfffffff : PCI Bus #00
> 		  dc000000-dfffffff : GART
> 		    dc000000-dfffffff : reserved
> 		e0000000-efffffff : PCI MMCONFIG 0
> 		  e0000000-efffffff : reserved
> 	when we have big range in e820
> 		00000000dc000000-00000000f0000000 (reserved)
> 
> v7: remove wrong removing of write_unlock(&resource_lock) in adjust_resource()

i've applied the generic commit below to tip/core/resources, and merged 
tip/core/resources into tip/x86/core, and added the remaining e820.c 
oneliner change (attached below as well).

thanks Yinghai!

	Ingo

-------------------->
>From 268364a0f48aee2f851f9d1ef8a6cda0f3039ef1 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 4 Sep 2008 21:02:44 +0200
Subject: [PATCH] IO resources: add reserve_region_with_split()

add reserve_region_with_split() to not lose e820 reserved entries if
they overlap with existing IO regions:

with test case by extend 0xe0000000 - 0xeffffff to 0xdd800000 -
we get:
	e0000000-efffffff : PCI MMCONFIG 0
		 e0000000-efffffff : reserved

and in /proc/iomem we get:
	found conflict for reserved [dd800000, efffffff], try to reserve with split
	    __reserve_region_with_split: (PCI Bus #80) [dd000000, ddffffff], res: (reserved) [dd800000, efffffff]
	    __reserve_region_with_split: (PCI Bus #00) [de000000, dfffffff], res: (reserved) [de000000, efffffff]
	initcall pci_subsys_init+0x0/0x121 returned 0 after 381 msecs
in dmesg

various fixes and improvements suggested by Linus.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ioport.h |    3 ++
 kernel/resource.c      |   68 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 8d3b7a9..fded376 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -108,6 +108,9 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void reserve_region_with_split(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     const char *name);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
diff --git a/kernel/resource.c b/kernel/resource.c
index 03d796c..414d6fc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -516,6 +516,74 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 	return result;
 }
 
+static void __init __reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	struct resource *parent = root;
+	struct resource *conflict;
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (!res)
+		return;
+
+	res->name = name;
+	res->start = start;
+	res->end = end;
+	res->flags = IORESOURCE_BUSY;
+
+	for (;;) {
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
+		}
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
+	}
+
+	if (!res) {
+		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+			 conflict->name, conflict->start, conflict->end,
+			 name, start, end);
+
+		/* failed, split and try again */
+
+		/* conflict coverred whole area */
+		if (conflict->start <= start && conflict->end >= end)
+			return;
+
+		if (conflict->start > start)
+			__reserve_region_with_split(root, start, conflict->start-1, name);
+		if (!(conflict->flags & IORESOURCE_BUSY)) {
+			resource_size_t common_start, common_end;
+
+			common_start = max(conflict->start, start);
+			common_end = min(conflict->end, end);
+			if (common_start < common_end)
+				__reserve_region_with_split(root, common_start, common_end, name);
+		}
+		if (conflict->end < end)
+			__reserve_region_with_split(root, conflict->end+1, end, name);
+	}
+
+}
+
+void reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name);
+	write_unlock(&resource_lock);
+}
+
 EXPORT_SYMBOL(adjust_resource);
 
 /**

>From fac8f1e4f99dff7a0c3a929f327d66f46de6fa21 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 4 Sep 2008 20:59:22 +0200
Subject: [PATCH] x86: split e820 reserved entries record to late, v7

try to insert_resource second time, by expanding the resource...

for case: e820 reserved entry is partially overlapped with bar res...

hope it will never happen

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/e820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a7a7133..e24d1bc 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1320,7 +1320,7 @@ void __init e820_reserve_resources_late(void)
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
 		if (!res->parent && res->end)
-			insert_resource(&iomem_resource, res);
+			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
 		res++;
 	}
 }

>From ebd60cd64f8ab1170102c3ab072eb73042b7a33d Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 4 Sep 2008 21:04:32 +0200
Subject: [PATCH] x86: unify using pci_mmcfg_insert_resource

even with known_bridge insert them late too.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/mmconfig-shared.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index d963576..654a223 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -209,7 +209,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -233,7 +233,7 @@ static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | resource_flags;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
@@ -434,11 +434,9 @@ static void __init __pci_mmcfg_init(int early)
 	    (pci_mmcfg_config[0].address == 0))
 		return;
 
-	if (pci_mmcfg_arch_init()) {
-		if (known_bridge)
-			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+	if (pci_mmcfg_arch_init())
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else {
+	else {
 		/*
 		 * Signal not to attempt to insert mmcfg resources because
 		 * the architecture mmcfg setup could not initialize.
@@ -475,7 +473,7 @@ static int __init pci_mmcfg_late_insert_resources(void)
 	 * marked so it won't cause request errors when __request_region is
 	 * called.
 	 */
-	pci_mmcfg_insert_resources(0);
+	pci_mmcfg_insert_resources();
 
 	return 0;
 }
