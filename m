Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407Ab0ANSec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0ANSec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713Ab0ANSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:34:31 -0500
Received: from relay2.sgi.com ([192.48.179.30]:46937 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519Ab0ANSea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:34:30 -0500
Date: Thu, 14 Jan 2010 12:34:22 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Read RTC using replicated cachelines
Message-ID: <20100114183422.GA12152@sgi.com>
References: <20100112210904.GA24546@sgi.com> <20100113092433.GB6739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113092433.GB6739@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For SGI UV node controllers (HUB) rev 2.0 or greater, use replicated
cachelines to read the RTC timer.  This optimization allows faster
simulataneous reads from a given socket.

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
 
