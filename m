Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbYBMIrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbYBMIrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYBMIrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:47:11 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:45012 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYBMIrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:47:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=oAc1HvYDr/MA5DoX2eP+ky1kl9ROFLM2oC6RpXppY9rk4AvlcpjB4FaU9YZ0rTUv72i60moLmG8d3DnSSlKeEIGom8A+EGqZNlv0Fb1zPcNtMq9fLWIC2llOk6DszrfJ6b9/AW3i/kVxgB1mR4cgmGRQHkO9tAr6iNnNKqM8n/Y=
Message-ID: <47B2AE7C.608@gmail.com>
Date: Wed, 13 Feb 2008 17:46:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH REPOST] printk: fix possible printk buffer overrun introduced
 with recursion check
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk recursion detection prepends message to printk_buf and offsets
printk_buf when actual message is printed but it forgets to trim
buffer length accordingly.  This can result in buffer overrun in
extreme cases.

While at it, make printk_recursion_bug_msg static and move static
variables for recursion check into vprintk().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
Eeeek, forgot to cc lkml last time.  Re-sending.  Sorry about the
noise.

 kernel/printk.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index bee3610..074a3ea 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -613,15 +613,13 @@ asmlinkage int printk(const char *fmt, ...)
 	return r;
 }
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
-
-const char printk_recursion_bug_msg [] =
-			KERN_CRIT "BUG: recent printk recursion!\n";
-static int printk_recursion_bug;
-
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	/* cpu currently holding logbuf_lock */
+	static volatile unsigned int printk_cpu = UINT_MAX;
+	static const char printk_recursion_bug_msg [] =
+		KERN_CRIT "BUG: recent printk recursion!\n";
+	static int printk_recursion_bug;
 	static int log_level_unknown = 1;
 	static char printk_buf[1024];
 
@@ -666,7 +664,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf), fmt, args);
+				  sizeof(printk_buf) - printed_len, fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
-- 
1.5.2.4

