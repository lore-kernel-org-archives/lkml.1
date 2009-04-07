Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZDGJEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZDGJEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZDGJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:03:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZDGJDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:03:52 -0400
Date: Tue, 7 Apr 2009 11:02:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
Message-ID: <20090407090229.GA2467@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org> <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407084950.GA1467@elte.hu>
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

> there's another new build failure as well:
> 
> drivers/pci/intr_remapping.c:680:28: error: macro "if" passed 2 arguments, but takes just 1
> drivers/pci/intr_remapping.c:694:28: error: macro "if" passed 2 arguments, but takes just 1
> drivers/pci/intr_remapping.c:701:28: error: macro "if" passed 2 arguments, but takes just 1

fixed below.

	Ingo

--------------->
>From f7f79511ff41d3e9b363df55fa3d5d5dd8bfe790 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 7 Apr 2009 11:01:59 +0200
Subject: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y

for_each_active_iommu() and for_each_iommu() uses some tricky
C that is weird and borderline valid but does not allow the
macro evaluation trick used by the branch tracer/profiler:

   drivers/pci/intr_remapping.c:680:28: error: macro "if" passed 2 arguments, but takes just 1

Switch it to a braced group statement.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/dmar.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index e397dc3..166670f 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -47,11 +47,11 @@ extern struct list_head dmar_drhd_units;
 
 #define for_each_active_iommu(i, drhd)					\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, drhd->ignored) {} else
+		if (({i=drhd->iommu, drhd->ignored;})) {} else
 
 #define for_each_iommu(i, drhd)						\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, 0) {} else 
+		if (({ i=drhd->iommu, 0;})) {} else
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
