Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZG3TSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZG3TSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZG3TSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:18:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:14920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZG3TSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:18:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,296,1246863600"; 
   d="scan'208";a="537325363"
Date: Thu, 30 Jul 2009 12:17:57 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com
Subject: Re: PAT wc & vmap mapping count issue ?
Message-ID: <20090730191757.GA16239@linux-os.sc.intel.com>
References: <1248952269.2462.33.camel@localhost> <1248973593.2462.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248973593.2462.35.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 10:06:33AM -0700, Jerome Glisse wrote:
> On Thu, 2009-07-30 at 13:11 +0200, Jerome Glisse wrote:
> > Hello,
> > 
> > I think i am facing a PAT issue code (at bottom of the mail) leads
> > to mapping count issue such as one at bottom of mail. Is my test
> > code buggy ? If so what is wrong with it ? Otherwise how could i
> > track this down ? (Tested with lastest Linus tree). Note that
> > the mapping count sometimes is negative, sometimes it's positive
> > but without proper mapping.
> > 
> > (With AMD Athlon(tm) Dual Core Processor 4450e)
> > 
> > Note that bad page might takes time to happen 256 pages is bit
> > too little either increasing that or doing memory hungry task
> > will helps triggering the bug faster.
> > 
> > Cheers,
> > Jerome
> > 
> > Jul 30 11:12:36 localhost kernel: BUG: Bad page state in process bash
> > pfn:6daed
> > Jul 30 11:12:36 localhost kernel: page:ffffea0001b6bb40
> > flags:4000000000000000 count:1 mapcount:1 mapping:(null) index:6d8
> > Jul 30 11:12:36 localhost kernel: Pid: 1876, comm: bash Not tainted
> > 2.6.31-rc2 #30
> > Jul 30 11:12:36 localhost kernel: Call Trace:
> > Jul 30 11:12:36 localhost kernel: [<ffffffff81098570>] bad_page
> > +0xf8/0x10d
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810997aa>]
> > get_page_from_freelist+0x357/0x475
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810a72e3>] ? cond_resched
> > +0x9/0xb
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810a9958>] ? copy_page_range
> > +0x4cc/0x558
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810999e0>]
> > __alloc_pages_nodemask+0x118/0x562
> > Jul 30 11:12:36 localhost kernel: [<ffffffff812a92c3>] ?
> > _spin_unlock_irq+0xe/0x11
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810a9dda>]
> > alloc_pages_node.clone.0+0x14/0x16
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810aa0b1>] do_wp_page
> > +0x2d5/0x57d
> > Jul 30 11:12:36 localhost kernel: [<ffffffff810aac00>] handle_mm_fault
> > +0x586/0x5e0
> > Jul 30 11:12:36 localhost kernel: [<ffffffff812ab635>] do_page_fault
> > +0x20a/0x21f
> > Jul 30 11:12:36 localhost kernel: [<ffffffff812a968f>] page_fault
> > +0x1f/0x30
> > Jul 30 11:12:36 localhost kernel: Disabling lock debugging due to kernel
> > taint
> > 
> > #define NPAGEST 256
> > void test_wc(void)
> > {
> >         struct page *pages[NPAGEST];
> >         int i, j;
> >         void *virt;
> > 
> >         for (i = 0; i < NPAGEST; i++) {
> >                 pages[i] = NULL;
> >         }
> >         for (i = 0; i < NPAGEST; i++) {
> >                 pages[i] = alloc_page(__GFP_DMA32 | GFP_USER);
> >                 if (pages[i] == NULL) {
> >                         printk(KERN_ERR "Failled allocating page %d\n",
> > i);
> >                         goto out_free;
> >                 }
> >                 if (!PageHighMem(pages[i]))
> >                         if (set_memory_wc((unsigned long)
> > page_address(pages[i]), 1)) {
> >                                 printk(KERN_ERR "Failled setting page %d
> > wc\n", i);
> >                                 goto out_free;
> >                         }
> >         }
> >         virt = vmap(pages, NPAGEST, 0,
> > pgprot_writecombine(PAGE_KERNEL));
> >         if (virt == NULL) {
> >                 printk(KERN_ERR "Failled vmapping\n");
> >                 goto out_free;
> >         }
> >         vunmap(virt);
> > out_free:
> >         for (i = 0; i < NPAGEST; i++) {
> >                 if (pages[i]) {
> >                         if (!PageHighMem(pages[i]))
> >                                 set_memory_wb((unsigned long)
> > page_address(pages[i]), 1);
> >                         __free_page(pages[i]);
> >                 }
> >         }
> > }
> 
> vmaping doesn't seems to be involved with the corruption simply
> setting some pages with set_memory_wc is enough.
> 
> 

This seems to be a regression from changeset
3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0

Below test patch should fix the problem. Can you please try it and let use know.
We can then send a cleaner patch with changelog etc to upstream+stable kernels.

Thanks,
Venki

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pageattr.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1b734d7..895d90e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -997,12 +997,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
+	unsigned long addr_copy = addr;
+
 	ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
-
 	if (!ret) {
-		ret = change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC), 0);
+		ret = change_page_attr_set_clr(&addr_copy, numpages,
+					       __pgprot(_PAGE_CACHE_WC),
+					       __pgprot(_PAGE_CACHE_MASK),
+					       0, 0, NULL);
 	}
 	return ret;
 }
-- 
1.6.0.6


