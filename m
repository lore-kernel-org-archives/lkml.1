Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYEDM5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYEDM5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYEDM5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:57:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37658 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYEDM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:57:40 -0400
Date: Sun, 04 May 2008 21:57:14 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [-mm][PATCH 2/5] introduce get_vm_event()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080504215602.8F58.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce get_vm_event() new function for easy use vm statics.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/vmstat.h |    7 ++++++-
 mm/vmstat.c            |   14 ++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

Index: b/include/linux/vmstat.h
===================================================================
--- a/include/linux/vmstat.h	2008-05-02 23:40:39.000000000 +0900
+++ b/include/linux/vmstat.h	2008-05-03 00:23:17.000000000 +0900
@@ -92,6 +92,8 @@ static inline void vm_events_fold_cpu(in
 }
 #endif
 
+unsigned long get_vm_event(enum vm_event_item event_type);
+
 #else
 
 /* Disable counters */
@@ -113,7 +115,10 @@ static inline void all_vm_events(unsigne
 static inline void vm_events_fold_cpu(int cpu)
 {
 }
-
+static inline unsigned long get_vm_event(enum vm_event_item event_type)
+{
+	return 0;
+}
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 
 #define __count_zone_vm_events(item, zone, delta) \
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c	2008-05-02 23:40:39.000000000 +0900
+++ b/mm/vmstat.c	2008-05-02 23:43:28.000000000 +0900
@@ -46,6 +46,20 @@ void all_vm_events(unsigned long *ret)
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
 
+unsigned long get_vm_event(enum vm_event_item event_type)
+{
+	int cpu;
+	unsigned long ret = 0;
+
+	for_each_cpu_mask(cpu, cpu_online_map) {
+		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
+
+		ret += this->event[event_type];
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_HOTPLUG
 /*
  * Fold the foreign cpu events into our own.


