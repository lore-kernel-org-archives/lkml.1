Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbZEGJ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbZEGJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761696AbZEGJYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:24:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:45039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761762AbZEGJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:24:51 -0400
Date: Thu, 7 May 2009 09:24:10 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144602.191165000@intel.com>
References: <20090403144602.191165000@intel.com>
Subject: [tip:tracing/core] x86, ds: use single debug store cpu configuration
Message-ID: <tip-ee811517a5604aa63fae803b7c044712699e1303@git.kernel.org>
Git-Commit-ID: ee811517a5604aa63fae803b7c044712699e1303
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee811517a5604aa63fae803b7c044712699e1303
Gitweb:     http://git.kernel.org/tip/ee811517a5604aa63fae803b7c044712699e1303
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:29 +0200

x86, ds: use single debug store cpu configuration

Use a single configuration for all cpus.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144602.191165000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 71cab3b..443f415 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -47,9 +47,8 @@ struct ds_configuration {
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
-static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+static struct ds_configuration ds_cfg __read_mostly;
 
-#define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
 /* Maximal size of a DS configuration: */
 #define MAX_SIZEOF_DS		(12 * 8)
@@ -1268,6 +1267,10 @@ ds_configure(const struct ds_configuration *cfg,
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Only configure the first cpu. Others are identical. */
+	if (ds_cfg.name)
+		return;
+
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
