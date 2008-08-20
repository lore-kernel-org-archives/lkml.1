Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYHTPQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYHTPQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbYHTPQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:16:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:38239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552AbYHTPQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:16:17 -0400
Date: Wed, 20 Aug 2008 08:13:03 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: fix warning when
	!CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080820151303.GA1754@suse.de>
References: <20080820141329.GB7622@orion> <20080820142453.GA31886@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820142453.GA31886@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 07:24:53AM -0700, Greg KH wrote:
> On Wed, Aug 20, 2008 at 06:13:29PM +0400, Alexander Beregalov wrote:
> > From: Alexander Beregalov <a.beregalov@gmail.com>
> > 
> > kernel/module.c: In function 'load_module':
> > kernel/module.c:1839: warning: unused variable 'value'
> > kernel/module.c:1838: warning: unused variable 'iter'
> > 
> > 
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > ---
> > 
> >  kernel/module.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 1721320..5a1258e 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -1835,8 +1835,10 @@ static struct module *load_module(void __user *umod,
> >  	unsigned int markersindex;
> >  	unsigned int markersstringsindex;
> >  	unsigned int verboseindex;
> > +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> >  	struct mod_debug *iter;
> >  	unsigned long value;
> > +#endif
> 
> Hm, that's not very nice, we try to keep #ifdefs out of the .c file
> where ever possible, especially within a single function.  I'll split
> the section out of this function that has the #ifdef which should fix
> this problem.

I'll merge in this patch below, unless someone objects.

thanks,

greg k-h

---
 kernel/module.c |   54 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 20 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1778,12 +1778,44 @@ static void add_kallsyms(struct module *
 static inline void add_kallsyms(struct module *mod,
 				Elf_Shdr *sechdrs,
 				unsigned int symindex,
-				unsigned int strindex,
 				const char *secstrings)
 {
 }
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+static void dynamic_printk_setup(struct module *mod,
+				 Elf_Shdr *sechdrs,
+				 unsigned int verboseindex,
+				 const char *secstrings)
+{
+	struct mod_debug *iter;
+	unsigned long value;
+
+	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
+	mod->num_verbose = sechdrs[verboseindex].sh_size /
+				sizeof(*mod->start_verbose);
+
+	for (value = (unsigned long)mod->start_verbose;
+		value < (unsigned long)mod->start_verbose +
+		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
+		value += sizeof(struct mod_debug)) {
+			iter = (struct mod_debug *)value;
+			register_dynamic_debug_module(iter->modname,
+				iter->type,
+				iter->logical_modname,
+				iter->flag_names, iter->hash, iter->hash2);
+	}
+}
+#else
+static inline void dynamic_printk_setup(struct module *mod,
+					Elf_Shdr *sechdrs,
+					unsigned int symindex,
+					const char *secstrings)
+{
+}
+#endif /* CONFIG_DYNAMIC_PRINTK_DEBUG */
+
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
@@ -1833,8 +1865,6 @@ static struct module *load_module(void _
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
 	unsigned int verboseindex;
-	struct mod_debug *iter;
-	unsigned long value;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2149,11 +2179,6 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
-#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
-	mod->num_verbose = sechdrs[verboseindex].sh_size /
-				sizeof(*mod->start_verbose);
-#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2177,18 +2202,7 @@ static struct module *load_module(void _
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
-#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-	for (value = (unsigned long)mod->start_verbose;
-		value < (unsigned long)mod->start_verbose +
-		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
-		value += sizeof(struct mod_debug)) {
-			iter = (struct mod_debug *)value;
-			register_dynamic_debug_module(iter->modname,
-				iter->type,
-				iter->logical_modname,
-				iter->flag_names, iter->hash, iter->hash2);
-	}
-#endif
+	dynamic_printk_setup(mod, sechdrs, verboseindex, secstrings);
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
