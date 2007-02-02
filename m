Return-Path: <linux-kernel-owner+w=401wt.eu-S1423033AbXBBAfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423033AbXBBAfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423035AbXBBAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:35:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:31562 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423033AbXBBAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WyeZQ5OTm9cxoaGkM1b+zA1PJtTUdjrIr39vkilXjWBhLyUjLYJ7Bc8XBo+5pu1gqYs2JKjDXzoO3rqrvVfPdOgKnqKygjJkwbMjsmssbU6Q8aNbpbYuvh3LQ/gyvkZveGEeSEfjxcVWc9ZzstzByuQ5TG+UnQEgAZdGew4amcU=
Message-ID: <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com>
Date: Thu, 1 Feb 2007 16:35:44 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32) __iomem *addr?
In-Reply-To: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I wrote this:
> (This is not an ARM-specific question, although the example is on ARM.)
and then sent it to linux-arm-kernel anyway.  :-P


I'm writing an ALSA driver for an ARM SoC whose PCM audio interface is
MMIO.  ALSA provides copy_from_user_toio and copy_to_user_fromio
routines for this purpose, but the results are not sane, perhaps
because STMIA to I/O addresses is bollixed on this core.  I suspect
that the right thing to do is to use iowrite32_rep and ioread32_rep,
approximately like so (slightly modified ALSA code):

/**
 * copy_u32s_to_user_fromio - copy data from mmio-space to user-space
 * @dst: the destination pointer on user-space
 * @src: the source pointer on mmio
 * @count: the data size to copy in u32s
 *
 * Copies the data from mmio-space to user-space.
 *
 * Returns zero if successful, or non-zero on failure.
 */
static int copy_u32s_to_user_fromio(void __user *dst, const volatile
void __iomem *src, size_t count)
{
        u32 buf[80];
        count <<= 2;
        while (count) {
                size_t c = count;
                if (c > sizeof(buf))
                        c = sizeof(buf);
                ioread32_rep(src, buf, c>>2);
                if (copy_to_user(dst, buf, c))
                        return -EFAULT;
                count -= c;
                dst += c;
                src += c;
        }
        return 0;
}

/**
 * copy_u32s_from_user_toio - copy data from user-space to mmio-space
 * @dst: the destination pointer on mmio-space
 * @src: the source pointer on user-space
 * @count: the data size to copy in u32s
 *
 * Copies the data from user-space to mmio-space.
 *
 * Returns zero if successful, or non-zero on failure.
 */
static int copy_u32s_from_user_toio(volatile void __iomem *dst, const
void __user *src, size_t count)
{
        u32 buf[80];
        count <<= 2;
        while (count) {
                size_t c = count;
                if (c > sizeof(buf))
                        c = sizeof(buf);
                if (copy_from_user(buf, src, c))
                        return -EFAULT;
                iowrite32_rep(dst, buf, c>>2);
                count -= c;
                dst += c;
                src += c;
        }
        return 0;
}

Compiling (with GCC 4.1.2 RC1) gives these warnings:

foo.c: In function 'copy_u32s_to_user_fromio':
foo.c:56: warning: passing argument 1 of '__raw_readsl' discards
qualifiers from pointer target type
foo.c: In function 'copy_u32s_from_user_toio':
foo.c:86: warning: passing argument 1 of '__raw_writesl' discards
qualifiers from pointer target type

The qualifiers being discarded are the "volatile"s, which are indeed
not present in the declarations of these functions (which happen to be
ARM's implementation of io(read|write)32_rep):

include/asm-arm/io.h:extern void __raw_writesb(void __iomem *addr,
const void *data, int bytelen);
include/asm-arm/io.h:extern void __raw_writesw(void __iomem *addr,
const void *data, int wordlen);
include/asm-arm/io.h:extern void __raw_writesl(void __iomem *addr,
const void *data, int longlen);
include/asm-arm/io.h:extern void __raw_readsb(const void __iomem
*addr, void *data, int bytelen);
include/asm-arm/io.h:extern void __raw_readsw(const void __iomem
*addr, void *data, int wordlen);
include/asm-arm/io.h:extern void __raw_readsl(const void __iomem
*addr, void *data, int longlen);

It looks to me, by comparison to memcpy_(from|to)io, as if the
volatiles ought to be there.  It also looks to me like the void *
parameters should be u(8|16|32) * instead, so the compiler knows what
alignment to expect (the implementations would generally fail or suck
on non-aligned arguments).  (That would also be more consistent with
the fact that the length parameters are in (8|16|32)-bit units, not
octets.)

Opinions?

Cheers,
- Michael
