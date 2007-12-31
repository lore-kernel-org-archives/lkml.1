Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbXLaULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbXLaULn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 15:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXLaULg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 15:11:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:16518 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXLaULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 15:11:35 -0500
Date: Mon, 31 Dec 2007 12:11:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>
Subject: Re: 2.6.24-rc6-mm1 (driver core/sysfs)
Message-Id: <20071231121115.b7ae39e4.randy.dunlap@oracle.com>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 23:30:56 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/


With CONFIG_BLOCK=n:

  LD      drivers/block/built-in.o
/local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c: In function 'device_add_class_symlinks':
/local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c:707: error: 'part_type' undeclared (first use in this function)
/local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c: In function 'device_remove_class_symlinks':
/local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c:746: error: 'part_type' undeclared (first use in this function)
make[3]: *** [drivers/base/core.o] Error 1


and that is after fixing (in some sense) the first CONFIG_BLOCK=n
problem with the patch below.  Please test lots of configs.
and/or use 'make randconfig' (automated, scripted, e.g., etc.).
maybe check Documentation/SubmitChecklist.  :)

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Parts of driver core use blk_lookup_devt() when CONFIG_BLOCK=n,
so provide an short inline version of it for that case.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/genhd.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.24-rc6-mm1.orig/include/linux/genhd.h
+++ linux-2.6.24-rc6-mm1/include/linux/genhd.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/kdev_t.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -443,6 +444,12 @@ static inline struct block_device *bdget
 
 static inline void printk_all_partitions(void) { }
 
+static inline dev_t blk_lookup_devt(const char *name)
+{
+	dev_t devt = MKDEV(0, 0);
+	return devt;
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
