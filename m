Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZCMVET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZCMVET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZCMVEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:04:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:45832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZCMVEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:04:08 -0400
Message-ID: <49BACA0B.5010308@kernel.org>
Date: Fri, 13 Mar 2009 14:03:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
References: <49B7EDF4.7060904@goop.org> <49B800B8.2040009@kernel.org> <49B9A1CD.5040704@goop.org> <49B9AC7F.9030302@kernel.org> <49BAC1B0.6050107@goop.org>
In-Reply-To: <49BAC1B0.6050107@goop.org>
Content-Type: multipart/mixed;
 boundary="------------070803010209030408000409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070803010209030408000409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> Jeremy Fitzhardinge wrote:
>>  
>>> Yinghai Lu wrote:
>>>    
>>>> could have more explanation about the 1M size.
>>>> because initial_pg_tables will sit in it. please consider to add
>>>> something like
>>>>
>>>> in head_32.S
>>>>
>>>>  LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
>>>>  
>>>>  #if PTRS_PER_PMD > 1
>>>>  PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
>>>>  #else
>>>>  PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
>>>>  #endif
>>>>  ALLOCATOR_SLOP = 4
>>>>         
>>> OK, how does this look:
>>>
>>> The following changes since commit
>>> 21e8ba72daf5d7f0af33968f873499c85f96ccef:
>>>  Jeremy Fitzhardinge (1):
>>>        x86: use brk allocation for DMI
>>>
>>> are available in the git repository at:
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
>>> push/x86/brk
>>>
>>> Jeremy Fitzhardinge (1):
>>>      x86: allow extend_brk users to reserve brk space
>>>
>>> Yinghai Lu (1):
>>>      x86-32: compute initial mapping size more accurately
>>>
>>> arch/x86/include/asm/page_32_types.h |    5 +++++
>>> arch/x86/include/asm/setup.h         |   30
>>> ++++++++++++++++++++++++++++++
>>> arch/x86/kernel/head_32.S            |    4 +++-
>>> arch/x86/kernel/setup.c              |    2 ++
>>> arch/x86/kernel/vmlinux_32.lds.S     |    4 +++-
>>> arch/x86/kernel/vmlinux_64.lds.S     |    4 +++-
>>> 6 files changed, 46 insertions(+), 3 deletions(-)
>>>
>>> git diff 21e8ba72daf5d7f0af33968f873499c85f96ccef..push/x86/brk
>>> diff --git a/arch/x86/include/asm/page_32_types.h
>>> b/arch/x86/include/asm/page_32_types.h
>>> index f1e4a79..0f915ae 100644
>>> --- a/arch/x86/include/asm/page_32_types.h
>>> +++ b/arch/x86/include/asm/page_32_types.h
>>> @@ -39,6 +39,11 @@
>>> #define __VIRTUAL_MASK_SHIFT    32
>>> #endif    /* CONFIG_X86_PAE */
>>>
>>> +/*
>>> + * Kernel image size is limited to 512 MB (see in
>>> arch/x86/kernel/head_32.S)
>>> + */
>>> +#define KERNEL_IMAGE_SIZE    (512 * 1024 * 1024)
>>> +
>>> #ifndef __ASSEMBLY__
>>>
>>> /*
>>> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
>>> index 366d366..61b126b 100644
>>> --- a/arch/x86/include/asm/setup.h
>>> +++ b/arch/x86/include/asm/setup.h
>>> @@ -104,6 +104,29 @@ extern struct boot_params boot_params;
>>> extern unsigned long _brk_end;
>>> void *extend_brk(size_t size, size_t align);
>>>
>>> +/*
>>> + * Reserve space in the brk section.  The name must be unique within
>>> + * the file, and somewhat descriptive.  The size is in bytes.  Must be
>>> + * used at file scope.
>>> + *
>>> + * (This uses a temp function to wrap the asm so we can pass it the
>>> + * size parameter; otherwise we wouldn't be able to.  We can't use a
>>> + * "section" attribute on a normal variable because it always ends up
>>> + * being @progbits, which ends up allocating space in the vmlinux
>>> + * executable.)
>>> + */
>>> +#define RESERVE_BRK(name,sz)                        \
>>> +    static void __section(.discard) __used            \
>>> +    __brk_reservation_fn_##name##__(void) {                \
>>> +        asm volatile (                        \
>>> +            ".pushsection .brk_reservation,\"aw\",@nobits;" \
>>> +            "__brk_reservation_" #name "__:"        \
>>> +            " 1:.skip %c0;"                    \
>>> +            " .size __brk_reservation_" #name "__, . - 1b;"    \
>>> +            " .popsection"                    \
>>> +            : : "i" (sz));                    \
>>> +    }
>>> +
>>> #ifdef __i386__
>>>
>>> void __init i386_start_kernel(void);
>>> @@ -115,6 +138,13 @@ void __init x86_64_start_reservations(char
>>> *real_mode_data);
>>>
>>> #endif /* __i386__ */
>>> #endif /* _SETUP */
>>> +#else
>>> +#define RESERVE_BRK(name,sz)                \
>>> +    .pushsection .brk_reservation,"aw",@nobits;    \
>>> +__brk_reservation_##name##__:                \
>>> +1:    .skip sz;                    \
>>> +    .size __brk_reservation_##name##__,.-1b;    \
>>> +    .popsection
>>> #endif /* __ASSEMBLY__ */
>>> #endif  /*  __KERNEL__  */
>>>
>>> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>>> index d243437..80dc05e 100644
>>> --- a/arch/x86/kernel/head_32.S
>>> +++ b/arch/x86/kernel/head_32.S
>>> @@ -54,7 +54,7 @@
>>>  *
>>>  * This should be a multiple of a page.
>>>  */
>>> -LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
>>> +LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
>>>
>>> /*
>>>  * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
>>> @@ -75,6 +75,8 @@ ALLOCATOR_SLOP = 4
>>>
>>> INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE +
>>> ALLOCATOR_SLOP)*PAGE_SIZE_asm
>>>     
>>
>> no user for INIT_MAP_BEYOND_END any more.
>>   
> 
> There are several remaining references:
> 
> : abulafia:pts/0; grep INIT_MAP_BEYOND_END arch/x86/kernel/head_32.S
> INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE +
> ALLOCATOR_SLOP)*PAGE_SIZE_asm
> * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
>      * End condition: we must map up to and including INIT_MAP_BEYOND_END
>     leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
>      * End condition: we must map up to and including INIT_MAP_BEYOND_END
>     leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
> 
> Are you saying they're redundant and should be removed?

please check attached ...

Impact: cleanup

Don't use ram after _end blindly for pagetables. aka init pages is before _end
put those pg table into .bss

v2: keep initial page table up to 512M only.
v4: put initial page tables just before _end

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_32_types.h |    5 +++
 arch/x86/kernel/head32.c             |    3 +
 arch/x86/kernel/head_32.S            |   55 ++++++++++++++---------------------
 arch/x86/kernel/vmlinux_32.lds.S     |   11 ++++++-
 4 files changed, 40 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -18,7 +18,8 @@ void __init i386_start_kernel(void)
 {
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop),
+			 "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S
+++ linux-2.6/arch/x86/kernel/head_32.S
@@ -38,42 +38,30 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     232/4096/8 = 128K worst case (4G/4G split.)
+ * This is how much memory for page table to and including _end
+ * we need mapped initially.
  *  - enough space to map all low memory, which means
- *     (232/4096) / 1024 pages (worst case, non PAE)
- *     (232/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
+ *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
+ *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
+ *
+ * KERNEL_IMAGE_SIZE should be greater than pa(_end)
+ * and small than max_low_pfn, otherwise will waste some page table entries
  */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
