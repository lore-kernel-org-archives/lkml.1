Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbZLFJaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbZLFJaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbZLFJaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:30:07 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:59606 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZLFJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:30:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 1/1] X86: use explicit register name for get/put_user
Date: Sun,  6 Dec 2009 10:30:08 +0100
Message-Id: <1260091808-8053-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't find any traces of documentation for the behavior used
in current get/put_user implementation. After the merge of
32/64-bit version there is back register reference ("0") to the
output register ("a"). The output is retval of int type, but
the value in the input may be a long on 64-bit.

I don't know if this could ever cause any problems, but changing
the input to an explicit register ("a") makes it cleaner in my eyes.
There is no need of the back reference.

Change this for both get and put_user.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..35f483b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -122,7 +122,7 @@ extern int __get_user_bad(void);
 #define __get_user_x(size, ret, x, ptr)		      \
 	asm volatile("call __get_user_" #size	      \
 		     : "=a" (ret), "=d" (x)	      \
-		     : "0" (ptr))		      \
+		     : "a" (ptr))		      \
 
 /* Careful: we have to cast the result to the type of the pointer
  * for sign reasons */
@@ -181,7 +181,7 @@ extern int __get_user_bad(void);
 
 #define __put_user_x(size, x, ptr, __ret_pu)			\
 	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+		     : "a" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 
 
-- 
1.6.5.3

