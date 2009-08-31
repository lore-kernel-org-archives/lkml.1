Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZHaT2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZHaT2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZHaT2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:28:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:64776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZHaT2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,306,1249282800"; 
   d="scan'208";a="546438205"
Date: Mon, 31 Aug 2009 12:28:35 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@redhat.com>
Cc: Tony luck <tony.luck@intel.com>, linux-ia64 <linux-ia64@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: [PATCH] linux-next drm_cache.c: fix compilation error
Message-ID: <20090831192834.GA10462@linux-os.sc.intel.com>
References: <bug-504363-150293@bugzilla.redhat.com> <200908042017.n74KHsNw018095@bz-web1.app.phx.redhat.com> <20090804221119.GA21544@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804221119.GA21544@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling drm_cache.c on ia64, gcc reports undefined
drm_clflush_ipi_handler() error. The problem is because drm_cache_ipi_handler is
a typo.

One straightforward fix is changing drm_cache_ipi_handler to
drm_clflush_ipi_handler.

But since drm_clflush_ipi_handler() does nothing on non-x86 platforms and ipi
handling is costly, it would be better to just do nothing on non-x86 platforms
and remove drm_clflush_ipi_handler() for those platforms.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---
The issue was introduced by commit c9c97b8c75019814d8c007059bc827bb475be917
in linux-next.

 drm_cache.c |    7 -------
 1 files changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 3a5575e..8054a5c 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -62,10 +62,6 @@ drm_clflush_ipi_handler(void *null)
 {
 	wbinvd();
 }
-#elif !defined(__powerpc__)
-static void drm_cache_ipi_handler(void *dummy)
-{
-}
 #endif
 void
 drm_clflush_pages(struct page *pages[], unsigned long num_pages)
@@ -94,9 +90,6 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 				   (unsigned long)page_virtual + PAGE_SIZE);
 		kunmap_atomic(page_virtual, KM_USER0);
 	}
-#else
-	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
-		printk(KERN_ERR "Timed out waiting for drm cache flush\n");
 #endif
 }
 EXPORT_SYMBOL(drm_clflush_pages);
