Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZDCPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZDCPqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbZDCPpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:45:54 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:48191 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbZDCPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:45:52 -0400
Date: Fri, 3 Apr 2009 17:41:32 +0200
From: Bastian Blank <waldi@debian.org>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 3/5] libgcc: Add Makefile
Message-ID: <20090403154132.GC7200@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20090403153941.GA7045@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403153941.GA7045@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It only supports the static linkage of the whole lib into vmlinux for
now.  Exports are generated.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 lib/Makefile        |    2 ++
 lib/libgcc/Makefile |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 lib/libgcc/Makefile

diff --git a/lib/Makefile b/lib/Makefile
index d6edd67..521f2d5 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -92,6 +92,8 @@ obj-$(CONFIG_NLATTR) += nlattr.o
 
 obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
 
+obj-$(CONFIG_LIBGCC_SUPPORT) += libgcc/
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/libgcc/Makefile b/lib/libgcc/Makefile
new file mode 100644
index 0000000..50dff0b
--- /dev/null
+++ b/lib/libgcc/Makefile
@@ -0,0 +1,29 @@
+libfuncs = \
+	_divdi3 _moddi3 _udivdi3 _umoddi3 _udiv_w_sdiv _udivmoddi4 \
+	_muldi3 _negdi2 _lshrdi3 _ashldi3 _ashrdi3 _cmpdi2 _ucmpdi2 _absvsi2 \
+	_absvdi2 _addvsi3 _addvdi3 _subvsi3 _subvdi3 _mulvsi3 _mulvdi3 _negvsi2 \
+	_negvdi2 _ffssi2 _ffsdi2 _clzsi2 _clzdi2 _ctzsi2 _ctzdi2 \
+	_popcountsi2 _popcountdi2 _paritysi2 _paritydi2 \
+	_bswapsi2 _bswapdi2
+
+libsyms = $(libfuncs) _clz _popcount_tab
+
+quiet_cmd_libgcc_cc_o_c = CC [L]  $@
+      cmd_libgcc_cc_o_c = $(CC) $(c_flags) -c -o $@ $< -std=gnu99 -Wno-declaration-after-statement -DL$*
+
+quiet_cmd_libgcc_exports = GEN     $@
+      cmd_libgcc_exports = ( \
+                             echo '\#include <linux/module.h>'; \
+                             echo '\#include "libgcc2.c"'; \
+			     $(patsubst %,echo 'EXPORT_SYMBOL(_%);';,$(libfuncs)) \
+			   )
+
+$(patsubst %,$(obj)/%.o,$(libsyms)): $(obj)/%.o: $(src)/libgcc2.c FORCE
+	$(call if_changed_dep,libgcc_cc_o_c)
+
+$(obj)/_exports.c: FORCE
+	$(call cmd,libgcc_exports) > $@
+
+obj-y := $(patsubst %,%.o,$(libsyms)) _exports.o
+
+clean-files := _exports.c
-- 
1.6.2.1


-- 
... The prejudices people feel about each other disappear when they get
to know each other.
		-- Kirk, "Elaan of Troyius", stardate 4372.5
