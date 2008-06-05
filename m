Return-Path: <linux-kernel-owner+w=401wt.eu-S1762985AbYFEBaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762985AbYFEBaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFEBaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:30:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54470 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYFEBaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:30:25 -0400
Date: Thu, 05 Jun 2008 10:29:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 2/5] introduce get_vm_event().
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080605021504.502113040@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com> <20080605021504.502113040@jp.fujitsu.com>
Message-Id: <20080605102647.9C26.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> introduce get_vm_event() new function for easy use vm statics.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sorry, this patch already get Rik-san's ACK.
I'll append it and resend by this mail.

------------------------------------
introduce get_vm_event() new function for easy use vm statics.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>

---
 include/linux/vmstat.h |    7 ++++++-
 mm/vmstat.c            |   16 ++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

Index: b/include/linux/vmstat.h
===================================================================
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -98,6 +98,8 @@ static inline void vm_events_fold_cpu(in
 }
 #endif
 
+unsigned long get_vm_event(enum vm_event_item event_type);
+
 #else
 
 /* Disable counters */
@@ -119,7 +121,10 @@ static inline void all_vm_events(unsigne
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
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -49,6 +49,22 @@ void all_vm_events(unsigned long *ret)
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
 
+unsigned long get_vm_event(enum vm_event_item event_type)
+{
+	int cpu;
+	unsigned long ret = 0;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
+
+		ret += this->event[event_type];
+	}
+	put_online_cpus();
+
+	return ret;
+}
+
 #ifdef CONFIG_HOTPLUG
 /*
  * Fold the foreign cpu events into our own.


