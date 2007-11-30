Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbXK3Ddm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbXK3Ddm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbXK3DdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:33:16 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1236 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934241AbXK3DdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:33:13 -0500
Subject: RFC - organize include/linux/kernel.h, add include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 19:31:40 -0800
Message-Id: <1196393500.22120.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25 material.

kernel.h has become a bit disorganized over a long time.
Here's an attempt to clean it up a bit.

Something for everyone to like or dislike...

Groups externs and functions by module/function
Creates a "logging.h" for printk, KERN_<level>
Changes some macros to statement expressions
	DIV_ROUND_UP, roundup and __ALIGN_MASK
Removes the unused PTR_ALIGN
Conforms to coding style and 80 columns
Passes checkpatch but for coding style defects in checkpatch
	statement expressions don't need a space between "; and })"
	"do {} whiles" between "; and }"

 include/linux/kernel.h  |  458 +++++++++++++++++------------------------------
 include/linux/logging.h |  154 ++++++++++++++++

These files used macros to declare array elements.
Statement expressions can't be used for that,
so these now use direct calculations instead.

 include/linux/bitops.h  |    2 +-
 lib/radix-tree.c        |    5 +-

This one used the ALIGN macro, but I'm not inclined to
figure out what it actually does right now, so copy
the old macro to this file and renames it.

 include/net/neighbour.h |    5 +-

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..2783ed9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -1,403 +1,273 @@
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
 
 #ifdef __KERNEL__
 
 #include <stdarg.h>
 #include <linux/linkage.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
-#include <asm/byteorder.h>
+#include <linux/logging.h>
 #include <asm/bug.h>
 
-extern const char linux_banner[];
-extern const char linux_proc_banner[];
-
+/* could be in an include linux/limits.h */
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
 #define LONG_MAX	((long)(~0UL>>1))
 #define LONG_MIN	(-LONG_MAX - 1)
 #define ULONG_MAX	(~0UL)
 #define LLONG_MAX	((long long)(~0ULL>>1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
-#define STACK_MAGIC	0xdeadbeef
+/* useful macros */
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
+/*
+ * Check at compile time that something is of a particular type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck(type, x)				\
+	({type _dummy; typeof(x) _dummy2; (void)(&_dummy == &_dummy2); 1;})
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+/*
+ * Check at compile time that 'function' is a certain type, or is a pointer
+ * to that type (needs to use typedef for the function type.)
+ */
+#define typecheck_fn(type, function)			\
+	({typeof(type) _x = function; (void)_x;})
 
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) *__mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member));})
 
-#ifdef CONFIG_LBD
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
+ * min()/max() macros that also do strict type-checking..
+ * See the "unnecessary" pointer comparison.
+ */
+#define min(x, y) ({		\
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void)(&_x == &_y);	\
+	_x < _y ? _x : _y;})
+
+#define max(x, y) ({		\
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void)(&_x == &_y);	\
+	_x > _y ? _x : _y;})
+
+/*
+ * ..and if you can't take the strict
+ * types, you can specify one yourself.
+ *
+ * Or not use min/max at all, of course.
+ */
+#define min_t(type, x, y) \
+	({type _x = (x); type _y = (y); _x < _y ? _x: _y;})
+
+#define max_t(type, x, y) \
+	({type _x = (x); type _y = (y); _x > _y ? _x: _y;})
+
+#define abs(x) ({int _x = (x); (_x < 0) ? -_x : _x;})
 
 /**
  * upper_32_bits - return bits 32-63 of a number
  * @n: the number we're accessing
  *
  * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
  * the "right shift count >= width of type" warning when that quantity is
  * 32-bits.
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
-#define	KERN_EMERG	"<0>"	/* system is unusable			*/
-#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define	KERN_CRIT	"<2>"	/* critical conditions			*/
-#define	KERN_ERR	"<3>"	/* error conditions			*/
-#define	KERN_WARNING	"<4>"	/* warning conditions			*/
-#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define	KERN_INFO	"<6>"	/* informational			*/
-#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define STACK_MAGIC	0xdeadbeef
 
-/*
- * Annotation for a "continued" line of log printout (only done after a
- * line that had no enclosing \n). Only to be used by core/arch code
- * during early bootup (a continued line is not SMP-safe otherwise).
- */
-#define	KERN_CONT	""
+#define __ALIGN_MASK(x, mask) ({	\
+	typeof(mask) _mask = (mask);	\
+	((x) + _mask) & ~_mask;})
+#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
+#define IS_ALIGNED(x, a)	(((x) % ((typeof(x))(a))) == 0)
 
