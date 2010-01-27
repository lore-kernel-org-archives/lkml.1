Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0A0NR7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 27 Jan 2010 08:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648Ab0A0NRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:17:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:60562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0A0NRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:17:48 -0500
Date: Wed, 27 Jan 2010 13:17:31 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20100122154140.GB4975@sgi.com>
References: <20100122154140.GB4975@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix RTC latency bug by reading replicated cachelines
Message-ID: <tip-aca3bb5910119d4cf6c28568a642582efb4cc14a@git.kernel.org>
Git-Commit-ID: aca3bb5910119d4cf6c28568a642582efb4cc14a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:17:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aca3bb5910119d4cf6c28568a642582efb4cc14a
Gitweb:     http://git.kernel.org/tip/aca3bb5910119d4cf6c28568a642582efb4cc14a
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Fri, 22 Jan 2010 09:41:40 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 11:33:53 +0100

x86, UV: Fix RTC latency bug by reading replicated cachelines

For SGI UV node controllers (HUB) rev 2.0 or greater, use
replicated cachelines to read the RTC timer.  This optimization
allows faster simulataneous reads from a given socket.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100122154140.GB4975@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_time.c |   13 ++++++++++++-
 drivers/char/uv_mmtimer.c |   18 +++++++++++-------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 3c84aa0..2b75ef6 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -282,10 +282,21 @@ static int uv_rtc_unset_timer(int cpu, int force)
 
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
diff --git a/drivers/char/uv_mmtimer.c b/drivers/char/uv_mmtimer.c
index 867b67b..c7072ba 100644
--- a/drivers/char/uv_mmtimer.c
+++ b/drivers/char/uv_mmtimer.c
@@ -89,13 +89,17 @@ static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
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
+		if (uv_get_min_hub_revision_id() == 1)
+			ret = 0;
 		else
-			ret = -ENOSYS;
+			ret = ((uv_blade_processor_id() * L1_CACHE_BYTES) %
+					PAGE_SIZE) / 8;
 		break;
 
 	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
@@ -115,8 +119,8 @@ static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
 		ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
 		break;
 
-	case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
-		ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
+	case MMTIMER_MMAPAVAIL:
+		ret = 1;
 		break;
 
 	case MMTIMER_GETCOUNTER:
