Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbZHUIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbZHUIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbZHUIHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:07:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbZHUIHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:07:34 -0400
Date: Fri, 21 Aug 2009 08:07:02 GMT
From: tip-bot for Kyle McMartin <kyle@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kyle@redhat.com, hpa@zytor.com,
       mingo@redhat.com, joerg.roedel@amd.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, kyle@redhat.com,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090820011708.GP25206@bombadil.infradead.org>
References: <20090820011708.GP25206@bombadil.infradead.org>
Subject: [tip:core/urgent] dma-debug: Fix check_unmap null pointer dereference
Message-ID: <tip-ec9c96ef3cc0124cb94375b17faaa8cff5dfdf97@git.kernel.org>
Git-Commit-ID: ec9c96ef3cc0124cb94375b17faaa8cff5dfdf97
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 08:07:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec9c96ef3cc0124cb94375b17faaa8cff5dfdf97
Gitweb:     http://git.kernel.org/tip/ec9c96ef3cc0124cb94375b17faaa8cff5dfdf97
Author:     Kyle McMartin <kyle@redhat.com>
AuthorDate: Wed, 19 Aug 2009 21:17:08 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 10:04:24 +0200

dma-debug: Fix check_unmap null pointer dereference

While it's debatable whether or not a NULL device argument to
the DMA API functions is valid... since it certainly isn't
valid on devices with an IOMMU... dma-debug really shouldn't be
dereferencing null pointers either.

Guard against that in err_printk and the driver_filter
functions. A Fedora rawhide user was seeing this in one of the
dvb drivers resulting in an oops on boot.

[ A patch has been sent for testing to the driver, but I feel
  the dma debugging support should be fixed as well. (There's
  still a pile of legacy garbage in the kernel passing null
  pointers to dma_{alloc,free}_*. :( ]

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: mchehab@infradead.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20090820011708.GP25206@bombadil.infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/dma-debug.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 65b0d99..58a9f9f 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -156,9 +156,13 @@ static bool driver_filter(struct device *dev)
 		return true;
 
 	/* driver filter on and initialized */
-	if (current_driver && dev->driver == current_driver)
+	if (current_driver && dev && dev->driver == current_driver)
 		return true;
 
+	/* driver filter on, but we can't filter on a NULL device... */
+	if (!dev)
+		return false;
+
 	if (current_driver || !current_driver_name[0])
 		return false;
 
@@ -183,17 +187,17 @@ static bool driver_filter(struct device *dev)
 	return ret;
 }
 
-#define err_printk(dev, entry, format, arg...) do {		\
-		error_count += 1;				\
-		if (driver_filter(dev) &&			\
-		    (show_all_errors || show_num_errors > 0)) {	\
-			WARN(1, "%s %s: " format,		\
-			     dev_driver_string(dev),		\
-			     dev_name(dev) , ## arg);		\
-			dump_entry_trace(entry);		\
-		}						\
-		if (!show_all_errors && show_num_errors > 0)	\
-			show_num_errors -= 1;			\
+#define err_printk(dev, entry, format, arg...) do {			\
+		error_count += 1;					\
+		if (driver_filter(dev) &&				\
+		    (show_all_errors || show_num_errors > 0)) {		\
+			WARN(1, "%s %s: " format,			\
+			     dev ? dev_driver_string(dev) : "NULL",	\
+			     dev ? dev_name(dev) : "NULL", ## arg);	\
+			dump_entry_trace(entry);			\
+		}							\
+		if (!show_all_errors && show_num_errors > 0)		\
+			show_num_errors -= 1;				\
 	} while (0);
 
 /*
