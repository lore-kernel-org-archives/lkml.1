Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbXDWXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbXDWXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXDWXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:13:40 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38871 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932812AbXDWXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:07:38 -0400
Message-Id: <20070423215709.802499615@goop.org>
References: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: [PATCH 03/25] xen: Add nosegneg capability to the vsyscall page notes
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
+NOTE_KERNELCAP_BEGIN(1, 2)
+NOTE_KERNELCAP(1, "nosegneg")
+NOTE_KERNELCAP_END
+#endif
+

-- 

