Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140Ab0AVPBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0AVPBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370Ab0AVPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:00:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39181 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0AVPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:00:56 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Dave Jones <davej@redhat.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH 2/5] intel-agp: Switch to wbinvd_on_all_cpus
Date: Fri, 22 Jan 2010 16:01:04 +0100
Message-Id: <1264172467-25155-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264172467-25155-1-git-send-email-bp@amd64.org>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Simplify if-statement while at it.

Cc: Dave Jones <davej@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/char/agp/intel-agp.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 30c36ac..28660b4 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -815,12 +815,6 @@ static void intel_i830_setup_flush(void)
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
@@ -837,12 +831,10 @@ static void intel_i830_chipset_flush(struct agp_bridge_data *bridge)
 
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
-- 
1.6.6

