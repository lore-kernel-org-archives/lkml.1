Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYEEFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYEEFf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYEEFfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:35:14 -0400
Received: from ozlabs.org ([203.10.76.45]:45693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYEEFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:35:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: changeset: Make forced module loading optional
Date: Mon, 5 May 2008 15:35:04 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051535.05370.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 15:05:51 Linus Torvalds wrote:
> On Mon, 5 May 2008, Rusty Russell wrote:
> >    I'm trying to figure out how you did this.  So fedora builds
> > unversioned modules, and version (and vermagic) matched your kernel?  And
> > you somehow mixed them up?
>
> And quite frankly, when I finally figured out what was going on, I was
> like *WHAT THE HELL*. That kernel/module.c code was absolute and utter
> crap in accepting modules that neither matched the kernel version
> signature (because it had CONFIG_MODVERSIONS) *nor* the actual versioned
> symbols (because the distro modules had been built without
> CONFIG_MODVERSIONS).

Erk, yes.  We ignore vermagic because we expect modversions, then ignore
missing modversions.  This is a logic bug; let's fix it.

BTW, for the peanut gallery: I don't recommend modversions: it's not reliable
in detecting all differences, nor being stable when there are no real
differences.

Untested:

module: don't ignore vermagic string if module doesn't have crcs

Linus found a logic bug: we ignore the version number in a module's
vermagic string if we have CONFIG_MODVERSIONS set, but modversions
also lets through a module with no versions at all (with tainting, but
still).

We should only ignore the start of the vermagic string if the module
actually *has* crcs to check.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0cefb252efe8 kernel/module.c
--- a/kernel/module.c	Mon May 05 15:00:12 2008 +1000
+++ b/kernel/module.c	Mon May 05 15:25:17 2008 +1000
@@ -939,11 +939,14 @@ static inline int check_modstruct_versio
 	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
 
-/* First part is kernel version, which we ignore. */
-static inline int same_magic(const char *amagic, const char *bmagic)
+/* First part is kernel version, which we ignore if module has crcs. */
+static inline int same_magic(const char *amagic, const char *bmagic,
+			     bool has_crcs)
 {
-	amagic += strcspn(amagic, " ");
-	bmagic += strcspn(bmagic, " ");
+	if (has_crcs) {
+		amagic += strcspn(amagic, " ");
+		bmagic += strcspn(bmagic, " ");
+	}
 	return strcmp(amagic, bmagic) == 0;
 }
 #else
@@ -963,7 +966,8 @@ static inline int check_modstruct_versio
 	return 1;
 }
 
-static inline int same_magic(const char *amagic, const char *bmagic)
+static inline int same_magic(const char *amagic, const char *bmagic,
+			     bool has_crcs)
 {
 	return strcmp(amagic, bmagic) == 0;
 }
@@ -1741,6 +1745,7 @@ static struct module *load_module(void _
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
+	bool has_crcs = false;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
@@ -1850,13 +1855,21 @@ static struct module *load_module(void _
 		goto free_hdr;
 	}
 
+#ifdef CONFIG_MODVERSIONS
+	if ((mod->num_syms == 0 || crcindex) &&
+	    (mod->num_gpl_syms == 0 || gplcrcindex) &&
+	    (mod->num_gpl_future_syms == 0 || gplfuturecrcindex) &&
+	    (mod->num_unused_syms == 0 || unusedcrcindex) &&
+	    (mod->num_unused_gpl_syms == 0 || unusedgplcrcindex))
+		has_crcs = true;
+#endif
 	modmagic = get_modinfo(sechdrs, infoindex, "vermagic");
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 		printk(KERN_WARNING "%s: no version magic, tainting kernel.\n",
 		       mod->name);
-	} else if (!same_magic(modmagic, vermagic)) {
+	} else if (!same_magic(modmagic, vermagic, has_crcs)) {
 		printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
 		       mod->name, modmagic, vermagic);
 		err = -ENOEXEC;
@@ -2001,11 +2014,8 @@ static struct module *load_module(void _
 			= (void *)sechdrs[unusedgplcrcindex].sh_addr;
 
 #ifdef CONFIG_MODVERSIONS
-	if ((mod->num_syms && !crcindex) ||
-	    (mod->num_gpl_syms && !gplcrcindex) ||
-	    (mod->num_gpl_future_syms && !gplfuturecrcindex) ||
-	    (mod->num_unused_syms && !unusedcrcindex) ||
-	    (mod->num_unused_gpl_syms && !unusedgplcrcindex)) {
+	/* If we get this far, it's time to warn about missing versions. */
+	if (!has_crcs) {
 		printk(KERN_WARNING "%s: No versions for exported symbols."
 		       " Tainting kernel.\n", mod->name);
 		add_taint_module(mod, TAINT_FORCED_MODULE);
