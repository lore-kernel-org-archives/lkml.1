Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYDBIGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYDBIGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYDBIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:05:52 -0400
Received: from mx.ATComputing.nl ([195.108.229.5]:35909 "EHLO
	mx.ATComputing.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYDBIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:05:51 -0400
Date: Wed, 2 Apr 2008 09:33:41 +0200
From: Gerlof Langeveld <gerlof@ATComputing.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/3] accounting: task counters for disk/network
Message-ID: <20080402073341.GC8419@atcmpg.ATComputing.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.7i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gerlof Langeveld <gerlof@atcomputing.nl>

This patch depends on patch 2/3 "accounting: task counters for disk/network".

Kernel configuration should allow the selection of the required
type of process accounting record (new type 6). The standard type
of process accounting record remains the default.

Furthermore per-task I/O accounting (i.e. the availability of the
file /proc/pid/io) is made independent of the export of these
statistics through netlink. The current structure of the ifdef's
allows this independency.

Modified file
  init/Kconfig:               When process accounting support is configured,
                              a choice can be made between type 2 (default),
                              type 3 (was already an existing alternative)
                              or type 6 (new alternative).

                              Task I/O accounting is no longer depending on
                              extended taskstats through netlink interface.

Signed-off-by: Gerlof Langeveld <gerlof@atcomputing.nl>
---

diff -uprN -X linux-2.6.24.4-modified/Documentation/dontdiff linux-2.6.24.4-vanilla/init/Kconfig linux-2.6.24.4-modified/init/Kconfig
--- linux-2.6.24.4-vanilla/init/Kconfig	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/init/Kconfig	2008-03-27 09:49:39.000000000 +0100
@@ -152,18 +152,37 @@ config BSD_PROCESS_ACCT
 	  up to the user level program to do useful things with this
 	  information.  This is generally a good idea, so say Y.
 
+choice
+        depends on BSD_PROCESS_ACCT
+        prompt "Accounting record type"
+	default BSD_PROCESS_ACCT_V2
+
+config BSD_PROCESS_ACCT_V2
+	bool "BSD Process Accounting version 2 file format"
+	help
+	  Default format with limited process accounting information.
+
 config BSD_PROCESS_ACCT_V3
 	bool "BSD Process Accounting version 3 file format"
-	depends on BSD_PROCESS_ACCT
-	default n
 	help
-	  If you say Y here, the process accounting information is written
+	  The process accounting information is written
 	  in a new file format that also logs the process IDs of each
 	  process and it's parent. Note that this file format is incompatible
 	  with previous v0/v1/v2 file formats, so you will need updated tools
 	  for processing it. A preliminary version of these tools is available
 	  at <http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/>.
 
+config PROCESS_ACCT_V6
+	bool "Process Accounting version 6 file format"
+	help
+	  The process accounting information is written
+	  in a file format that logs the PID of each process and
+	  additional I/O statistics for disk and networking.
+	  Note that this file format is incompatible
+	  with previous v0/v1/v2/v3 file formats, but supplies optimal
+	  information for tools like atop.
+endchoice
+
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
 	depends on NET
@@ -198,11 +217,10 @@ config TASK_XACCT
 	  Say N if unsure.
 
 config TASK_IO_ACCOUNTING
-	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
-	depends on TASK_XACCT
+	bool "Enable per-task I/O accounting (EXPERIMENTAL)"
 	help
-	  Collect information on the number of bytes of storage I/O which this
-	  task has caused.
+	  Collect information on disk and network I/O which this task
+	  has caused.
 
 	  Say N if unsure.
 