-/*
- * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
- * pagetables from above the 16MB DMA limit, so we'll have to set
- * up pagetables 16MB more (worst-case):
- */
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-LOW_PAGES = LOW_PAGES + 0x1000000
-#endif
+LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
 #if PTRS_PER_PMD > 1
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
 #else
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
 #endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
@@ -166,10 +154,9 @@ num_subarch_entries = (. - subarch_entri
 
 /*
  * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
+ * tables, which are located immediately beyond _end.
  * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ * and PAGE_OFFSET for up to _end
  *
  * Note that the stack is not yet set up!
  */
@@ -209,14 +196,14 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables.
+	 * End condition: we must map up to the end.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
-	movl %edi,pa(init_pg_tables_end)
+	movl %edi, pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -242,14 +229,14 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables; the +0x007 is
+	 * End condition: we must map up to end, the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,pa(init_pg_tables_end)
+	movl %edi, pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -636,6 +623,10 @@ swapper_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
+
+.section ".bss.extra_page_aligned","wa"
+	.align PAGE_SIZE_asm
+	.fill INIT_MAP_SIZE,1,0
 /*
  * This starts the data section.
  */
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,10 +189,13 @@ SECTIONS
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
-  	_end = . ;
+	/* extra_page_aligned must be last one before end*/
 	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(PAGE_SIZE);
 	pg0 = . ;
+	*(.bss.extra_page_aligned)
+	. = ALIGN(8);
+	_end = . ;
   }
 
   /* Sections to be discarded */
