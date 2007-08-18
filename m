Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXHRO4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXHRO4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXHRO4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:56:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXHRO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:56:14 -0400
Date: Sat, 18 Aug 2007 07:56:02 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: [PATCH] x86-64: memset optimization
Message-ID: <20070818075602.34350b25@freepuppy.rosehill.hemminger.net>
In-Reply-To: <200708181146.24399.ak@suse.de>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
	<200708181146.24399.ak@suse.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007 11:46:24 +0200
Andi Kleen <ak@suse.de> wrote:

> On Saturday 18 August 2007 01:34:46 Stephen Hemminger wrote:
> > Optimize uses of memset with small constant offsets.
> > This will generate smaller code, and avoid the slow rep/string instructions.
> > Code copied from i386 with a little cleanup.
> 
> 
> Newer gcc should do all this on its own.  That is why I intentionally
> didn't implement it on 64bit.
> 
> On what compiler version did you see smaller code?
> 
> -Andi
> 

The problem is that on x86-64 you are overriding memset() so the builtin
version doesn't kick in.  You allow gcc to inline memcpy but not memset.

What about adding code similar to memcpy() stuff.

--- a/include/asm-x86_64/string.h	2007-08-18 07:37:58.000000000 -0700
+++ b/include/asm-x86_64/string.h	2007-08-18 07:44:31.000000000 -0700
@@ -43,8 +43,13 @@ extern void *__memcpy(void *to, const vo
 	   __ret; }) 
 #endif
 
-#define __HAVE_ARCH_MEMSET
-void *memset(void *s, int c, size_t n);
+#define __HAVE_ARCH_MEMSET 1
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+extern void memset(void *s, int c, size_t n);
+#else
+#define memset(s, c, n) __builtin_memset((s),(c),(n))
+#endif
+
 
 #define __HAVE_ARCH_MEMMOVE
 void * memmove(void * dest,const void *src,size_t count);
