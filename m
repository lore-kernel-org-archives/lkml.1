Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYCWIni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYCWIni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbYCWIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:53 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2312 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbYCWIKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:45 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 133/148] include/asm-x86/uaccess_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:48 -0700
Message-Id: <1206259443-13210-134-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/uaccess_32.h |  316 +++++++++++++++++++++++++-----------------
 1 files changed, 187 insertions(+), 129 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index fcc570e..8e7595c 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -32,7 +32,7 @@
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
@@ -43,7 +43,9 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
-#define __addr_ok(addr) ((unsigned long __force)(addr) < (current_thread_info()->addr_limit.seg))
+#define __addr_ok(addr)					\
+	((unsigned long __force)(addr) <		\
+	 (current_thread_info()->addr_limit.seg))
 
 /*
  * Test whether a block of memory is a valid user space address.
@@ -54,13 +56,16 @@ extern struct movsl_mask {
  *
  * This needs 33-bit arithmetic. We have a carry...
  */
-#define __range_ok(addr,size) ({ \
-	unsigned long flag,roksum; \
-	__chk_user_ptr(addr); \
-	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0" \
-		:"=&r" (flag), "=r" (roksum) \
-		:"1" (addr),"g" ((int)(size)),"rm" (current_thread_info()->addr_limit.seg)); \
-	flag; })
+#define __range_ok(addr, size)						\
+({									\
+	unsigned long flag, roksum;					\
+	__chk_user_ptr(addr);						\
+	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"		\
+	    :"=&r" (flag), "=r" (roksum)				\
+	    :"1" (addr), "g" ((int)(size)),				\
+	    "rm" (current_thread_info()->addr_limit.seg));		\
+	flag;								\
+})
 
 /**
  * access_ok: - Checks if a user space pointer is valid
@@ -81,7 +86,7 @@ extern struct movsl_mask {
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type,addr,size) (likely(__range_ok(addr,size) == 0))
+#define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
 
 /*
  * The exception table consists of pairs of addresses: the first is the
@@ -96,8 +101,7 @@ extern struct movsl_mask {
  * on our cache or tlb entries.
  */
 
-struct exception_table_entry
-{
+struct exception_table_entry {
 	unsigned long insn, fixup;
 };
 
@@ -122,13 +126,15 @@ extern void __get_user_1(void);
 extern void __get_user_2(void);
 extern void __get_user_4(void);
 
-#define __get_user_x(size,ret,x,ptr) \
-	__asm__ __volatile__("call __get_user_" #size \
-		:"=a" (ret),"=d" (x) \
-		:"0" (ptr))
+#define __get_user_x(size, ret, x, ptr)	      \
+	asm volatile("call __get_user_" #size \
+		     :"=a" (ret),"=d" (x)     \
+		     :"0" (ptr))
+
 
+/* Careful: we have to cast the result to the type of the pointer
+ * for sign reasons */
 
-/* Careful: we have to cast the result to the type of the pointer for sign reasons */
 /**
  * get_user: - Get a simple variable from user space.
  * @x:   Variable to store result.
@@ -146,15 +152,24 @@ extern void __get_user_4(void);
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define get_user(x,ptr)							\
-({	int __ret_gu;							\
+#define get_user(x, ptr)						\
+({									\
+	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
-	switch(sizeof (*(ptr))) {					\
-	case 1:  __get_user_x(1,__ret_gu,__val_gu,ptr); break;		\
-	case 2:  __get_user_x(2,__ret_gu,__val_gu,ptr); break;		\
-	case 4:  __get_user_x(4,__ret_gu,__val_gu,ptr); break;		\
-	default: __get_user_x(X,__ret_gu,__val_gu,ptr); break;		\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 2:								\
+		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 4:								\
+		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	default:							\
+		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
+		break;							\
 	}								\
 	(x) = (__typeof__(*(ptr)))__val_gu;				\
 	__ret_gu;							\
@@ -171,11 +186,25 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
-#define __put_user_1(x, ptr) __asm__ __volatile__("call __put_user_1":"=a" (__ret_pu):"0" ((typeof(*(ptr)))(x)), "c" (ptr))
-#define __put_user_2(x, ptr) __asm__ __volatile__("call __put_user_2":"=a" (__ret_pu):"0" ((typeof(*(ptr)))(x)), "c" (ptr))
-#define __put_user_4(x, ptr) __asm__ __volatile__("call __put_user_4":"=a" (__ret_pu):"0" ((typeof(*(ptr)))(x)), "c" (ptr))
-#define __put_user_8(x, ptr) __asm__ __volatile__("call __put_user_8":"=a" (__ret_pu):"A" ((typeof(*(ptr)))(x)), "c" (ptr))
-#define __put_user_X(x, ptr) __asm__ __volatile__("call __put_user_X":"=a" (__ret_pu):"c" (ptr))
+#define __put_user_1(x, ptr)					\
+	asm volatile("call __put_user_1" : "=a" (__ret_pu)	\
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+
+#define __put_user_2(x, ptr)					\
+	asm volatile("call __put_user_2" : "=a" (__ret_pu)	\
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+
+#define __put_user_4(x, ptr)					\
+	asm volatile("call __put_user_4" : "=a" (__ret_pu)	\
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
+
+#define __put_user_8(x, ptr)					\
+	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
+		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr))
+
+#define __put_user_X(x, ptr)					\
+	asm volatile("call __put_user_X" : "=a" (__ret_pu)	\
+		     : "c" (ptr))
 
 /**
  * put_user: - Write a simple value into user space.
@@ -195,32 +224,43 @@ extern void __put_user_8(void);
  */
 #ifdef CONFIG_X86_WP_WORKS_OK
 
-#define put_user(x,ptr)						\
-({	int __ret_pu;						\
+#define put_user(x, ptr)					\
+({								\
+	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
 	__pu_val = x;						\
-	switch(sizeof(*(ptr))) {				\
-	case 1: __put_user_1(__pu_val, ptr); break;		\
-	case 2: __put_user_2(__pu_val, ptr); break;		\
-	case 4: __put_user_4(__pu_val, ptr); break;		\
-	case 8: __put_user_8(__pu_val, ptr); break;		\
-	default:__put_user_X(__pu_val, ptr); break;		\
+	switch (sizeof(*(ptr))) {				\
+	case 1:							\
+		__put_user_1(__pu_val, ptr);			\
+		break;						\
+	case 2:							\
+		__put_user_2(__pu_val, ptr);			\
+		break;						\
+	case 4:							\
+		__put_user_4(__pu_val, ptr);			\
+		break;						\
+	case 8:							\
+		__put_user_8(__pu_val, ptr);			\
+		break;						\
+	default:						\
+		__put_user_X(__pu_val, ptr);			\
+		break;						\
 	}							\
 	__ret_pu;						\
 })
 
 #else
-#define put_user(x,ptr)						\
+#define put_user(x, ptr)					\
 ({								\
- 	int __ret_pu;						\
-	__typeof__(*(ptr)) __pus_tmp = x;			\
-	__ret_pu=0;						\
-	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
-				sizeof(*(ptr))) != 0))		\
- 		__ret_pu=-EFAULT;				\
- 	__ret_pu;						\
- })
+	int __ret_pu;						\
+	__typeof__(*(ptr))__pus_tmp = x;			\
+	__ret_pu = 0;						\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
+				       sizeof(*(ptr))) != 0))	\
+		__ret_pu = -EFAULT;				\
+	__ret_pu;						\
+})
 
 
 #endif
