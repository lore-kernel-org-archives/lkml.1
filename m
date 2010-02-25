Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab0BYBi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:38:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:59232 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab0BYBi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g9O/MipTOdBwK0WxS4zefAvYUSaMyJ1pT4dhT+GFF4HD/a9d5MlVU2Tqb4c6kNFIAl
         x0ybeuY9NXt8l7k162x8zjjH6ULxnVFCzh7uKo/zVcKBFFcKPWxx8nbpPIQWVwtE5YBF
         O0LLBzkMmXR7/Cs98J/pN14vZhKwFDgMp8Qw8=
MIME-Version: 1.0
In-Reply-To: <20100224162152.GK3687@quack.suse.cz>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
	 <20100224162152.GK3687@quack.suse.cz>
Date: Thu, 25 Feb 2010 10:38:25 +0900
Message-ID: <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
Subject: Re: [PATCH] udf: use ext2_find_next_bit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/25 Jan Kara <jack@suse.cz>:
> On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
>> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
>> in little endian bitmap region.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Jan Kara <jack@suse.cz>
>  I've looked at the code and I think this is wrong. UDF uses 1 for free
> block in the bitmap and 0 for used one. So you need to use
> generic_find_next_le_bit...
>  Something like the patch below?

According to include/asm-generic/bitops/ext2-non-atomic.h,
generic_find_next_le_bit() == ext2_find_next_bit().

So, is there any difference between my patch and yours?
Or am I missing something?

BTW, I realized that udf_find_first_one_bit() macro is not used.
So you can remove it in this patch.

>                                                                Honza
>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> ---
>
> From bfc8c674188d4be5856e445f9b57e1b7a3dbff6d Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 24 Feb 2010 17:18:57 +0100
> Subject: [PATCH] udf: Use generic function for bit searching
>
> Use generic_find_next_le_bit to search for bits in bitmap so
> that we don't duplicate code unnecessarily.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/balloc.c |   51 ++-------------------------------------------------
>  1 files changed, 2 insertions(+), 49 deletions(-)
>
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index 82372e3..f5ff06c 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -31,55 +31,8 @@
>  #define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
>  #define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
>  #define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
> -#define udf_find_first_one_bit(addr, size) find_first_one_bit(addr, size)
>  #define udf_find_next_one_bit(addr, size, offset) \
> -               find_next_one_bit(addr, size, offset)
> -
> -#define leBPL_to_cpup(x) leNUM_to_cpup(BITS_PER_LONG, x)
> -#define leNUM_to_cpup(x, y) xleNUM_to_cpup(x, y)
> -#define xleNUM_to_cpup(x, y) (le ## x ## _to_cpup(y))
> -#define uintBPL_t uint(BITS_PER_LONG)
> -#define uint(x) xuint(x)
> -#define xuint(x) __le ## x
> -
> -static inline int find_next_one_bit(void *addr, int size, int offset)
> -{
> -       uintBPL_t *p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
> -       int result = offset & ~(BITS_PER_LONG - 1);
> -       unsigned long tmp;
> -
> -       if (offset >= size)
> -               return size;
> -       size -= result;
> -       offset &= (BITS_PER_LONG - 1);
> -       if (offset) {
> -               tmp = leBPL_to_cpup(p++);
> -               tmp &= ~0UL << offset;
> -               if (size < BITS_PER_LONG)
> -                       goto found_first;
> -               if (tmp)
> -                       goto found_middle;
> -               size -= BITS_PER_LONG;
> -               result += BITS_PER_LONG;
> -       }
> -       while (size & ~(BITS_PER_LONG - 1)) {
> -               tmp = leBPL_to_cpup(p++);
> -               if (tmp)
> -                       goto found_middle;
> -               result += BITS_PER_LONG;
> -               size -= BITS_PER_LONG;
> -       }
> -       if (!size)
> -               return result;
> -       tmp = leBPL_to_cpup(p);
> -found_first:
> -       tmp &= ~0UL >> (BITS_PER_LONG - size);
> -found_middle:
> -       return result + ffz(~tmp);
> -}
> -
> -#define find_first_one_bit(addr, size)\
> -       find_next_one_bit((addr), (size), 0)
> +               generic_find_next_le_bit((unsigned long *)addr, size, offset)
>
>  static int read_block_bitmap(struct super_block *sb,
>                             struct udf_bitmap *bitmap, unsigned int block,
> @@ -356,7 +309,7 @@ repeat:
>                                break;
>                        }
>                } else {
> -                       bit = udf_find_next_one_bit((char *)bh->b_data,
> +                       bit = udf_find_next_one_bit(bh->b_data,
>                                                    sb->s_blocksize << 3,
>                                                    group_start << 3);
>                        if (bit < sb->s_blocksize << 3)
> --
> 1.6.4.2
>
>
