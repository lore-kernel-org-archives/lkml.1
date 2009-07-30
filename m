Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbZG3LMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbZG3LMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZG3LMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:12:31 -0400
Received: from nox.protox.org ([88.191.38.29]:44214 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZG3LMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:12:30 -0400
Subject: PAT wc & vmap mapping count issue ?
From: Jerome Glisse <glisse@freedesktop.org>
To: linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com
Content-Type: text/plain
Date: Thu, 30 Jul 2009 13:11:09 +0200
Message-Id: <1248952269.2462.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think i am facing a PAT issue code (at bottom of the mail) leads
to mapping count issue such as one at bottom of mail. Is my test
code buggy ? If so what is wrong with it ? Otherwise how could i
track this down ? (Tested with lastest Linus tree). Note that
the mapping count sometimes is negative, sometimes it's positive
but without proper mapping.

(With AMD Athlon(tm) Dual Core Processor 4450e)

Note that bad page might takes time to happen 256 pages is bit
too little either increasing that or doing memory hungry task
will helps triggering the bug faster.

Cheers,
Jerome

Jul 30 11:12:36 localhost kernel: BUG: Bad page state in process bash
pfn:6daed
Jul 30 11:12:36 localhost kernel: page:ffffea0001b6bb40
flags:4000000000000000 count:1 mapcount:1 mapping:(null) index:6d8
Jul 30 11:12:36 localhost kernel: Pid: 1876, comm: bash Not tainted
2.6.31-rc2 #30
Jul 30 11:12:36 localhost kernel: Call Trace:
Jul 30 11:12:36 localhost kernel: [<ffffffff81098570>] bad_page
+0xf8/0x10d
Jul 30 11:12:36 localhost kernel: [<ffffffff810997aa>]
get_page_from_freelist+0x357/0x475
Jul 30 11:12:36 localhost kernel: [<ffffffff810a72e3>] ? cond_resched
+0x9/0xb
Jul 30 11:12:36 localhost kernel: [<ffffffff810a9958>] ? copy_page_range
+0x4cc/0x558
Jul 30 11:12:36 localhost kernel: [<ffffffff810999e0>]
__alloc_pages_nodemask+0x118/0x562
Jul 30 11:12:36 localhost kernel: [<ffffffff812a92c3>] ?
_spin_unlock_irq+0xe/0x11
Jul 30 11:12:36 localhost kernel: [<ffffffff810a9dda>]
alloc_pages_node.clone.0+0x14/0x16
Jul 30 11:12:36 localhost kernel: [<ffffffff810aa0b1>] do_wp_page
+0x2d5/0x57d
Jul 30 11:12:36 localhost kernel: [<ffffffff810aac00>] handle_mm_fault
+0x586/0x5e0
Jul 30 11:12:36 localhost kernel: [<ffffffff812ab635>] do_page_fault
+0x20a/0x21f
Jul 30 11:12:36 localhost kernel: [<ffffffff812a968f>] page_fault
+0x1f/0x30
Jul 30 11:12:36 localhost kernel: Disabling lock debugging due to kernel
taint

#define NPAGEST 256
void test_wc(void)
{
        struct page *pages[NPAGEST];
        int i, j;
        void *virt;

        for (i = 0; i < NPAGEST; i++) {
                pages[i] = NULL;
        }
        for (i = 0; i < NPAGEST; i++) {
                pages[i] = alloc_page(__GFP_DMA32 | GFP_USER);
                if (pages[i] == NULL) {
                        printk(KERN_ERR "Failled allocating page %d\n",
i);
                        goto out_free;
                }
                if (!PageHighMem(pages[i]))
                        if (set_memory_wc((unsigned long)
page_address(pages[i]), 1)) {
                                printk(KERN_ERR "Failled setting page %d
wc\n", i);
                                goto out_free;
                        }
        }
        virt = vmap(pages, NPAGEST, 0,
pgprot_writecombine(PAGE_KERNEL));
        if (virt == NULL) {
                printk(KERN_ERR "Failled vmapping\n");
                goto out_free;
        }
        vunmap(virt);
out_free:
        for (i = 0; i < NPAGEST; i++) {
                if (pages[i]) {
                        if (!PageHighMem(pages[i]))
                                set_memory_wb((unsigned long)
page_address(pages[i]), 1);
                        __free_page(pages[i]);
                }
        }
}

