Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXIUO2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXIUO2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXIUO20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:28:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:41076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXIUO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TAYo8BIBo+Nt9CDy+QuaxSixsmdR1Nj1nFmEWYCmg5jgE1FA3Y3QzuuDA8NPnS8UbqnfjzWw9XqqhWm90WjNUt+BxmKRsr33nngd6DKd9J1pyFaKY1PnrX+5BANNEaYsMB2q20U8y4jdZQYIOGJFJvVS1Txm+bSX6NjOIdPOptQ=
Subject: [PATCH] Reduce __print_symbol/sprint_symbol stack usage. (v3)
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>,
       Paulo Marques <pmarques@grupopie.com>
In-Reply-To: <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 16:28:13 +0200
Message-Id: <1190384893.30016.42.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

(1) Problem:
I. When CONFIG_4KSTACKS and CONFIG_DEBUG_STACKOVERFLOW are enabled on
i386 kernels, do_IRQ calls dump_stack which, down the path, uses
print_symbol (display) and  sprint_symbol (format) to format and display
the function name/address/module.
Both function use stack based char array (~350 bytes) that, given the
initial state (<512 bytes of stack space) may overrun the stack.
II. (Comments - previous patches) Using spinlock protected static
storage within these functions might block or even deadlock dump_stack
(E.g. Crash within dump_stack itself)

(2) Solution:
I. Break sprint_symbol into sprint_symbol (API functions; keeps the
current interface) and sprint_symbol_helper (helper function with
minimal local storage). 
II. Replace the char array in __print_symbol with two spinlock protected
static char arrays; call the __sprint_symbol helper function instead of
sprint_symbol.
III. Ignore the spinlock if oops_in_progress is set.

(3) Comments:
I. Currently, if oops_in_progress is set, multiple callers can trash
each other.
II. In order to solve it, print_symbol (and/or dump_stack itself) must
be aware of it's own context. (Read: if it's being called by oops, or by
a "debug/warning" code).
III. Possible solutions:
A. Add oops_in_progress_cpuid to bust_spinlocks (Hack, but generates far
less noise).
B. Add priority tag to all the functions that handle the calls stuck.
(Nicer, requires a massive tree-changing patch.)

Signed-off-by: Gilboa Davara <gilboad@gmail.org>

Satyam, Paulo,
     A. I hope this patch better complies with your comments.

- Gilboa
--- linux-2.6/kernel/kallsyms.orig	2007-09-20 19:17:49.000000000 +0200
+++ linux-2.6/kernel/kallsyms.c	2007-09-21 16:24:03.000000000 +0200
@@ -306,13 +306,17 @@ int lookup_symbol_attrs(unsigned long ad
 	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
 }
 
-/* Look up a kernel symbol and return it in a text buffer. */
-int sprint_symbol(char *buffer, unsigned long address)
+/*
+ * Helper function:
+ *
+ * Look up a kernel symbol and module name and return them to the
+ *   caller's buffer/namebuf buffers.
+*/
+int sprint_symbol_helper(char *buffer, char *namebuf, unsigned long
address)
 {
-	char *modname;
-	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN];
+	const char *name;
+	char *modname;
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
@@ -325,14 +329,52 @@ int sprint_symbol(char *buffer, unsigned
 		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 }
 
+/*
+ * API function:
+ *
+ * Look up a kernel symbol and return it in a text buffer.
+ */
+int sprint_symbol(char *buffer, unsigned long address)
+{
+	char namebuf[KSYM_NAME_LEN];
+
+	return sprint_symbol_helper(buffer, namebuf, address);
+}
+
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
+	/*
+	 * Use static buffers instead of char array to reduce the
+	 *   stack footprint in i386/4KSTACKS.
+	 * Buffers must be protected against re-entry.
+	 * ( As long as Oops is not in progress. )
+	 */
+	static DEFINE_SPINLOCK(symbol_lock);
+	static char namebuf[KSYM_NAME_LEN];
+	static char buffer[KSYM_SYMBOL_LEN];
+	unsigned long flags;
+	int locked = 0;
+
+
+	/*
+	 * Bust all spinlocks if oops is in progress.
+	 * FIXME: Might generate broken output if BUG()/oops
+	 *   generates a callstack while another one uses
+	 *   dump_stack for debug purposes.
+	 */
+	if (!oops_in_progress) {
+		/* Normal lock mode. */
+		spin_lock_irqsave(&symbol_lock, flags);
+		locked = 1;
+	}
 
+	sprint_symbol_helper(buffer, namebuf, address);
 	printk(fmt, buffer);
+
+	if (locked)
+		spin_unlock_irqrestore(&symbol_lock, flags);
 }
 
 /* To avoid using get_symbol_offset for every symbol, we carry prefix
along. */


