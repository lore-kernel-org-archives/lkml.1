Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbXJDUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbXJDUE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJDUET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:04:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22014 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXJDUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fTjeqcBTgyqldhGctxA59+x+V75A0J6Bh2/1BvSQGmyBEdjtrlHZ0byhAd80K2RUXByU0Pi1lQ86/VecxCzIKxi1lMuvn9AHeFwjL+CkPa9f1nOx6hkA9URcUwFGQzrNKu3lhZ5cwn3NvX/hEsyp28eZfSA1P532NvCjhidVL94=
Subject: [RFC][PATCH] New message-logging API (kprint)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>,
       Miguel Ojeda <maxextreme@gmail.com>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 22:04:07 +0200
Message-Id: <1191528247.13580.11.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: This patch largely implements the kprint API as previously
posted to the LKML and described in Documentation/kprint.txt (see patch).

The main purpose of this change is provide a unified logging API to the
kernel and at the same time make it easy to add extensions, now and later.

My changes and additions are as follows:

1. A general-purpose ring-buffer data structure. This is used by kprint to
   store the messages, similarly to what printk() does. I've looked, but
   couldn't find something like this in the kernel already.

2. A generalized printf()-like function (currently called by the somewhat
   confusing name of args_printf). The function, instead of writing to a
   string, calls one of several functions submitted through a struct args_ops.

   This allows us to skip all the characters from the format string and only
   output the characters resulting from argument conversion.

   It should be noted that this function is a generalization of, and largely
   copies, the existing snprintf() function. It would be possible to implement
   snprintf() in terms of the new function if that is preferred.

3. kprint header and source files. These files implements separating the
   format string from its arguments, and saving them along with extension-
   specific attributes (for example the current time) to the log.

4. A redefinition of the legacy printk(). The new definition redirects calls
   made from C to the new kprint() system in a mostly backwards-compatible
   way. The incompatibility stems from the fact that kprint() does not return
   the number of characters written to the log. There are several reasons for
   this; firstly, in order to filter out certain log-levels, the actual call
   must happen from within an if-block, and thus no value can be returned.

5. Changes to calls in the rest of the kernel that expects kprint() to return
   a value. These changes are few and mostly trivial. One of the pitfalls of
   actually using the return value of printk() is that the number is
   unreliable in terms of how much is written to the log, and how much is
   written to the console.

6. Calling syslog (in glibc, klogctl()) with a (type|0x10) will access the
   new kprint buffer instead of the regular log buffer. The kprint buffer
   is different in that it doesn't record the actual formatted message, but
   the format string and the (formatted) arguments. Example:

6 0 42949372960000000 arch/um/kernel/mem.c 89 mem_init unknown mem, "Memory: %luk available\x0a", "255104"
7 0 42949372960000000 init/calibrate.c 135 calibrate_delay unknown calibrate, "Calibrating delay loop... ",
4 0 42949373260000000 init/calibrate.c 170 calibrate_delay unknown calibrate, "%lu.%02lu BogoMIPS (lpj=%lu)\x0a", "4246" "73" "21233664"
4 0 42949373260000000 fs/namespace.c 1830 mnt_init unknown namespace, "Mount-cache hash table entries: %d\x0a", "512"
6 0 42949373260000000 net/socket.c 2116 sock_register unknown socket, "NET: Registered protocol family %d\x0a", "16"
6 0 42949373300000000 net/socket.c 2116 sock_register unknown socket, "NET: Registered protocol family %d\x0a", "2"

   Each log entry consists of three fields separated by a comma. The first
   field records attributes assigned with the message. In the example above,
   these attributes are, in order, log-level, class, timestamp, source file,
   line in source file, current function, subsystem, and driver/module name.

   The second field contains the format string of the message. This can be
   used to identify a particular string and provide user-space translations of
   the kernel messages.

   The last field contains the arguments to the format string. These arguments
   can be used to reconstruct (i.e. format) a message at a later time,
   possibly with a different format string (i.e. a translation).

7. The kprint configuration options can be found under General setup
   -> Logging.


There are also several unresolved issues: (Help would be appreciated!)

1. As there is not yet a good way to provide compile-time filtering of multi-
   line messages, this feature is completely omitted for now. Note that
   printing multiple related messages, or continuing a single message across
   calls to printk() has always been broken because of the race condition
   that arises when several tasks want to print messages at the same time,
   and at least one of those tasks want to print multiple lines or a
   continuation.

2. The "new" syslog() doesn't check if the caller has the right privileges.
   To be honest, I don't really know how to do it, apart from looking at what
   do_syslog() currently does.

3. Certain drivers, like the AIC7xxx SCSI drivers, and a few of the ATM
   drivers rely on the return value of printk(), and consequently will not
   compile. I think this is inherently buggy, but as the code is not always
   trivial to change, the solution for now is to disable these drivers.


Thank you for reading :)


Kind regards,
Vegard Nossum