-extern int console_printk[];
+#define DIV_ROUND_UP(n, d) ({	\
+	typeof(n) _n = (n);	\
+	typeof(d) _d = (d);	\
+	(_n + _d - 1) / _d;})
 
-#define console_loglevel (console_printk[0])
-#define default_message_loglevel (console_printk[1])
-#define minimum_console_loglevel (console_printk[2])
-#define default_console_loglevel (console_printk[3])
+#define roundup(x, y) ({	\
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(((_x + (_y - 1)) / _y) * _y);})
 
-struct completion;
+/* arch specific */
 struct pt_regs;
 struct user;
+extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
-/**
- * might_sleep - annotation for functions that can sleep
- *
- * this macro will print a stack trace if it is executed in an atomic
- * context (spinlock, irq-handler, ...).
- *
- * This is a useful debugging help to be able to catch problems early and not
- * be bitten later when the calling function happens to sleep when it is not
- * supposed to.
- */
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int cond_resched(void);
-# define might_resched() cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
+/* init/main and kernel/sys */
+extern enum system_states {
+	SYSTEM_BOOTING,
+	SYSTEM_RUNNING,
+	SYSTEM_HALT,
+	SYSTEM_POWER_OFF,
+	SYSTEM_RESTART,
+	SYSTEM_SUSPEND_DISK,
+} system_state;
 
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
-# define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
-#else
-# define might_sleep() do { might_resched(); } while (0)
-#endif
+/* init/version */
+extern const char linux_banner[];
+extern const char linux_proc_banner[];
 
-#define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
+/* kernel/exit */
+struct completion;
+extern fastcall NORET_TYPE void do_exit(long error_code) ATTRIB_NORET;
+extern NORET_TYPE void complete_and_exit(struct completion *, long)
+	ATTRIB_NORET;
 
-#define abs(x) ({				\
-		int __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+/* kernel/extable */
+struct pid;
+extern struct pid *session_of_pgrp(struct pid *pgrp);
+extern int core_kernel_text(unsigned long addr);
+extern int __kernel_text_address(unsigned long addr);
+extern int kernel_text_address(unsigned long addr);
 
