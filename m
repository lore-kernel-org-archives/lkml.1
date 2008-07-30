Return-Path: <linux-kernel-owner+w=401wt.eu-S1761087AbYG3MIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087AbYG3MIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYG3MIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:08:00 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:17157 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbYG3MH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=CtD0/CsBiyTR4Rllelu+q5FX0aYkOvmT/oKtUyIv6XKuhY8zGucw//b3TlTW19IuD5
         v1cb3fc8icuolRhe293ZhfZT25IDOGs9+cgbksUPAssN1PEZygQtrvS0jQq8/06bggOc
         Z+SAkRbj+GFuE42DN5EPkgcjRnq6JXqRjki3Q=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
Date: Wed, 30 Jul 2008 14:07:58 +0200
In-Reply-To: <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 28 Jul 2008 08:48:41 -0700 (PDT)")
Message-ID: <m3hca760dd.fsf@gravicappa.englab.brq.redhat.com>
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

Optimize tail handling with regarding to flags passed to handler
routine.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f4df6e7..d793900 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -161,23 +161,32 @@ EXPORT_SYMBOL(copy_in_user);
 /*
  * Try to copy last bytes and clear the rest if needed.
  * Since protection fault in copy_from/to_user is not a normal situation,
- * it is not necessary to optimize tail handling.
+ * it is not necessary to do low level optimization of tail handling.
  */
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
+copy_user_handle_tail(char *dst, char *src, unsigned remainder, unsigned flags)
 {
 	char c;
-	unsigned zero_len;
+	unsigned max_copy = remainder;
 
-	for (; len; --len) {
-		if (__get_user_nocheck(c, from++, sizeof(char)))
+	/* Don't even bother trying to cross a page in user space! */
+	if (flags & DEST_IS_USERSPACE)
+		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(dst));
+	if (flags & SOURCE_IS_USERSPACE)
+		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(src));
+
+	while (max_copy--) {
+		if (__get_user(c, src))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user(c, dst))
 			break;
+		src++;
+		dst++;
+		remainder--;
 	}
 
-	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
-		if (__put_user_nocheck(c, to++, sizeof(char)))
-			break;
-	return len;
+	if (flags & CLEAR_REMAINDER)
+		memset(dst, 0, remainder);
+
+	return remainder;
 }

-- 
wbr, Vitaly
