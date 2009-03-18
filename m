Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZCRUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZCRUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZCRUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:51:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44231 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCRUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:51:42 -0400
Date: Wed, 18 Mar 2009 15:42:51 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Stephen Smalley <sds@epoch.ncsc.mil>,
       Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org,
       linux-api@vger.kernel.org
Subject: [RFC PATCH] CAP_FS_MASK: add some long-missing capabilities to
	cap_fs_mask
Message-ID: <20090318204251.GA608@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When POSIX capabilities were introduced during the 2.1 Linux
cycle, the fs mask, which represents the capabilities which having
fsuid==0 is supposed to grant, did not include CAP_MKNOD and
CAP_LINUX_IMMUTABLE.  However, before capabilities the privilege
to call these did in fact depend upon fsuid==0.

This patch introduces those capabilities into the fsmask,
restoring the old behavior.

See the thread starting at http://lkml.org/lkml/2009/3/11/157 for
reference.

Note that if this fix is deemed valid, then earlier kernel versions (2.4
and 2.2) ought to be fixed too.

Reported-by: Igor Zhbanov <izh1979@gmail.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 1b98725..eae98b1 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -377,7 +377,21 @@ struct cpu_vfs_cap_data {
 #define CAP_FOR_EACH_U32(__capi)  \
 	for (__capi = 0; __capi < _KERNEL_CAPABILITY_U32S; ++__capi)
 
+/*
+ * CAP_FS_MASK and CAP_NFSD_MASKS:
+ *
+ * The fs mask is all the privileges that fsuid==0 historically meant.
+ * At one time in the past, that included CAP_MKNOD and CAP_LINUX_IMMUTABLE.
+ *
+ * It has never meant setting security.* and trusted.* xattrs.
+ *
+ * We could also define fsmask as follows:
+ *    1. CAP_FS_MASK is the privilege to bypass all fs-related DAC permissions
+ *    2. The security.* and trusted.* xattrs are fs-related MAC permissions
+ */
+
 # define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
+			    | CAP_TO_MASK(CAP_MKNOD)		\
 			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
 			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
 			    | CAP_TO_MASK(CAP_FOWNER)		\
@@ -392,7 +406,9 @@ struct cpu_vfs_cap_data {
 # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
 # define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
 # define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
-# define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
+# define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
+					| CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
+					CAP_FS_MASK_B1 } })
 # define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
 					CAP_FS_MASK_B1 } })
 
-- 
1.5.4.3

