Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYDPUQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYDPUQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYDPUP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:15:59 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:44967 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbYDPUP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:15:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAF/7BUhMROPA/2dsb2JhbACBYKx9
Date: Wed, 16 Apr 2008 16:10:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: text_poke, vmap and vmalloc on x86_64
Message-ID: <20080416201045.GA31199@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415164814.GA15842@elte.hu> <20080415213832.GC7873@Krystal> <20080416131751.GI6304@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416131751.GI6304@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:06:44 up 47 days, 16:17,  5 users,  load average: 0.27, 0.27,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to figure out why the following code seems to work fine on
x86_32, but the update fails to happen on x86_64. Any idea why ? From
what I see the memcpy seems to fall in a memory area which is not the
same as the one I test at the end of the function. It only fails for
module addresses, which are vmalloc'd. Once I fix this, I'll be able to
send the patchset.

(from my own alternative.c) :

void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
{
        unsigned long flags;
        char *vaddr;
        int nr_pages = 2;
        struct page *pages[2];
        int i;

        if (*((uint8_t *)addr - 1) != BREAKPOINT_INSTRUCTION) {
                BUG_ON(len > sizeof(long));
                BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
                        - ((long)addr & ~(sizeof(long) - 1)));
        }
        if (is_vmalloc_addr(addr)) {
                pages[0] = vmalloc_to_page(addr);
                pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
        } else {
                pages[0] = virt_to_page(addr);
                pages[1] = virt_to_page(addr + PAGE_SIZE);
        }
        BUG_ON(!pages[0]);
        if (!pages[1])
                nr_pages = 1;
        vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
        BUG_ON(!vaddr);
        local_irq_save(flags);
        memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
        local_irq_restore(flags);
        vunmap(vaddr);
        sync_core();
        /* Could also do a CLFLUSH here to speed up CPU recovery; but
           that causes hangs on some VIA CPUs. */
        for (i = 0; i < len; i++)
                BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
        return addr;
}

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
