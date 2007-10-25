Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXJYDXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXJYDXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXJYDX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:23:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60591 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXJYDX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:23:28 -0400
Date: Wed, 24 Oct 2007 21:23:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071025032327.GI27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx> <0533759C-81D0-45CB-A663-088A6D4E56A9@mac.com> <20071024212110.GG27248@parisc-linux.org> <314B5322-3575-4449-90D2-3068BDC3F64D@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <314B5322-3575-4449-90D2-3068BDC3F64D@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 08:07:23PM -0400, Kyle Moffett wrote:
> No, the problem is what happens when you don't have enough space  
> allocated:  you call "vsnprintf(s, len, format, args);" and then  
> later call "vsprintf(s, format, args);" with the *SAME* "args".   
> That's what's broken.

Ah, gotcha.  I don't really like the va_copy idea, and I don't like the idea of having sb_printf call sb_vprintf twice ... how about just doing away with sb_vprintf altogether:

diff --git a/include/linux/stringbuf.h b/include/linux/stringbuf.h
index c030bc6..ae5c02f 100644
--- a/include/linux/stringbuf.h
+++ b/include/linux/stringbuf.h
@@ -57,11 +57,6 @@ static inline void sb_free(struct stringbuf *sb)
 
 extern void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
 	__attribute__((format(printf, 3, 4)));
-#if 0
-/* Waiting for a user to show up */
-extern void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *fmt,
-			va_list args) __attribute__((format(printf, 3, 0)));
-#endif
 
 /*
  * Convert the stringbuf to a string.  It is the caller's responsibility
diff --git a/lib/stringbuf.c b/lib/stringbuf.c
index b4e59f4..691fcd1 100644
--- a/lib/stringbuf.c
+++ b/lib/stringbuf.c
@@ -22,12 +22,9 @@
 #define INITIAL_SIZE 128
 #define ERR_STRING "out of memory"
 
-/*
- * Not currently used outside this file, but separated from sb_printf
- * for when someone needs it.
- */
-static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *format, va_list args)
+void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *format, ...)
 {
+	va_list args;
 	char *s;
 	int size, newlen;
 
@@ -41,7 +38,9 @@ static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *format, va_l
 	}
 
 	s = sb->buf + sb->len;
+	va_start(args, format);
 	size = vsnprintf(s, sb->alloc - sb->len, format, args);
+	va_end(args);
 
 	sb->len += size;
 	if (likely(sb->len < sb->alloc))
@@ -61,7 +60,9 @@ static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *format, va_l
 
 	/* Point to the end of the old string since we already updated ->len */
 	s += sb->len - size;
+	va_start(args, format);
 	vsprintf(s, format, args);
+	va_end(args);
 	return;
 
  nomem:
@@ -70,16 +71,4 @@ static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *format, va_l
 	sb->len = sizeof(ERR_STRING);
 	sb->alloc = -ENOMEM;
 }
-/* When we get our first modular user, delete this comment
-EXPORT_SYMBOL(sb_vprintf);
-*/
-
-void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *format, ...)
-{
-	va_list args;
-
-	va_start(args, format);
-	sb_vprintf(sb, gfp, format, args);
-	va_end(args);
-}
 EXPORT_SYMBOL(sb_printf);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
