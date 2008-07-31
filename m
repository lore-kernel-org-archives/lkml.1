Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYGaWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYGaWup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbYGaWuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYGaWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e2KtGS//w63crdBvnRptiKRM2pycw01+d4DhLVp4FakY67QmIJITAXT7FX+R3UEEVH
         17R3tqYLZnorMRk1kah53hFxzyh4hk6879rccQJ7MIo5vKCqe7l2DZDOsYpjVpzXhXWK
         HoBFYuJVTtmbrnatooQzCilPMst6HxadwVlxs=
From: Andrea Righi <righi.andrea@gmail.com>
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com
Cc: Matt Heaton <matt@bluehost.com>, Mark Seger <Mark.Seger@hp.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 1/4] documentation of /proc/<pid>/blockio and /proc/<pid>/task/<tid>/blockio
Date: Fri,  1 Aug 2008 00:49:56 +0200
Message-Id: <1217544599-8935-2-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the documentation about the kernel->userspace interface to show
task/thread/block device IO statistics.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/filesystems/proc.txt |   43 ++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 6455782..55f425f 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -44,6 +44,7 @@ Table of Contents
   2.14	/proc/<pid>/io - Display the IO accounting fields
   2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
   2.16	/proc/<pid>/mountinfo - Information about mounts
+  2.17	/proc/<pid>/blockio - Display per block device IO statistics
 
 ------------------------------------------------------------------------------
 Preface
@@ -2451,3 +2452,45 @@ For more information on mount propagation see:
   Documentation/filesystems/sharedsubtree.txt
 
 ------------------------------------------------------------------------------
+
+2.17	/proc/<pid>/blockio - Display per block device IO statistics
+--------------------------------------------------------------------
+
+This file provides process IO statistics separated per block device, running
+thread and exited children.
+
+IO statistics are reported in the following form:
+
+$ cat /proc/<pid>/blockio
+3609 t 3,1 331776 0 0
+3609 c 3,1 25677824 33513472 0
+3609 c 3,5 54658560 66994176 0
+(1) (2)(3)   (4)      (5)   (6)
+
+(1) thread id (tid)
+(2) type: "t" identifies the specific thread IO statistics, "c" identifies the
+    IO statistics of all the exited children
+(3) device: the specific block device the IO statistics refer to, reported in
+    the form major,minor (device numbers)
+(4) read_bytes: IO counter of bytes read (see §2.14)
+(4) write_bytes: IO counter of bytes written (see §2.14)
+(5) cancelled_write_bytes: IO counter of truncated bytes (see §2.14)
+
+As a simple example it is possible to quickly retrieve the list of the top IO
+consumers on /dev/hda1 as following:
+
+$ cat /proc/[0-9]*/blockio | sed -ne "s/^\(.*\)` \
+stat /dev/hda1 | sed -ne 's/.*type: \(.*\)$/\1/p' \
+` \([0-9]\+\) \([0-9]\+\) \([0-9]\+\)$/echo \1\$((\2 + \3 + \4))/p" | \
+sh | sort -nrt' ' -k3
+
+Looking at the type of statistic it is also possible to know if the top IO
+consumer spawned many children (c) that did the real IO work or if it is
+currently doing the work (t).
+
+Distinct thread IO statistics are provided by /proc/<pid>/task/<tid>/blockio.
+This file only reports the specific thread IO, excluding the statistics of the
+exited children and the other running threads belonging to the same thread
+group.
+
+------------------------------------------------------------------------------
-- 
1.5.4.3

