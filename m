Return-Path: <linux-kernel-owner+w=401wt.eu-S1030289AbXCAVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030289AbXCAVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030296AbXCAVZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:25:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030289AbXCAVZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:25:57 -0500
Message-ID: <45E744E2.1040000@redhat.com>
Date: Thu, 01 Mar 2007 15:25:54 -0600
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21-rc1] Extend print_symbol capability
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Today's print_symbol function dumps a kernel symbol with printk.
This patch extends the functionality of kallsyms.c so that the symbol
lookup function may be used without the printk.  This is
useful for modules that want to dump symbols elsewhere, for
example, to debugfs.  I intend to use the new function call in the
GFS2 file system (which will be a separate patch).

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
---
 include/linux/kallsyms.h |   10 ++++++++++
 kernel/kallsyms.c        |   21 ++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 1cebcbc..a54afe5 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -7,6 +7,8 @@
 
 
 #define KSYM_NAME_LEN 127
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN + \
+                        2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
@@ -22,6 +24,9 @@ const char *kallsyms_lookup(unsigned long addr,
                            unsigned long *offset,
                            char **modname, char *namebuf);
 
+/* Look up a kernel symbol and return it in a text buffer. */
+extern void lookup_symbol(unsigned long addr, char *buffer);
+
 /* Replace "%s" in format with address, if found */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
@@ -47,6 +52,11 @@ static inline const char *kallsyms_lookup(unsigned 
long addr,
        return NULL;
 }
 
+static inline void lookup_symbol(unsigned long addr, char *buffer)
+{
+       return NULL;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f294ff..a5fedf5 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -267,20 +267,17 @@ const char *kallsyms_lookup(unsigned long addr,
        return NULL;
 }
 
-/* Replace "%s" in format with address, or returns -errno. */
-void __print_symbol(const char *fmt, unsigned long address)
+/* Look up a kernel symbol and return it in a text buffer. */
+void lookup_symbol(unsigned long addr, char *buffer)
 {
        char *modname;
        const char *name;
        unsigned long offset, size;
        char namebuf[KSYM_NAME_LEN+1];
-       char buffer[sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +
-                   2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1];
-
-       name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 
+       name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
        if (!name)
-               sprintf(buffer, "0x%lx", address);
+               sprintf(buffer, "0x%lx", addr);
        else {
                if (modname)
                        sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
@@ -288,6 +285,15 @@ void __print_symbol(const char *fmt, unsigned long 
address)
                else
                        sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
        }
+}
+
+/* Replace "%s" in format with address, or returns -errno. */
+void __print_symbol(const char *fmt, unsigned long address)
+{
+       char buffer[KSYM_SYMBOL_LEN];
+
+       lookup_symbol(address, buffer);
+
        printk(fmt, buffer);
 }
 
@@ -452,3 +458,4 @@ static int __init kallsyms_init(void)
 __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
+EXPORT_SYMBOL(lookup_symbol);

