Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbXF1PmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbXF1PmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759279AbXF1Pln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:41:43 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:37857 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbXF1Pll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:41:41 -0400
Date: Thu, 28 Jun 2007 11:41:38 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] security: move mmap_min_addr sysctl to /proc/sys/vm
In-Reply-To: <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0706281140530.13114@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
 <20070628001221.364438ce.akpm@linux-foundation.org>
 <20070628012749.caf450f6.akpm@linux-foundation.org>
 <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move mmap_min_addr sysctl to /proc/sys/vm, as suggested by Andrew Morton.

Signed-off-by: James Morris <jmorris@namei.org>
---
 Documentation/sysctl/kernel.txt |   14 --------------
 Documentation/sysctl/vm.txt     |   15 +++++++++++++++
 kernel/sysctl.c                 |   20 ++++++++++----------
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1a9dc8a..111fd28 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -29,7 +29,6 @@ show up in /proc/sys/kernel:
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
-- mmap_min_addr
 - modprobe                    ==> Documentation/kmod.txt
 - msgmax
 - msgmnb
@@ -179,19 +178,6 @@ kernel stack.
 
 ==============================================================
 
-mmap_min_addr
-
-This file indicates the amount of address space  which a user process will be
-restricted from mmaping.  Since kernel null dereference bugs could
-accidentally operate based on the information in the first couple of pages of
-memory userspace processes should not be allowed to write to them.  By default
-this value is set to 0 and no protections will be enforced by the security
-module.  Setting this value to something like 64k will allow the vast majority
-of applications to work correctly and provide defense in depth against future
-potential kernel bugs.
-
-==============================================================
-
 osrelease, ostype & version:
 
 # cat osrelease
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 1d19256..8cfca17 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -31,6 +31,7 @@ Currently, these files are in /proc/sys/vm:
 - min_unmapped_ratio
 - min_slab_ratio
 - panic_on_oom
+- mmap_min_address
 
 ==============================================================
 
@@ -216,3 +217,17 @@ above-mentioned.
 The default value is 0.
 1 and 2 are for failover of clustering. Please select either
 according to your policy of failover.
+
+==============================================================
+
+mmap_min_addr
+
+This file indicates the amount of address space  which a user process will
+be restricted from mmaping.  Since kernel null dereference bugs could
+accidentally operate based on the information in the first couple of pages
+of memory userspace processes should not be allowed to write to them.  By
+default this value is set to 0 and no protections will be enforced by the
+security module.  Setting this value to something like 64k will allow the
+vast majority of applications to work correctly and provide defense in depth
+against future potential kernel bugs.
+
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8f9a737..44f0a50 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -615,16 +615,6 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_SECURITY
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "mmap_min_addr",
-		.data		= &mmap_min_addr,
-		.maxlen         = sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-	},
-#endif
 	{ .ctl_name = 0 }
 };
 
@@ -878,6 +868,16 @@ static ctl_table vm_table[] = {
 		.strategy	= &sysctl_jiffies,
 	},
 #endif
+#ifdef CONFIG_SECURITY
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_min_addr",
+		.data		= &mmap_min_addr,
+		.maxlen         = sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
-- 
1.5.0.6

