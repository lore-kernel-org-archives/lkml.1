Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZBXGvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZBXGvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZBXGvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:51:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbZBXGvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:51:14 -0500
Date: Tue, 24 Feb 2009 01:51:12 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, kyle@redhat.com, roland@redhat.com,
       aoliva@redhat.com
Subject: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with
	gcc-4.4
Message-ID: <20090224065112.GA6690@bombadil.infradead.org>
Reply-To: kyle@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

On ppc64 (at least) gcc-4.4 is defaulting to generating .eh_frame
sections, which are, for the kernel, fairly pointless. Additionally, on
ppc64 this generates a relocation format which the kernel module loader
does not currently support (R_PPC64_REL32.)

Alexandre Oliva verifies that -fno-dwarf2-cfi-asm prevents this
.eh_frame section from being generated.

These seem to be used for unwinding, but it doesn't look like we
currently use them anywhere. (In fact, we explicitly dump them in the
x86_64 linker script.)

If these .eh_frame sections are eventually used, adding a per-arch
CONFIG_WANT_UNWIND check would be trivial.

(This was reported against Fedora, which appears to be the only distro
doing any building against gcc-4.4 at present: RH bz#486545.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: roland@redhat.com
Cc: aoliva@redhat.com

---
diff --git a/Makefile b/Makefile
index df6ce3e..d66a512 100644
--- a/Makefile
+++ b/Makefile
@@ -566,6 +566,11 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
+# gcc-4.4 defaults to generating .eh_frame sections, but we aren't
+# interested in those currently. additionally, it causes issues on some
+# architectures.
+KBUILD_CFLAGS += $(call cc-option,-fno-dwarf2-cfi-asm)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