diff --git a/Documentation/kprint.txt b/Documentation/kprint.txt
new file mode 100644
index 0000000..3046cbc
--- /dev/null
+++ b/Documentation/kprint.txt
@@ -0,0 +1,238 @@
+New kernel-message logging API
+
+
+1. Requirements
+
+   * Backwards compatibility with printk(), syslog(), etc. There is no way the 
+whole kernel can be converted to a new interface in one go. printk() is used 
+all over the kernel, in many different ways, including calls from assembly, 
+multi-line prints spread over several calls, etc.
+
+   * Extensibility. Features like eliminating messages below a given threshold 
+or recording the location (i.e. source file/line) of a message [1] should be 
+both selectable at compile-time and (if compiled in) at run-time.
+
+2. API
+
+2.1. linux/kprint.h
+
+  This header defines the primary (i.e. lowest-level) interface to kprint that 
+is made available to the rest of the kernel.
+
+2.1.1. kprint()
+
+	#define kprint(fmt, ...)
+
+  This function is the equivalent of the old printk(), except that it does not 
+take a log-level parameter, but emits messages using the default log-level. The 
+string must be a single line of information (i.e. it must not contain any 
+newlines). kprint() is implemented as a macro, and must not be called from 
+assembly.
+
+2.1.2. Log-levels
+
+  To support the different log-levels, there exists one kprint_*() function for 
+each log-level, for example kprint_info(). This contrasts with the printk() 
+interface, but allows the log-level argument to be passed as an argument 
+(instead of prepending it to the message string) and omitted if the default 
+log-level should be used.
+
+  The string must be a single line of information. Calling 
+kprint_emerg("Oops.") is equivalent to calling printk(KERN_EMERG "Oops.\n"). 
+These functions are implemented as macros, and must not be called from 
+assembly. The different log-levels (and their functions) are:
+
+	enum kprint_loglevel {
+		KPRINT_EMERG,	/* kprint_emerg() */
+		KPRINT_ALERT,	/* kprint_alert() */
+		KPRINT_CRIT,	/* kprint_crit() */
+		KPRINT_ERROR,	/* kprint_err() */
+		KPRINT_WARNING,	/* kprint_warn() */
+		KPRINT_NOTICE,	/* kprint_notice() */
+		KPRINT_INFO,	/* kprint_info() */
+		KPRINT_DEBUG,	/* kprint_debug() */
+	};
+
+  The individual log-levels can be enabled/disabled in the kernel configuration 
+and subsequently removed from the kernel (by the compiler) entirely. It is not 
+an option to filter out messages that are simply above a certain log-level, 
+although it could be more convenient; controlling each log-level is the more 
+general approach and can be used to emulate the threshold filter. [8]
+
+2.1.3. Classification tags
+
+  It turns out that many messages share a similar purpose. It would be useful 
+to classify these by a different scheme than severity [6]. Therefore, an 
+additional four special-purpose macros are defined:
+
+   * printk_detected()    A "hardware detected" message
+   * printk_registered()  A "device driver (un-)registered" message
+   * printk_setting()     A "hardware setting change" message
+   * printk_copyright()   A copyright message, such as module authorship
+                          information
+
+  Each message will be assigned the appropriate log-level for the message class 
+in question.
+
+2.1.4. Blocks
+
+  Note: Blocks are not implemented. The details of the API are not yet worked
+        out.
+
+  In order to print several related lines as one chunk, the emitter should 
+first allocate an object of the type struct kprint_block. This struct is 
+initialized with the function kprint_block_init() which takes as arguments a 
+pointer to an object of the type struct kprint_block followed by the log-level 
+number. The emitter may then make as many or as few calls to kprint_block() 
+that is desired. A final call to kprint_block_flush() appends the messages to 
+the kernel message log in a single, atomic operation. After it has been 
+flushed, the struct is not usable again (unless it is re-initialized). If for 
+any reason the struct should be de-initialized without writing it to the log, a 
+call to kprint_block_abort() must be made.
+
+Example: {
+	struct kprint_block out;
+	kprint_block_init(&out, KPRINT_DEBUG);
+	kprint_block(&out, "Stack trace:");
+
+	while(unwind_stack()) {
+		kprint_block(&out, "%p %s", address, symbol);
+	}
+	kprint_block_flush(&out);
+}
+
+2.1.5. Subsystem/driver tags
+
+  Many parts of the kernel already prefix their log messages with a subsystem 
+and/or driver tag to identify the source of a particular message. With the 
+kprint interface, these tags are redundant. Instead, the macros SUBSYSTEM and 
+KBUILD_MODNAME are used and recorded along with each log message. Therefore, 
+each source file should define the macro SUBSYSTEM before any of the kprint 
+functions are used. If this macro is not defined, the recorded subsystem will 
+be an empty string. [6][7]
+
+2.1.6. Early- and assembly functions
+
+  It may happen that certain parts of the kernel might wish to emit messages to 
+the log (and console, if any) in an early part of the boot procedure, for 
+example before the main memory allocation routines have been set up properly. 
+For this purpose, a function kprint_early() exists. This "early" is a minimal 
+way for the kernel to log its functions, and may as such not include all the 
+features of the full kprint system. When the kernel is beyond the critical 
+"early" point, the messages (if any) in the "early" log may be moved into the 
+main logging store and kprint_early() must not be used again. kprint_early() is 
+a function and may be called from assembly.
+
+  To allow non-early calls from assembly, a function kprint_asm() exists. This 
+function takes a log-level number followed by a string literal and a variable 
+number of arguments.
+
+2.1.7 Backwards compatibility
+
+  The legacy printk() function is replaced by a backwards-compatible interface 
+but different implementation. In short, printk should parse messages, remove 
+(and convert) initial log-level tokens, remove any newlines (splitting the 
+string into several lines), and call the appropriate kprint()-system functions.
+
+  Because printk() itself remains a function with the same specification, all 
+printing/logging mechanisms based on it, such as dev_printk(), sdev_printk(), 
+and ata_dev_printk() will remain functional. Alternatively, the macros could be 
+changed to use the new kprint API.
+
+
+2.2. linux/kprint-light.h
+
+  The kprint "light" interface provides a simpler interface that covers the 
+most frequent usage patterns. It should be noted that this interface is 
+preferred over the primary interface as it encourages the use of a smaller set 
+of log-levels [5].
+
+  The interface consists primarily of the three macros, err(), warn(), and 
+info() that emit messages at the corresponding log-level.
+
+  This header is optional and must not be included by other header files. The 
+names defined by this header are already used by different parts of the kernel, 
+but in different ways. With an optional header, new code (or code converted to 
+the kprint API) can explicitly request these definitions while leaving old 
+locations unchanged.
+
+
+3. Internals
+
+  Most of the kprint entry-points (especially kprint() and its log-level 
+variations) are implemented as macros in order to be able to transparently pass 
+extra information into the main kprint machinery. This makes the interface 
+abstract, because we can change the behaviour (through the configuration and by 
+adding extensions) without changing the calling code. As an example, prepending 
+the current file and line (the __FILE__ and __LINE__ macros) to the message can 
+be done in such a way that it can be discarded at run-time, or recorded along 
+with (but separate from) the messages. This allows the compiler to completely 
+optimize out calls that are below a certain log-level severity level [2][3].
+
+  With such a modular interface, message attributes (for example the current 
+time) and arguments can also be recorded separately from the actual format 
+string, instead of written already formatted to a ring buffer of characters. 
+Parameters would be formatted to their own strings (regardless of the original 
+type) and saved in a list.
+
+Example: {
+	struct kprint_message {
+		const char *format;
+		struct kprint_arg *args;
+
+	#ifdef KPRINT_TIMESTAMP
+		unsigned long long timestamp;
+	#endif
+
+	#ifndef KPRINT_LOCATION
+		const char *file;
+		unsigned int line;
+
+		const char *function;
+	#endif
+	};
+
+	struct kprint_arg {
+		struct kprint_arg *next;
+
+		/* The string formatted argument, regardless
+		 * of original type. */
+		char *arg;
+	};
+}
+
+  This can be a great help, for example in (user-space) localisation of kernel 
+messages [4], since the "static" message (ie. format string) can be translated 
+separately and the arguments re-attached at run-time, possibly in a different 
+order. A new kernel-/user-space interface would be needed to retrieve the 
+messages in this format, though the syslog() and /proc/kmsg interfaces will 
+retain backwards compatibility by formatting messages as they are requested 
+from user-space.
+
+  This does not mean that user-space is obliged provide any form of 
+lookup-/translation tables in order to read the kernel log; the kernel simply 
+hands over the format string used to format a particular message in addition to 
+the full log message, and this format string may be used to easily look up 
+translations (if they exist).
+
+4. Considerations
+
+  This scheme is obviously much more complex than the printk() is today. But at 
+the same time, it is also much more powerful, extensible, and clearly/cleanly 
+defined.
+
+  The kernel can still used a fixed-size ring-buffer for storing the kernel 
+log. With a fixed, static buffer, we are certain to never  run into memory-
+related problems, even if the rest of the system is unstable or unusable.
+
+
+References
+
+[1] http://lkml.org/lkml/2007/9/21/267 (Joe Perches)
+[2] http://lkml.org/lkml/2007/9/20/352 (Rob Landley)
+[3] http://lkml.org/lkml/2007/9/21/151 (Dick Streefland)
+[4] http://lkml.org/lkml/2007/6/13/146 (Michael Holzheu)
+[5] http://lkml.org/lkml/2007/9/24/320 (Jesse Barnes)
+[6] http://lkml.org/lkml/2007/9/22/162 (Miguel Ojeda)
+[7] http://lkml.org/lkml/2007/9/25/62 (Vegard Nossum)
+[8] http://lkml.org/lkml/2007/9/22/157 (Joe Perches)
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 47b0bef..70eda51 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL(dump_trace);
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
-	printk(data);
+	printk("%s", data);
 	print_symbol(msg, symbol);
 	printk("\n");
 }
diff --git a/arch/um/include/user.h b/arch/um/include/user.h
index d380e6d..c971d93 100644
--- a/arch/um/include/user.h
+++ b/arch/um/include/user.h
@@ -19,9 +19,11 @@
  */
 #include <linux/types.h>
 
