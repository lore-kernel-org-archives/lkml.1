Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXFCIRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXFCIRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFCIQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:16:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36750 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXFCIQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:16:48 -0400
Date: Sun, 3 Jun 2007 10:17:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: Conditionals for development tests and output
Message-ID: <20070603081748.GA4871@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com> <20070602190236.GA10768@uranus.ravnborg.org> <Pine.LNX.4.64.0706021627360.15441@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706021627360.15441@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 04:29:27PM -0700, Christoph Lameter wrote:
> On Sat, 2 Jun 2007, Sam Ravnborg wrote:
> 
> > The below patch suffers from the problem that changing the
> > value of DEVELKERNEL in the Makefile are not automatically
> > reflected in autoconf.h.
> 
> Well you are restating what is in the description. See below.

This turned out to be a simple dependency issue.
Added Makefile as prerequisite solved it as far as my testing showed.
Updated patch below.

The naming I do not like.
What about: KERNELHACKING (to make association with the Kernel hacking menu)?

Thats a claer signal that if you hack on the kernel you better set this.

	Sam

diff --git a/Makefile b/Makefile
index 562a909..d1e1e6e 100644
--- a/Makefile
+++ b/Makefile
@@ -3,6 +3,7 @@ PATCHLEVEL = 6
 SUBLEVEL = 22
 EXTRAVERSION = -rc3
 NAME = Jeff Thinks I Should Change This, But To What?
+DEVELKERNEL = 1
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
@@ -320,7 +321,7 @@ AFLAGS          := -D__ASSEMBLY__
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
-export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
+export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION DEVELKERNEL
 export ARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
@@ -453,7 +454,8 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # with it and forgot to run make oldconfig.
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
-include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
+include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd Makefile
+	$(Q)echo "  Kconfig - silentoldconfig"
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
 # external modules needs include/linux/autoconf.h and include/config/auto.conf
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 45353d7..cb98841 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -375,4 +375,18 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#ifdef CONFIG_DEVELKERNEL
+#define DEVELKERNEL 1
+#else
+#define DEVELKERNEL 0
+#endif
+
+#define DEVEL_WARN_ON(x)	WARN_ON(DEVELKERNEL && (x))
+#define DEVEL_WARN_ON_ONCE(x)	WARN_ON_ONCE(DEVELKERNEL && (x))
+
+#define devel_printk(fmt,arg...) 	({					\
+	if (DEVELKERNEL)						\
+			printk(fmt, ##arg);				\
+})
+
 #endif
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 0764c82..8c58d44 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -74,7 +74,7 @@ static inline int kmalloc_index(size_t size)
 	 * We should return 0 if size == 0 but we use the smallest object
 	 * here for SLAB legacy reasons.
 	 */
-	WARN_ON_ONCE(size == 0);
+	DEVEL_WARN_ON_ONCE(size == 0);
 
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
diff --git a/mm/slab.c b/mm/slab.c
index 2e71a32..0b7aca9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -774,7 +774,7 @@ static inline struct kmem_cache *__find_general_cachep(size_t size,
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
-	WARN_ON_ONCE(size == 0);
+	DEVEL_WARN_ON_ONCE(size == 0);
 	while (size > csizep->cs_size)
 		csizep++;
 
diff --git a/mm/slub.c b/mm/slub.c
index 3e5aefc..4de2b24 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2464,8 +2464,8 @@ void __init kmem_cache_init(void)
 	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
 				nr_cpu_ids * sizeof(struct page *);
 
-	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" Processors=%d, Nodes=%d\n",
+	devel_printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, "
+		"MinObjects=%d, Processors=%d, Nodes=%d\n",
 		KMALLOC_SHIFT_HIGH, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c35dcc5..bf788ad 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -72,6 +72,15 @@ void sym_init(void)
 	sym->type = S_STRING;
 	sym->flags |= SYMBOL_AUTO;
 	sym_add_default(sym, uts.release);
+
+	sym = sym_lookup("DEVELKERNEL", 0);
+	sym->type = S_BOOLEAN;
+	sym->flags |= SYMBOL_VALID|SYMBOL_AUTO;
+	p = getenv("DEVELKERNEL");
+	if (p && atoi(p))
+		sym_add_default(sym, "y");
+	else
+		sym_add_default(sym, "n");
 }
 
 enum symbol_type sym_get_type(struct symbol *sym)
