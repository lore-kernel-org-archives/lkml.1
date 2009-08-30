Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZH3Cay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZH3Cay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZH3Cas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:30:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:46479 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbZH3Cap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:30:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182006353"
Subject: [PATCH v3 09/14] async_tx: kill needless module_{init|exit}
To: neilb@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 29 Aug 2009 19:30:47 -0700
Message-ID: <20090830023047.5934.62490.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If module_init and module_exit are nops then neither need to be defined.

[ Impact: pure cleanup ]

Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_memcpy.c |   13 -------------
 crypto/async_tx/async_memset.c |   13 -------------
 crypto/async_tx/async_tx.c     |   17 +++--------------
 3 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 89e0555..98e15bd 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -90,19 +90,6 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 }
 EXPORT_SYMBOL_GPL(async_memcpy);
 
-static int __init async_memcpy_init(void)
-{
-	return 0;
-}
-
-static void __exit async_memcpy_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_memcpy_init);
-module_exit(async_memcpy_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous memcpy api");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index c144372..b896a6e 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -80,19 +80,6 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 }
 EXPORT_SYMBOL_GPL(async_memset);
 
-static int __init async_memset_init(void)
-{
-	return 0;
-}
-
-static void __exit async_memset_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_memset_init);
-module_exit(async_memset_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous memset api");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 802a5ce..6e37ad3 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -42,6 +42,9 @@ static void __exit async_tx_exit(void)
 	async_dmaengine_put();
 }
 
+module_init(async_tx_init);
+module_exit(async_tx_exit);
+
 /**
  * __async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
@@ -61,17 +64,6 @@ __async_tx_find_channel(struct async_submit_ctl *submit,
 	return async_dma_find_channel(tx_type);
 }
 EXPORT_SYMBOL_GPL(__async_tx_find_channel);
-#else
-static int __init async_tx_init(void)
-{
-	printk(KERN_INFO "async_tx: api initialized (sync-only)\n");
-	return 0;
-}
-
-static void __exit async_tx_exit(void)
-{
-	do { } while (0);
-}
 #endif
 
 
@@ -298,9 +290,6 @@ void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
 }
 EXPORT_SYMBOL_GPL(async_tx_quiesce);
 
-module_init(async_tx_init);
-module_exit(async_tx_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Asynchronous Bulk Memory Transactions API");
 MODULE_LICENSE("GPL");

