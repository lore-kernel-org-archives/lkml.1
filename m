Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXB0Iiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXB0Iiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXB0Iit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:38:49 -0500
Received: from gw.goop.org ([64.81.55.164]:46812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974AbXB0Iim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:42 -0500
Message-Id: <20070227081635.765724334@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: [patch 17/26] Xen-paravirt_ops: Add nosegneg capability to the vsyscall page notes
Content-Disposition: inline; filename=xen-vsyscall-note.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
used by the runtime linker to select a glibc version which then
disables negative-offset accesses to the thread-local segment via
%gs. These accesses require emulation in Xen (because segments are
truncated to protect the hypervisor address space) and avoiding them
provides a measurable performance boost.

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/vsyscall-note.S |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

===================================================================
--- a/arch/i386/kernel/vsyscall-note.S
+++ b/arch/i386/kernel/vsyscall-note.S
@@ -23,3 +24,31 @@ 3:	.balign 4;		/* pad out section */			 
 	ASM_ELF_NOTE_BEGIN(".note.kernel-version", "a", UTS_SYSNAME, 0)
 	.long LINUX_VERSION_CODE
 	ASM_ELF_NOTE_END
+
+#ifdef CONFIG_XEN
+/*
+ * Add a special note telling glibc's dynamic linker a fake hardware
+ * flavor that it will use to choose the search path for libraries in the
+ * same way it uses real hardware capabilities like "mmx".
+ * We supply "nosegneg" as the fake capability, to indicate that we
+ * do not like negative offsets in instructions using segment overrides,
+ * since we implement those inefficiently.  This makes it possible to
+ * install libraries optimized to avoid those access patterns in someplace
+ * like /lib/i686/tls/nosegneg.  Note that an /etc/ld.so.conf.d/file
+ * corresponding to the bits here is needed to make ldconfig work right.
+ * It should contain:
+ *	hwcap 0 nosegneg
+ * to match the mapping of bit to name that we give here.
+ */
+#define NOTE_KERNELCAP_BEGIN(ncaps, mask) \
+	ASM_ELF_NOTE_BEGIN(".note.kernelcap", "a", "GNU", 2) \
+	.long ncaps, mask
+#define NOTE_KERNELCAP(bit, name) \
+	.byte bit; .asciz name
+#define NOTE_KERNELCAP_END ASM_ELF_NOTE_END
+
+NOTE_KERNELCAP_BEGIN(1, 1)
+NOTE_KERNELCAP(1, "nosegneg")
+NOTE_KERNELCAP_END
+#endif
+

-- 

