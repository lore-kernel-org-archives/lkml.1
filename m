Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZDQTJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZDQTJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZDQTHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:30 -0400
Received: from kroah.org ([198.145.64.141]:51217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754556AbZDQTH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/10] dynamic debug: resurrect old pr_debug() semantics as pr_devel()
Date: Fri, 17 Apr 2009 12:04:31 -0700
Message-Id: <1239995074-4065-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

pr_debug() used to produce zero code unless DEBUG was #defined.  This is
now no longer the case in practice[1].

There are places where it's useful to have debugging printks, but we don't
want them to generate any code in production kernels.

So add a new macro, pr_devel(), for _devel_opment, to provide the old
semantics, ie.  if the programmer doesn't explicitly enable debugging, no
code is produced.

[1]: You can turn CONFIG_DYNAMIC_DEBUG off, but it's enabled in at least
     one distro kernel, so it's not really a solution.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg Banks <gnb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kernel.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d9e75ec..883cd44 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -377,6 +377,15 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
-- 
1.6.2