@@ -205,6 +208,12 @@ SECTIONS
   DWARF_DEBUG
 }
 
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
 #ifdef CONFIG_KEXEC
 /* Link time checks */
 #include <asm/kexec.h>
Index: linux-2.6/arch/x86/include/asm/page_32_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_32_types.h
+++ linux-2.6/arch/x86/include/asm/page_32_types.h
@@ -39,6 +39,11 @@
 #define __VIRTUAL_MASK_SHIFT	32
 #endif	/* CONFIG_X86_PAE */
 
+/*
+ * Kernel image size is limited to 512 MB (see in arch/x86/kernel/head_32.S)
+ */
+#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+
 #ifndef __ASSEMBLY__
 
 /*


--------------070803010209030408000409
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message"

Message-ID: <49B4D03D.7030205@kernel.org>
Date: Mon, 09 Mar 2009 01:15:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>, 
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, 
 Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: put initial_pg_tables into .bss -v4
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org> <49AA5356.3050602@zytor.com> <49AACEB3.5050206@kernel.org> <49AB1A5C.6040300@zytor.com> <49AB2E69.1010201@kernel.org>
In-Reply-To: <49AB2E69.1010201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Impact: cleanup

Don't use ram after _end blindly for pagetables. aka init pages is before _end
put those pg table into .bss

v2: keep initial page table up to 512M only.
v4: put initial page tables just before _end

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_32_types.h |    5 +++
 arch/x86/kernel/head32.c             |    3 +
 arch/x86/kernel/head_32.S            |   55 ++++++++++++++---------------------
 arch/x86/kernel/vmlinux_32.lds.S     |   11 ++++++-
 4 files changed, 40 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -18,7 +18,8 @@ void __init i386_start_kernel(void)
 {
 	reserve_trampoline_memory();
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop),
+			 "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S
+++ linux-2.6/arch/x86/kernel/head_32.S
@@ -38,42 +38,30 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ * This is how much memory for page table to and including _end
+ * we need mapped initially.
  *  - enough space to map all low memory, which means
- *     (2^32/4096) / 1024 pages (worst case, non PAE)
- *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
+ *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
+ *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
+ *
+ * KERNEL_IMAGE_SIZE should be greater than pa(_end)
+ * and small than max_low_pfn, otherwise will waste some page table entries
  */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
-/*
- * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
- * pagetables from above the 16MB DMA limit, so we'll have to set
- * up pagetables 16MB more (worst-case):
- */
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-LOW_PAGES = LOW_PAGES + 0x1000000
-#endif
+LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
 #if PTRS_PER_PMD > 1
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
 #else
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
 #endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
@@ -166,10 +154,9 @@ num_subarch_entries = (. - subarch_entri
 
 /*
  * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
+ * tables, which are located immediately beyond _end.
  * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ * and PAGE_OFFSET for up to _end
  *
  * Note that the stack is not yet set up!
  */
@@ -209,14 +196,14 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables.
+	 * End condition: we must map up to the end.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
-	movl %edi,pa(init_pg_tables_end)
+	movl %edi, pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -242,14 +229,14 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables; the +0x007 is
+	 * End condition: we must map up to end, the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end), %ebp
+	addl PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,pa(init_pg_tables_end)
+	movl %edi, pa(init_pg_tables_end)
 	shrl $12, %eax
 	movl %eax, pa(max_pfn_mapped)
 
@@ -636,6 +623,10 @@ swapper_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
+
+.section ".bss.extra_page_aligned","wa"
+	.align PAGE_SIZE_asm
+	.fill INIT_MAP_SIZE,1,0
 /*
  * This starts the data section.
  */
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,10 +189,13 @@ SECTIONS
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
-  	_end = . ;
+	/* extra_page_aligned must be last one before end*/
 	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(PAGE_SIZE);
 	pg0 = . ;
+	*(.bss.extra_page_aligned)
+	. = ALIGN(8);
+	_end = . ;
   }
 
   /* Sections to be discarded */
@@ -205,6 +208,12 @@ SECTIONS
   DWARF_DEBUG
 }
 
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
 #ifdef CONFIG_KEXEC
 /* Link time checks */
 #include <asm/kexec.h>
Index: linux-2.6/arch/x86/include/asm/page_32_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_32_types.h
+++ linux-2.6/arch/x86/include/asm/page_32_types.h
@@ -39,6 +39,11 @@
 #define __VIRTUAL_MASK_SHIFT	32
 #endif	/* CONFIG_X86_PAE */
 
+/*
+ * Kernel image size is limited to 512 MB (see in arch/x86/kernel/head_32.S)
+ */
+#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+
 #ifndef __ASSEMBLY__
 
 /*


--------------070803010209030408000409--
