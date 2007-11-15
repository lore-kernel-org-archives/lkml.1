Return-Path: <linux-kernel-owner+w=401wt.eu-S1765507AbXKOGZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765507AbXKOGZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763508AbXKOGVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763985AbXKOGVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:49 -0500
Date: Wed, 14 Nov 2007 22:20:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/23] Fix advertised packet scheduler timer resolution
Message-ID: <20071115062015.GE8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-advertised-packet-scheduler-timer-resolution.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

patch 3c0cfc135829b98f7a4894938652f9ef78e24237 in mainline

The fourth parameter of /proc/net/psched is supposed to show the timer
resultion and is used by HTB userspace to calculate the necessary
burst rate. Currently we show the clock resolution, which results in a
too low burst rate when the two differ.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_api.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1225,10 +1225,13 @@ EXPORT_SYMBOL(tcf_destroy_chain);
 #ifdef CONFIG_PROC_FS
 static int psched_show(struct seq_file *seq, void *v)
 {
+	struct timespec ts;
+
+	hrtimer_get_res(CLOCK_MONOTONIC, &ts);
 	seq_printf(seq, "%08x %08x %08x %08x\n",
 		   (u32)NSEC_PER_USEC, (u32)PSCHED_US2NS(1),
 		   1000000,
-		   (u32)NSEC_PER_SEC/(u32)ktime_to_ns(KTIME_MONOTONIC_RES));
+		   (u32)NSEC_PER_SEC/(u32)ktime_to_ns(timespec_to_ktime(ts)));
 
 	return 0;
 }

-- 