-extern void panic(const char *fmt, ...)
+extern int printk_asm(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
-extern int printk(const char *fmt, ...)
+#define printk printk_asm
+
+extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 extern void schedule(void);
 extern int in_aton(char *str);
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 11f9359..acdfc45 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -874,9 +874,8 @@ static void test_available(void)
 	char **name = check;
 
 	while (*name) {
-		printk("alg %s ", *name);
-		printk(crypto_has_alg(*name, 0, 0) ?
-		       "found\n" : "not found\n");
+		printk("algorithm %s %s\n", *name, crypto_has_alg(*name, 0, 0)
+			? "found" : "not found");
 		name++;
 	}
 }
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index bbee97f..83bd492 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -890,10 +890,12 @@ static ssize_t kmsg_write(struct file * file, const char __user * buf,
 	ret = -EFAULT;
 	if (!copy_from_user(tmp, buf, count)) {
 		tmp[count] = 0;
-		ret = printk("%s", tmp);
-		if (ret > count)
-			/* printk can add a prefix */
-			ret = count;
+		printk("%s", tmp);
+
+		/* Instead of saying how many bytes were written to the log,
+		 * including log-level, timestamp, etc., we simply return the
+		 * string length. */
+		ret = strlen(tmp);
 	}
 	kfree(tmp);
 	return ret;
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 92a6c7b..5f3061f 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -447,7 +447,8 @@ static u8 ide_dump_ata_status(ide_drive_t *drive, const char *msg, u8 stat)
 		printk("%s: %s: error=0x%02x { ", drive->name, msg, err);
 		if (err & ABRT_ERR)	printk("DriveStatusError ");
 		if (err & ICRC_ERR)
-			printk((err & ABRT_ERR) ? "BadCRC " : "BadSector ");
+			printk("%s", (err & ABRT_ERR)
+				? "BadCRC " : "BadSector ");
 		if (err & ECC_ERR)	printk("UncorrectableError ");
 		if (err & ID_ERR)	printk("SectorIdNotFound ");
 		if (err & TRK0_ERR)	printk("TrackZeroNotFound ");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f883b7e..a04cbcf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -62,7 +62,10 @@
 #define MdpMinorShift 6
 
 #define DEBUG 0
-#define dprintk(x...) ((void)(DEBUG && printk(x)))
+#define dprintk(x...)		\
+	if(DEBUG) {		\
+		 printk(x);	\
+	}
 

 #ifndef MODULE
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index e725f61..c564f64 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -351,10 +351,15 @@ static int tda10021_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 	afc = tda10021_readreg(state, 0x19);
 	if (verbose) {
 		/* AFC only valid when carrier has been recovered */
-		printk(sync & 2 ? "DVB: TDA10021(%d): AFC (%d) %dHz\n" :
-				  "DVB: TDA10021(%d): [AFC (%d) %dHz]\n",
-			state->frontend.dvb->num, afc,
-		       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		if(sync & 2) {
+			printk("DVB: TDA10021(%d): AFC (%d) %dHz\n",
+				state->frontend.dvb->num, afc,
+			       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		} else {
+			printk("DVB: TDA10021(%d): [AFC (%d) %dHz]\n",
+				state->frontend.dvb->num, afc,
+			       -((s32)p->u.qam.symbol_rate * afc) >> 10);;
+		}
 	}
 
 	p->inversion = ((state->reg0 & 0x20) == 0x20) ^ (state->config->invert != 0) ? INVERSION_ON : INVERSION_OFF;
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index 4bb06f9..c3c6e23 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -414,10 +414,15 @@ static int tda10023_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 
 	if (verbose) {
 		/* AFC only valid when carrier has been recovered */
-		printk(sync & 2 ? "DVB: TDA10023(%d): AFC (%d) %dHz\n" :
-				  "DVB: TDA10023(%d): [AFC (%d) %dHz]\n",
-			state->frontend.dvb->num, afc,
-		       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		if(sync & 2) {
+			printk("DVB: TDA10023(%d): AFC (%d) %dHz\n",
+				state->frontend.dvb->num, afc,
+			       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		} else {
+			printk("DVB: TDA10023(%d): [AFC (%d) %dHz]\n",
+				state->frontend.dvb->num, afc,
+			       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		}
 	}
 
 	p->inversion = (inv&0x20?0:1);
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 9b57576..e9af469 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -319,8 +319,13 @@ static int ves1820_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	afc = ves1820_readreg(state, 0x19);
 	if (verbose) {
 		/* AFC only valid when carrier has been recovered */
-		printk(sync & 2 ? "ves1820: AFC (%d) %dHz\n" :
-			"ves1820: [AFC (%d) %dHz]\n", afc, -((s32) p->u.qam.symbol_rate * afc) >> 10);
+		if(sync & 2) {
+			printk("ves1820: AFC (%d) %dHz\n", afc,
+				-((s32) p->u.qam.symbol_rate * afc) >> 10);
+		} else {
+			printk("ves1820: [AFC (%d) %dHz]\n", afc,
+				-((s32) p->u.qam.symbol_rate * afc) >> 10);
+		}
 	}
 
 	if (!state->config->invert) {
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 255a47d..5a1f398 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -148,8 +148,12 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, buf, len, HZ);
 
-	if (reg_debug){
-		printk(ret < 0 ? " failed!\n" : "%02x values: ", ret);
+	if (reg_debug) {
+		if(ret < 0)
+			printk(" failed!\n");
+		else
+			printk("%02x values: ", ret);
+
 		for (byte = 0; byte < len; byte++) {
 			printk(" %02x", buf[byte]);
 		}
@@ -177,8 +181,12 @@ int em28xx_read_reg_req(struct em28xx *dev, u8 req, u16 reg)
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, &val, 1, HZ);
 
-	if (reg_debug)
-		printk(ret < 0 ? " failed!\n" : "%02x\n", val);
+	if (reg_debug) {
+		if(ret < 0)
+			printk(" failed!\n");
+		else
+			printk("%02x\n", val);
+	}
 
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/video/usbvideo/usbvideo.h b/drivers/media/video/usbvideo/usbvideo.h
index 051775d..39fdadc 100644
--- a/drivers/media/video/usbvideo/usbvideo.h
+++ b/drivers/media/video/usbvideo/usbvideo.h
@@ -22,7 +22,12 @@
 #include <linux/mutex.h>
 
 /* Most helpful debugging aid */
-#define assert(expr) ((void) ((expr) ? 0 : (err("assert failed at line %d",__LINE__))))
+#define assert(expr)							\
+	do {								\
+		if(!(expr)) {						\
+			err("assert failed at line %d", __LINE__);	\
+		}							\
+	} while(0)
 
 #define USBVIDEO_REPORT_STATS	1	/* Set to 0 to block statistics on close */
 
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 280313b..b4a7dbc 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -182,9 +182,13 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 MODULE_PARM_DESC(eeprom_bad_csum_allow, "Allow bad eeprom checksums");
 MODULE_PARM_DESC(use_io, "Force use of i/o access mode");
 #define DPRINTK(nlevel, klevel, fmt, args...) \
-	(void)((NETIF_MSG_##nlevel & nic->msg_enable) && \
-	printk(KERN_##klevel PFX "%s: %s: " fmt, nic->netdev->name, \
-		__FUNCTION__ , ## args))
+	do {								\
+		if(NETIF_MSG_##nlevel & nic->msg_enable) {		\
+			printk(KERN_##klevel PFX "%s: %s: " fmt,	\
+				nic->netdev->name,			\
+				__FUNCTION__ , ## args);		\
+		}							\
+	} while(0)
 
 #define INTEL_8255X_ETHERNET_DEVICE(device_id, ich) {\
 	PCI_VENDOR_ID_INTEL, device_id, PCI_ANY_ID, PCI_ANY_ID, \
diff --git a/drivers/net/e1000/e1000.h b/drivers/net/e1000/e1000.h
index 16a6edf..5445616 100644
--- a/drivers/net/e1000/e1000.h
+++ b/drivers/net/e1000/e1000.h
@@ -90,10 +90,14 @@ struct e1000_adapter;
 #define E1000_ERR(args...) printk(KERN_ERR "e1000: " args)
 
 #define PFX "e1000: "
-#define DPRINTK(nlevel, klevel, fmt, args...) \
-	(void)((NETIF_MSG_##nlevel & adapter->msg_enable) && \
-	printk(KERN_##klevel PFX "%s: %s: " fmt, adapter->netdev->name, \
-		__FUNCTION__ , ## args))
+#define DPRINTK(nlevel, klevel, fmt, args...)				\
+	do {								\
+		if(NETIF_MSG_##nlevel & adapter->msg_enable) {		\
+			printk(KERN_##klevel PFX "%s: %s: " fmt,	\
+				adapter->netdev->name, __FUNCTION__,	\
+				## args);				\
+		}							\
+	} while(0)
 
 #define E1000_MAX_INTR 10
 
diff --git a/drivers/net/irda/ma600.c b/drivers/net/irda/ma600.c
index f5e6836..bd59424 100644
--- a/drivers/net/irda/ma600.c
+++ b/drivers/net/irda/ma600.c
@@ -44,7 +44,10 @@
 
 #ifndef NDEBUG
 	#undef IRDA_DEBUG
-	#define IRDA_DEBUG(n, args...) (printk(KERN_DEBUG args))
+	#define IRDA_DEBUG(n, args...)			\
+		do {					\
+			printk(KERN_DEBUG args);	\
+		} while(0)
 
 	#undef ASSERT
 	#define ASSERT(expr, func) \
diff --git a/drivers/net/ixgb/ixgb.h b/drivers/net/ixgb/ixgb.h
index 3569d5b..f40502b 100644
--- a/drivers/net/ixgb/ixgb.h
+++ b/drivers/net/ixgb/ixgb.h
@@ -82,10 +82,13 @@ struct ixgb_adapter;
 #endif
 
 #define PFX "ixgb: "
-#define DPRINTK(nlevel, klevel, fmt, args...) \
-	(void)((NETIF_MSG_##nlevel & adapter->msg_enable) && \
-	printk(KERN_##klevel PFX "%s: %s: " fmt, adapter->netdev->name, \
-		__FUNCTION__ , ## args))
+#define DPRINTK(nlevel, klevel, fmt, args...)				\
+	do {								\
+		if(NETIF_MSG_##nlevel & adapter->msg_enable) {		\
+			printk(KERN_##klevel PFX "%s: %s: " fmt,	\
+			adapter->netdev->name, __FUNCTION__, ## args);	\
+		}							\
+	} while(0)
 

 /* TX/RX descriptor defines */
diff --git a/drivers/net/lib8390.c b/drivers/net/lib8390.c
index c429a50..d2e2238 100644
--- a/drivers/net/lib8390.c
+++ b/drivers/net/lib8390.c
@@ -1,4 +1,3 @@
-/* 8390.c: A general NS8390 ethernet driver core for linux. */
 /*
 	Written 1992-94 by Donald Becker.
 
@@ -451,11 +450,17 @@ static irqreturn_t __ei_interrupt(int irq, void *dev_id)
 	{
 #if 1 /* This might just be an interrupt for a PCI device sharing this line */
 		/* The "irqlock" check is only for testing. */
-		printk(ei_local->irqlock
-			   ? "%s: Interrupted while interrupts are masked! isr=%#2x imr=%#2x.\n"
-			   : "%s: Reentering the interrupt handler! isr=%#2x imr=%#2x.\n",
-			   dev->name, ei_inb_p(e8390_base + EN0_ISR),
-			   ei_inb_p(e8390_base + EN0_IMR));
+		if(ei_local->irqlock) {
+			printk("%s: Interrupted while interrupts are masked! "
+				"isr=%#2x imr=%#2x.\n", 
+				dev->name, ei_inb_p(e8390_base + EN0_ISR),
+				ei_inb_p(e8390_base + EN0_IMR));
+		} else {
+			printk("%s: Reentering the interrupt handler! "
+				"isr=%#2x imr=%#2x.\n",
+				dev->name, ei_inb_p(e8390_base + EN0_ISR),
+				ei_inb_p(e8390_base + EN0_IMR));
+		}
 #endif
 		spin_unlock(&ei_local->page_lock);
 		return IRQ_NONE;
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 50dff1b..8051b5c 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -1213,11 +1213,17 @@ static irqreturn_t ax_interrupt(int irq, void *dev_id)
 	{
 #if 1 /* This might just be an interrupt for a PCI device sharing this line */
 		/* The "irqlock" check is only for testing. */
-		printk(ei_local->irqlock
-			   ? "%s: Interrupted while interrupts are masked! isr=%#2x imr=%#2x.\n"
-			   : "%s: Reentering the interrupt handler! isr=%#2x imr=%#2x.\n",
+		if(ei_local->irqlock) {
+			printk("%s: Interrupted while interrupts are masked! "
+				" isr=%#2x imr=%#2x.\n",
 			   dev->name, inb_p(e8390_base + EN0_ISR),
 			   inb_p(e8390_base + EN0_IMR));
+		} else {
+			printk("%s: Reentering the interrupt handler! "
+				"isr=%#2x imr=%#2x.\n",
+			   dev->name, inb_p(e8390_base + EN0_ISR),
+			   inb_p(e8390_base + EN0_IMR));
+		}
 #endif
 		spin_unlock(&ei_local->page_lock);
 		return IRQ_NONE;
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index bfcaad6..d90ebb6 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -248,7 +248,10 @@ static void do_io_probe(struct pcmcia_socket *s, kio_addr_t base, kio_addr_t num
 	}
     }
 
-    printk(any ? "\n" : " clean.\n");
+    if(any)
+	printk("\n");
+    else
+	printk(" clean.\n");
 }
 #endif
 
@@ -396,7 +399,10 @@ static int do_mem_probe(u_long base, u_long num, struct pcmcia_socket *s)
 	    bad += j-i;
 	}
     }
-    printk(bad ? "\n" : " clean.\n");
+    if(bad)
+	printk("\n");
+    else
+	printk(" clean.\n");
     return (num - bad);
 }
 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..712bf9f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7417,7 +7417,7 @@ static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
 	ret = vsprintf(s, fmt, args);
 	ASC_ASSERT(ret < ASC_PRTLINE_SIZE);
 	if (buf == NULL) {
-		(void)printk(s);
+		printk(s);
 		ret = 0;
 	} else {
 		ret = min(buflen, ret);
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 29ff5d8..3f9e8d8 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -28,7 +28,10 @@ static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline void pud_clear(pud_t *pud)	{ }
-#define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
+#define pmd_ERROR(pmd)			\
+	do {				\
+		pud_ERROR((pmd).pud);	\
+	} while(0)
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 5664645..b091db1 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -26,7 +26,10 @@ static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
 static inline void pgd_clear(pgd_t *pgd)	{ }
-#define pud_ERROR(pud)				(pgd_ERROR((pud).pgd))
+#define pud_ERROR(pud)			\
+	do {				\
+		pgd_ERROR((pud).pgd);	\
+	} while(0)
 
 #define pgd_populate(mm, pgd, pud)		do { } while (0)
 /*
diff --git a/include/linux/args.h b/include/linux/args.h
new file mode 100644
index 0000000..7ad1e02
--- /dev/null
+++ b/include/linux/args.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+#ifndef LINUX_ARGS_H
+#define LINUX_ARGS_H
+
+#include <linux/kernel.h>
+
+struct args_ops {
+	void (*begin)(void *data);
+	void (*end)(void *data);
+	void (*put_format)(void *data, char c);
+
+	void (*begin_param)(void *data);
+	void (*end_param)(void *data);
+	void (*put_param)(void *data, char c);
+
+	void (*unknown_conversion)(void *data, char c);
+};
+
+extern void args_printf(void *data, const struct args_ops *ops,
+	const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern void args_vprintf(void *data, const struct args_ops *ops,
+	const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+
+#endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 47160fe..f014b7c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/kprint.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -155,15 +156,35 @@ extern void dump_thread(struct pt_regs *regs, struct user *dump);
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
+asmlinkage int printk_asm(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
+static inline int printk_asm(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int __cold printk_asm(const char *s, ...) { return 0; }
+#endif
+
+#ifdef __ASSEMBLY__
+/* Redirect printk() to a backwards-compatible kprint. */
+#define printk kprint_asm
+#endif
+
+#ifndef __ASSEMBLY__
+/* Redirect printk() to kprint. */
+#define printk(fmt, ...)						\
+	do {								\
+		if(fmt[0] == '<' && fmt[1] >= '0' &&			\
+			fmt[1] <= '9' && fmt[2] == '>')			\
+		{							\
+			kprint_wrapper(fmt[1] - '0', KPRINT_NO_CLASS,	\
+				fmt, ## __VA_ARGS__);			\
+		} else {						\
+			kprint(fmt, ## __VA_ARGS__);			\
+		}							\
+	} while(0)
 #endif
 
 unsigned long int_sqrt(unsigned long);
diff --git a/include/linux/kprint-light.h b/include/linux/kprint-light.h
new file mode 100644
index 0000000..f51ce71
--- /dev/null
+++ b/include/linux/kprint-light.h
@@ -0,0 +1,25 @@
+/*
+ * Message-logging API
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+/**
+ * Do not include this header from other headers! (i.e. Don't enforce these
+ * definitions on anybody, since they're fairly common names.)
+ */
+
+#ifndef LINUX_KPRINT_LIGHT_H
+#define LINUX_KPRINT_LIGHT_H
+
+#include <linux/kprint.h>
+
+#define err(fmt, ...) \
+	kprint_err(fmt, ## __VA_ARGS__)
+
+#define warn(fmt, ...) \
+	kprint_warn(fmt, ## __VA_ARGS__)
+
+#define info(fmt, ...) \
+	kprint_info(fmt, ## __VA_ARGS__)
+
+#endif
diff --git a/include/linux/kprint.h b/include/linux/kprint.h
new file mode 100644
index 0000000..27aff06
--- /dev/null
+++ b/include/linux/kprint.h
@@ -0,0 +1,201 @@
+/*
+ * Message-logging API
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+#ifndef LINUX_KPRINT_H
+#define LINUX_KPRINT_H
+
+#include <linux/compiler.h>
+
+enum kprint_loglevel {
+	KPRINT_EMERG,
+	KPRINT_ALERT,
+	KPRINT_CRIT,
+	KPRINT_ERROR,
+	KPRINT_WARNING,
+	KPRINT_NOTICE,
+	KPRINT_INFO,
+	KPRINT_DEBUG,
+};
+
+/* We really need numeric values for these. */
+#ifndef CONFIG_KPRINT_FILTER_EMERG
+#define CONFIG_KPRINT_FILTER_EMERG 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_ALERT
+#define CONFIG_KPRINT_FILTER_ALERT 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_CRIT
+#define CONFIG_KPRINT_FILTER_CRIT 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_ERROR
+#define CONFIG_KPRINT_FILTER_ERROR 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_WARNING
+#define CONFIG_KPRINT_FILTER_WARNING 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_NOTICE
+#define CONFIG_KPRINT_FILTER_NOTICE 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_INFO
+#define CONFIG_KPRINT_FILTER_INFO 0
+#endif
+
+#ifndef CONFIG_KPRINT_FILTER_DEBUG
+#define CONFIG_KPRINT_FILTER_DEBUG 0
+#endif
+
+enum kprint_class {
+	KPRINT_NO_CLASS,
+	KPRINT_DETECTED,
+	KPRINT_REGISTERED,
+	KPRINT_SETTING,
+	KPRINT_COPYRIGHT,
+};
+
+#ifdef CONFIG_KPRINT_TIMESTAMP
+/* XXX: This is ugly. */
+unsigned long long kprint_clock(void);
+#endif
+
+#ifdef CONFIG_KPRINT_TAGS
+/* Default (fall-back) values for subsystem/driver tags. If tags are not
+ * enabled, these symbols will never be referenced. */
+static const char *KPRINT_SUBSYSTEM __maybe_unused = "unknown";
+static const char *KPRINT_DRIVER __maybe_unused = KBUILD_MODNAME;
+#endif
+
+/* Define conditional macros that are used to optimize out structure fields,
+ * function parameters, etc. at compile time. */
+#ifdef CONFIG_KPRINT_CLASS
+#define KPRINT_CLASS(x...) x
+#else
+#define KPRINT_CLASS(x...)
+#endif
+
+#ifdef CONFIG_KPRINT_TIMESTAMP
+#define KPRINT_TIMESTAMP(x...) x
+#else
+#define KPRINT_TIMESTAMP(x...)
+#endif
+
+#ifdef CONFIG_KPRINT_LOCATION
+#define KPRINT_LOCATION(x...) x
+#else
+#define KPRINT_LOCATION(x...)
+#endif
+
+#ifdef CONFIG_KPRINT_TAGS
+#define KPRINT_TAGS(x...) x
+#else
+#define KPRINT_TAGS(x...)
+#endif
+
+/* A single argument, formatted as a string. */
+struct kprint_arg {
+	struct kprint_arg *next;
+	char *arg;
+};
+
+struct kprint_message {
+	enum kprint_loglevel loglevel;
+
+	KPRINT_CLASS(enum kprint_class class);
+	KPRINT_TIMESTAMP(unsigned long long clock);
+	KPRINT_LOCATION(const char *file);
+	KPRINT_LOCATION(unsigned int line);
+	KPRINT_LOCATION(const char *function);
+	KPRINT_TAGS(const char *subsystem);
+	KPRINT_TAGS(const char *module);
+
+	const char *format;
+	struct kprint_arg *args;
+};
+
+void kprint_function(
+	enum kprint_loglevel loglevel,
+	KPRINT_CLASS(enum kprint_class class,)
+	KPRINT_TIMESTAMP(unsigned long long clock,)
+	KPRINT_LOCATION(const char *file,)
+	KPRINT_LOCATION(unsigned int line,)
+	KPRINT_LOCATION(const char *function,)
+	KPRINT_TAGS(const char *subsystem,)
+	KPRINT_TAGS(const char *module,)
+	const char *format, ...);
+
+/* Thank god for constant expression evaluation. This returns true if the
+ * message should be filtered out. */
+#define KPRINT_FILTER(level)						\
+	   (CONFIG_KPRINT_FILTER_EMERG && (level) == KPRINT_EMERG)	\
+	|| (CONFIG_KPRINT_FILTER_ALERT && (level) == KPRINT_ALERT)	\
+	|| (CONFIG_KPRINT_FILTER_CRIT && (level) == KPRINT_CRIT)	\
+	|| (CONFIG_KPRINT_FILTER_ERROR && (level) == KPRINT_ERROR)	\
+	|| (CONFIG_KPRINT_FILTER_WARNING && (level) == KPRINT_WARNING)	\
+	|| (CONFIG_KPRINT_FILTER_NOTICE && (level) == KPRINT_NOTICE)	\
+	|| (CONFIG_KPRINT_FILTER_INFO && (level) == KPRINT_INFO)	\
+	|| (CONFIG_KPRINT_FILTER_DEBUG  && (level) == KPRINT_DEBUG)
+
+#define kprint_wrapper(level, class, fmt, ...)			\
+	if (!(KPRINT_FILTER(level))) {				\
+		kprint_function(				\
+			level,					\
+			KPRINT_CLASS(class,)			\
+			KPRINT_TIMESTAMP(kprint_clock(),)	\
+			KPRINT_LOCATION(__FILE__,)		\
+			KPRINT_LOCATION(__LINE__,)		\
+			KPRINT_LOCATION(__FUNCTION__,)		\
+			KPRINT_TAGS(KPRINT_SUBSYSTEM,)		\
+			KPRINT_TAGS(KPRINT_DRIVER,)		\
+			fmt, ## __VA_ARGS__);		\
+	}
+
+/* Severity levels */
+#define kprint(fmt, ...) \
+	kprint_wrapper(KPRINT_WARNING, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_emerg(fmt, ...) \
+	kprint_wrapper(KPRINT_EMERG, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_alert(fmt, ...) \
+	kprint_wrapper(KPRINT_ALERT, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_crit(fmt, ...) \
+	kprint_wrapper(KPRINT_CRIT, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_err(fmt, ...) \
+	kprint_wrapper(KPRINT_ERROR, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_warn(fmt, ...) \
+	kprint_wrapper(KPRINT_WARNING, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_notice(fmt, ...) \
+	kprint_wrapper(KPRINT_NOTICE, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_info(fmt, ...) \
+	kprint_wrapper(KPRINT_INFO, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+#define kprint_debug(fmt, ...) \
+	kprint_wrapper(KPRINT_DEBUG, KPRINT_NO_CLASS, fmt, ## __VA_ARGS__)
+
+
+/* Classification tags */
+#define kprint_detected(fmt, ...) \
+	kprint_wrapper(KPRINT_INFO, KPRINT_DETECTED, fmt, ## __VA_ARGS__)
+
+#define kprint_registered(fmt, ...) \
+	kprint_wrapper(KPRINT_INFO, KPRINT_REGISTERED, fmt, ## __VA_ARGS__)
+
+#define kprint_setting(fmt, ...) \
+	kprint_wrapper(KPRINT_INFO, KPRINT_SETTING, fmt, ## __VA_ARGS__)
+
+#define kprint_copyright(fmt, ...) \
+	kprint_wrapper(KPRINT_INFO, KPRINT_COPYRIGHT, fmt, ## __VA_ARGS__)
+
+#endif
diff --git a/include/linux/ringbuffer.h b/include/linux/ringbuffer.h
new file mode 100644
index 0000000..814bbe5
--- /dev/null
+++ b/include/linux/ringbuffer.h
@@ -0,0 +1,34 @@
+/*
+ * General-purpose ring-buffer data structure
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+#ifndef LINUX_RINGBUFFER_H
+#define LINUX_RINGBUFFER_H
+
+#include <linux/kernel.h>
+
+struct ringbuffer {
+	char *data;
+	unsigned int size;
+	unsigned int mask;
+
+	unsigned int wr;
+	unsigned int rd;
+
+	unsigned int fill_count;
+};
+
+void ringbuffer_init(struct ringbuffer *rb, char *data, unsigned int size);
+void ringbuffer_clear(struct ringbuffer *rb);
+unsigned int ringbuffer_fill_count(struct ringbuffer *rb);
+unsigned int ringbuffer_write(struct ringbuffer *rb,
+	const char *data, unsigned int size);
+unsigned int ringbuffer_read(struct ringbuffer *rb,
+	char  *data, unsigned int size);
+unsigned int ringbuffer_write_user(struct ringbuffer *rb,
+	const char __user *data, unsigned int size);
+unsigned int ringbuffer_read_user(struct ringbuffer *rb,
+	char __user *data, unsigned int size);
+
+#endif
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index c9cc00c..224a672 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -288,7 +288,11 @@ struct sctp_mib {
 #if SCTP_DEBUG
 extern int sctp_debug_flag;
 #define SCTP_DEBUG_PRINTK(whatever...) \
-	((void) (sctp_debug_flag && printk(KERN_DEBUG whatever)))
+	do { \
+		if(sctp_debug_flag) { \
+			 printk(KERN_DEBUG whatever); \
+		} \
+	} while(0)
 #define SCTP_DEBUG_PRINTK_IPADDR(lead, trail, leadparm, saddr, otherparms...) \
 	if (sctp_debug_flag) { \
 		if (saddr->sa.sa_family == AF_INET6) { \
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d5057bc..4186d93 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,10 +157,16 @@ struct scsi_device {
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
 #define scmd_printk(prefix, scmd, fmt, a...)				\
-        (scmd)->request->rq_disk ?					\
-	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
-	sdev_printk(prefix, (scmd)->device, fmt, ##a)
+	do {								\
+		if((scmd)->request->rq_disk) {				\
+			sdev_printk(prefix, (scmd)->device,		\
+				"[%s] " fmt,				\
+				(scmd)->request->rq_disk->disk_name,	\
+				##a);					\
+		} else {						\
+			sdev_printk(prefix, (scmd)->device, fmt, ##a);	\
+		}							\
+	} while(0)
 
 enum scsi_target_state {
 	STARGET_RUNNING = 1,
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index ce02ad1..3d98e29 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -62,9 +62,14 @@ static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
 #define sd_printk(prefix, sdsk, fmt, a...)				\
-        (sdsk)->disk ?							\
-	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
-	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+	do {								\
+		if((sdsk)->disk) {					\
+			sdev_printk(prefix, (sdsk)->device,		\
+			"[%s] " fmt,					\
+			(sdsk)->disk->disk_name, ##a);			\
+		} else {						\
+			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	\
+		}							\
+	} while(0)
 
 #endif /* _SCSI_DISK_H */
diff --git a/init/Kconfig b/init/Kconfig
index d54d0ca..9848295 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -571,6 +571,8 @@ config SLOB
 
 endchoice
 
+source "kernel/Kconfig.kprint"
+
 endmenu		# General setup
 
 config RT_MUTEXES
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index fd4fc12..385a39e 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -98,7 +98,7 @@ static void __init handle_initrd(void)
 			error = sys_ioctl(fd, BLKFLSBUF, 0);
 			sys_close(fd);
 		}
-		printk(!error ? "okay\n" : "failed\n");
+		printk("%s\n", error ? "failed" : "okay");
 	}
 }
 
diff --git a/kernel/Kconfig.kprint b/kernel/Kconfig.kprint
new file mode 100644
index 0000000..119ca41
--- /dev/null
+++ b/kernel/Kconfig.kprint
@@ -0,0 +1,125 @@
+#
+# Message-logging API configuration
+#
+
+menu "Logging"
+
+config KPRINT_CLASS
+	bool "Classification tags"
+	default y
+	help
+	  Classification tags are used to provide a programmatic way to
+	  distinguish between different kinds of log messages. For instance,
+	  all messages about registered or un-registered drivers will be
+	  tagged with the "registered" tag.
+
+	  It is safe to say N here.
+
+config KPRINT_TIMESTAMP
+	bool "Timestamps"
+	default y
+	help
+	  Along with each log entry, record when the message was emitted.
+
+	  It is safe to say N here.
+
+config KPRINT_LOCATION
+	bool "Message source"
+	default n
+	help
+	  This option saves the location (i.e. source file, line, and name of
+	  the current function) of each recorded log message.
+
+	  Saying Y here will increase the size of your kernel by a lot. This is
+	  primarily a tool for developers (or the curious).
+
+	  If unsure, say N.
+
+config KPRINT_TAGS
+	bool "Subsystem/driver tags"
+	default y
+	help
+	  The subsystem/driver tags are tags that identify the source
+	  subsystem and/or driver for each log messages. An example of this
+	  would be "NET: Registered protocol family 10" where the subsystem
+	  part is "NET".
+
+	  Turning this option off will decrease the size of the kernel, at
+	  the cost of log readability. This is primarily useful for embedded
+	  systems.
+
+	  If unsure, say Y.
+
+menu "Log-level filters"
+
+config KPRINT_FILTER_EMERG
+	bool "Filter EMERG messages"
+	default n
+	help
+	  This option removes all EMERG (emergency) messages from the kernel.
+
+	  This is probably not something you want, so say N.
+
+config KPRINT_FILTER_ALERT
+	bool "Filter ALERT messages"
+	default n
+	help
+	  This option removes all ALERT messages from the kernel.
+
+	  This is probably not something you want, so say N.
+
+config KPRINT_FILTER_CRIT
+	bool "Filter CRIT messages"
+	default n
+	help
+	  This option removes all CRIT (critical) messages from the kernel.
+
+	  This is probably not something you want, so say N.
+
+config KPRINT_FILTER_ERROR
+	bool "Filter ERROR messages"
+	default n
+	help
+	  This option removes all ERROR messages from the kernel.
+
+	  This is probably not something you want, so say N.
+
+config KPRINT_FILTER_WARNING
+	bool "Filter WARNING messages"
+	default n
+	help
+	  This option removes all WARNING messages from the kernel.
+
+	  This is probably not something you want, so say N.
+
+config KPRINT_FILTER_NOTICE
+	bool "Filter NOTICE messages"
+	default n
+	help
+	  This option removes all NOTICE messages from the kernel.
+
+	  This is probably not something you want, though it will probably
+	  reduce the size of the kernel. If unsure, say N.
+
+config KPRINT_FILTER_INFO
+	bool "Filter INFO messages"
+	default n
+	help
+	  This option removes all INFO messages from the kernel.
+
+	  This is probably not something you want, though it will probably
+	  reduce the size of the kernel. If unsure, say N.
+
+config KPRINT_FILTER_DEBUG
+	bool "Filter DEBUG messages"
+	default n
+	help
+	  This option removes all DEBUG messages from the kernel.
+
+	  This is probably not something you want, though it will probably
+	  reduce the size of the kernel. Even though you are not a developer,
+	  debugging info will help you when something goes wrong, so say N.
+
+endmenu
+
+endmenu
diff --git a/kernel/Makefile b/kernel/Makefile
index 2a99983..3eb28f3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o kprint.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/kprint.c b/kernel/kprint.c
new file mode 100644
index 0000000..53ca573
--- /dev/null
+++ b/kernel/kprint.c
@@ -0,0 +1,345 @@
+/*
+ * Message-logging API
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+#include <asm/uaccess.h>
+
+#include <linux/args.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/kprint.h>
+#include <linux/module.h>
+#include <linux/ringbuffer.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+/* Callbacks and data for arg_printf() to extract only the parameter text.
+ * Surround each argument with double quotes (escaping any double quotes that
+ * may appear in the argument string itself), and separate each argument by a
+ * single space. */
+struct escape_args {
+	/* When we end a parameter, we need to know if it was the first one
+	 * in the string, because if it's not, we have to add the separating
+	 * space before the actual parameter text. */
+	int first_param;
+
+	/* In the print_args routines, we want to omit the surrounding
+	 * double-quotes if we can. Keep track of whether the parameter is
+	 * empty (no output) or not, so we can output the double quotes if
+	 * it is. */
+	int empty_param;
+
+	char *buf;
+	char *end;
+};
+
+static void output_char(struct escape_args *e, char c)
+{
+	if(e->buf < e->end)
+		*e->buf = c;
+	++e->buf;
+}
+
+static void escape_begin(void *data)
+{
+	struct escape_args *e = data;
+
+	e->first_param = 1;
+}
+
+static void escape_end(void *data)
+{
+}
+
+static void escape_put_format(void *data, char c)
+{
+}
+
+static void escape_begin_param(void *data)
+{
+	struct escape_args *e = data;
+
+	if(e->first_param)
+		e->first_param = 0;
+	else
+		output_char(e, ' ');
+
+	output_char(e, '\"');
+}
+
+static void escape_end_param(void *data)
+{
+	struct escape_args *e = data;
+
+	output_char(e, '\"');
+}
+
+static void escape_put_param(void *data, char c)
+{
+	static const char digits[] = "0123456789abcdef";
+	struct escape_args *e = data;
+
+	if(!isprint(c)) {
+		output_char(e, '\\');
+		output_char(e, 'x');
+		output_char(e, digits[c >> 4]);
+		output_char(e, digits[c & 0x0f]);
+		return;
+	}
+
+	/* Escape double quotes and backslashes. */
+	if(c == '\"' || c == '\\')
+		output_char(e, '\\');
+
+	output_char(e, c);
+}
+
+static const struct args_ops escape_args = {
+	.begin = &escape_begin,
+	.end = &escape_end,
+	.put_format = &escape_put_format,
+
+	.begin_param = &escape_begin_param,
+	.end_param = &escape_end_param,
+	.put_param = &escape_put_param,
+
+	.unknown_conversion = &escape_put_format,
+};
+
+static void print_begin(void *data)
+{
+}
+
+static void print_end(void *data)
+{
+}
+
+static void print_put_format(void *data, char c)
+{
+	struct escape_args *e = data;
+
+	output_char(e, c);
+}
+
+static void print_begin_param(void *data)
+{
+	struct escape_args *e = data;
+
+	e->empty_param = 1;
+}
+
+static void print_end_param(void *data)
+{
+	struct escape_args *e = data;
+
+	if(e->empty_param) {
+		output_char(e, '\"');
+		output_char(e, '\"');
+	}
+}
+
+static void print_put_param(void *data, char c)
+{
+	struct escape_args *e = data;
+
+	escape_put_param(data, c);
+	e->empty_param = 0;
+}
+
+static const struct args_ops print_args = {
+	.begin = &print_begin,
+	.end = &print_end,
+	.put_format = &print_put_format,
+
+	.begin_param = &print_begin_param,
+	.end_param = &print_end_param,
+	.put_param = &print_put_param,
+
+	.unknown_conversion = &print_put_format,
+};
+
+/* Use the same log size as printk. Note that this MUST be a power of two in
+ * order for the ring-buffer to work (safely). */
+static char log_data[1 << CONFIG_LOG_BUF_SHIFT];
+static struct ringbuffer log_buffer = {
+	.data = log_data,
+	.size = sizeof(log_data),
+	.mask = sizeof(log_data) - 1,
+	.wr = 0,
+	.rd = 0,
+	.fill_count = 0,
+};
+
+static spinlock_t log_spinlock = SPIN_LOCK_UNLOCKED;
+static DECLARE_WAIT_QUEUE_HEAD(log_waitqueue);
+
+/* This is the condition that log_waitqueue (klogctl(2, ...)) will wake up
+ * with. It is also protected by log_spinlock. */
+static int log_contains_data = 0;
+
+/* This is the main kprint machinery. This function takes arguments from all
+ * the kprint "extensions", saves them to the log, formats the message, and
+ * stores the arguments. Phew. */
+void kprint_function(
+	enum kprint_loglevel loglevel,
+	KPRINT_CLASS(enum kprint_class class,)
+	KPRINT_TIMESTAMP(unsigned long long clock,)
+	KPRINT_LOCATION(const char *file,)
+	KPRINT_LOCATION(unsigned int line,)
+	KPRINT_LOCATION(const char *function,)
+	KPRINT_TAGS(const char *subsystem,)
+	KPRINT_TAGS(const char *module,)
+	const char *format, ...)
+{
+	static char s[1024];
+	static int printed_len;
+
+	unsigned long flags;
+
+	/* We use this to hold the "format without log-level prepended" */
+	const char *kprint_format;
+
+	va_list ap;
+	struct escape_args esc;
+
+	kprint_format = format;
+	if(format[0] == '<' && format[1] >= '0'
+		&& format[1] <= '9' && format[2] == '>')
+	{
+		kprint_format += 3;
+	}
+
+	esc.buf = s;
+	esc.end = s + sizeof(s);
+
+	/* Part 1: Extension-specific attributes */
+	args_printf(&esc, &print_args, "%d", loglevel);
+	KPRINT_CLASS(args_printf(&esc, &print_args, " %d", class));
+	KPRINT_TIMESTAMP(args_printf(&esc, &print_args, " %llu", clock));
+	KPRINT_LOCATION(args_printf(&esc, &print_args,
+		" %s %d %s", file, line, function));
+	KPRINT_TAGS(args_printf(&esc, &print_args,
+		" %s %s", subsystem, module));
+	args_printf(&esc, &print_args, ", ");
+
+	/* Part 2: Format string */
+	args_printf(&esc, &escape_args, "%s", kprint_format);
+	args_printf(&esc, &print_args, ", ");
+
+	/* Part 3: Parameters */
+	va_start(ap, format);
+	args_vprintf(&esc, &escape_args, kprint_format, ap);
+	va_end(ap);
+
+	/* Close with a newline. */
+	args_printf(&esc, &print_args, "\n");
+
+	/* Log the whole thing to the kprint ring-buffer */
+	printed_len = esc.buf - s;
+	if(printed_len > sizeof(s))
+		printed_len = sizeof(s);
+
+	spin_lock_irqsave(&log_spinlock, flags);
+	printed_len = printed_len
+		- ringbuffer_write(&log_buffer, s, printed_len);
+	log_contains_data = !!ringbuffer_fill_count(&log_buffer);
+	spin_unlock_irqrestore(&log_spinlock, flags);
+
+	/* Wake up readers */
+	wake_up(&log_waitqueue);
+
+	/* We hand this over to the old printk, and let that take care of
+	 * printing to the console and storing the plain-text version. */
+	va_start(ap, format);
+	vprintk(format, ap);
+	va_end(ap);
+}
+
+EXPORT_SYMBOL(kprint_function);
+
+/* We're putting this here because linux/sched.h can't be included in
+ * linux/kprint.h. */
+unsigned long long kprint_clock(void)
+{
+	return sched_clock();
+}
+
+EXPORT_SYMBOL(kprint_clock);
+
+/* The "format" of each log entry, i.e. which parameters we're
+ * printing, in order. */
+static const char kprint_columns[] =
+	"loglevel"
+	KPRINT_CLASS(" class")
+	KPRINT_TIMESTAMP(" clock")
+	KPRINT_LOCATION(" file line function")
+	KPRINT_TAGS(" subsystem module");
+
+/**
+ * Similar to do_syslog() in kernel/printk.c. In order to reach this from
+ * user-space, call syslog() with (type | 0x10).
+ *
+ * In addition to the plain syslog() commands, we also have one to print the
+ * column headers (field names) for the optional (extension-specific)
+ * attributes.
+ *
+ */
+int do_syslog_kprint(int type, char __user *buf, int len)
+{
+	/* XXX: Check security */
+	int ret = 0;
+
+	switch(type) {
+	case 0: /* Close the log */
+		return 0;
+	case 1: /* Open the log */
+		return 0;
+	case 2: /* Read from the log */
+
+		/* Sleep until the buffer contains something. Note that if
+		 * there are several processes waiting here, they'll try to
+		 * steal the chunks from each other and the results will be
+		 * unpredictable. */
+		ret = wait_event_interruptible(log_waitqueue,
+			log_contains_data);
+		if(ret)
+			return ret;
+
+		spin_lock(&log_spinlock);
+		ret = len - ringbuffer_read_user(&log_buffer, buf, len);
+		log_contains_data = !!ringbuffer_fill_count(&log_buffer);
+		spin_unlock(&log_spinlock);
+
+		/* Even though it's silly, we need to wake up others that
+		 * might be waiting, in case there's more data. */
+		wake_up(&log_waitqueue);
+		return ret;
+	case 3: /* Read all messages remaining in the ring buffer */
+		return -EINVAL;
+	case 4: /* Read and clear all messages remaining in the ring buffer */
+		spin_lock(&log_spinlock);
+		ret = len - ringbuffer_read_user(&log_buffer, buf, len);
+		ringbuffer_clear(&log_buffer);
+		log_contains_data = 0;
+		spin_unlock(&log_spinlock);
+
+		/* No need to wake anybody up at this point, since the
+		 * condition they'll wake up on is false. */
+		return ret;
+	case 5: /* Clear ring buffer */
+		ringbuffer_clear(&log_buffer);
+		return 0;
+	case 9: /* Return number of unread characters in the log buffer */
+		return ringbuffer_fill_count(&log_buffer);
+	case 10: /* Return size of the log buffer */
+		return sizeof(log_data);
+	case 11: /* Return attribute names (i.e. column headers) */
+		ret = min((int) sizeof(kprint_columns), len);
+		copy_to_user(buf, kprint_columns, ret);
+		return ret;
+	}
+
+	return -EINVAL;
+}
diff --git a/kernel/printk.c b/kernel/printk.c
index 8451dfc..d6a81cc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -312,8 +312,13 @@ out:
 	return error;
 }
 
+extern int do_syslog_kprint(int type, char __user *buf, int len);
+
 asmlinkage long sys_syslog(int type, char __user *buf, int len)
 {
+	if(type & 0x10)
+		return do_syslog_kprint(type & ~0x10, buf, len);
+
 	return do_syslog(type, buf, len);
 }
 
@@ -504,7 +509,7 @@ static int have_callable_console(void)
  * printf(3)
  */
 
-asmlinkage int printk(const char *fmt, ...)
+asmlinkage int printk_asm(const char *fmt, ...)
 {
 	va_list args;
 	int r;
@@ -639,7 +644,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
+EXPORT_SYMBOL(printk_asm);
 EXPORT_SYMBOL(vprintk);
 
 #else
diff --git a/lib/Makefile b/lib/Makefile
index 6b0ba8c..608b552 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,8 @@
 lib-y := ctype.o string.o vsprintf.o kasprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
+	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
+	 ringbuffer.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/ringbuffer.c b/lib/ringbuffer.c
new file mode 100644
index 0000000..645c1ff
--- /dev/null
+++ b/lib/ringbuffer.c
@@ -0,0 +1,155 @@
+/*
+ * General-purpose ring-buffer data structure
+ * Copyright (C) 2007  Vegard Nossum
+ */
+
+#include <asm/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/ringbuffer.h>
+
+/* Size must be a power of two. */
+void ringbuffer_init(struct ringbuffer *rb, char *data, unsigned int size)
+{
+	rb->data = data;
+	rb->size = size;
+	rb->mask = size - 1;
+
+	rb->wr = 0;
+	rb->rd = 0;
+
+	rb->fill_count = 0;
+}
+
+void ringbuffer_clear(struct ringbuffer *rb)
+{
+	rb->wr = 0;
+	rb->rd = 0;
+
+	rb->fill_count = 0;
+}
+
+unsigned int ringbuffer_fill_count(struct ringbuffer *rb) {
+	return rb->fill_count;
+}
+
+/* Returns the number of bytes remaining in data (i.e. the number of bytes
+ * that were NOT written). */
+unsigned int ringbuffer_write(struct ringbuffer *rb,
+	const char *data, unsigned int size)
+{
+	unsigned int n = 2;
+
+	do {
+		unsigned int can_write;
+
+		if(rb->fill_count == rb->size || !size)
+			return size;
+
+		/* How much can we fit after the write pointer?
+		 * Stop at the read pointer or end of the buffer. */
+		if(rb->wr >= rb->rd)
+			can_write = rb->size - rb->wr;
+		else
+			can_write = rb->rd - rb->wr;
+
+		/* Also, don't write more than the input buffer contains. */
+		if(can_write > size)
+			can_write = size;
+
+		/* Write the chunk. */
+		memcpy(rb->data + rb->wr, data, can_write);
+		rb->wr = (rb->wr + can_write) & rb->mask;
+		rb->fill_count += can_write;
+		data += can_write;
+		size -= can_write;
+	} while(--n);
+
+	return size;
+}
+
+unsigned int ringbuffer_read(struct ringbuffer *rb,
+	char *data, unsigned int size)
+{
+	unsigned int n = 2;
+
+	do {
+		unsigned int can_read;
+
+		if(rb->fill_count == 0 || !size)
+			return size;
+
+		if(rb->rd >= rb->wr)
+			can_read = rb->size - rb->rd;
+		else
+			can_read = rb->wr - rb->rd;
+
+		if(can_read > size)
+			can_read = size;
+
+		memcpy(data, rb->data + rb->rd, can_read);
+		rb->rd = (rb->rd + can_read) & rb->mask;
+		rb->fill_count -= can_read;
+		data += can_read;
+		size -= can_read;
+	} while(--n);
+
+	return size;
+}
+
+unsigned int ringbuffer_write_user(struct ringbuffer *rb,
+	const char __user *data, unsigned int size)
+{
+	unsigned int n = 2;
+
+	do {
+		unsigned int can_write;
+
+		if(rb->fill_count == rb->size || !size)
+			return size;
+
+		if(rb->wr >= rb->rd)
+			can_write = rb->size - rb->wr;
+		else
+			can_write = rb->rd - rb->wr;
+
+		if(can_write > size)
+			can_write = size;
+
+		copy_from_user(rb->data + rb->wr, data, can_write);
+		rb->wr = (rb->wr + can_write) & rb->mask;
+		rb->fill_count += can_write;
+		data += can_write;
+		size -= can_write;
+	} while(--n);
+
+	return size;
+}
+
+unsigned int ringbuffer_read_user(struct ringbuffer *rb,
+	char __user *data, unsigned int size)
+{
+	unsigned int n = 2;
+
+	do {
+		unsigned int can_read;
+
+		if(rb->fill_count == 0 || !size)
+			return size;
+
+		if(rb->rd >= rb->wr)
+			can_read = rb->size - rb->rd;
+		else
+			can_read = rb->wr - rb->rd;
+
+		if(can_read > size)
+			can_read = size;
+
+		copy_to_user(data, rb->data + rb->rd, can_read);
+		rb->rd = (rb->rd + can_read) & rb->mask;
+		rb->fill_count -= can_read;
+		data += can_read;
+		size -= can_read;
+	} while(--n);
+
+	return size;
+}
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7b481ce..f7d7055 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -17,6 +17,7 @@
  */
 
 #include <stdarg.h>
+#include <linux/args.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -355,6 +356,101 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	return buf;
 }
 
+/* Similar to number(), only we don't output to a string. */
+static void args_number(void *data, const struct args_ops *ops,
+	unsigned long long num, int base, int size, int precision, int type)
+{
+	char sign,tmp[66];
+	const char *digits;
+	/* we are called with base 8, 10 or 16, only, thus don't need "g..."  */
+	static const char small_digits[] = "0123456789abcdefx"; /* "ghijklmnopqrstuvwxyz"; */
+	static const char large_digits[] = "0123456789ABCDEFX"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+	int need_pfx = ((type & SPECIAL) && base != 10);
+	int i;
+
+	digits = (type & LARGE) ? large_digits : small_digits;
+	if (type & LEFT)
+		type &= ~ZEROPAD;
+	if (base < 2 || base > 36)
+		return;
+	sign = 0;
+	if (type & SIGN) {
+		if ((signed long long) num < 0) {
+			sign = '-';
+			num = - (signed long long) num;
+			size--;
+		} else if (type & PLUS) {
+			sign = '+';
+			size--;
+		} else if (type & SPACE) {
+			sign = ' ';
+			size--;
+		}
+	}
+	if (need_pfx) {
+		size--;
+		if (base == 16)
+			size--;
+	}
+
+	/* generate full string in tmp[], in reverse order */
+	i = 0;
+	if (num == 0)
+		tmp[i++] = '0';
+	/* Generic code, for any base:
+	else do {
+		tmp[i++] = digits[do_div(num,base)];
+	} while (num != 0);
+	*/
+	else if (base != 10) { /* 8 or 16 */
+		int mask = base - 1;
+		int shift = 3;
+		if (base == 16) shift = 4;
+		do {
+			tmp[i++] = digits[((unsigned char)num) & mask];
+			num >>= shift;
+		} while (num);
+	} else { /* base 10 */
+		i = put_dec(tmp, num) - tmp;
+	}
+
+	/* printing 100 using %2d gives "100", not "00" */
+	if (i > precision)
+		precision = i;
+	/* leading space padding */
+	size -= precision;
+	if (!(type & (ZEROPAD+LEFT))) {
+		while(--size >= 0)
+			ops->put_param(data, ' ');
+	}
+	/* sign */
+	if (sign)
+		ops->put_param(data, sign);
+	/* "0x" / "0" prefix */
+	if (need_pfx) {
+		ops->put_param(data, '0');
+		if (base == 16) {
+			ops->put_param(data, digits[16]);
+			/* for arbitrary base: digits[33]; */
+		}
+	}
+	/* zero or space padding */
+	if (!(type & LEFT)) {
+		char c = (type & ZEROPAD) ? '0' : ' ';
+		while (--size >= 0)
+			ops->put_param(data, c);
+	}
+	/* hmm even more zero padding? */
+	while (i <= --precision)
+		ops->put_param(data, '0');
+	/* actual digits of result */
+	while (--i >= 0)
+		ops->put_param(data, tmp[i]);
+	/* trailing space padding */
+	while (--size >= 0)
+		ops->put_param(data, ' ');
+}
+
 /**
  * vsnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -616,6 +712,217 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 EXPORT_SYMBOL(vsnprintf);
 
+/* This is similar to printf(), except we call output_format() whenever
+ * we want to output a character that was part of the format string, and we
+ * call output_parameter() whenever we want to output a character that was
+ * the result of a parameter conversion. No call is made for the last NULL
+ * byte.
+ *
+ * Returns nothing; it would be the responsibility of the caller/callbacks
+ * to keep track of that.
+ *
+ * Technically, printf() could be implemented in terms of this function,
+ * and quite elegantly, too, but as that is probably already hand-optimized,
+ * they will stay separate for now.
+ */
+void args_vprintf(void *data, const struct args_ops *ops,
+	const char *fmt, va_list args)
+{
+	int len;
+	unsigned long long num;
+	int i, base;
+	char c;
+	const char *s;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/* min. # of digits for integers; max
+				   number of chars for from string */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+				/* 'z' support added 23/7/1999 S.H.    */
+				/* 'z' changed to 'Z' --davidm 1/25/99 */
+				/* 't' added for ptrdiff_t */
+
+	ops->begin(data);
+
+	for (; *fmt ; ++fmt) {
+		if (*fmt != '%') {
+			ops->put_format(data, *fmt);
+			continue;
+		}
+
+		ops->begin_param(data);
+
+		/* process flags */
+		flags = 0;
+		repeat:
+			++fmt;		/* this also skips first '%' */
+			switch (*fmt) {
+				case '-': flags |= LEFT; goto repeat;
+				case '+': flags |= PLUS; goto repeat;
+				case ' ': flags |= SPACE; goto repeat;
+				case '#': flags |= SPECIAL; goto repeat;
+				case '0': flags |= ZEROPAD; goto repeat;
+			}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = va_arg(args, int);
+			if (field_width < 0) {
+				field_width = -field_width;
+				flags |= LEFT;
+			}
+		}
+
+		/* get the precision */
+		precision = -1;
+		if (*fmt == '.') {
+			++fmt;	
+			if (isdigit(*fmt))
+				precision = skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				precision = va_arg(args, int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
+		    *fmt =='Z' || *fmt == 'z' || *fmt == 't') {
+			qualifier = *fmt;
+			++fmt;
+			if (qualifier == 'l' && *fmt == 'l') {
+				qualifier = 'L';
+				++fmt;
+			}
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+			case 'c':
+				if (!(flags & LEFT)) {
+					while (--field_width > 0)
+						ops->put_param(data, ' ');
+				}
+				c = (unsigned char) va_arg(args, int);
+				ops->put_param(data, c);
+				while (--field_width > 0)
+					ops->put_param(data, ' ');
+				ops->end_param(data);
+				continue;
+
+			case 's':
+				s = va_arg(args, char *);
+				if ((unsigned long)s < PAGE_SIZE)
+					s = "<NULL>";
+
+				len = strnlen(s, precision);
+
+				if (!(flags & LEFT)) {
+					while (len < field_width--)
+						ops->put_param(data, ' ');
+				}
+				for (i = 0; i < len; ++i) {
+					ops->put_param(data, *s);
+					++s;
+				}
+				while (len < field_width--)
+					ops->put_param(data, ' ');
+				ops->end_param(data);
+				continue;
+
+			case 'p':
+				if (field_width == -1) {
+					field_width = 2*sizeof(void *);
+					flags |= ZEROPAD;
+				}
+				args_number(data, ops,
+					(unsigned long) va_arg(args, void *),
+					16, field_width, precision, flags);
+				ops->end_param(data);
+				continue;
+
+
+			case 'n':
+				if (qualifier == 'l')
+					va_arg(args, long *);
+				else if (qualifier == 'Z' || qualifier == 'z')
+					va_arg(args, size_t *);
+				else
+					va_arg(args, int *);
+				ops->end_param(data);
+				continue;
+
+			case '%':
+				ops->put_param(data, '%');
+				ops->end_param(data);
+				continue;
+
+				/* integer number formats - set up the flags and "break" */
+			case 'o':
+				base = 8;
+				break;
+
+			case 'X':
+				flags |= LARGE;
+			case 'x':
+				base = 16;
+				break;
+
+			case 'd':
+			case 'i':
+				flags |= SIGN;
+			case 'u':
+				break;
+
+			default:
+				ops->unknown_conversion(data, *fmt);
+				if (!*fmt)
+					--fmt;
+				ops->end_param(data);
+				continue;
+		}
+		if (qualifier == 'L')
+			num = va_arg(args, long long);
+		else if (qualifier == 'l') {
+			num = va_arg(args, unsigned long);
+			if (flags & SIGN)
+				num = (signed long) num;
+		} else if (qualifier == 'Z' || qualifier == 'z') {
+			num = va_arg(args, size_t);
+		} else if (qualifier == 't') {
+			num = va_arg(args, ptrdiff_t);
+		} else if (qualifier == 'h') {
+			num = (unsigned short) va_arg(args, int);
+			if (flags & SIGN)
+				num = (signed short) num;
+		} else {
+			num = va_arg(args, unsigned int);
+			if (flags & SIGN)
+				num = (signed int) num;
+		}
+		args_number(data, ops,
+			num, base, field_width, precision, flags);
+		ops->end_param(data);
+	}
+
+	ops->end(data);
+}
+
+EXPORT_SYMBOL(args_vprintf);
+
 /**
  * vscnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -666,6 +973,20 @@ int snprintf(char * buf, size_t size, const char *fmt, ...)
 EXPORT_SYMBOL(snprintf);
 
 /**
+ * See args_vsnprintf().
+ */
+void args_printf(void *data, const struct args_ops *ops, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	args_vprintf(data, ops, fmt, ap);
+	va_end(ap);
+}
+
+EXPORT_SYMBOL(args_printf);
+
+/**
  * scnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
diff --git a/net/tipc/dbg.c b/net/tipc/dbg.c
index e809d2a..d00fa22 100644
--- a/net/tipc/dbg.c
+++ b/net/tipc/dbg.c
@@ -288,7 +288,7 @@ static void print_to_console(char *crs, int len)
 		char c = crs[sz];
 
 		crs[sz] = 0;
-		printk((const char *)crs);
+		printk("%s", crs);
 		crs[sz] = c;
 		rest -= sz;
 		crs += sz;


