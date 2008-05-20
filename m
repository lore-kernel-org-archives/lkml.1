Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbYETPmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbYETPmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYETPm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:42:26 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:7055 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYETPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:42:25 -0400
Message-ID: <4832F14B.2060305@de.ibm.com>
Date: Tue, 20 May 2008 17:42:03 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] consolidate all within() implementations
References: <48313E23.4030104@de.ibm.com>	<1211230216.5915.90.camel@brick>	<48328700.4000907@googlemail.com> <20080520024535.6b4f487e.akpm@linux-foundation.org>
In-Reply-To: <20080520024535.6b4f487e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 20 May 2008 10:08:32 +0200 Peter Oberparleiter <oberparleiter@googlemail.com> wrote:
>> +/**
>> + * addr_within_len - check whether address is in start-and-length address range
>> + * @addr: address
>> + * @start: start of range
>> + * @len: number of bytes in range
>> + */
>> +static inline int addr_within_len(unsigned long addr, unsigned long start,
>> +				  unsigned long len)
>> +{
>> +	return (addr >= start) && (addr < (start + len));
>> +}
> 
> The kernel's use of unsigned long to represent pointers sometimes makes
> sense, but often gets us into a mess.  It's OK in bootup code which
> fiddles with memory map layout because there is no reason why such
> code will ever dereference any of the addresses.
> 
> But I don't think we can assume this usage pattern when creating a
> kernel-wide facility in kernel.h.
> 
> So yes, I do think that an address-comparison tool like this should
> operate on void*'s.  (They will need to be const void*'s).

Now that every line using a within() has to be changed anyway, it could
as well be done right, yes.

> And you've had to add a great pile of casts anwyay?

Well, between the unsigned long and the void * version, there's not that
much of a difference in the number of casts. So here goes #3:

--

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

This patch consolidates a number of different implementations of the
within() function which checks whether an address is within a specified
address range. Apart from parameter typing, existing implementations can
be classified in two categories which differ in the way the range is
specified:

  1) by start and end address
  2) by start and size

Case 1) is covered by addr_within() while 2) is covered by
addr_within_len().

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/x86/mm/pageattr.c |   26 ++++++++++++--------------
 include/linux/kernel.h |   26 ++++++++++++++++++++++++++
 kernel/lockdep.c       |   10 +++-------
 kernel/module.c        |   34 +++++++++++++++++++---------------
 4 files changed, 60 insertions(+), 36 deletions(-)

Index: linux-2.6.26-rc3/include/linux/kernel.h
===================================================================
--- linux-2.6.26-rc3.orig/include/linux/kernel.h
+++ linux-2.6.26-rc3/include/linux/kernel.h
@@ -434,6 +434,32 @@ static inline char *pack_hex_byte(char *
 	__val > __max ? __max: __val; })
 
 /**
+ * addr_within - check whether address is in start-and-end address range
+ * @addr: address
+ * @start: start address (included in range)
+ * @end: end address (excluded from range)
+ */
+static inline int addr_within(const void *addr, const void *start,
+			      const void *end)
+{
+	return ((unsigned long) addr >= (unsigned long) start) &&
+	       ((unsigned long) addr < (unsigned long) end);
+}
+
+/**
+ * addr_within_len - check whether address is in start-and-length address range
+ * @addr: address
+ * @start: start of range
+ * @len: number of bytes in range
+ */
+static inline int addr_within_len(const void *addr, const void *start,
+				  size_t len)
+{
+	return ((unsigned long) addr >= (unsigned long) start) &&
+	       ((unsigned long) addr < ((unsigned long) start + len));
+}
+
+/**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
  * @type:	the type of the container struct this is embedded in.
Index: linux-2.6.26-rc3/kernel/lockdep.c
===================================================================
--- linux-2.6.26-rc3.orig/kernel/lockdep.c
+++ linux-2.6.26-rc3/kernel/lockdep.c
@@ -25,6 +25,7 @@
  * Thanks to Arjan van de Ven for coming up with the initial idea of
  * mapping lock dependencies runtime.
  */
+#include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
@@ -2932,11 +2933,6 @@ static void zap_class(struct lock_class 
 
 }
 
