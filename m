Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbXEPWt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbXEPWt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbXEPWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50144 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758461AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355695.94408@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224818.544351896@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 3/9] readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
Content-Disposition: inline; filename=readahead-minmax_ra_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Define two convenient macros for read-ahead:
	- MAX_RA_PAGES: rounded down counterpart of VM_MAX_READAHEAD
	- MIN_RA_PAGES: rounded _up_ counterpart of VM_MIN_READAHEAD

Note that the rounded up MIN_RA_PAGES will work flawlessly with _large_
page sizes like 64k.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 mm/readahead.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc1-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc1-mm1/mm/readahead.c
@@ -21,8 +21,16 @@ void default_unplug_io_fn(struct backing
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
+/*
+ * Convienent macros for min/max read-ahead pages.
+ * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
+ * The latter is necessary for systems with large page size(i.e. 64k).
+ */
+#define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
+#define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
+
 struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE,
+	.ra_pages	= MAX_RA_PAGES,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,
@@ -51,7 +59,7 @@ static inline unsigned long get_max_read
 
 static inline unsigned long get_min_readahead(struct file_ra_state *ra)
 {
-	return (VM_MIN_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	return MIN_RA_PAGES;
 }
 
 static inline void reset_ahead_window(struct file_ra_state *ra)

--
