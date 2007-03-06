Return-Path: <linux-kernel-owner+w=401wt.eu-S1750720AbXCFU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750720AbXCFU1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXCFU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:27:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXCFU1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:27:21 -0500
Message-ID: <45EDCE67.3010902@redhat.com>
Date: Tue, 06 Mar 2007 14:26:15 -0600
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21-rc1] Extend print_symbol capability TRY #3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is try #3 for this patch, with corrections based on feedback.
It is the same as try #2 except:

(1) I changed the comment on function __print_symbol.  Although
    my original patch didn't change this comment, Randy Dunlap noted 
    that the comment was wrong, so I changed it.  Hopefully it makes 
    more sense now.
(2) I followed Andrew Morton's suggestion and reordered the
    parameters to the sprint_symbol function so that buffer comes
    first.  That makes it more like other sprint functions elsewhere.
(3) I hope to <insert diety/> this time it's inlined correctly, 
    with no word wrap, and my tabs haven't been converted to spaces
    again. (Sorry).
One last note: This has been tested with the patch to GFS2
to print symbols through debugfs (see original comment), and it works.

Original comment:

Today's print_symbol function dumps a kernel symbol with printk.
This patch extends the functionality of kallsyms.c so that the symbol
lookup function may be used without the printk.  This is
useful for modules that want to dump symbols elsewhere, for
example, to debugfs.  I intend to use the new function call in the
GFS2 file system (which will be a separate patch).

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
---
 include/linux/kallsyms.h |   12 +++++++++++-
 kernel/kallsyms.c        |   17 ++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 1cebcbc..5356133 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -7,6 +7,8 @@
 
 
 #define KSYM_NAME_LEN 127
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
+			 2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
@@ -22,7 +24,10 @@ const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *offset,
 			    char **modname, char *namebuf);
 
-/* Replace "%s" in format with address, if found */
+/* Look up a kernel symbol and return it in a text buffer. */
+extern void sprint_symbol(char *buffer, unsigned long address);
+
+/* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
 #else /* !CONFIG_KALLSYMS */
@@ -47,6 +52,11 @@ static inline const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
+static inline void sprint_symbol(char *buffer, unsigned long addr)
+{
+	return;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f294ff..0d6ae07 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -267,18 +267,15 @@ const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
-/* Replace "%s" in format with address, or returns -errno. */
-void __print_symbol(const char *fmt, unsigned long address)
+/* Look up a kernel symbol and return it in a text buffer. */
+void sprint_symbol(char *buffer, unsigned long address)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	char namebuf[KSYM_NAME_LEN+1];
-	char buffer[sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +
-		    2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1];
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
-
 	if (!name)
 		sprintf(buffer, "0x%lx", address);
 	else {
@@ -288,6 +285,15 @@ void __print_symbol(const char *fmt, unsigned long address)
 		else
 			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
+}
+
+/* Look up a kernel symbol and print it to the kernel messages. */
+void __print_symbol(const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(buffer, address);
+
 	printk(fmt, buffer);
 }
 
@@ -452,3 +458,4 @@ static int __init kallsyms_init(void)
 __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
+EXPORT_SYMBOL_GPL(sprint_symbol);
