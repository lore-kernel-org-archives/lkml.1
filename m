Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYG1OKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYG1OKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYG1OK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:10:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYG1OKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=dWiVccBzQ51qGFPxOuTcO+tX4zHN+RxQtPc0nMKoahpupzrWF1TAQegUEl9allUU82
         6031VB9OMNpU+uFUqWqmXUVta/EfxnhplgzRdydaI6B2tmaXmrnnqoeNdPSEh7T733ky
         dywQxiXfz7cp/y7yoY775HijwiQZEIT47VNg8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Optimize tail handling for copy_user
Date: Mon, 28 Jul 2008 16:10:30 +0200
Message-ID: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce protection faults count in copy_user_handle_tail routine by
limiting clear length to the end of page as was suggested by Linus.

Linus, should I add myself "signed-off-by: you" for patches with your
ideas implemented? Clear length calculation was changed a bit for
correct handling of page aligned addresses.

I'm using this systemtap script for sanity testing:
http://people.redhat.com/vmayatsk/copy_user_x8664/
It looks very ugly, but works.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f4df6e7..42baeca 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -161,23 +161,33 @@ EXPORT_SYMBOL(copy_in_user);
 /*
  * Try to copy last bytes and clear the rest if needed.
  * Since protection fault in copy_from/to_user is not a normal situation,
- * it is not necessary to optimize tail handling.
+ * it is not necessary to do low level optimization of tail handling.
  */
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
+copy_user_handle_tail(char *to, char *from, unsigned len, unsigned clear_rest)
 {
 	char c;
-	unsigned zero_len;
+	unsigned clear_len;
 
-	for (; len; --len) {
-		if (__get_user_nocheck(c, from++, sizeof(char)))
-			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+	while (len) {
+		if (__get_user_nocheck(c, from, 1))
 			break;
+		from++;
+		if (__put_user_nocheck(c, to, 1))
+			/* Fault in destination, nothing to clear */
+			goto out;
+		to++;
+		len--;
 	}
 
-	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
-		if (__put_user_nocheck(c, to++, sizeof(char)))
-			break;
+	if (clear_rest) {
+		unsigned long addr = (unsigned long)to;
+		clear_len = len;
+		/* Limit clear_len to the rest of the page */
+		if ((addr + len) & PAGE_MASK != addr & PAGE_MASK)
+			clear_len = len - ((addr + len) & ~PAGE_MASK);
+		memset(to, 0, clear_len);
+	}
+out:
 	return len;
 }
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 5cfd295..c5c5af0 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -196,6 +196,6 @@ static inline int __copy_from_user_inatomic_nocache(void *dst,
 }
 
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest);
+copy_user_handle_tail(char *to, char *from, unsigned len, unsigned clear_rest);
 
 #endif /* ASM_X86__UACCESS_64_H */

-- 
wbr, Vitaly
