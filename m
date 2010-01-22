Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AVVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AVVnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499Ab0AVVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:43:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:14783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab0AVVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:43:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,324,1262592000"; 
   d="scan'208";a="533763082"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH] net: NETDEV WATCHDOG should print something every time
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com
Date: Fri, 22 Jan 2010 13:43:33 -0800
Message-ID: <20100122214333.14389.86017.stgit@jbrandeb-ich9b.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5337407c changed NETDEV WATCHDOG messages into a message
that will only print once per driver load.  This removed a significant amount
of information from an admin who might be missing that his system was having
NETDEV WATCHDOGs, esp since there is no other global counter available to
count these events.

simply check the __warned flag and print a simple version of the message
without the full stack dump if the (kerneloops related) WARN_ON_ONCE has
already logged the hardware type and one hang.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Arjan <arjan@linux.intel.com>
---

 include/asm-generic/bug.h |    5 +++++
 net/sched/sch_generic.c   |    9 +++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..ad810a0 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -132,6 +132,11 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARNED_ALREADY() ({					\
+	static bool __warned;					\
+	unlikely(__warned);					\
+})
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 5173c1e..28fb14f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -251,8 +251,13 @@ static void dev_watchdog(unsigned long arg)
 
 			if (some_queue_timedout) {
 				char drivername[64];
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev, drivername, 64), i);
+				/* FIXME: is there a way to const char string[] = "NETDEV WATCHDOG..." */
+				if (!WARNED_ALREADY())
+					WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
+						  dev->name, netdev_drivername(dev, drivername, 64), i);
+				else
+					printk(KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
+					       dev->name, netdev_drivername(dev, drivername, 64), i);
 				dev->netdev_ops->ndo_tx_timeout(dev);
 			}
 			if (!mod_timer(&dev->watchdog_timer,

