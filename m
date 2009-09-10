Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZIJRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZIJRQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZIJRQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:16:23 -0400
Received: from claw.goop.org ([74.207.240.146]:48903 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZIJRQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:16:22 -0400
Message-ID: <4AA93466.6020607@goop.org>
Date: Thu, 10 Sep 2009 10:16:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes
References: <4AA83F99.5040401@goop.org> <20090910051648.GA1335@elte.hu>
In-Reply-To: <20090910051648.GA1335@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/09 22:16, Ingo Molnar wrote:
>> +# Make sure __phys_addr has no stackprotector
>> +nostackp := $(call cc-option, -fno-stack-protector)
>> +CFLAGS_ioremap.o		:= $(nostackp)
>> +
>>     
> Sure we could move __phys_addr into its own file and thus avoid 
> turning off stackprotector for the rest of ioremap.c?
>   

I'm not very keen on having zillions of tiny files just to cope with the
lack of per-function stackprotector disable.  I don't see any code in
ioremap.c that would really benefit from stack-protector anyway; there
are no local arrays.

At least __phys_addr and friends aren't terribly closely related to
ioremap so it would at least make some sense.  Patch below.

>> --- a/arch/x86/xen/Makefile
>> +++ b/arch/x86/xen/Makefile
>> @@ -8,6 +8,7 @@ endif
>>  # Make sure early boot has no stackprotector
>>  nostackp := $(call cc-option, -fno-stack-protector)
>>  CFLAGS_enlighten.o		:= $(nostackp)
>> +CFLAGS_mmu.o			:= $(nostackp)
>>     
> A similar argument could be made here - what proportion of mmu.c is 
> affected?
>   

More.  It would be a fairly arbitrary chunk of code to split out into a
separate file.

> Also, once the commits have hit upstream feel free bounce them to 
> stable@kernel.org - they dont have Cc: <stable@kernel.org> tags for 
> automatic back-merging requests. The fixes narrowly missed v2.6.31.
>   

Will do.

Thanks,
    J

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: split __phys_addr out into separate file

Split __phys_addr out into its own file so we can disable
-fstack-protector in a fine-grained fashion.  Also it doesn't
have terribly much to do with the rest of ioremap.c.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 72bb3a2..9b5a9f5 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,9 +1,9 @@
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o gup.o
+	    pat.o pgtable.o physaddr.o gup.o
 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
-CFLAGS_ioremap.o		:= $(nostackp)
+CFLAGS_physaddr.o		:= $(nostackp)
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8a45093..04e1ad6 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -22,77 +22,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-static inline int phys_addr_valid(resource_size_t addr)
-{
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-	return !(addr >> boot_cpu_data.x86_phys_bits);
-#else
-	return 1;
-#endif
-}
-
-#ifdef CONFIG_X86_64
-
-unsigned long __phys_addr(unsigned long x)
-{
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
-		x += phys_base;
-	} else {
-		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
-		x -= PAGE_OFFSET;
-		VIRTUAL_BUG_ON(!phys_addr_valid(x));
-	}
-	return x;
-}
-EXPORT_SYMBOL(__phys_addr);
-
-bool __virt_addr_valid(unsigned long x)
-{
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		if (x >= KERNEL_IMAGE_SIZE)
-			return false;
-		x += phys_base;
-	} else {
-		if (x < PAGE_OFFSET)
-			return false;
-		x -= PAGE_OFFSET;
-		if (!phys_addr_valid(x))
-			return false;
-	}
-
-	return pfn_valid(x >> PAGE_SHIFT);
-}
-EXPORT_SYMBOL(__virt_addr_valid);
-
-#else
-
-#ifdef CONFIG_DEBUG_VIRTUAL
-unsigned long __phys_addr(unsigned long x)
-{
-	/* VMALLOC_* aren't constants  */
-	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
-	VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
-	return x - PAGE_OFFSET;
-}
-EXPORT_SYMBOL(__phys_addr);
-#endif
-
-bool __virt_addr_valid(unsigned long x)
-{
-	if (x < PAGE_OFFSET)
-		return false;
-	if (__vmalloc_start_set && is_vmalloc_addr((void *) x))
-		return false;
-	if (x >= FIXADDR_START)
-		return false;
-	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
-}
-EXPORT_SYMBOL(__virt_addr_valid);
-
-#endif
+#include "physaddr.h"
 
 int page_is_ram(unsigned long pagenr)
 {
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
new file mode 100644
index 0000000..d2e2735
--- /dev/null
+++ b/arch/x86/mm/physaddr.c
@@ -0,0 +1,70 @@
+#include <linux/mmdebug.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+#include <asm/page.h>
+
+#include "physaddr.h"
+
+#ifdef CONFIG_X86_64
+
+unsigned long __phys_addr(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
+		x += phys_base;
+	} else {
+		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+		x -= PAGE_OFFSET;
+		VIRTUAL_BUG_ON(!phys_addr_valid(x));
+	}
+	return x;
+}
+EXPORT_SYMBOL(__phys_addr);
+
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		if (x >= KERNEL_IMAGE_SIZE)
+			return false;
+		x += phys_base;
+	} else {
+		if (x < PAGE_OFFSET)
+			return false;
+		x -= PAGE_OFFSET;
+		if (!phys_addr_valid(x))
+			return false;
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
+#else
+
+#ifdef CONFIG_DEBUG_VIRTUAL
+unsigned long __phys_addr(unsigned long x)
+{
+	/* VMALLOC_* aren't constants  */
+	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+	VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
+	return x - PAGE_OFFSET;
+}
+EXPORT_SYMBOL(__phys_addr);
+#endif
+
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x < PAGE_OFFSET)
+		return false;
+	if (__vmalloc_start_set && is_vmalloc_addr((void *) x))
+		return false;
+	if (x >= FIXADDR_START)
+		return false;
+	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
+#endif	/* CONFIG_X86_64 */
diff --git a/arch/x86/mm/physaddr.h b/arch/x86/mm/physaddr.h
new file mode 100644
index 0000000..a3cd5a0
--- /dev/null
+++ b/arch/x86/mm/physaddr.h
@@ -0,0 +1,10 @@
+#include <asm/processor.h>
+
+static inline int phys_addr_valid(resource_size_t addr)
+{
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
+	return 1;
+#endif
+}


