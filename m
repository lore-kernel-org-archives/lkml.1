Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYFPXJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYFPXJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYFPXJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:09:00 -0400
Received: from gw.goop.org ([64.81.55.164]:46515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYFPXI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:08:59 -0400
Message-ID: <4856F261.9040504@goop.org>
Date: Mon, 16 Jun 2008 16:08:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make asm/asm.h work for asm code.
References: <4856E3D3.2010207@goop.org> <4856EDD3.4080808@kernel.org>
In-Reply-To: <4856EDD3.4080808@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> This is useful for unifying some pieces of asm code.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Thinking about it some more, this should be possible to do cleaner 
> like this:

OK, how about this...

    J

Subject: x86: make asm/asm.h work for asm code.

This is useful for unifying some pieces of asm code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/asm.h |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

===================================================================
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -1,33 +1,29 @@
 #ifndef _ASM_X86_ASM_H
 #define _ASM_X86_ASM_H
 
+#ifdef __ASSEMBLY__
+# define __ASM_FORM(x)	x
+#else
+# define __ASM_FORM(x)	" " #x " "
+#endif
+
 #ifdef CONFIG_X86_32
-/* 32 bits */
+# define __ASM_SEL(a,b) __ASM_FORM(a)
+#else
+# define __ASM_SEL(a,b) __ASM_FORM(b)
+#endif
 
-# define _ASM_PTR	" .long "
-# define _ASM_ALIGN	" .balign 4 "
-# define _ASM_MOV_UL	" movl "
+#define __ASM_SIZE(inst)	__ASM_SEL(inst##l, inst##q)
 
-# define _ASM_INC	" incl "
-# define _ASM_DEC	" decl "
-# define _ASM_ADD	" addl "
-# define _ASM_SUB	" subl "
-# define _ASM_XADD	" xaddl "
+#define _ASM_PTR	__ASM_SEL(.long, .quad)
+#define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
+#define _ASM_MOV_UL	__ASM_SIZE(mov)
 
-#else
-/* 64 bits */
-
-# define _ASM_PTR	" .quad "
-# define _ASM_ALIGN	" .balign 8 "
-# define _ASM_MOV_UL	" movq "
-
-# define _ASM_INC	" incq "
-# define _ASM_DEC	" decq "
-# define _ASM_ADD	" addq "
-# define _ASM_SUB	" subq "
-# define _ASM_XADD	" xaddq "
-
-#endif /* CONFIG_X86_32 */
+#define _ASM_INC	__ASM_SIZE(inc)
+#define _ASM_DEC	__ASM_SIZE(dec)
+#define _ASM_ADD	__ASM_SIZE(add)
+#define _ASM_SUB	__ASM_SIZE(sub)
+#define _ASM_XADD	__ASM_SIZE(xadd)
 
 /* Exception table entry */
 # define _ASM_EXTABLE(from,to) \


