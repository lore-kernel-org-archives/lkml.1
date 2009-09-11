Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZIKDaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZIKDaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZIKDaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:30:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1099 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZIKD3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:29:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] include/linux/kernel.h: neaten and group functions and definitions
Date: Thu, 10 Sep 2009 20:29:42 -0700
Message-Id: <3f59882968c546eefe7c1b7f5510be9db3d55e42.1252639196.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1252639195.git.joe@perches.com>
References: <cover.1252639195.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the clutter, make checkpatch cleaner.
There are a couple of checkpatch false positives.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |  467 +++++++++++++++++++++++++++---------------------
 1 files changed, 262 insertions(+), 205 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 20eb8ae..6fe9ac6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -21,6 +21,9 @@
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
+/*
+ * tracing structs, functions and redefined "if"
+ */
 struct ftrace_branch_data {
 	const char *func;
 	const char *file;
@@ -112,82 +115,57 @@ static inline void branch_profiler(struct ftrace_branch_data *data, int cond)
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
 #endif
 
+/*
+ * little limits
+ */
 #define USHORT_MAX	((u16)(~0U))
-#define SHORT_MAX	((s16)(USHORT_MAX>>1))
+#define SHORT_MAX	((s16)(USHORT_MAX >> 1))
 #define SHORT_MIN	(-SHORT_MAX - 1)
-#define INT_MAX		((int)(~0U>>1))
+#define INT_MAX		((int)(~0U >> 1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
-#define LONG_MAX	((long)(~0UL>>1))
+#define LONG_MAX	((long)(~0UL >> 1))
 #define LONG_MIN	(-LONG_MAX - 1)
 #define ULONG_MAX	(~0UL)
-#define LLONG_MAX	((long long)(~0ULL>>1))
+#define LLONG_MAX	((long long)(~0ULL >> 1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
-#define STACK_MAGIC	0xdeadbeef
-
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+/*
+ * Alignment checks
+ */
+#define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN(((unsigned long)(p)), (a)))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
+/*
+ * Simple array sizes and offsets
+ */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define FIELD_SIZEOF(t, f)	(sizeof(((t *)0)->f))
 
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-#define DIV_ROUND_CLOSEST(x, divisor)(			\
-{							\
-	typeof(divisor) __divisor = divisor;		\
-	(((x) + ((__divisor) / 2)) / (__divisor));	\
-}							\
-)
-
-#define _RET_IP_		(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
-
-#ifdef CONFIG_LBDAF
-# include <asm/div64.h>
-# define sector_div(a, b) do_div(a, b)
-#else
-# define sector_div(n, b)( \
-{ \
-	int _res; \
-	_res = (n) % (b); \
-	(n) /= (b); \
-	_res; \
-} \
-)
-#endif
+/*
+ * swap - swap value of @a and @b
+ */
+#define swap(a, b)			\
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 /**
- * upper_32_bits - return bits 32-63 of a number
- * @n: the number we're accessing
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
  *
- * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
- * the "right shift count >= width of type" warning when that quantity is
- * 32-bits.
  */
-#define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
+#define container_of(ptr, type, member)				\
+({	const typeof(((type *)0)->member) *__mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member));	\
+})
 
-/**
- * lower_32_bits - return bits 0-31 of a number
- * @n: the number we're accessing
+/*
+ * sleep/reschedule/fault checks
  */
