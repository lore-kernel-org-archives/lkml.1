Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517Ab0AWAnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab0AWAnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454Ab0AWAnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:43:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:52395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab0AWAnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:43:16 -0500
Date: Sat, 23 Jan 2010 00:42:51 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       airlied@linux.ie, davej@redhat.com, tglx@linutronix.de,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, airlied@linux.ie,
       borislav.petkov@amd.com
In-Reply-To: <1264172467-25155-3-git-send-email-bp@amd64.org>
References: <1264172467-25155-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] intel-agp: Switch to wbinvd_on_all_cpus
Message-ID: <tip-48a719c238bcbb72d6da79de9c5b3b93ab472107@git.kernel.org>
Git-Commit-ID: 48a719c238bcbb72d6da79de9c5b3b93ab472107
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Jan 2010 00:42:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48a719c238bcbb72d6da79de9c5b3b93ab472107
Gitweb:     http://git.kernel.org/tip/48a719c238bcbb72d6da79de9c5b3b93ab472107
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 22 Jan 2010 16:01:04 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Jan 2010 16:06:30 -0800

intel-agp: Switch to wbinvd_on_all_cpus

Simplify if-statement while at it.

[ hpa: we need to #include <asm/smp.h> ]

Cc: Dave Jones <davej@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-3-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/char/agp/intel-agp.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3999a5f..8a713f1 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
+#include <asm/smp.h>
 #include "agp.h"
 
 /*
@@ -815,12 +816,6 @@ static void intel_i830_setup_flush(void)
 		intel_i830_fini_flush();
 }
 
-static void
-do_wbinvd(void *null)
-{
-	wbinvd();
-}
-
 /* The chipset_flush interface needs to get data that has already been
  * flushed out of the CPU all the way out to main memory, because the GPU
  * doesn't snoop those buffers.
@@ -837,12 +832,10 @@ static void intel_i830_chipset_flush(struct agp_bridge_data *bridge)
 
 	memset(pg, 0, 1024);
 
-	if (cpu_has_clflush) {
+	if (cpu_has_clflush)
 		clflush_cache_range(pg, 1024);
-	} else {
-		if (on_each_cpu(do_wbinvd, NULL, 1) != 0)
-			printk(KERN_ERR "Timed out waiting for cache flush.\n");
-	}
+	else if (wbinvd_on_all_cpus() != 0)
+		printk(KERN_ERR "Timed out waiting for cache flush.\n");
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.
