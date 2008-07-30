Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYG3MCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYG3MCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYG3MCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:02:25 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:64262 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYG3MCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=rzJP1N3zx3LUs3QBCOjRrpJGQjIJTV+aYHfdNn8kzNDWWRT3jLIGOxOyNwS07uXe+8
         o2vMnRTT38BhoZhE1cs+xp5OyKnxIaJmQyrjPmkRcbhc7pcvgJwrw/tiak8908gu84ap
         3DgxbNWI2Vst3zsPq8ya+uLOiBY8+4KfLuyfc=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
Date: Wed, 30 Jul 2008 14:02:27 +0200
In-Reply-To: <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 28 Jul 2008 08:48:41 -0700 (PDT)")
Message-ID: <m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 28 Jul 2008, Vitaly Mayatskikh wrote:
>>
>> Reduce protection faults count in copy_user_handle_tail routine by
>> limiting clear length to the end of page as was suggested by Linus.
>
> No, you did it wrong.

Another try. Added direction and clear remainder flags to let
handle tail routine know how to optimize tail copying and clearing.
BYTES_LEFT_IN_PAGE macro returns PAGE_SIZE, not zero, when the address
is well aligned to page.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 5cfd295..e0ddedf 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -1,6 +1,16 @@
 #ifndef ASM_X86__UACCESS_64_H
 #define ASM_X86__UACCESS_64_H
 
+/* Flags for copy_user_handle_tail */
+#define CLEAR_REMAINDER		1
+#define DEST_IS_USERSPACE	2
+#define SOURCE_IS_USERSPACE	4
+
+#define BYTES_LEFT_IN_PAGE(ptr) \
+	(unsigned)((PAGE_MASK & ((long)(ptr) + PAGE_SIZE)) - (long)(ptr))
+
+#ifndef __ASSEMBLY__
+
 /*
  * User space memory access functions
  */
@@ -179,23 +189,26 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
-				unsigned size, int zerorest);
+				unsigned size, unsigned flags);
 
 static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 					   unsigned size)
 {
 	might_sleep();
-	return __copy_user_nocache(dst, src, size, 1);
+	return __copy_user_nocache(dst, src, size, SOURCE_IS_USERSPACE
+						   | CLEAR_REMAINDER);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst,
 						    const void __user *src,
 						    unsigned size)
 {
-	return __copy_user_nocache(dst, src, size, 0);
+	return __copy_user_nocache(dst, src, size, SOURCE_IS_USERSPACE);
 }
 
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest);
+copy_user_handle_tail(char *dst, char *src, unsigned remainder, unsigned flags);
+
+#endif /* __ASSEMBLY__ */
 
 #endif /* ASM_X86__UACCESS_64_H */

-- 
wbr, Vitaly
