Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXD0JMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXD0JMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXD0JMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:12:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXD0JM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:12:28 -0400
Date: Fri, 27 Apr 2007 02:11:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "l l" <happyarch@gmail.com>
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: linux-2.6.21 and __udivid3
Message-Id: <20070427021135.0e8afbc1.akpm@linux-foundation.org>
In-Reply-To: <768a59a70704261756x5b588ef0y3a3ac9460e437b89@mail.gmail.com>
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
	<20070426175526.GR3468@stusta.de>
	<768a59a70704261730hbe4a987oa54f65e85d0ceda4@mail.gmail.com>
	<768a59a70704261756x5b588ef0y3a3ac9460e437b89@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 09:56:03 +0900 "l l" <happyarch@gmail.com> wrote:

> Here is another compilation failure.
> 
> make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC [M]  drivers/w1/w1.o
> drivers/w1/w1.c: In function 'w1_slave_read_id':
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
> make[2]: *** [drivers/w1/w1.o] Error 1
> make[1]: *** [drivers/w1] Error 2
> make: *** [drivers] Error 2

hm,

		memcpy(buf, (u8 *)&sl->reg_num, count);

and

struct w1_reg_num
{
#if defined(__LITTLE_ENDIAN_BITFIELD)
	__u64	family:8,
		id:48,
		crc:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
	__u64	crc:8,
		id:48,
		family:8;
#else
#error "Please fix <asm/byteorder.h>"
#endif
};

the compiler is being a bit pedantic there, IMO.  What version of gcc are
you using?

Does this help?


--- a/drivers/w1/w1.h~w1-build-fix
+++ a/drivers/w1/w1.h
@@ -22,19 +22,23 @@
 #ifndef __W1_H
 #define __W1_H
 
-struct w1_reg_num
-{
+struct w1_reg_num {
+	union {
+		__u64 unused;	/* So gcc will permit pointers to this struct */
+		struct {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u64	family:8,
-		id:48,
-		crc:8;
+			__u64	family:8,
+				id:48,
+				crc:8;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u64	crc:8,
-		id:48,
-		family:8;
+			__u64	crc:8,
+				id:48,
+				family:8;
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
+		};
+	};
 };
 
 #ifdef __KERNEL__
_

