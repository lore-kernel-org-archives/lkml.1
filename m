Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbYBTRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbYBTRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYBTRgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:36:25 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:22389 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYBTRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HYqa5tz2oyZBSosK9quXcFQo4mejY0HDNlFkmgMD2HY6Qx3IYHV7t4nd/rj6dE1NhQAZQvCm1BmpWVSDpX9DGt923769Vkq1mt3NcBDH23b3ELmtR7lzpsSd6e01fjIe2oJQaf49OpzqZHdBLlN7DnuHQTHb1wj8NjcqD/0Mz4I=
Subject: [PATCH] ata: use clamp_t macro to avoid sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47BC6073.8080705@garzik.org>
References: <1203350873.5757.23.camel@brick>  <47BC6073.8080705@garzik.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 09:36:36 -0800
Message-Id: <1203528996.25307.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nesting min_t/max_t macros produces many shadowed variable warnings
due to use of __x.  Add a clamp_t macro to linux/kernel.h and use
it in the FIT macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kernel.h |    9 +++++++++
 include/linux/libata.h |    2 +-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..47924ce 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -362,6 +362,15 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
 
+/*
+ * Clamp a value to within a given range using comparisons of a specified type.
+ */
+#define clamp_t(type,val,min,max) ({ \
+	type __val = (val);	\
+	type __min = (min);	\
+	type __max = (max);	\
+	__val = __val < __min ? __min: __val; \
+	__val > __max ? __max: __val; })
 
 /**
  * container_of - cast a member of a structure out to the containing structure
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2e098f9..8adc2a0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -754,7 +754,7 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
+#define FIT(v, vmin, vmax)	clamp_t(short, v, vmin, vmax)
 
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
-- 
1.5.4.2.200.g99e75



