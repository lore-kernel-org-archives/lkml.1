Return-Path: <linux-kernel-owner+w=401wt.eu-S966162AbXDCKvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966162AbXDCKvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966161AbXDCKvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:51:40 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:33444 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966164AbXDCKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:51:39 -0400
Message-ID: <461230B5.8000807@hitachi.com>
Date: Tue, 03 Apr 2007 19:47:17 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 2/2] VM throttling: Add vm.dirty_start_writeback_ratio to
 sysctl
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com> <46026B78.3080401@tmr.com> <4607A01D.1060401@hitachi.com> <4607FECD.1090101@tmr.com>
In-Reply-To: <4607FECD.1090101@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a sysctl variable `vm.dirty_start_writeback_ratio' to
enable users to adjust the writeback starting level of the dirty pages.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
---
 Documentation/filesystems/proc.txt |   11 +++++++++--
 Documentation/sysctl/vm.txt        |    3 ++-
 kernel/sysctl.c                    |   11 +++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc5-mm3-writeback/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.21-rc5-mm3-writeback.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.21-rc5-mm3-writeback/Documentation/filesystems/proc.txt
@@ -1170,13 +1170,20 @@ dirty_background_ratio
 Contains, as a percentage of total system memory, the number of pages at which
 the pdflush background writeback daemon will start writing out dirty data.

-dirty_ratio
------------------
+dirty_writeback_start_ratio
+---------------------------

 Contains, as a percentage of total system memory, the number of pages at which
 a process which is generating disk writes will itself start writing out dirty
 data.

+dirty_ratio
+-----------------
+
+Contains, as a percentage of total system memory, the number of pages at which
+a process which is generating disk writes will be blocked untill the level
+subsides.
+
 dirty_writeback_centisecs
 -------------------------

Index: linux-2.6.21-rc5-mm3-writeback/Documentation/sysctl/vm.txt
===================================================================
--- linux-2.6.21-rc5-mm3-writeback.orig/Documentation/sysctl/vm.txt
+++ linux-2.6.21-rc5-mm3-writeback/Documentation/sysctl/vm.txt
@@ -19,6 +19,7 @@ Currently, these files are in /proc/sys/
 - overcommit_memory
 - page-cluster
 - dirty_ratio
+- dirty_start_writeback_ratio
 - dirty_background_ratio
 - dirty_expire_centisecs
 - dirty_writeback_centisecs
@@ -40,7 +41,7 @@ Currently, these files are in /proc/sys/
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
 dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
 block_dump, swap_token_timeout, drop-caches,
-hugepages_treat_as_movable:
+hugepages_treat_as_movable, dirty_start_writeback_ratio:

 See Documentation/filesystems/proc.txt

Index: linux-2.6.21-rc5-mm3-writeback/kernel/sysctl.c
===================================================================
--- linux-2.6.21-rc5-mm3-writeback.orig/kernel/sysctl.c
+++ linux-2.6.21-rc5-mm3-writeback/kernel/sysctl.c
@@ -708,6 +708,17 @@ static ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_start_writeback_ratio",
+		.data		= &dirty_start_writeback_ratio,
+		.maxlen		= sizeof(dirty_start_writeback_ratio),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+	{
 		.ctl_name	= VM_DIRTY_WB_CS,
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
