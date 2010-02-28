Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968069Ab0B1OHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 09:07:23 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44447 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966548Ab0B1OHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:07:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i2sbKw4fH/XkcRbIYHaUi7wMJla4VWjQzAqQbhvJGCsv+1FxdktP/fQiBZzKly+l/m
         FeR5Ix7fvAb8e+kqv8VzFokMCzflNyslZUDA12hAmXZK3ou6lxKMyEZyuj3ZsNRp+6S3
         8DT0OpUv5zZcMJx+fqvsk+41lxmQEsdeq1zWs=
MIME-Version: 1.0
In-Reply-To: <10f740e81002280204q2849317bj3e7d22c5c0c93333@mail.gmail.com>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
	 <20100224162152.GK3687@quack.suse.cz>
	 <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
	 <10f740e81002250050g287f7753g96063376ecee9487@mail.gmail.com>
	 <961aa3351002250629p11fc4a49m60aadbf79fc10696@mail.gmail.com>
	 <10f740e81002280204q2849317bj3e7d22c5c0c93333@mail.gmail.com>
Date: Sun, 28 Feb 2010 15:07:17 +0100
X-Google-Sender-Auth: 66c033b2454af88c
Message-ID: <10f740e81002280607p2ec5ec7eya6d6c2cc694b4733@mail.gmail.com>
Subject: Re: [PATCH] udf: use ext2_find_next_bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       Linux-Next <linux-next@vger.kernel.org>,
       linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 11:04, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Feb 25, 2010 at 15:29, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> 2010/2/25 Geert Uytterhoeven <geert@linux-m68k.org>:
>>> On Thu, Feb 25, 2010 at 02:38, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>>> 2010/2/25 Jan Kara <jack@suse.cz>:
>>>>> On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
>>>>>> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
>>>>>> in little endian bitmap region.
>>>
>>> Is any of this in linux-next now?
>>>
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/2208481/
>>> | fs/udf/balloc.c:274: error: implicit declaration of function
>>> 'generic_find_next_le_bit'
>>
>> Yep, Jan's patch caused the build breakage.
>>
>> Because generic_find_next_le_bit() is not available for all
>> archtectures. So we should use ext2_find_next_bit() here.
>
> Most architectures use the definitions in asm-generic, so they're OK.
> M68k doesn't. S390 is also affected, and I think arm as well (but there's no
> arm all-modconfig build in linux-next, so I'm not 100% sure).
>
> I'm cooking a patch...

>From c9b5c7e6ef2092be822778a0b6b3d3032c058f5b Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 28 Feb 2010 13:06:27 +0100
Subject: [PATCH] m68k: Implement generic_find_next_{zero_,}le_bit()

linux-next:
fs/udf/balloc.c: In function 'udf_bitmap_new_block':
fs/udf/balloc.c:274: error: implicit declaration of function
'generic_find_next_le_bit'

Convert ext2_find_next_{zero_,}bit() into generic_find_next_{zero_,}le_bit(),
and wrap the ext2_find_next_{zero_,}bit() around the latter.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/bitops_mm.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h
b/arch/m68k/include/asm/bitops_mm.h
index 9bde784..b4ecdaa 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -365,6 +365,10 @@ static inline int minix_test_bit(int nr, const void *vaddr)
 #define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^
24, (unsigned long *)(addr))
 #define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24,
(unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr)
^ 24, (unsigned long *)(addr))
+#define ext2_find_next_zero_bit(addr, size, offset) \
+	generic_find_next_zero_le_bit((unsigned long *)addr, size, offset)
+#define ext2_find_next_bit(addr, size, offset) \
+	generic_find_next_le_bit((unsigned long *)addr, size, offset)

 static inline int ext2_test_bit(int nr, const void *vaddr)
 {
@@ -394,10 +398,9 @@ static inline int ext2_find_first_zero_bit(const
void *vaddr, unsigned size)
 	return (p - addr) * 32 + res;
 }

-static inline int ext2_find_next_zero_bit(const void *vaddr, unsigned size,
-					  unsigned offset)
+static inline unsigned long generic_find_next_zero_le_bit(const
unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
-	const unsigned long *addr = vaddr;
 	const unsigned long *p = addr + (offset >> 5);
 	int bit = offset & 31UL, res;

@@ -437,10 +440,9 @@ static inline int ext2_find_first_bit(const void
*vaddr, unsigned size)
 	return (p - addr) * 32 + res;
 }

-static inline int ext2_find_next_bit(const void *vaddr, unsigned size,
-				     unsigned offset)
+static inline unsigned long generic_find_next_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
-	const unsigned long *addr = vaddr;
 	const unsigned long *p = addr + (offset >> 5);
 	int bit = offset & 31UL, res;

-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
