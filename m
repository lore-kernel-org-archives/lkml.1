Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYBYNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYBYNDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYBYNDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:03:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYBYNDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:03:07 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: [PATCH 1/3] xen: Make xen-blkfront write its protocol ABI to xenstore
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 25 Feb 2008 14:02:24 +0100
Message-ID: <87mypp6vfj.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frontends are expected to write their protocol ABI to xenstore.  Since
the protocol ABI defaults to the backend's native ABI, things work
fine without that as long as the frontend's native ABI is identical to
the backend's native ABI.  This is not the case for xen-blkfront
running 32-on-64, because its ABI differs between 32 and 64 bit, and
thus needs this fix.

Based on http://xenbits.xensource.com/xen-unstable.hg?rev/c545932a18f3
and http://xenbits.xensource.com/xen-unstable.hg?rev/ffe52263b430 by
Gerd Hoffmann <kraxel@suse.de>

Signed-off-by: Markus Armbruster <armbru@redhat.com>

---
 drivers/block/xen-blkfront.c         |    7 +++++++
 include/xen/interface/io/protocols.h |   21 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 include/xen/interface/io/protocols.h

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8afce67..e69164a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -46,6 +46,7 @@
 
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/blkif.h>
+#include <xen/interface/io/protocols.h>
 
 #include <asm/xen/hypervisor.h>
 
@@ -597,6 +598,12 @@ again:
 		message = "writing event-channel";
 		goto abort_transaction;
 	}
+	err = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
+			    XEN_IO_PROTO_ABI_NATIVE);
+	if (err) {
+		message = "writing protocol";
+		goto abort_transaction;
+	}
 
 	err = xenbus_transaction_end(xbt, 0);
 	if (err) {
diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
new file mode 100644
index 0000000..01fc8ae
--- /dev/null
+++ b/include/xen/interface/io/protocols.h
@@ -0,0 +1,21 @@
+#ifndef __XEN_PROTOCOLS_H__
+#define __XEN_PROTOCOLS_H__
+
+#define XEN_IO_PROTO_ABI_X86_32     "x86_32-abi"
+#define XEN_IO_PROTO_ABI_X86_64     "x86_64-abi"
+#define XEN_IO_PROTO_ABI_IA64       "ia64-abi"
+#define XEN_IO_PROTO_ABI_POWERPC64  "powerpc64-abi"
+
+#if defined(__i386__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_32
+#elif defined(__x86_64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_64
+#elif defined(__ia64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
+#elif defined(__powerpc64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
+#else
+# error arch fixup needed here
+#endif
+
+#endif
-- 
1.5.3.3