@@ -245,8 +285,8 @@ extern void __put_user_8(void);
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define __get_user(x,ptr) \
-  __get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __get_user(x, ptr)				\
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 
 
 /**
@@ -268,54 +308,62 @@ extern void __put_user_8(void);
  *
  * Returns zero on success, or -EFAULT on error.
  */
-#define __put_user(x,ptr) \
-  __put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+#define __put_user(x, ptr)						\
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#define __put_user_nocheck(x,ptr,size)				\
+#define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	long __pu_err;						\
-	__put_user_size((x),(ptr),(size),__pu_err,-EFAULT);	\
+	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
 	__pu_err;						\
 })
 
 
-#define __put_user_u64(x, addr, err)				\
-	__asm__ __volatile__(					\
-		"1:	movl %%eax,0(%2)\n"			\
-		"2:	movl %%edx,4(%2)\n"			\
-		"3:\n"						\
-		".section .fixup,\"ax\"\n"			\
-		"4:	movl %3,%0\n"				\
-		"	jmp 3b\n"				\
-		".previous\n"					\
-		_ASM_EXTABLE(1b,4b)				\
-		_ASM_EXTABLE(2b,4b)				\
-		: "=r"(err)					\
-		: "A" (x), "r" (addr), "i"(-EFAULT), "0"(err))
+#define __put_user_u64(x, addr, err)					\
+	asm volatile("1:	movl %%eax,0(%2)\n"			\
+		     "2:	movl %%edx,4(%2)\n"			\
+		     "3:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "4:	movl %3,%0\n"				\
+		     "	jmp 3b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 4b)				\
+		     _ASM_EXTABLE(2b, 4b)				\
+		     : "=r" (err)					\
+		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
 
 #ifdef CONFIG_X86_WP_WORKS_OK
 
