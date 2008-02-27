Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYB0TnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYB0TnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:43:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYB0Tmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:42:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbYB0Tmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:42:52 -0500
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Priit Laes <plaes@plaes.org>
Subject: [PATCH] x86 vdso: fix build locale dependency
X-Fcc: ~/Mail/linus
Emacs: it's all fun and games, until somebody tries to edit a file.
Message-Id: <20080227194215.0B5A32700FD@magilla.localdomain>
Date: Wed, 27 Feb 2008 11:42:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Priit Laes discovered that the sed command processing nm output was
sensitive to locale settings.  This was addressed in commit
03994f01e8b72b3d01fd3d09d1cc7c9f421a727c by using [:alnum:] in place of
[a-zA-Z0-9].  But that too is locale-dependent and may not always match
the identifiers it needs to.  The better fix is just to run sed et al
with a fixed locale setting in all builds.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Priit Laes <plaes@plaes.org>
---
 arch/x86/vdso/Makefile |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index b8bd0c4..0a8f474 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -48,9 +48,11 @@ obj-$(VDSO64-y)			+= vdso-syms.lds
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
 #
 sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([[:xdigit:]]*\) . \(VDSO[[:alnum:]_]*\)$$/\2 = 0x\1;/p'
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
 quiet_cmd_vdsosym = VDSOSYM $@
-      cmd_vdsosym = $(NM) $< | sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+define cmd_vdsosym
+	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+endef
 
 $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
