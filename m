Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYDYK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYDYK5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYDYK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:57:29 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43578 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYDYK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:57:28 -0400
Date: Fri, 25 Apr 2008 06:57:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: curious about setting read-only section to RO
Message-ID: <alpine.LFD.1.10.0804250651170.5837@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  from arch/x86/mm/init_32.c:
...
#ifdef CONFIG_DEBUG_RODATA
const int rodata_test_data = 0xC3;
EXPORT_SYMBOL_GPL(rodata_test_data);

void mark_rodata_ro(void)
{
        unsigned long start = PFN_ALIGN(_text);
        unsigned long size = PFN_ALIGN(_etext) - start;

        set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
        printk(KERN_INFO "Write protecting the kernel text: %luk\n",
                size >> 10);

#ifdef CONFIG_CPA_DEBUG
        printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
                start, start+size);
        set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);

        printk(KERN_INFO "Testing CPA: write protecting again\n");
        set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
#endif
        start += size;
        size = (unsigned long)__end_rodata - start;
        set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
        printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
                size >> 10);
        rodata_test();
...

  some questions:

1) i was going to ask why the kernel .text section wasn't just set to
RO by default, but i read a post by arjan suggesting that might be a
performance hit.  enough of a performance hit to actually not put in
that check permanently?

2) the .rodata section is allegedly write-protected by simply assuming
it always lives *immediately* after the .text section.  is that always
a valid assumption here?  wouldn't it be safer to identify the .rodata
section based on the __start_rodata symbol defined in
include/asm-generic/vmlinux.lds.h?  that would seem to be the more
reliable thing to do, no?

3) is there any debugging benefit to treating the .text and .rodata
sections independently?  as in, allowing one to write-protect one or
the other, but not both?  i'm not arguing for that, just asking.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