-#define __put_user_size(x,ptr,size,retval,errret)			\
+#define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	case 1: __put_user_asm(x,ptr,retval,"b","b","iq",errret);break;	\
-	case 2: __put_user_asm(x,ptr,retval,"w","w","ir",errret);break; \
-	case 4: __put_user_asm(x,ptr,retval,"l","","ir",errret); break;	\
-	case 8: __put_user_u64((__typeof__(*ptr))(x),ptr,retval); break;\
-	  default: __put_user_bad();					\
+	case 1:								\
+		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
+		break;							\
+	case 2:								\
+		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
+		break;							\
+	case 4:								\
+		__put_user_asm(x, ptr, retval, "l", "",  "ir", errret);	\
+		break;							\
+	case 8:								\
+		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		break;							\
+	default:							\
+		__put_user_bad();					\
 	}								\
 } while (0)
 
 #else
 
-#define __put_user_size(x,ptr,size,retval,errret)			\
+#define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
-	__typeof__(*(ptr)) __pus_tmp = x;				\
+	__typeof__(*(ptr))__pus_tmp = x;				\
 	retval = 0;							\
 									\
-	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
 		retval = errret;					\
 } while (0)
 
@@ -329,65 +377,70 @@ struct __large_struct { unsigned long buf[100]; };
  * aliasing issues.
  */
 #define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	__asm__ __volatile__(						\
-		"1:	mov"itype" %"rtype"1,%2\n"			\
-		"2:\n"							\
-		".section .fixup,\"ax\"\n"				\
-		"3:	movl %3,%0\n"					\
-		"	jmp 2b\n"					\
-		".previous\n"						\
-		_ASM_EXTABLE(1b,3b)					\
-		: "=r"(err)						\
-		: ltype (x), "m"(__m(addr)), "i"(errret), "0"(err))
-
-
-#define __get_user_nocheck(x,ptr,size)				\
-({								\
-	long __gu_err;						\
-	unsigned long __gu_val;					\
-	__get_user_size(__gu_val,(ptr),(size),__gu_err,-EFAULT);\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
-	__gu_err;						\
+	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	movl %3,%0\n"				\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r"(err)					\
+		     : ltype (x), "m" (__m(addr)), "i" (errret), "0" (err))
+
+
+#define __get_user_nocheck(x, ptr, size)				\
+({									\
+	long __gu_err;							\
+	unsigned long __gu_val;						\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
+	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	__gu_err;							\
 })
 
 extern long __get_user_bad(void);
 
-#define __get_user_size(x,ptr,size,retval,errret)			\
+#define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	case 1: __get_user_asm(x,ptr,retval,"b","b","=q",errret);break;	\
-	case 2: __get_user_asm(x,ptr,retval,"w","w","=r",errret);break;	\
-	case 4: __get_user_asm(x,ptr,retval,"l","","=r",errret);break;	\
-	default: (x) = __get_user_bad();				\
+	case 1:								\
+		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
+		break;							\
+	case 2:								\
+		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
+		break;							\
+	case 4:								\
+		__get_user_asm(x, ptr, retval, "l", "", "=r", errret);	\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
 	}								\
 } while (0)
 
 #define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	__asm__ __volatile__(						\
