Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYFZOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYFZOcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYFZOcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:32:31 -0400
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:41251 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYFZOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:32:30 -0400
X-Greylist: delayed 2426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 10:32:28 EDT
From: Benny Halevy <bhalevy@panasas.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] fix extern inline errors with gcc 4.3.0
Date: Thu, 26 Jun 2008 16:50:51 +0300
Message-Id: <1214488251-20927-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.5.6.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.3.0 needs -funit-at-a-time for extern inline functions
otherwise it doesn't find their body.

For example:
$ gcc --version
gcc (GCC) 4.3.0 20080428 (Red Hat 4.3.0-8)

/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/fs/buffer.c: In function ‘alloc_page_buffers’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/fs/buffer.c:51: sorry, unimplemented: inlining failed in call to ‘init_buffer’: function body not available
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/fs/buffer.c:948: sorry, unimplemented: called from here

Fix follows the lines of commit 22eecde2f9034764a3fd095eecfa3adfb8ec9a98
that was reverted by commit c0a18111e571138747a98af18b3a2124df56a0d1,
just limiting the flag for pre- gcc 4.3.0 rather than 4.0.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 arch/um/Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index dbeab15..e7ed37b 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -77,7 +77,11 @@ include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
+# Disable unit-at-a-time mode on pre-gcc-4.3 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots:
+# gcc 4.3.0 needs -funit-at-a-time for extern inline functions
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0403 ] ; then \
+			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 PHONY += linux
 
-- 
1.5.6.GIT

