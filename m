Return-Path: <linux-kernel-owner+w=401wt.eu-S934897AbXEVPUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897AbXEVPUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXEVPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:12 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4983
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759822AbXEVPTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:10 -0400
Message-Id: <20070522141251.598618585@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:50 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 09/33] xen: Add nosegneg capability to the vsyscall page notes
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
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>

---
 arch/i386/kernel/vsyscall-note.S |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

===================================================================
--- a/arch/i386/kernel/vsyscall-note.S
+++ b/arch/i386/kernel/vsyscall-note.S
@@ -12,3 +12,31 @@ ELFNOTE_START(Linux, 0, "a")
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
+
+#ifdef CONFIG_XEN
+
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
+ *	hwcap 1 nosegneg
+ * to match the mapping of bit to name that we give here.
+ */
+
+/* Bit used for the pseudo-hwcap for non-negative segments.  We use
+   bit 1 to avoid bugs in some versions of glibc when bit 0 is
+   used; the choice is otherwise arbitrary. */
+#define VDSO_NOTE_NONEGSEG_BIT	1
+
+ELFNOTE_START(GNU, 2, "a")
+	.long 1, 1<<VDSO_NOTE_NONEGSEG_BIT		/* ncaps, mask */
+	.byte VDSO_NOTE_NONEGSEG_BIT; .asciz "nosegneg"	/* bit, name */
+ELFNOTE_END
+#endif

-- 

