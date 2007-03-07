Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXCGPwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXCGPwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXCGPwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:52:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbXCGPwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:52:02 -0500
Message-ID: <45EEDF53.4070609@redhat.com>
Date: Wed, 07 Mar 2007 09:50:43 -0600
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] Extend print_symbol capability TRY #3
References: <45EDCE67.3010902@redhat.com> <45EECE60.4010808@grupopie.com>
In-Reply-To: <45EECE60.4010808@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> That is why I suggested to change it to something like "*buffer = '\0'" 
> instead.

Point well taken.  A revised patch with your suggested fix is below.

> The really nice solution IMHO, would be to remove the print_symbol and 
> sprint_symbol functions from the the "#ifdef CONFIG_KALLSYMS" and just 
> let them be available even in a not CONFIG_KALLSYMS kernel.
> 
> Since kallsyms_lookup is already #ifdef'ed to something sane, 
> sprint_symbol will just print out the symbol address in that case, but 
> it is better than not printing anything at all.

Although this sounds like a good idea, I'm uncomfortable taking the
fix to this level as part of this patch.  If CONFIG_KALLSYMS is not set,
the Makefile doesn't even compile kallsyms.c due to this:

kernel/Makefile:obj-$(CONFIG_KALLSYMS) += kallsyms.o

To keep the functionality you mentioned, we'd have to keep kallsyms.o 
and keeping kallsyms.o in the kernel would have a whole different
set of ramifications in the kernel that I don't want to chase down.
It probably would be easy, but it's beyond the scope of this fix,
and therefore probably best left to a separate patch.
Feel free to send that out in another patch if you want.  If you do,
I'd be happy to test it, review it, and ACK it.

Regards,

Bob Peterson

Amended patch (TRY #4) follows:

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
--- 
 include/linux/kallsyms.h |   13 ++++++++++++-
 kernel/kallsyms.c        |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 1cebcbc..cd83e89 100644
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
@@ -47,6 +52,12 @@ static inline const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
+static inline void sprint_symbol(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
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
