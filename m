Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYGBNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYGBNsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYGBNs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:48:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:53142 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYGBNsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=B+Bd52qnBNr1IKt0p/0wloayeOBZO2T2ED00gmDYcTaOX/Qt3QXNuqg9kGI/n4xkEb
         ELPXC+8Ukje+6NA0O96WWXX6XCCMke+sohe7py4h63sdf9Ay2NUAQjlPVnQ+lZLxKv1x
         dSJbcgmZRv2Hfd6XpQPpSonNDXxcn8oDC5qak=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
Date: Wed, 02 Jul 2008 15:48:21 +0200
In-Reply-To: <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 30 Jun 2008 08:55:02 -0700 (PDT)")
Message-ID: <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic C routine for handling necessary tail operations after
protection fault in copy_*_user on x86.

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 0c89d1b..3ab4ec8 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -158,3 +158,26 @@ unsigned long copy_in_user(void __user *to, const void __user *from, unsigned le
 }
 EXPORT_SYMBOL(copy_in_user);
 
+/*
+ * Try to copy last bytes and clear the rest if needed.
+ * Since protection fault in copy_from/to_user is not a normal situation,
+ * it is not necessary to optimize tail handling.
+ */
+unsigned long
+copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
+{
+	char c;
+	unsigned zero_len;
+
+	for (; len; --len) {
+		if (__get_user_nocheck(c, from++, sizeof(char)))
+			break;
+		if (__put_user_nocheck(c, to++, sizeof(char)))
+			break;
+	}
+
+	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
+		if (__put_user_nocheck(c, to++, sizeof(char)))
+			break;
+	return len;
+}
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index b8a2f43..1dc2003 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -455,4 +455,7 @@ static inline int __copy_from_user_inatomic_nocache(void *dst,
 	return __copy_user_nocache(dst, src, size, 0);
 }
 
+unsigned long
+copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest);
+
 #endif /* __X86_64_UACCESS_H */

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

-- 
wbr, Vitaly
