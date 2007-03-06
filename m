Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXCFAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXCFAFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbXCFAE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:04:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbXCFAE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:04:58 -0500
Message-ID: <45ECAFEF.3030607@redhat.com>
Date: Mon, 05 Mar 2007 18:03:59 -0600
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2.6.21-rc1] Extend print_symbol capability TRY #2
Content-Type: multipart/mixed;
 boundary="------------050802040201050601040504"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050802040201050601040504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is try #2 for this patch, with corrections based on feedback. 
It is the same as the previous patch except:
(1) The function has been renamed from lookup_symbol to sprint_symbol
    as requested by Paulo Marques.
(2) I fixed the "return NULL;" to "return;" as pointed out by Paulo Marques
    for the case where the kallsyms function is not selected in .config
(3) I changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL as
    requested by Roman Zippel. (Andrew, I thought you said you changed this,
    but I didn't see it in mm1).

I hope this patch attaches with proper spacing and without word wrap.
If it doesn't, my apologies (I'm using Thunderbird, but suggestions 
welcome).

Original comment:

Today's print_symbol function dumps a kernel symbol with printk.
This patch extends the functionality of kallsyms.c so that the symbol
lookup function may be used without the printk.  This is
useful for modules that want to dump symbols elsewhere, for
example, to debugfs.  I intend to use the new function call in the
GFS2 file system (which will be a separate patch).

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
---


--------------050802040201050601040504
Content-Type: text/plain;
 name="kallsyms.patch.try2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kallsyms.patch.try2"

 include/linux/kallsyms.h |   10 ++++++++++
 kernel/kallsyms.c        |   21 ++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 1cebcbc..3bb4136 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -7,6 +7,8 @@
 
 
 #define KSYM_NAME_LEN 127
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
+			 2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
@@ -22,6 +24,9 @@ const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *offset,
 			    char **modname, char *namebuf);
 
+/* Look up a kernel symbol and return it in a text buffer. */
+extern void sprint_symbol(unsigned long addr, char *buffer);
+
 /* Replace "%s" in format with address, if found */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
@@ -47,6 +52,11 @@ static inline const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
+static inline void sprint_symbol(unsigned long addr, char *buffer)
+{
+	return;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f294ff..775d5e4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -267,20 +267,17 @@ const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
-/* Replace "%s" in format with address, or returns -errno. */
-void __print_symbol(const char *fmt, unsigned long address)
+/* Look up a kernel symbol and return it in a text buffer. */
+void sprint_symbol(unsigned long addr, char *buffer)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	char namebuf[KSYM_NAME_LEN+1];
-	char buffer[sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +
-		    2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1];
-
-	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 
+	name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
 	if (!name)
-		sprintf(buffer, "0x%lx", address);
+		sprintf(buffer, "0x%lx", addr);
 	else {
 		if (modname)
 			sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
@@ -288,6 +285,15 @@ void __print_symbol(const char *fmt, unsigned long address)
 		else
 			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
+}
+
+/* Replace "%s" in format with address, or returns -errno. */
+void __print_symbol(const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(address, buffer);
+
 	printk(fmt, buffer);
 }
 
@@ -452,3 +458,4 @@ static int __init kallsyms_init(void)
 __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
+EXPORT_SYMBOL_GPL(sprint_symbol);

--------------050802040201050601040504--
