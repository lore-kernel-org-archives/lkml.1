Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbZB1CSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbZB1CSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbZB1CO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:59 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:56031 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761742AbZB1CO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:58 -0500
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Feb 2009 21:14:57 EST
Message-Id: <200902280156.n1S1udEL014057@pobox-pa.hpl.hp.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] proc: /proc/kpageflags: incorrect arg order in kpf_copy_bits()
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Jeff.Mogul@hp.com
From: Jeffrey Mogul <Jeff.Mogul@hp.com>
X-Organization: Hewlett-Packard Labs, Large Scale Systems group
Date: Fri, 27 Feb 2009 17:56:39 -0800
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jeff.mogul@hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in fs/proc/page.c that implements /proc/kpageflags has
two similar but different bugs in the way that it copies bits
from the internal page->flags representation to the exported
representation:

(1) The kpf_copy_bits() macro was defined with argument order
(flags, srcpos, dstpos), which is the logical order, but all
but one of the uses of this macro invoke it instead in the order
(flags, dstpos, srcpos).  This only affects the output for a few
flags, since in most -- but not all! -- cases, srcpos == dstpos.

I fixed this by changing the macro definition rather than the macro
uses, which minimizes the number of lines to change but which might
not be the most obvious/logical design.

(2) One use of the kpf_copy_bit macro (for the PG_locked flag) had
the arguments in a random (rotated?) order, and was clearly wrong.

These bugs appear to have been in the code since /proc/kpageflags
was introduced (2.6.25).

CC: stable@kernel.org
Signed-off-by: Jeff Mogul <Jeff.Mogul@hp.com>
---
 fs/proc/page.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
--- linux-2.6.28.7/fs/proc/page.c.orig	2009-02-26 17:16:42.000000000 -0800
+++ linux-2.6.28.7/fs/proc/page.c	2009-02-26 17:18:04.000000000 -0800
@@ -80,7 +80,8 @@ static const struct file_operations proc
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
 
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+/* Arg order is dstpos,srcpos because that's how this macro is used below */
+#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
@@ -107,7 +108,7 @@ static ssize_t kpageflags_read(struct fi
 		else
 			kflags = ppage->flags;
 
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
 			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
 			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
 			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
