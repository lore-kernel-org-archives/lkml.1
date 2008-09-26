Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYIZIDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYIZIDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYIZICt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:02:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZICr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:02:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Alphabetic proportion vapor
   (2) Obedient goats
   (3) Atrocious animals
   (4) Vacant accusation detention
Message-Id: <20080926080204.1EDC11541FA@magilla.localdomain>
Date: Fri, 26 Sep 2008 01:02:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a kconfig option to change the /proc/PID/coredump_filter default.
Fedora has been carrying a trivial patch to change the hard-wired value for
this default, since Fedora 8.  The default default can't change safely
because there are old GDB versions out there (all before 6.7) that are
confused by the core dump files created by the MMF_DUMP_ELF_HEADERS setting.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/Kconfig.binfmt     |   22 ++++++++++++++++++++++
 include/linux/sched.h |    8 +++++++-
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 4a551af..195b826 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -40,6 +40,28 @@ config BINFMT_ELF_FDPIC
 
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
+config CORE_DUMP_DEFAULT_ELF_HEADERS
+	bool "Write ELF core dumps with partial segments"
+	default n
+	depends on BINFMT_ELF
+	help
+	  ELF core dump files describe each memory mapping of the crashed
+	  process, and can contain or omit the memory contents of each one.
+	  The contents of an unmodified text mapping are omitted by default.
+
+	  For an unmodified text mapping of an ELF object, including just
+	  the first page of the file in a core dump makes it possible to
+	  identify the build ID bits in the file, without paying the i/o
+	  cost and disk space to dump all the text.  However, versions of
+	  GDB before 6.7 are confused by ELF core dump files in this format.
+
+	  The core dump behavior can be controlled per process using
+	  the /proc/PID/coredump_filter pseudo-file; this setting is
+	  inherited.  See Documentation/filesystems/proc.txt for details.
+
+	  This config option changes the default setting of coredump_filter
+	  seen at boot time.  If unsure, say N.
+
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
 	depends on !MMU && (!FRV || BROKEN)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..db9d25c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -408,7 +408,13 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_DUMP_FILTER_MASK \
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) | \
+	 MMF_DUMP_MASK_DEFAULT_ELF)
+#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
+# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
+#else
+# define MMF_DUMP_MASK_DEFAULT_ELF	0
+#endif
 
 struct sighand_struct {
 	atomic_t		count;
