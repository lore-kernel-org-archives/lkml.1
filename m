Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYDBSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYDBSmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYDBSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:53 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38416 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757393AbYDBSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 24] [PATCH] xen: Make xen-blkfront write its protocol
	ABI to xenstore
X-Mercurial-Node: 720af08a3d23217c5bc8858ca05774232ee2e060
Message-Id: <720af08a3d23217c5bc8.1207158842@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Armbruster <armbru@redhat.com>

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
Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c         |    7 +++++++
 include/xen/interface/io/protocols.h |   22 +++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -47,6 +47,7 @@
 
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/blkif.h>
+#include <xen/interface/io/protocols.h>
 
 #include <asm/xen/hypervisor.h>
 
@@ -614,6 +615,12 @@
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