+/* kernel/modules */
+#define TAINT_PROPRIETARY_MODULE	(1<<0)
+#define TAINT_FORCED_MODULE		(1<<1)
+#define TAINT_UNSAFE_SMP		(1<<2)
+#define TAINT_FORCED_RMMOD		(1<<3)
+#define TAINT_MACHINE_CHECK		(1<<4)
+#define TAINT_BAD_PAGE			(1<<5)
+#define TAINT_USER			(1<<6)
+#define TAINT_DIE			(1<<7)
+extern int tainted;
+extern const char *print_tainted(void);
+extern void add_taint(unsigned);
+
+/* kernel/panic */
+extern int oops_in_progress;	/* If set, an oops, panic(), BUG() or die()
+				   is in progress */
+extern int panic_timeout;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
+NORET_TYPE void panic(const char *fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-fastcall NORET_TYPE void do_exit(long error_code)
-	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
-	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int sprintf(char * buf, const char * fmt, ...)
+
+/* kernel/timer */
+struct sysinfo;
+extern int do_sysinfo(struct sysinfo *info);
+
+/* lib/bust_spinlocks */
+extern void bust_spinlocks(int yes);
+
+/* lib/int_sqrt */
+extern unsigned long int_sqrt(unsigned long);
+
+/* lib/vsprintf */
+extern unsigned long simple_strtoul(const char *cp, char **endp,
+				    unsigned int base);
+extern long simple_strtol(const char *cp, char **endp, unsigned int base);
+extern unsigned long long simple_strtoull(const char *cp, char **endp,
+					  unsigned int base);
+extern long long simple_strtoll(const char *cp, char **endp, unsigned int base);
+extern int sprintf(char *buf, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
-extern int vsprintf(char *buf, const char *, va_list)
+extern int vsprintf(char *buf, const char *fmt, va_list args)
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
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
-extern int sscanf(const char *, const char *, ...)
+extern int sscanf(const char *str, const char *fmt, ...)
 	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
+extern int vsscanf(const char *str, const char *fmt, va_list args)
 	__attribute__ ((format (scanf, 2, 0)));
 
+/* lib/cmdline */
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(char *ptr, char **retptr);
 
-extern int core_kernel_text(unsigned long addr);
-extern int __kernel_text_address(unsigned long addr);
-extern int kernel_text_address(unsigned long addr);
-struct pid;
-extern struct pid *session_of_pgrp(struct pid *pgrp);
-
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
-
-#ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2))) __cold;
-extern int log_buf_get_len(void);
-extern int log_buf_read(int idx);
-extern int log_buf_copy(char *dest, int idx, int len);
+/* config specific */
+#ifdef CONFIG_LBD
+# include <asm/div64.h>
+# define sector_div(a, b) do_div(a, b)
 #else
-static inline int vprintk(const char *s, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
-	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
-static inline int log_buf_get_len(void) { return 0; }
-static inline int log_buf_read(int idx) { return 0; }
-static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
+# define sector_div(n, b) ({int _res = (n) % (b); (n) /= (b); _res;})
 #endif
 
-unsigned long int_sqrt(unsigned long);
-
-extern int printk_ratelimit(void);
-extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				unsigned int interval_msec);
-
-static inline void console_silent(void)
-{
-	console_loglevel = 0;
-}
-
-static inline void console_verbose(void)
-{
-	if (console_loglevel)
-		console_loglevel = 15;
-}
-
-extern void bust_spinlocks(int yes);
-extern void wake_up_klogd(void);
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
-extern int panic_timeout;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int tainted;
-extern const char *print_tainted(void);
-extern void add_taint(unsigned);
-
-/* Values used for system_state */
-extern enum system_states {
-	SYSTEM_BOOTING,
-	SYSTEM_RUNNING,
-	SYSTEM_HALT,
-	SYSTEM_POWER_OFF,
-	SYSTEM_RESTART,
-	SYSTEM_SUSPEND_DISK,
-} system_state;
-
-#define TAINT_PROPRIETARY_MODULE	(1<<0)
-#define TAINT_FORCED_MODULE		(1<<1)
-#define TAINT_UNSAFE_SMP		(1<<2)
-#define TAINT_FORCED_RMMOD		(1<<3)
-#define TAINT_MACHINE_CHECK		(1<<4)
-#define TAINT_BAD_PAGE			(1<<5)
-#define TAINT_USER			(1<<6)
-#define TAINT_DIE			(1<<7)
-
-extern void dump_stack(void) __cold;
-
-enum {
-	DUMP_PREFIX_NONE,
-	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
-};
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
-extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
-extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
-#define hex_asc(x)	"0123456789abcdef"[x]
-
-#define pr_emerg(fmt, arg...) \
-	printk(KERN_EMERG fmt, ##arg)
-#define pr_alert(fmt, arg...) \
-	printk(KERN_ALERT fmt, ##arg)
-#define pr_crit(fmt, arg...) \
-	printk(KERN_CRIT fmt, ##arg)
-#define pr_err(fmt, arg...) \
-	printk(KERN_ERR fmt, ##arg)
-#define pr_warning(fmt, arg...) \
-	printk(KERN_WARNING fmt, ##arg)
-#define pr_notice(fmt, arg...) \
-	printk(KERN_NOTICE fmt, ##arg)
-#define pr_info(fmt, arg...) \
-	printk(KERN_INFO fmt, ##arg)
-
-#ifdef DEBUG
-/* If you are writing a driver, please use dev_dbg instead */
-#define pr_debug(fmt, arg...) \
-	printk(KERN_DEBUG fmt, ##arg)
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int cond_resched(void);
+# define might_resched() cond_resched()
 #else
-static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char * fmt, ...)
-{
-	return 0;
-}
+# define might_resched() do {} while (0)
 #endif
 
-/*
- *      Display an IP address in readable format.
- */
-
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[3]
-#define NIPQUAD_FMT "%u.%u.%u.%u"
-
-#define NIP6(addr) \
-	ntohs((addr).s6_addr16[0]), \
-	ntohs((addr).s6_addr16[1]), \
-	ntohs((addr).s6_addr16[2]), \
-	ntohs((addr).s6_addr16[3]), \
-	ntohs((addr).s6_addr16[4]), \
-	ntohs((addr).s6_addr16[5]), \
-	ntohs((addr).s6_addr16[6]), \
-	ntohs((addr).s6_addr16[7])
-#define NIP6_FMT "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x"
-#define NIP6_SEQFMT "%04x%04x%04x%04x%04x%04x%04x%04x"
-
-#if defined(__LITTLE_ENDIAN)
-#define HIPQUAD(addr) \
-	((unsigned char *)&addr)[3], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[0]
-#elif defined(__BIG_ENDIAN)
-#define HIPQUAD	NIPQUAD
-#else
-#error "Please fix asm/byteorder.h"
-#endif /* __LITTLE_ENDIAN */
-
-/*
- * min()/max() macros that also do
- * strict type-checking.. See the
- * "unnecessary" pointer comparison.
- */
-#define min(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x < _y ? _x : _y; })
-
-#define max(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x > _y ? _x : _y; })
-
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max at all, of course.
- */
-#define min_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
-#define max_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
-
-
 /**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
+ * might_sleep - annotation for functions that can sleep
  *
+ * this macro will print a stack trace if it is executed in an atomic
+ * context (spinlock, irq-handler, ...).
+ *
+ * This is a useful debugging help to be able to catch problems early and not
+ * be bitten later when the calling function happens to sleep when it is not
+ * supposed to.
  */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
-/*
- * Check at compile time that something is of a particular type.
- * Always evaluates to 1 so you may use it easily in comparisons.
- */
-#define typecheck(type,x) \
-({	type __dummy; \
-	typeof(x) __dummy2; \
-	(void)(&__dummy == &__dummy2); \
-	1; \
-})
-
-/*
- * Check at compile time that 'function' is a certain type, or is a pointer
- * to that type (needs to use typedef for the function type.)
- */
-#define typecheck_fn(type,function) \
-({	typeof(type) __tmp = function; \
-	(void)__tmp; \
-})
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+extern  void __might_sleep(char *file, int line);
+# define might_sleep() \
+	do {__might_sleep(__FILE__, __LINE__); might_resched();} while (0)
+#else
+# define might_sleep() do {might_resched();} while (0)
+#endif
 
-struct sysinfo;
-extern int do_sysinfo(struct sysinfo *info);
+#define might_sleep_if(cond) do {if (cond) might_sleep();} while (0)
 
 #endif /* __KERNEL__ */
 
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
 	long uptime;			/* Seconds since boot */
 	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
 	unsigned long totalram;		/* Total usable main memory size */
 	unsigned long freeram;		/* Available memory size */
 	unsigned long sharedram;	/* Amount of shared memory */
 	unsigned long bufferram;	/* Memory used by buffers */
 	unsigned long totalswap;	/* Total swap space size */
 	unsigned long freeswap;		/* swap space still available */
 	unsigned short procs;		/* Number of current processes */
 	unsigned short pad;		/* explicit padding for m68k */
 	unsigned long totalhigh;	/* Total high memory size */
 	unsigned long freehigh;		/* Available high memory size */
 	unsigned int mem_unit;		/* Memory unit size in bytes */
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 69c1edb..e1998e9 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -6,7 +6,7 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
+#define BITS_TO_LONGS(nr)	((nr + BITS_PER_LONG - 1) / BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #endif
 
diff --git a/include/linux/logging.h b/include/linux/logging.h
new file mode 100644
index 0000000..f0187f2
--- /dev/null
+++ b/include/linux/logging.h
@@ -0,0 +1,154 @@
+#ifndef _LINUX_LOGGING_H
+#define _LINUX_LOGGING_H
+
+#include <asm/byteorder.h>
+
+#define KERN_EMERG	"<0>"	/* system is unusable			*/
+#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define KERN_CRIT	"<2>"	/* critical conditions			*/
+#define KERN_ERR	"<3>"	/* error conditions			*/
+#define KERN_WARNING	"<4>"	/* warning conditions			*/
+#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define KERN_INFO	"<6>"	/* informational			*/
+#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
+
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define	KERN_CONT	""
+
+extern int console_printk[];
+
+#define console_loglevel (console_printk[0])
+#define default_message_loglevel (console_printk[1])
+#define minimum_console_loglevel (console_printk[2])
+#define default_console_loglevel (console_printk[3])
+
+#ifdef CONFIG_PRINTK
+
+asmlinkage int printk(const char * fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int vprintk(const char *fmt, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+
+extern int log_buf_get_len(void);
+extern int log_buf_read(int idx);
+extern int log_buf_copy(char *dest, int idx, int len);
+
+#else
+
+static inline int __attribute__ ((format (printf, 1, 2))) printk(const char *s, ...)
+{
+	return 0;
+}
+
+static inline int __attribute__ ((format (printf, 1, 0))) vprintk(const char *s, va_list args)
+{
+	return 0;
+}
+
+static inline int log_buf_get_len(void)
+{
+	return 0;
+}
+
+static inline int log_buf_read(int idx)
+{
+	return 0;
+}
+
+static inline int log_buf_copy(char *dest, int idx, int len)
+{
+	return 0;
+}
+#endif
+
+extern int printk_ratelimit(void);
+extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
+extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+				   unsigned int interval_msec);
+
+static inline void console_silent(void)
+{
+	console_loglevel = 0;
+}
+
+static inline void console_verbose(void)
+{
+	if (console_loglevel)
+		console_loglevel = 15;
+}
+
+extern void dump_stack(void) __cold;
+extern void wake_up_klogd(void);
+
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
+extern void print_hex_dump(const char *level, const char *prefix_str,
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+				 const void *buf, size_t len);
+
+#define pr_emerg(fmt, arg...)	printk(KERN_EMERG fmt, ##arg)
+#define pr_alert(fmt, arg...)	printk(KERN_ALERT fmt, ##arg)
+#define pr_crit(fmt, arg...)	printk(KERN_CRIT fmt, ##arg)
+#define pr_err(fmt, arg...)	printk(KERN_ERR fmt, ##arg)
+#define pr_warning(fmt, arg...)	printk(KERN_WARNING fmt, ##arg)
+#define pr_notice(fmt, arg...)	printk(KERN_NOTICE fmt, ##arg)
+#define pr_info(fmt, arg...)	printk(KERN_INFO fmt, ##arg)
+
+#ifdef DEBUG
+/* If you are writing a driver, please use dev_dbg instead */
+#define pr_debug(fmt, arg...)	printk(KERN_DEBUG fmt, ##arg)
+#else
+static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char * fmt, ...)
+{
+	return 0;
+}
+#endif
+
+/*
+ *      Display an IP address in readable format.
+ */
+
+#define NIPQUAD(addr)			\
+	((unsigned char *)&addr)[0],	\
+	((unsigned char *)&addr)[1],	\
+	((unsigned char *)&addr)[2],	\
+	((unsigned char *)&addr)[3]
+#define NIPQUAD_FMT "%u.%u.%u.%u"
+
+#define NIP6(addr)			\
+	ntohs((addr).s6_addr16[0]),	\
+	ntohs((addr).s6_addr16[1]),	\
+	ntohs((addr).s6_addr16[2]),	\
+	ntohs((addr).s6_addr16[3]),	\
+	ntohs((addr).s6_addr16[4]),	\
+	ntohs((addr).s6_addr16[5]),	\
+	ntohs((addr).s6_addr16[6]),	\
+	ntohs((addr).s6_addr16[7])
+#define NIP6_FMT "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x"
+#define NIP6_SEQFMT "%04x%04x%04x%04x%04x%04x%04x%04x"
+
+#if defined(__LITTLE_ENDIAN)
+#define HIPQUAD(addr)			\
+	((unsigned char *)&addr)[3],	\
+	((unsigned char *)&addr)[2],	\
+	((unsigned char *)&addr)[1],	\
+	((unsigned char *)&addr)[0]
+#elif defined(__BIG_ENDIAN)
+#define HIPQUAD	NIPQUAD
+#else
+#error "Please fix asm/byteorder.h"
+#endif /* __LITTLE_ENDIAN */
+
+#endif
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index a4f2618..b2fb8b3 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -87,6 +87,9 @@ struct neigh_statistics
 		preempt_enable();					\
 	} while (0)
 
+#define HA_ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#define HA_ALIGN(x, a)		HA_ALIGN_MASK(x, (typeof(x))(a) - 1)
+
 struct neighbour
 {
 	struct neighbour	*next;
@@ -102,7 +105,7 @@ struct neighbour
 	__u8			dead;
 	atomic_t		probes;
 	rwlock_t		lock;
-	unsigned char		ha[ALIGN(MAX_ADDR_LEN, sizeof(unsigned long))];
+	unsigned char		ha[HA_ALIGN(MAX_ADDR_LEN, sizeof(unsigned long))];
 	struct hh_cache		*hh;
 	atomic_t		refcnt;
 	int			(*output)(struct sk_buff *skb);
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 48c250f..32aac58 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -60,8 +60,9 @@ struct radix_tree_path {
 };
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
-					  RADIX_TREE_MAP_SHIFT))
+#define RADIX_TREE_MAX_PATH					\
+	((RADIX_TREE_INDEX_BITS + RADIX_TREE_MAP_SHIFT - 1) /	\
+	 RADIX_TREE_MAP_SHIFT)
 
 /*
  * The height_to_maxindex array needs to be one deeper than the maximum


