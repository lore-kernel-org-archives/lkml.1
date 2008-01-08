Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYAHLum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYAHLum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYAHLu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:50:29 -0500
Received: from ozlabs.org ([203.10.76.45]:36420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbYAHLu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:50:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Date: Tue, 8 Jan 2008 22:50:06 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080108063113.GA21287@fattire.cabal.ca> <200801082228.05218.rusty@rustcorp.com.au> <20080108113323.GB11083@elte.hu>
In-Reply-To: <20080108113323.GB11083@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082250.06828.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 22:33:23 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > +/* FIXME: Risky: returns a pointer into a module w/o lock */
>
> stupid question: since module unloads are so rare, why isnt this via the
> same mechanism that CPU hotplug uses to securely unregister CPUs? I.e.
> quiet all CPUs, disable irqs on all of them, then unlink the module.

That's what we do.  This old locking stuff is legacy.

And here's the patch for the FIXME (which I put in to remind myself):

Make module_address_lookup safe

module_address_lookup releases preemption then returns a pointer into
the module space.  The only user (kallsyms) copies the result, so just
do that under the preempt disable.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 27c34f677af7 include/linux/module.h
--- a/include/linux/module.h	Tue Jan 08 22:27:02 2008 +1100
+++ b/include/linux/module.h	Tue Jan 08 22:44:14 2008 +1100
@@ -446,11 +446,14 @@ static inline void __module_get(struct m
 	__mod ? __mod->name : "kernel";		\
 })
 
-/* For kallsyms to ask for address resolution.  NULL means not found. */
-const char *module_address_lookup(unsigned long addr,
-				  unsigned long *symbolsize,
-				  unsigned long *offset,
-				  char **modname);
+/* For kallsyms to ask for address resolution.  namebuf should be at
+ * least KSYM_NAME_LEN long: a pointer to namebuf is returned if
+ * found, otherwise NULL. */
+char *module_address_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
 int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
@@ -516,10 +519,11 @@ static inline void module_put(struct mod
 #define module_name(mod) "kernel"
 
 /* For kallsyms to ask for address resolution.  NULL means not found. */
-static inline const char *module_address_lookup(unsigned long addr,
-						unsigned long *symbolsize,
-						unsigned long *offset,
-						char **modname)
+static inline char *module_address_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname,
+					  char *namebuf)
 {
 	return NULL;
 }
diff -r 27c34f677af7 kernel/kallsyms.c
--- a/kernel/kallsyms.c	Tue Jan 08 22:27:02 2008 +1100
+++ b/kernel/kallsyms.c	Tue Jan 08 22:44:14 2008 +1100
@@ -233,10 +233,11 @@ int kallsyms_lookup_size_offset(unsigned
 int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 				unsigned long *offset)
 {
+	char namebuf[KSYM_NAME_LEN];
 	if (is_ksym_addr(addr))
 		return !!get_symbol_pos(addr, symbolsize, offset);
 
-	return !!module_address_lookup(addr, symbolsize, offset, NULL);
+	return !!module_address_lookup(addr, symbolsize, offset, NULL, namebuf);
 }
 
 /*
@@ -251,8 +252,6 @@ const char *kallsyms_lookup(unsigned lon
 			    unsigned long *offset,
 			    char **modname, char *namebuf)
 {
-	const char *msym;
-
 	namebuf[KSYM_NAME_LEN - 1] = 0;
 	namebuf[0] = 0;
 
@@ -268,10 +267,8 @@ const char *kallsyms_lookup(unsigned lon
 	}
 
 	/* see if it's in a module */
-	msym = module_address_lookup(addr, symbolsize, offset, modname);
-	if (msym)
-		return strncpy(namebuf, msym, KSYM_NAME_LEN - 1);
-
+	return module_address_lookup(addr, symbolsize, offset, modname,
+				     namebuf);
 	return NULL;
 }
 
diff -r 27c34f677af7 kernel/module.c
--- a/kernel/module.c	Tue Jan 08 22:27:02 2008 +1100
+++ b/kernel/module.c	Tue Jan 08 22:44:14 2008 +1100
@@ -2235,14 +2235,13 @@ static const char *get_ksymbol(struct mo
 	return mod->strtab + mod->symtab[best].st_name;
 }
 
-/* For kallsyms to ask for address resolution.  NULL means not found.
-   We don't lock, as this is used for oops resolution and races are a
-   lesser concern. */
-/* FIXME: Risky: returns a pointer into a module w/o lock */
-const char *module_address_lookup(unsigned long addr,
-				  unsigned long *size,
-				  unsigned long *offset,
-				  char **modname)
+/* For kallsyms to ask for address resolution.  NULL means not found.  Careful
+ * not to lock to avoid deadlock on oopses, simply disable preemption. */
+char *module_address_lookup(unsigned long addr,
+			    unsigned long *size,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf)
 {
 	struct module *mod;
 	const char *ret = NULL;
@@ -2256,6 +2255,11 @@ const char *module_address_lookup(unsign
 			ret = get_ksymbol(mod, addr, size, offset);
 			break;
 		}
+	}
+	/* Make a copy in here where it's safe */
+	if (ret) {
+		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
+		ret = namebuf;
 	}
 	preempt_enable();
 	return ret;
