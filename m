Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbZD3RX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbZD3RX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764581AbZD3RHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:53 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764580AbZD3RHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:43 2009
Message-Id: <20090430165743.681003313@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 36/88] add some long-missing capabilities to fs_mask
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0063-add-some-long-missing-capabilities-to-fs_mask.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Serge E. Hallyn <serue@us.ibm.com>

upstream commit: 0ad30b8fd5fe798aae80df6344b415d8309342cc

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

Changelog:
	[Mar 23] Actually delete old CAP_FS_SET definition...
	[Mar 20] Updated against J. Bruce Fields's patch

Reported-by: Igor Zhbanov <izh1979@gmail.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: stable@kernel.org
Cc: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/capability.h |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -366,7 +366,21 @@ typedef struct kernel_cap_struct {
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
+ *   1. CAP_FS_MASK is the privilege to bypass all fs-related DAC permissions
+ *   2. The security.* and trusted.* xattrs are fs-related MAC permissions
+ */
+
 # define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
+			    | CAP_TO_MASK(CAP_MKNOD)		\
 			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
 			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
 			    | CAP_TO_MASK(CAP_FOWNER)		\
@@ -381,11 +395,12 @@ typedef struct kernel_cap_struct {
 # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
 # define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
 # define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
-# define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
+# define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
+				    | CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
+				    CAP_FS_MASK_B1 } })
 # define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0 \
-					    | CAP_TO_MASK(CAP_SYS_RESOURCE) \
-					    | CAP_TO_MASK(CAP_MKNOD), \
-					    CAP_FS_MASK_B1 } })
+				    | CAP_TO_MASK(CAP_SYS_RESOURCE), \
+				    CAP_FS_MASK_B1 } })
 
 #endif /* _KERNEL_CAPABILITY_U32S != 2 */
 


