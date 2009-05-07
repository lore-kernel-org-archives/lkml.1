Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbZEGW2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbZEGW2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762990AbZEGW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:13 -0400
Received: from mga06.intel.com ([134.134.136.21]:19804 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753753AbZEGW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470425"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to take multiple inputs
Date: Thu,  7 May 2009 15:26:53 -0700
Message-Id: <1241735222-6640-6-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Allow the compression commands in Kbuild (i.e. gzip, bzip2, lzma) to
take multiple input files and emit the concatenated compressed
output.  This avoids an intermediate step when a kernel image is built
from multiple components, such as the relocatable x86-32 kernel.

[ Impact: new build feature, not yet used ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.lib |   11 ++++++++---
 scripts/bin_size     |    8 ++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9796195..35dfdf6 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -183,7 +183,8 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = gzip -f -9 < $< > $@
+cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
+	(rm -f $@ ; false)
 
 
 # Bzip2
@@ -193,10 +194,14 @@ cmd_gzip = gzip -f -9 < $< > $@
 size_append=$(CONFIG_SHELL) $(srctree)/scripts/bin_size
 
 quiet_cmd_bzip2 = BZIP2    $@
-cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
+cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
+	bzip2 -9 && $(size_append) $(filter-out FORCE,$^)) > $@ || \
+	(rm -f $@ ; false)
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
+cmd_lzma = (cat $(filter-out FORCE,$^) | \
+	lzma -9 && $(size_append) $(filter-out FORCE,$^)) > $@ || \
+	(rm -f $@ ; false)
diff --git a/scripts/bin_size b/scripts/bin_size
index 43e1b36..55f2161 100644
--- a/scripts/bin_size
+++ b/scripts/bin_size
@@ -1,10 +1,14 @@
 #!/bin/sh
 
 if [ $# = 0 ] ; then
-   echo Usage: $0 file
+   echo Usage: $0 file...
 fi
 
-size_dec=`stat -c "%s" $1`
+size_dec=0
+for file; do
+  fsize=`stat -c "%s" $file`
+  size_dec=`expr $size_dec + $fsize`
+done
 size_hex_echo_string=`printf "%08x" $size_dec |
      sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
 /bin/echo -ne $size_hex_echo_string
-- 
1.6.0.6