-		"1:	mov"itype" %2,%"rtype"1\n"			\
-		"2:\n"							\
-		".section .fixup,\"ax\"\n"				\
-		"3:	movl %3,%0\n"					\
-		"	xor"itype" %"rtype"1,%"rtype"1\n"		\
-		"	jmp 2b\n"					\
-		".previous\n"						\
-		_ASM_EXTABLE(1b,3b)					\
-		: "=r"(err), ltype (x)					\
-		: "m"(__m(addr)), "i"(errret), "0"(err))
-
-
-unsigned long __must_check __copy_to_user_ll(void __user *to,
-				const void *from, unsigned long n);
-unsigned long __must_check __copy_from_user_ll(void *to,
-				const void __user *from, unsigned long n);
-unsigned long __must_check __copy_from_user_ll_nozero(void *to,
-				const void __user *from, unsigned long n);
-unsigned long __must_check __copy_from_user_ll_nocache(void *to,
-				const void __user *from, unsigned long n);
-unsigned long __must_check __copy_from_user_ll_nocache_nozero(void *to,
-				const void __user *from, unsigned long n);
+	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	movl %3,%0\n"				\
+		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r" (err), ltype (x)				\
+		     : "m" (__m(addr)), "i" (errret), "0" (err))
+
+
+unsigned long __must_check __copy_to_user_ll
+		(void __user *to, const void *from, unsigned long n);
+unsigned long __must_check __copy_from_user_ll
+		(void *to, const void __user *from, unsigned long n);
+unsigned long __must_check __copy_from_user_ll_nozero
+		(void *to, const void __user *from, unsigned long n);
+unsigned long __must_check __copy_from_user_ll_nocache
+		(void *to, const void __user *from, unsigned long n);
+unsigned long __must_check __copy_from_user_ll_nocache_nozero
+		(void *to, const void __user *from, unsigned long n);
 
 /**
  * __copy_to_user_inatomic: - Copy a block of data into user space, with less checking.
@@ -416,13 +469,16 @@ __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 
 		switch (n) {
 		case 1:
-			__put_user_size(*(u8 *)from, (u8 __user *)to, 1, ret, 1);
+			__put_user_size(*(u8 *)from, (u8 __user *)to,
+					1, ret, 1);
 			return ret;
 		case 2:
-			__put_user_size(*(u16 *)from, (u16 __user *)to, 2, ret, 2);
+			__put_user_size(*(u16 *)from, (u16 __user *)to,
+					2, ret, 2);
 			return ret;
 		case 4:
-			__put_user_size(*(u32 *)from, (u32 __user *)to, 4, ret, 4);
+			__put_user_size(*(u32 *)from, (u32 __user *)to,
+					4, ret, 4);
 			return ret;
 		}
 	}
@@ -545,19 +601,21 @@ static __always_inline unsigned long __copy_from_user_nocache(void *to,
 }
 
 static __always_inline unsigned long
-__copy_from_user_inatomic_nocache(void *to, const void __user *from, unsigned long n)
+__copy_from_user_inatomic_nocache(void *to, const void __user *from,
+				  unsigned long n)
 {
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
 
 unsigned long __must_check copy_to_user(void __user *to,
-				const void *from, unsigned long n);
+					const void *from, unsigned long n);
 unsigned long __must_check copy_from_user(void *to,
-				const void __user *from, unsigned long n);
+					  const void __user *from,
+					  unsigned long n);
 long __must_check strncpy_from_user(char *dst, const char __user *src,
-				long count);
+				    long count);
 long __must_check __strncpy_from_user(char *dst,
-				const char __user *src, long count);
+				      const char __user *src, long count);
 
 /**
  * strlen_user: - Get the size of a string in user space.
-- 
1.5.4.rc2

