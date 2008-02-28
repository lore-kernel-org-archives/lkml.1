Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYB1Eys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYB1Eys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYB1Eyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:54:39 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:42638 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYB1Eyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:54:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADjNxUdMQWRV/2dsb2JhbACBVq0JgXo
Date: Wed, 27 Feb 2008 23:54:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Linux Kernel Markers - if check format
Message-ID: <20080228045433.GA32364@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:53:07 up 17 days, 53 min,  3 users,  load average: 1.61, 1.14,
	0.95
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap __mark_check_format() into an if(0) to make sure that parameters such as

trace_mark(mm_page_alloc, "order %u pfn %lu", order, page?page_to_pfn(page):0);

(where page_to_pfn() has side-effects) won't generate code because of the
__mark_check_format().

Thanks to Jan Kiszka for reporting this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 include/linux/marker.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-02-27 11:08:50.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2008-02-27 11:11:27.000000000 -0500
@@ -104,10 +104,16 @@ static inline void marker_update_probe_r
 #define MARK_NOARGS " "
 
 /* To be used for string format validity checking with gcc */
-static inline void __printf(1, 2) __mark_check_format(const char *fmt, ...)
+static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
 {
 }
 
+#define __mark_check_format(format, args...)				\
+	do {								\
+		if (0)							\
+			___mark_check_format(format, ## args);		\
+	} while (0)
+
 extern marker_probe_func __mark_empty_function;
 
 extern void marker_probe_cb(const struct marker *mdata,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
