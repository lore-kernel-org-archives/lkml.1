Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYKXU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYKXU4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYKXUxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:53:52 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36726 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753946AbYKXUxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:53:51 -0500
Date: Mon, 24 Nov 2008 14:53:50 -0600
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] have sgi-gru driver call fs_initcall() if statically linked
Message-ID: <20081124205350.GA32474@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If xpc.ko and gru.ko are both statically linked into the kernel, then
xpc_init() can get called before gru_init() and make a call to one of the
gru's exported functions before the gru has initialized itself. The end
result is a NULL dereference.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-gru/grufile.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2008-11-21 11:44:02.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2008-11-21 13:40:08.000000000 -0600
@@ -678,7 +678,11 @@ struct vm_operations_struct gru_vm_ops =
 	.fault		= gru_fault,
 };
 
+#ifndef MODULE
+fs_initcall(gru_init);
+#else
 module_init(gru_init);
+#endif
 module_exit(gru_exit);
 
 module_param(gru_options, ulong, 0644);
