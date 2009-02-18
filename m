Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZBRWuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZBRWuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbZBRWnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:43:41 -0500
Received: from ozlabs.org ([203.10.76.45]:35486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760881AbZBRWnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:43:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
Date: Thu, 19 Feb 2009 09:13:26 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <20090218224541.fe6e0355.sfr@canb.auug.org.au> <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
In-Reply-To: <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902190913.27653.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 03:40:59 Mike Frysinger wrote:
> On Wed, Feb 18, 2009 at 06:45, Stephen Rothwell wrote:
> > That would be a side effect of commit 43a47c6ca0e0b5479ae316e188a28b7e625d41e5 ("misc:strstarts") from the rr tree.  Rusty cc'd.
> 
> breaks all Blackfin ports as well:

My first reaction was WTF?  My second was, how did our string code become
such a catastrophe?

Sorry, I had no idea what a mess I was wading into.

Here's the s390 fix:

Subject: s390: allow usage of string functions in linux/string.h

In introducing a trivial "strstarts()" function in linux/string.h, we
hit the following error on s390:

In file included from include/linux/bitmap.h:8,
                 from include/linux/cpumask.h:142,
                 from include/linux/smp.h:12,
                 from /home/rusty/devel/kernel/patches/linux-2.6/arch/s390/include/asm/spinlock.h:14,
                 from include/linux/spinlock.h:88,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from arch/s390/lib/string.c:13:
include/linux/string.h: In function 'strstarts':
include/linux/string.h:124: error: implicit declaration of function 'strlen'
include/linux/string.h:124: warning: incompatible implicit declaration of built-in function 'strlen'

Because when including asm/string.h from arch/s390/lib/string.c we
don't declare the string ops we are about to define, and
linux/string.h barfs.

The fix is to declare them in this IN_ARCH_STRING_C case, but in
general I wonder if there's a neater fix.

Reported-by: linux-next
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/s390/include/asm/string.h b/arch/s390/include/asm/string.h
--- a/arch/s390/include/asm/string.h
+++ b/arch/s390/include/asm/string.h
@@ -135,7 +135,13 @@ static inline size_t strnlen(const char 
 		: "+a" (end), "+a" (tmp) : "d" (r0)  : "cc");
 	return end - s;
 }
-
+#else /* IN_ARCH_STRING_C */
+void *memchr(const void * s, int c, size_t n);
+void *memscan(void *s, int c, size_t n);
+char *strcat(char *dst, const char *src);
+char *strcpy(char *dst, const char *src);
+size_t strlen(const char *s);
+size_t strnlen(const char * s, size_t n);
 #endif /* !IN_ARCH_STRING_C */
 
 #endif /* __KERNEL__ */
