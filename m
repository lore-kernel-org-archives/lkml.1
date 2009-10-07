Return-Path: <linux-kernel-owner+w=401wt.eu-S934295AbZJGQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295AbZJGQhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbZJGQhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:37:16 -0400
Received: from mail.perches.com ([173.55.12.10]:1989 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759405AbZJGQhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:37:13 -0400
Subject: Re: [PATCH 1/7] printk: clean up return value
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, mingo@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 09:36:36 -0700
Message-Id: <1254933396.2134.371.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 08:36 -0700, Linus Torvalds wrote:
> On Wed, 7 Oct 2009, Alan Jenkins wrote:
> > We could fix this up, but it seems pointless.  Callers don't really care
> > about the extra characters added by printk().  Instead, let's return the
> > length of the original message as formatted (and possibly truncated)
> > by vscnprintf().
> Or we could just change it to 'void'. As Joe Perches says, nobody really 
> cares deeply enough for this to generally even matter.

Here are changes to make printk/vprintk return void
to the only uses I found:

 arch/arm/mach-iop13xx/pci.c   |    2 +-
 arch/arm/mach-iop13xx/setup.c |    2 +-
 drivers/char/mem.c            |    6 ++----
 drivers/md/md.c               |    3 +--
 drivers/md/raid5.c            |    3 ++-
 drivers/net/e100.c            |    9 +++++----
 include/linux/kernel.h        |   16 ++++++++--------
 include/net/sctp/sctp.h       |    6 +++---
 kernel/lockdep.c              |    4 ++--
 kernel/printk.c               |   10 +++-------
 net/sunrpc/svc.c              |    9 +++------
 11 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 4873f26..eb58d0a 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -28,7 +28,7 @@
 #include <mach/pci.h>
 
 #define IOP13XX_PCI_DEBUG 0
-#define PRINTK(x...) ((void)(IOP13XX_PCI_DEBUG && printk(x)))
+#define PRINTK(x...) do { if (IOP13XX_PCI_DEBUG) printk(x); } while (0)
 
 u32 iop13xx_atux_pmmr_offset; /* This offset can change based on strapping */
 u32 iop13xx_atue_pmmr_offset; /* This offset can change based on strapping */
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 5c147fb..f6595ad 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -29,7 +29,7 @@
 
 #define IOP13XX_UART_XTAL 33334000
 #define IOP13XX_SETUP_DEBUG 0
-#define PRINTK(x...) ((void)(IOP13XX_SETUP_DEBUG && printk(x)))
+#define PRINTK(x...) do { if (IOP13XX_SETUP_DEBUG) printk(x); } while (0)
 
 /* Standard IO mapping for all IOP13XX based systems
  */
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..6fd98d0 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -851,10 +851,8 @@ static ssize_t kmsg_write(struct file * file, const char __user * buf,
 	ret = -EFAULT;
 	if (!copy_from_user(tmp, buf, count)) {
 		tmp[count] = 0;
-		ret = printk("%s", tmp);
-		if (ret > count)
-			/* printk can add a prefix */
-			ret = count;
+		printk("%s", tmp);
+		ret = count;
 	}
 	kfree(tmp);
 	return ret;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26ba42a..02173fd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -51,8 +51,7 @@
 #include "bitmap.h"
 
 #define DEBUG 0
-#define dprintk(x...) ((void)(DEBUG && printk(x)))
-
+#define dprintk(x...) do { if (DEBUG) printk(x); } while (0)
 
 #ifndef MODULE
 static void autostart_arrays(int part);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9482980..1e4b018 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -94,7 +94,8 @@
 #define __inline__
 #endif
 
-#define printk_rl(args...) ((void) (printk_ratelimit() && printk(args)))
+#define printk_rl(args...) \
+	do { if (printk_ratelimit()) printk(args); } while (0)
 
 /*
  * We maintain a biased count of active stripes in the bottom 16 bits of
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 679965c..9e35650 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -198,10 +198,11 @@ module_param(use_io, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 MODULE_PARM_DESC(eeprom_bad_csum_allow, "Allow bad eeprom checksums");
 MODULE_PARM_DESC(use_io, "Force use of i/o access mode");
-#define DPRINTK(nlevel, klevel, fmt, args...) \
-	(void)((NETIF_MSG_##nlevel & nic->msg_enable) && \
-	printk(KERN_##klevel PFX "%s: %s: " fmt, nic->netdev->name, \
-		__func__ , ## args))
+#define DPRINTK(nlevel, klevel, fmt, args...) do {			\
+	if (NETIF_MSG_##nlevel & nic->msg_enable)			\
+		printk(KERN_##klevel PFX "%s: %s: " fmt,		\
+		       nic->netdev->name, __func__ , ## args);		\
+	} while (0)
 
 #define INTEL_8255X_ETHERNET_DEVICE(device_id, ich) {\
 	PCI_VENDOR_ID_INTEL, device_id, PCI_ANY_ID, PCI_ANY_ID, \
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d3cd23f..c75bad4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -236,9 +236,9 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 #define FW_INFO		"[Firmware Info]: "
 
 #ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
+asmlinkage void vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
+asmlinkage void printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
 extern struct ratelimit_state printk_ratelimit_state;
@@ -262,12 +262,12 @@ extern int printk_delay_msec;
 
 void log_buf_kexec_setup(void);
 #else
-static inline int vprintk(const char *s, va_list args)
+static inline void vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
+static inline void vprintk(const char *s, va_list args) {}
+static inline void printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
+static inline void __cold printk(const char *s, ...) {}
 static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
@@ -389,7 +389,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); ; })
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
@@ -403,7 +403,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	} while (0)
 #else
 #define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); ; })
 #endif
 
 /*
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 8a6d529..9330780 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -276,9 +276,9 @@ struct sctp_mib {
 #if SCTP_DEBUG
 extern int sctp_debug_flag;
 #define SCTP_DEBUG_PRINTK(whatever...) \
-	((void) (sctp_debug_flag && printk(KERN_DEBUG whatever)))
+	do { if (sctp_debug_flag) printk(KERN_DEBUG whatever); } while (0)
 #define SCTP_DEBUG_PRINTK_IPADDR(lead, trail, leadparm, saddr, otherparms...) \
-	if (sctp_debug_flag) { \
+	do { if (sctp_debug_flag) {					\
 		if (saddr->sa.sa_family == AF_INET6) { \
 			printk(KERN_DEBUG \
 			       lead "%pI6" trail, \
@@ -292,7 +292,7 @@ extern int sctp_debug_flag;
 			       &saddr->v4.sin_addr.s_addr, \
 			       otherparms); \
 		} \
-	}
+	} while (0)
 #define SCTP_ENABLE_DEBUG { sctp_debug_flag = 1; }
 #define SCTP_DISABLE_DEBUG { sctp_debug_flag = 0; }
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3815ac1..2f77f23 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1281,8 +1281,8 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 		if (class->usage_mask & (1 << bit)) {
 			int len = depth;
 
-			len += printk("%*s   %s", depth, "", usage_str[bit]);
-			len += printk(" at:\n");
+			printk("%*s   %s at:\n", depth, "", usage_str[bit]);
+			len += depth + strlen(usage_str[bit]) + 8;
 			print_stack_trace(class->usage_traces + bit, len);
 		}
 	}
diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..276f40f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -586,16 +586,13 @@ static int have_callable_console(void)
  * See the vsnprintf() documentation for format string extensions over C99.
  */
 
-asmlinkage int printk(const char *fmt, ...)
+asmlinkage void printk(const char *fmt, ...)
 {
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
-	r = vprintk(fmt, args);
+	vprintk(fmt, args);
 	va_end(args);
-
-	return r;
 }
 
 /* cpu currently holding logbuf_lock */
@@ -667,7 +664,7 @@ static inline void printk_delay(void)
 	}
 }
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+asmlinkage void vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
 	int current_log_level = default_message_loglevel;
@@ -796,7 +793,6 @@ out_restore_irqs:
 	raw_local_irq_restore(flags);
 
 	preempt_enable();
-	return printed_len;
 }
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 952f206..33cf786 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -953,25 +953,22 @@ static void svc_unregister(const struct svc_serv *serv)
 /*
  * Printk the given error with the address of the client that caused it.
  */
-static int
+static void
 __attribute__ ((format (printf, 2, 3)))
 svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
 {
 	va_list args;
-	int 	r;
 	char 	buf[RPC_MAX_ADDRBUFLEN];
 
 	if (!net_ratelimit())
-		return 0;
+		return;
 
 	printk(KERN_WARNING "svc: %s: ",
 		svc_print_addr(rqstp, buf, sizeof(buf)));
 
 	va_start(args, fmt);
-	r = vprintk(fmt, args);
+	vprintk(fmt, args);
 	va_end(args);
-
-	return r;
 }
 
 /*


