Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZHYSHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZHYSHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZHYSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:07:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbZHYSHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:07:19 -0400
Date: Tue, 25 Aug 2009 20:07:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fix
Message-ID: <20090825180713.GA477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Kyle McMartin (1):
      dma-debug: Fix check_unmap null pointer dereference


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
