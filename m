Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbXL0Lco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbXL0Lco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXL0Lcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:32:36 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:46128 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbXL0Lcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:32:36 -0500
Date: Thu, 27 Dec 2007 14:32:50 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] moduleparam: fix alpha and ia64 compile failures
Message-ID: <20071227113250.GB22678@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On alpha and ia64 only relocations to local data can go into read-only
sections. The vast majority of module parameters use the global generic
param_set_*/param_get_* functions, so the 'const' attribute for struct
kernel_param is not only useless, but it also causes compile failures due
to 'section type conflict' in those rare cases where param_set/get are
local functions.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=8964

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 include/linux/moduleparam.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 13410b2..4c416d8 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -62,6 +62,15 @@ struct kparam_array
 	void *elem;
 };
 
+/* On alpha and ia64 relocations to global data cannot go into read-only
+   sections, so 'const' makes no sense and even causes compile failures
+   with some compilers. */
+#if defined(__alpha__) || defined(__ia64__)
+#define __moduleparam_const
+#else
+#define __moduleparam_const const
+#endif
+
 /* This is the fundamental function for registering boot/module
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
@@ -71,7 +80,7 @@ struct kparam_array
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param const __param_##name			\
+	static struct kernel_param __moduleparam_const __param_##name	\
 	__attribute_used__						\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
