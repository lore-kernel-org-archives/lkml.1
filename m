Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZBXCDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZBXCDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZBXCDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:03:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZBXCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:03:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from:x-system-of-record;
	b=KeSwroPtrtPA8jR9EeqnmmhK4sSh7EH0RqxStZDdK73Eqr4yNZTG2NWWmntBsmX0T
	c0X05qioWErvSpP+DVY9w==
Date: Mon, 23 Feb 2009 18:03:04 -0800
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Performance regression in write() syscall
Message-ID: <20090224020304.GA4496@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: sqazi@google.com (Salman Qazi)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the introduction of __copy_from_user_nocache (see commit:
0812a579c92fefa57506821fa08e90f47cb6dbdd) may have been an improvement
for sufficiently large writes, there is evidence to show that it is
deterimental for small writes.  Unixbench's fstime test gives the
following results for 256 byte writes with MAX_BLOCK of 2000:
    
    2.6.29-rc6 ( 5 samples, each in KB/sec ):
    283750, 295200, 294500, 293000, 293300
    
    2.6.29-rc6 + this patch (5 samples, each in KB/sec):
    313050, 3106750, 293350, 306300, 307900

    2.6.18
    395700, 342000, 399100, 366050, 359850

    See w_test() in src/fstime.c in unixbench version 4.1.0.  Basically, the above test
    consists of counting how much we can write in this manner:

    alarm(10);
    while (!sigalarm) {
            for (f_blocks = 0; f_blocks < 2000; ++f_blocks) {
                   write(f, buf, 256);
            }
            lseek(f, 0L, 0);
    }

I realised that there are other components to the write syscall regression
that are not addressed here.  I will send another email shortly stating the
source of another one.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 84210c4..efe7315 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -192,14 +192,20 @@ static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 					   unsigned size)
 {
 	might_sleep();
-	return __copy_user_nocache(dst, src, size, 1);
+	if (likely(size >= PAGE_SIZE))
+		return __copy_user_nocache(dst, src, size, 1);
+	else
+		return __copy_from_user(dst, src, size);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst,
 						    const void __user *src,
 						    unsigned size)
 {
-	return __copy_user_nocache(dst, src, size, 0);
+	if (likely(size >= PAGE_SIZE))
+		return __copy_user_nocache(dst, src, size, 0);
+	else
+		return __copy_from_user_inatomic(dst, src, size);
 }
 
 unsigned long
