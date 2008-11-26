Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYKZUlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYKZUlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYKZUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:40:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbYKZUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:40:55 -0500
Date: Wed, 26 Nov 2008 12:40:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH-mm 3/7] unaligned: use generic implementation on
 packed-struct arches
Message-Id: <20081126124031.c709d597.akpm@linux-foundation.org>
In-Reply-To: <1226979551.6150.268.camel@brick>
References: <1226979551.6150.268.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 19:39:11 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> No functional changes, convert arches that use the packed-struct
> implementation for native-endianness and C byteshifting for the
> other endianness.

arch/sh has gone and changed things in linux-next.

> diff --git a/arch/sh/include/asm/unaligned.h b/arch/sh/include/asm/unaligned.h
> index c1641a0..abe2dd7 100644
> --- a/arch/sh/include/asm/unaligned.h
> +++ b/arch/sh/include/asm/unaligned.h
> @@ -1,19 +1,6 @@
>  #ifndef _ASM_SH_UNALIGNED_H
>  #define _ASM_SH_UNALIGNED_H
>  
> -/* SH can't handle unaligned accesses. */
> -#ifdef __LITTLE_ENDIAN__
> -# include <linux/unaligned/le_struct.h>
> -# include <linux/unaligned/be_byteshift.h>
> -# include <linux/unaligned/generic.h>
> -# define get_unaligned	__get_unaligned_le
> -# define put_unaligned	__put_unaligned_le
> -#else
> -# include <linux/unaligned/be_struct.h>
> -# include <linux/unaligned/le_byteshift.h>
> -# include <linux/unaligned/generic.h>
> -# define get_unaligned	__get_unaligned_be
> -# define put_unaligned	__put_unaligned_be
> -#endif
> +#include <asm-generic/unaligned.h>
>  
>  #endif /* _ASM_SH_UNALIGNED_H */

But this happened instead:

--- linux-2.6.28-rc6/arch/sh/include/asm/unaligned.h	2008-10-15 11:43:12.000000000 -0700
+++ 25/arch/sh/include/asm/unaligned.h	2008-11-26 12:32:18.000000000 -0800
@@ -1,7 +1,11 @@
 #ifndef _ASM_SH_UNALIGNED_H
 #define _ASM_SH_UNALIGNED_H
 
-/* SH can't handle unaligned accesses. */
+#ifdef CONFIG_CPU_SH4A
+/* SH-4A can handle unaligned loads in a relatively neutered fashion. */
+#include <asm/unaligned-sh4a.h>
+#else
+/* Otherwise, SH can't handle unaligned accesses. */
 #ifdef __LITTLE_ENDIAN__
 # include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
@@ -15,5 +19,6 @@
 # define get_unaligned	__get_unaligned_be
 # define put_unaligned	__put_unaligned_be
 #endif
+#endif
 
 #endif /* _ASM_SH_UNALIGNED_H */

It's a bit sad to create a new variant of the sh unaligned accessors
while Harvey is madly tugging everything in the opposite direction.

I am tempted to revise the patch by just blowing away the above
changes, so the new unaligned-sh4a.h just doesn't get used by anything.
However...

commit accccfb3d8c2cb65baf7cdfc74a2da4cdeee65ab
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Wed Nov 26 00:29:58 2008 +0900

    sh: Provide optimized unaligned loads on SH-4A.
    
    This adds support for unaligned loads on SH-4A, using the SH-4A's
    neutered movua.l instruction. As movua.l is r0-inspired, stores are
    still handled through the packed struct.
    
    Based on asm-generic/unaligned.h by Harvey Harrison.
    
    Signed-off-by: Paul Mundt <lethal@linux-sh.org>


so I'll just drop the sh hunk from
unaligned-use-generic-implementation-on-packed-struct-arches.patch, I
think.