-static inline int within(const void *addr, void *start, unsigned long size)
-{
-	return addr >= start && addr < start + size;
-}
-
 void lockdep_free_key_range(void *start, unsigned long size)
 {
 	struct lock_class *class, *next;
@@ -2956,9 +2952,9 @@ void lockdep_free_key_range(void *start,
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_safe(class, next, head, hash_entry) {
-			if (within(class->key, start, size))
+			if (addr_within_len(class->key, start, size))
 				zap_class(class);
-			else if (within(class->name, start, size))
+			else if (addr_within_len(class->name, start, size))
 				zap_class(class);
 		}
 	}
Index: linux-2.6.26-rc3/kernel/module.c
===================================================================
--- linux-2.6.26-rc3.orig/kernel/module.c
+++ linux-2.6.26-rc3/kernel/module.c
@@ -2262,11 +2262,6 @@ sys_init_module(void __user *umod,
 	return 0;
 }
 
-static inline int within(unsigned long addr, void *start, unsigned long size)
-{
-	return ((void *)addr >= start && (void *)addr < start + size);
-}
-
 #ifdef CONFIG_KALLSYMS
 /*
  * This ignores the intensely annoying "mapping symbols" found
@@ -2287,7 +2282,7 @@ static const char *get_ksymbol(struct mo
 	unsigned long nextval;
 
 	/* At worse, next value is at end of module */
-	if (within(addr, mod->module_init, mod->init_size))
+	if (addr_within_len((void *) addr, mod->module_init, mod->init_size))
 		nextval = (unsigned long)mod->module_init+mod->init_text_size;
 	else
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
@@ -2335,8 +2330,10 @@ const char *module_address_lookup(unsign
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size)
-		    || within(addr, mod->module_core, mod->core_size)) {
+		if (addr_within_len((void *) addr, mod->module_init,
+				    mod->init_size)
+		    || addr_within_len((void *) addr, mod->module_core,
+				       mod->core_size)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -2358,8 +2355,10 @@ int lookup_module_symbol_name(unsigned l
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (addr_within_len((void *) addr, mod->module_init,
+				    mod->init_size) ||
+		    addr_within_len((void *) addr, mod->module_core,
+				    mod->core_size)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -2382,8 +2381,10 @@ int lookup_module_symbol_attrs(unsigned 
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (addr_within_len((void *) addr, mod->module_init,
+				    mod->init_size) ||
+		    addr_within_len((void *) addr, mod->module_core,
+				    mod->core_size)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, size, offset);
@@ -2579,7 +2580,8 @@ int is_module_address(unsigned long addr
 	preempt_disable();
 
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_core, mod->core_size)) {
+		if (addr_within_len((void *) addr, mod->module_core,
+				    mod->core_size)) {
 			preempt_enable();
 			return 1;
 		}
@@ -2597,8 +2599,10 @@ struct module *__module_text_address(uns
 	struct module *mod;
 
 	list_for_each_entry(mod, &modules, list)
-		if (within(addr, mod->module_init, mod->init_text_size)
-		    || within(addr, mod->module_core, mod->core_text_size))
+		if (addr_within_len((void *) addr, mod->module_init,
+				    mod->init_text_size)
+		    || addr_within_len((void *) addr, mod->module_core,
+				       mod->core_text_size))
 			return mod;
 	return NULL;
 }
Index: linux-2.6.26-rc3/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.26-rc3.orig/arch/x86/mm/pageattr.c
+++ linux-2.6.26-rc3/arch/x86/mm/pageattr.c
@@ -2,6 +2,7 @@
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * Thanks to Ben LaHaise for precious feedback.
  */
+#include <linux/kernel.h>
 #include <linux/highmem.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
@@ -54,12 +55,6 @@ static inline unsigned long highmap_end_
 # define debug_pagealloc 0
 #endif
 
-static inline int
-within(unsigned long addr, unsigned long start, unsigned long end)
-{
-	return addr >= start && addr < end;
-}
-
 /*
  * Flushing functions
  */
@@ -164,7 +159,8 @@ static inline pgprot_t static_protection
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+	if (addr_within((void *) pfn, (void *) (BIOS_BEGIN >> PAGE_SHIFT),
+			(void *) (BIOS_END >> PAGE_SHIFT)))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
@@ -172,15 +168,16 @@ static inline pgprot_t static_protection
 	 * Does not cover __inittext since that is gone later on. On
 	 * 64bit we do not enforce !NX on the low mapping
 	 */
-	if (within(address, (unsigned long)_text, (unsigned long)_etext))
+	if (addr_within((void *) address, _text, _etext))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
 	 * The .rodata section needs to be read-only. Using the pfn
 	 * catches all aliases.
 	 */
-	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
-		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
+	if (addr_within((void *) pfn,
+			(void *) (__pa(__start_rodata) >> PAGE_SHIFT),
+			(void *) (__pa(__end_rodata) >> PAGE_SHIFT)))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
@@ -620,8 +617,8 @@ static int cpa_process_alias(struct cpa_
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!within(cpa->vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+	if (!addr_within((void *) cpa->vaddr, (void *) PAGE_OFFSET,
+		    (void *) (PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
 		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
@@ -636,14 +633,15 @@ static int cpa_process_alias(struct cpa_
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (addr_within((void *) cpa->vaddr, _text, _end))
 		return 0;
 
 	/*
 	 * If the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (!within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn()))
+	if (!addr_within((void *) cpa->pfn, (void *) highmap_start_pfn(),
+			 (void *) highmap_end_pfn()))
 		return 0;
 
 	alias_cpa = *cpa;
