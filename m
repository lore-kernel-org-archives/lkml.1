Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXIFXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXIFXDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbXIFXDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:03:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932444AbXIFXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:03:00 -0400
Date: Thu, 6 Sep 2007 16:00:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
Message-Id: <20070906160009.fa52e8d2.akpm@linux-foundation.org>
In-Reply-To: <20070906184011.GA1776@Krystal>
References: <20070906184011.GA1776@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 6 Sep 2007 14:40:11 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Hi Andrew,
> 
> Guess what, another one ;)
> 
>   /opt/crosstool/gcc-4.1.1-glibc-2.3.6/powerpc-405-linux-gnu/bin/powerpc-405-linux-gnu-gcc -m32 -Wp,-MD,arch/ppc/kernel/.asm-offsets.s.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.1-glibc-2.3.6/powerpc-405-linux-gnu/lib/gcc/powerpc-405-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -Iarch/ppc -Iarch/ppc/include -I/home/compudj/git/linux-2.6-lttng/. -I. -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -I/home/compudj/git/linux-2.6-lttng/arch/ppc -Iarch/ppc -msoft-float -pipe -ffixed-r2 -mmultiple -mno-altivec -mstring -Wa,-m405 -fomit-frame-pointer -g -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"  -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o arch/ppc/kernel/asm-offsets.s /home/compudj/git/linux-2.6-lttng/arc!
 h/ppc/kernel/asm-offsets.c
> In file included from /home/compudj/git/linux-2.6-lttng/include/linux/bitops.h:17,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/kernel.h:15,
>                  from include2/asm/system.h:7,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/list.h:9,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/signal.h:8,
>                  from /home/compudj/git/linux-2.6-lttng/arch/ppc/kernel/asm-offsets.c:11:
> arch/ppc/include/asm/bitops.h: In function '__clear_bit_unlock':
> arch/ppc/include/asm/bitops.h:229: error: expected string literal before ':' token
> arch/ppc/include/asm/bitops.h:229: confused by earlier errors, bailing out
> make[2]: *** [arch/ppc/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [_all] Error 2

What the heck is arch/ppc/include/asm/bitops.h?  I assume that it's
include/asm-powerpc/bitops.h via some wormhole.


If so, the finger points at this:

static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
{
	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
	__clear_bit(nr, addr);
}

which was added by Nick's powerpc-lock-bitops.patch.  I am suspecting that
this isn't pp32 code?

(what's with the newly-added old-style __inline__, btw?  That's just more
stuff we need to clean up later, so there doesn't seem much point in adding
it).

