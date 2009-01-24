Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZAXS5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZAXS5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZAXS50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:57:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:37048 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZAXS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qEGlFk/D5nWRHC/ETUkp04YHpoAvLaYx8OgDy3EBSThMgVd/v+nASzi/qEqtcWLR40
         T1yThYLbXRL54FXYw26VTa4avOe6cmepuBNrCoJ3GRA/yHUi6liEam07KJDOZY05F829
         ZPq9l5ECVTWK53yKI50OX/u6WVoE5OvsYN3Dw=
Message-ID: <497B648E.7020805@gmail.com>
Date: Sat, 24 Jan 2009 20:57:18 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
Subject: Re: inline asm semantics: output constraint width smaller than input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu>
In-Reply-To: <20090124172758.GA31699@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-24 19:27, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>   
>>  #define put_user(x, ptr)                    \
>>  ({                                \
>> -    int __ret_pu;                        \
>> +    __typeof__(*(ptr)) __ret_pu;                \
>>     
>
> This does not look right. We can sometimes have put_user() of non-integer 
> types (say structures). 

I didn't encounter it with my .config, but it is certainly possible.
I think using __builtin_choose_expr would be better than the switch

See a new patch at the end of this mail, using __builtin_choose_expr.
[vmlinux size still same]
It also includes some 32-bit stuff, but that is not complete yet.

> How does the (int)__ret_pu cast work in that case? 
>   

It would fail at compile time, with an error message that you can't cast
aggregates to ints, so my patch is not good.

> We'll fall into this branch in that case:
>
>         default:                                                \
>                 __put_user_x(X, __pu_val, ptr, __ret_pu);       \
>                 break;                                          \
>
> and __ret_pu has a nonsensical type in that case.
>   

That branch is a call to a non-existent function __put_user_X, and
should give error at link time, right?
In the new patch below I used (void)-EFAULT so that you would get an
error at compile time (as suggested
in __builtin_choose_expr in gcc's manual), if that branch would ever get
expanded. Does that sound right?

>   
>>      __typeof__(*(ptr)) __pu_val;                \
>>      __chk_user_ptr(ptr);                    \
>>      might_fault();                        \
>>      __pu_val = x;                        \
>> +       /* return value is 0 or -EFAULT, both fit in 1 byte, and \
>> +    * are sign-extendable to int */                \
>>      switch (sizeof(*(ptr))) {                \
>>      case 1:                            \
>>          __put_user_x(1, __pu_val, ptr, __ret_pu);    \
>> @@ -261,7 +263,7 @@ extern void __put_user_8(void);
>>          __put_user_x(X, __pu_val, ptr, __ret_pu);    \
>>          break;                        \
>>      }                            \
>> -    __ret_pu;                        \
>> +    (int)__ret_pu;                        \
>>  })
>>  
>>  #define __put_user_size(x, ptr, size, retval, errret)            \
>> diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
>> index f456860..12d27f8 100644
>> --- a/arch/x86/lib/delay.c
>> +++ b/arch/x86/lib/delay.c
>> @@ -112,7 +112,7 @@ EXPORT_SYMBOL(__delay);
>>  
>>  inline void __const_udelay(unsigned long xloops)
>>  {
>> -    int d0;
>> +    unsigned long d0;
>>  
>>      xloops *= 4;
>>      asm("mull %%edx"
>>     
>
> Is this all that you need (plus the 16-bit setup code tweaks)

The 16-bit setup code is compiled, but obviously doesn't work.
I think the best approach would be for LLVM to give a warning/error, when
-fno-unit-at-a-time is used, since it doesn't support that.

>  to get LLVM 
> to successfully build a 64-bit kernel image?
>   

With the .config I sent previously, yes. With some other .config most
likely more changes are needed,
for example the SMP code, KVM code, but as I said in my previous email I
don't know how to "fix" the inline asm in that case.

There's something wrong with building some modules also, I keep getting
an "idr_init" undefined error, but the symbol is present in my vmlinux.
If I turn make those modules built into the kernel it works then (sctp,
w1, thermalsysfs).

It looks like I'll also have to submit some patches for ARCH=um, because
I get undefined references to __bad_size, __guard, and

__stack_smash_handler. __bad_size is probably because LLVM didn't inline expand + DCE something GCC did.


With an unpatched LLVM I would also need weak attributes to be on the
function type, instead of the return type,
but I think thats an LLVM bug, and a one-line patch corrects it.

> If yes then this doesnt look all that bad or invasive at first sight (if 
> the put_user() workaround can be expressed in a cleaner way), but in any 
> case it would be nice to hear an LLVM person's opinion about roughly when 
> this is going to be solved in LLVM itself.
>   

Yes, that is why LLVMDev is on Cc:, somebody will eventually reply ;)


Not-Signed-off-by: Török Edwin <edwintorok@gmail.com>
---

 arch/x86/include/asm/uaccess.h |   41
+++++++++++++++++++--------------------
 arch/x86/lib/delay.c           |    2 +-
 arch/x86/pci/pcbios.c          |    4 ++-
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 69d2757..46d00a8 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -154,7 +154,7 @@ extern int __get_user_bad(void);
 
 #define get_user(x, ptr)                        \
 ({                                    \
-    int __ret_gu;                            \
+    unsigned long __ret_gu;                        \
     unsigned long __val_gu;                        \
     __chk_user_ptr(ptr);                        \
     might_fault();                            \
@@ -176,7 +176,7 @@ extern int __get_user_bad(void);
         break;                            \
     }                                \
     (x) = (__typeof__(*(ptr)))__val_gu;                \
-    __ret_gu;                            \
+    (int)__ret_gu;                            \
 })
 
 #define __put_user_x(size, x, ptr, __ret_pu)            \
@@ -200,12 +200,15 @@ extern int __get_user_bad(void);
              : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
 
 #define __put_user_x8(x, ptr, __ret_pu)                \
-    asm volatile("call __put_user_8" : "=a" (__ret_pu)    \
-             : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+    ({ u32 __ret_pu;\
+     asm volatile("call __put_user_8" : "=a" (__ret_pu)    \
+             : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx");\
+     (int)__ret_pu;})
 #else
 #define __put_user_asm_u64(x, ptr, retval) \
     __put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
-#define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
+#define __put_user_x8(x, ptr, __ret_pu) \
+    ({ u64 __ret_pu; __put_user_x(8, x, ptr, __ret_pu); (int)__ret_pu; })
 #endif
 
 extern void __put_user_bad(void);
@@ -239,29 +242,25 @@ extern void __put_user_8(void);
  */
 #define put_user(x, ptr)                    \
 ({                                \
-    int __ret_pu;                        \
     __typeof__(*(ptr)) __pu_val;                \
     __chk_user_ptr(ptr);                    \
     might_fault();                        \
     __pu_val = x;                        \
-    switch (sizeof(*(ptr))) {                \
-    case 1:                            \
+    __builtin_choose_expr(sizeof(*(ptr)) == 1,        \
+        ({  u8 __ret_pu;                    \
         __put_user_x(1, __pu_val, ptr, __ret_pu);    \
-        break;                        \
-    case 2:                            \
+            (int)__ret_pu;}),                \
+    __builtin_choose_expr(sizeof(*(ptr)) == 2,        \
+            ({  u16 __ret_pu;                    \
         __put_user_x(2, __pu_val, ptr, __ret_pu);    \
-        break;                        \
-    case 4:                            \
+            (int)__ret_pu;}),                \
+    __builtin_choose_expr(sizeof(*(ptr)) == 4,        \
+        ({  u32 __ret_pu;                    \
         __put_user_x(4, __pu_val, ptr, __ret_pu);    \
-        break;                        \
-    case 8:                            \
-        __put_user_x8(__pu_val, ptr, __ret_pu);        \
-        break;                        \
-    default:                        \
-        __put_user_x(X, __pu_val, ptr, __ret_pu);    \
-        break;                        \
-    }                            \
-    __ret_pu;                        \
+        (int)__ret_pu;}),                \
+    __builtin_choose_expr(sizeof(*(ptr)) == 8,        \
+        __put_user_x8(__pu_val, ptr, __ret_pu),        \
+            (void)-EFAULT))));                \
 })
 
 #define __put_user_size(x, ptr, size, retval, errret)            \
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index f456860..12d27f8 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
 {
-    int d0;
+    unsigned long d0;
 
     xloops *= 4;
     asm("mull %%edx"
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index b82cae9..dfff175 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -65,6 +65,7 @@ static struct {
 static unsigned long bios32_service(unsigned long service)
 {
     unsigned char return_code;    /* %al */
+    unsigned long return_code_compat; /* %eax */
     unsigned long address;        /* %ebx */
     unsigned long length;        /* %ecx */
     unsigned long entry;        /* %edx */
@@ -72,13 +73,14 @@ static unsigned long bios32_service(unsigned long
service)
 
     local_irq_save(flags);
     __asm__("lcall *(%%edi); cld"
-        : "=a" (return_code),
+        : "=a" (return_code_compat),
           "=b" (address),
           "=c" (length),
           "=d" (entry)
         : "0" (service),
           "1" (0),
           "D" (&bios32_indirect));
+    return_code = return_code_compat;
     local_irq_restore(flags);
 
     switch (return_code) {
-- 
1.5.6.5

