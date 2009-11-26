Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZKZLHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZKZLHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZKZLHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:07:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60258 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZKZLHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=uKC2cSvbj9PrtLNpKirhptaP7PXTWibuYUI27LG4q0p9HgxB0XnIdQdieo7xEy1Oxm
         AWLsIrX+DaysDyk7MYiAZw1plNDUl0vH86/BaAb2syCJ4l6jr9F3ZsjRm7IlB2f/EetS
         kuylQ2tqTZx6eOsiqxMO6dmYG/RRhQSbpoKQA=
Message-ID: <4B0E6189.6050708@gmail.com>
Date: Thu, 26 Nov 2009 13:07:53 +0200
From: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Memset of length zero bugs
References: <20091111215703.GA24390@redhat.com>
In-Reply-To: <20091111215703.GA24390@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080003060401060101060902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080003060401060101060902
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 2009-11-11 23:57, Dave Jones wrote:
> Nearly every invocation of memset in drivers/staging/hv/StorVsc.c
> has it's arguments the wrong way around.
Hi,

I found 2 more bugs like this in v2.6.32-rc8-11-ga8a8a66 by letting gcc
warn in such cases on an allyesconfig build.
I used the attached patch (meant to be used only to find bugs, linking
fails).

Here are the warnings:
1. Wrong parameter order
In function ‘memset’,
inlined from ‘ir_input_init’ at drivers/media/common/ir-functions.c:67:
/home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
warning: call to ‘__warn_memset_zero_len’ declared with attribute
warning: memset used with constant zero length parameter; this could be
due to transposed parameters
memset(ir->ir_codes, sizeof(ir->ir_codes), 0);

2. pgsize variable (and hence length argument) is always zero.

In function ‘memset’,
inlined from ‘erasecrosstest’ at drivers/mtd/tests/mtd_pagetest.c:345:
/home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
warning: call to ‘__warn_memset_zero_len’ declared with attribute
warning: memset used with constant zero length parameter; this could be
due to transposed parameters
memset(readbuf, 0, pgsize);
In function ‘memset’,
inlined from ‘erasecrosstest’ at drivers/mtd/tests/mtd_pagetest.c:384:
/home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
warning: call to ‘__warn_memset_zero_len’ declared with attribute
warning: memset used with constant zero length parameter; this could be
due to transposed parameters
In function ‘memset’,
inlined from ‘crosstest’ at drivers/mtd/tests/mtd_pagetest.c:219:
/home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
warning: call to ‘__warn_memset_zero_len’ declared with attribute
warning: memset used with constant zero length parameter; this could be
due to transposed parameters

Now this one is interesting, the memsets are fine, however pgsize is
always zero, it is declared as 'static int pgsize' and never assigned a
value (hence it is always zero).
I didn't look at what mtd_pagetest wants to test, but the name suggests
that a pagesize of zero isn't a very useful test.

Best regards,
--Edwin

--------------080003060401060101060902
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..cddefb7 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -52,7 +52,17 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 #endif
 
 #define __HAVE_ARCH_MEMSET
-void *memset(void *s, int c, size_t n);
+extern void __warn_memset_zero_len (void) __attribute__((__warning__ ("memset used with constant zero length parameter; this could be due to transposed parameters")));
+extern __inline __attribute__ ((__always_inline__)) __attribute__ ((__artificial__)) void *
+__attribute__ ((__nothrow__)) memset (void *__dest, int __ch, size_t __len)
+{
+  if (__builtin_constant_p (__len) && __len == 0)
+    {
+      __warn_memset_zero_len ();
+      return __dest;
+    }
+  return __builtin___memset_chk (__dest, __ch, __len, __builtin_object_size (__dest, 0));
+}
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);

--------------080003060401060101060902--
