Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738Ab0ASOll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0ASOll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522Ab0ASOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:41:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751512Ab0ASOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:41:39 -0500
Date: Tue, 19 Jan 2010 08:41:37 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Subject: [PATCH] x86, UV: Fix RTC latency bug by reading replicated
	cachelines
Message-ID: <20100119144137.GB22276@sgi.com>
References: <20100112210904.GA24546@sgi.com> <20100113092433.GB6739@elte.hu> <20100114183422.GA12152@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114183422.GA12152@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an RTC read latency bug by using replicated cachelines to read the RTC
timer on SGI UV node controllers (HUB) rev 2.0 or greater.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Patch requires "Add function retrieving node controller revision number" patch.

 arch/x86/kernel/uv_time.c |   13 ++++++++++++-
 drivers/char/uv_mmtimer.c |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2010-01-14 11:52:44.000000000 -0600
+++ linux/arch/x86/kernel/uv_time.c	2010-01-14 11:56:57.000000000 -0600
@@ -282,10 +282,21 @@ static int uv_rtc_unset_timer(int cpu, i
 
 /*
  * Read the RTC.
+ *
+ * Starting with HUB rev 2.0, the UV RTC register is replicated across all
+ * cachelines of it's own page.  This allows faster simultaneous reads
+ * from a given socket.
  */
 static cycle_t uv_read_rtc(struct clocksource *cs)
 {
-	return (cycle_t)uv_read_local_mmr(UVH_RTC);
+	unsigned long offset;
+
+	if (uv_get_min_hub_revision_id() == 1)
+		offset = 0;
+	else
+		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
+
+	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
 }
 
 /*
Index: linux/drivers/char/uv_mmtimer.c
===================================================================
--- linux.orig/drivers/char/uv_mmtimer.c	2010-01-14 11:52:45.000000000 -0600
+++ linux/drivers/char/uv_mmtimer.c	2010-01-14 11:56:57.000000000 -0600
@@ -89,12 +89,19 @@ static long uv_mmtimer_ioctl(struct file
 	switch (cmd) {
 	case MMTIMER_GETOFFSET:	/* offset of the counter */
 		/*
-		 * UV RTC register is on its own page
+		 * Starting with HUB rev 2.0, the UV RTC register is
+		 * replicated across all cachelines of it's own page.
+		 * This allows faster simultaneous reads from a given socket.
+		 *
+		 * The offset returned is in 64 bit units.
 		 */
-		if (PAGE_SIZE <= (1 << 16))
-			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
-				/ 8;
-		else
+		if (PAGE_SIZE <= (1 << 16)) {
+			if (uv_get_min_hub_revision_id() == 1)
+				ret = 0;
+			else
+				ret = ((uv_blade_processor_id() *
+					L1_CACHE_BYTES) % PAGE_SIZE) / 8;
+		} else
 			ret = -ENOSYS;
 		break;
 
