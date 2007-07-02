Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbXGBTI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbXGBTI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXGBTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:08:21 -0400
Received: from gw.goop.org ([64.81.55.164]:40927 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbXGBTIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:08:21 -0400
Message-ID: <46894D22.8020505@goop.org>
Date: Mon, 02 Jul 2007 12:08:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] ioremap: fix iounmap numpages
References: <20070629170907.GA1735@darkstar.te-china.tietoenator.com>	 <4684FCC9.7010709@goop.org> <a8e1da0707011733g643730eakde04b40a4f8293c0@mail.gmail.com>
In-Reply-To: <a8e1da0707011733g643730eakde04b40a4f8293c0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
>> On 6/29/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Dave Young wrote:
>> > Hi,
>> > The second parameter of change_page_attr in iounmap is wrong, it 
>> should be (p->size - 1) >> PAGE_SHIFT
>> >
>>
>> Why's that?  Isn't p->size always going to be a pagesize multiple; in
>> which case, why would you want to change_page_attr on n-1 pages?
>>
>> Are you seeing a problem that this patch fixes?
>>
>>     J
>>
> Hi,
> Please read the  ioremap_nocache function, the page number is 
> calculated by:
>
> last_addr = phys_addr + size - 1;
> npages = (last_addr - phys_addr) >> PAGE_SHIFT;
>
> but the pages number in iounmap is p->size >> PAGE_SHIFT, the result
> is not consistent.
>
> If there's no netsc520 device then the netsc520 mtd driver
> initializing will cause oops.
> I debugged it with some printk messages, find that the ioremap_nocache
> call change_page_attr 256 times, but the iounmap call change_page_attr
> more than 256 times, so kernel oops. please finid the oops message:

OK, so the problem is that get_vm_area allocates the vm_area with an 
extra page added as a guard page.  iounmap uses p->size directly, 
without taking the guard page into account.

I don't see why this doesn't cause more problems.  I guess uncached 
iomappings are not used that much?

Anyway, I think this is the right fix:

Subject: fix iounmap's use of vm_struct's size field

get_vm_area always returns an area with an adjacent guard page.  That
guard page is included in vm_struct.size.  iounmap uses vm_struct.size
to determine how much address space needs to have change_page_attr
applied to it, which will BUG if applied to the guard page.

This patch adds a helper function - get_vm_area_size() in
linux/vmalloc.h - to return the actual size of a vm area, and uses it
to make iounmap do the right thing.  There are probably other places
which should be using get_vm_area_size().

Thanks to Dave Young <hidave.darkstar@gmail.com> for debugging the
problem.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/ioremap.c  |    2 +-
 include/linux/vmalloc.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/mm/ioremap.c
+++ b/arch/i386/mm/ioremap.c
@@ -193,7 +193,7 @@ void iounmap(volatile void __iomem *addr
 	/* Reset the direct mapping. Can block */
 	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
 		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 p->size >> PAGE_SHIFT,
+				 get_vm_area_size(p) >> PAGE_SHIFT,
 				 PAGE_KERNEL);
 		global_flush_tlb();
 	} 
===================================================================
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -70,6 +70,12 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
+static inline size_t get_vm_area_size(const struct vm_struct *area)
+{
+	/* return actual size without guard page */
+	return area->size - PAGE_SIZE;
+}
+
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);