-#define lower_32_bits(n) ((u32)(n))
-
-struct completion;
-struct pt_regs;
-struct user;
-
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int _cond_resched(void);
-# define might_resched() _cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
   void __might_sleep(char *file, int line, int preempt_offset);
 /**
@@ -209,10 +187,12 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x) ({				\
-		int __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
+#else
+# define might_resched() do { } while (0)
+#endif
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
@@ -223,34 +203,206 @@ static inline void might_fault(void)
 }
 #endif
 
+/*
+ * Miscellaneous math functions
+ */
+#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
+#define roundup(x, y)		((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_CLOSEST(x, divisor)			\
+({	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+})
+
+#define abs(x)				\
+({	int __x = (x);			\
+	(__x < 0) ? -__x : __x;		\
+})
+
+/*
+ * min()/max()/clamp() macros that also do
+ * strict type-checking.. See the
+ * "unnecessary" pointer comparison.
+ */
+#define min(x, y)				\
+({	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void)(&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2;		\
+})
+
+#define max(x, y)				\
+({	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void)(&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2;		\
+})
+
+/**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
+#define clamp(val, min, max)			\
+({	typeof(val) __val = (val);		\
+	typeof(min) __min = (min);		\
+	typeof(max) __max = (max);		\
+	(void)(&__val == &__min);		\
+	(void)(&__val == &__max);		\
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val;		\
+})
+
+/*
+ * ..and if you can't take the strict
+ * types, you can specify one yourself.
+ *
+ * Or not use min/max/clamp at all, of course.
+ */
+#define min_t(type, x, y)			\
+({	type __min1 = (x);			\
+	type __min2 = (y);			\
+	__min1 < __min2 ? __min1 : __min2;	\
+})
+
+#define max_t(type, x, y)			\
+({	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1 : __max2;	\
+})
+
+/**
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * 'type' to make all the comparisons.
+ */
+#define clamp_t(type, val, min, max)		\
+({	type __val = (val);			\
+	type __min = (min);			\
+	type __max = (max);			\
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val;		\
+})
+
+/**
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument 'val' is.  This is useful when val is an unsigned
+ * type and min and max are literals that will otherwise be assigned a signed
+ * integer type.
+ */
+#define clamp_val(val, min, max)		\
+({	typeof(val) __val = (val);		\
+	typeof(val) __min = (min);		\
+	typeof(val) __max = (max);		\
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val;		\
+})
+
+unsigned long int_sqrt(unsigned long);
+
+#ifdef CONFIG_LBDAF
+# include <asm/div64.h>
+# define sector_div(a, b) do_div(a, b)
+#else
+# define sector_div(n, b)	  \
+({	int _res;		  \
+	_res = (n) % (b);	  \
+	(n) /= (b);		  \
+	_res;			  \
+})
+#endif
+
+/**
+ * upper_32_bits - return bits 32-63 of a number
+ * @n: the number we're accessing
+ *
+ * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
+ * the "right shift count >= width of type" warning when that quantity is
+ * 32-bits.
+ */
+#define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
+
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((u32)(n))
+
+/*
+ * Panic/oops/exit functions and data
+ */
+struct completion;
+struct pt_regs;
+struct user;
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+void panic(const char *fmt, ...)
+	__attribute__ ((noreturn, format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-NORET_TYPE void do_exit(long error_code)
-	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
-	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int strict_strtoul(const char *, unsigned int, unsigned long *);
-extern int strict_strtol(const char *, unsigned int, long *);
-extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
-extern int strict_strtoll(const char *, unsigned int, long long *);
-extern int sprintf(char * buf, const char * fmt, ...)
+void do_exit(long error_code) __attribute__ ((noreturn));
+void complete_and_exit(struct completion *comp, long code)
+	__attribute__ ((noreturn));
+extern void bust_spinlocks(int yes);
+extern void wake_up_klogd(void);
+extern int oops_in_progress;		/* If set, one of these is in progress:
+					 * oops, panic(), BUG() or die() */
+extern int panic_timeout;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+
+/*
+ * string to value functions
+ */
+extern int strict_strtoul(const char *cp, unsigned int base,
+			  unsigned long *res);
+extern int strict_strtol(const char *cp, unsigned int base,
+			 long *res);
+extern int strict_strtoull(const char *cp, unsigned int base,
+			   unsigned long long *res);
+extern int strict_strtoll(const char *cp, unsigned int base,
+			  long long *res);
+
+/*
+ * deprecated string to value functions, use strict_ variants instead
+ */
+extern unsigned long simple_strtoul(const char *cp, char **endp,
+				    unsigned int base);
+extern long simple_strtol(const char *cp, char **endp,
+			  unsigned int base);
+extern unsigned long long simple_strtoull(const char *cp, char **endp,
+					  unsigned int base);
+extern long long simple_strtoll(const char *cp, char **endp,
+				unsigned int base);
+
+/*
+ * printf functions
+ */
+extern int sprintf(char *buf, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
 	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
+extern int snprintf(char *buf, size_t size, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
+extern int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
@@ -258,38 +410,34 @@ extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
+/*
+ * scanf functions
+ */
 extern int sscanf(const char *, const char *, ...)
 	__attribute__ ((format (scanf, 2, 3)));
 extern int vsscanf(const char *, const char *, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
+/*
+ * command line options functions
+ */
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
+/*
+ * kernel addressing info
+ */
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
+#define _RET_IP_	(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_	({ __label__ __here; __here: (unsigned long)&&__here; })
 
-struct pid;
-extern struct pid *session_of_pgrp(struct pid *pgrp);
-
-unsigned long int_sqrt(unsigned long);
-
-extern void bust_spinlocks(int yes);
-extern void wake_up_klogd(void);
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
-extern int panic_timeout;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern void add_taint(unsigned flag);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
-extern int root_mountflags;
-
-/* Values used for system_state */
+/*
+ *Values used for system_state
+ */
 extern enum system_states {
 	SYSTEM_BOOTING,
 	SYSTEM_RUNNING,
@@ -299,6 +447,13 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;
 
+/*
+ * Kernel taint functions (non-gpl modules, etc)
+ */
+extern void add_taint(unsigned flag);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+
 #define TAINT_PROPRIETARY_MODULE	0
 #define TAINT_FORCED_MODULE		1
 #define TAINT_UNSAFE_SMP		2
@@ -319,13 +474,13 @@ enum {
 	DUMP_PREFIX_OFFSET
 };
 extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
+				 const void *buf, size_t len);
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
@@ -341,7 +496,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 /*
  *      Display an IP address in readable format.
  */
-
 #define NIPQUAD(addr) \
 	((unsigned char *)&addr)[0], \
 	((unsigned char *)&addr)[1], \
@@ -350,109 +504,12 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define NIPQUAD_FMT "%u.%u.%u.%u"
 
 /*
- * min()/max()/clamp() macros that also do
- * strict type-checking.. See the
- * "unnecessary" pointer comparison.
- */
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
-#define max(x, y) ({				\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
-
-/**
- * clamp - return a value clamped to a given range with strict typechecking
- * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
- *
- * This macro does strict typechecking of min/max to make sure they are of the
- * same type as val.  See the unnecessary pointer comparisons.
- */
-#define clamp(val, min, max) ({			\
-	typeof(val) __val = (val);		\
-	typeof(min) __min = (min);		\
-	typeof(max) __max = (max);		\
-	(void) (&__val == &__min);		\
-	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
-
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
+ * unclassified or really miscellaneous
  */
-#define min_t(type, x, y) ({			\
-	type __min1 = (x);			\
-	type __min2 = (y);			\
-	__min1 < __min2 ? __min1: __min2; })
-
-#define max_t(type, x, y) ({			\
-	type __max1 = (x);			\
-	type __max2 = (y);			\
-	__max1 > __max2 ? __max1: __max2; })
-
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * 'type' to make all the comparisons.
- */
-#define clamp_t(type, val, min, max) ({		\
-	type __val = (val);			\
-	type __min = (min);			\
-	type __max = (max);			\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument 'val' is.  This is useful when val is an unsigned
- * type and min and max are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, min, max) ({		\
-	typeof(val) __val = (val);		\
-	typeof(val) __min = (min);		\
-	typeof(val) __max = (max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
-
-
-/*
- * swap - swap value of @a and @b
- */
-#define swap(a, b) \
-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
+#define STACK_MAGIC	0xdeadbeef
+extern int root_mountflags;
+struct pid;
+extern struct pid *session_of_pgrp(struct pid *pgrp);
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
-- 
1.6.3.1.10.g659a0.dirty

