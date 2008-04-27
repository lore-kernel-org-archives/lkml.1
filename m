Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbYD0Mb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbYD0Mb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYD0Mbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:31:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37194 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbYD0Mbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:31:48 -0400
Date: Sun, 27 Apr 2008 15:31:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: x86 pat.c:phys_mem_access_prot_allowed() bogosity
Message-ID: <20080427123120.GZ2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e7f260a276f2c9184fe753732d834b1f6fbe9f17
(x86: PAT use reserve free memtype in mmap of /dev/mem)
added the following gem to arch/x86/mm/pat.c:

<--  snip  -->

...
int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
                                unsigned long size, pgprot_t *vma_prot)
{
        u64 offset = ((u64) pfn) << PAGE_SHIFT;
        unsigned long flags = _PAGE_CACHE_UC_MINUS;
        unsigned long ret_flags;
...
...  (nothing that touches ret_flags)
...
        if (flags != _PAGE_CACHE_UC_MINUS) {
                retval = reserve_memtype(offset, offset + size, flags, NULL);
        } else {
                retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
        }

        if (retval < 0)
                return 0;

        flags = ret_flags;

        if (pfn <= max_pfn_mapped &&
            ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
                free_memtype(offset, offset + size);
                printk(KERN_INFO
                "%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
                        current->comm, current->pid,
                        cattr_name(flags),
                        offset, offset + size);
                return 0;
        }

        *vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
                             flags);
        return 1;
}

<--  snip  -->

If (flags != _PAGE_CACHE_UC_MINUS) we pass garbage from the stack to 
ioremap_change_attr() and/or __pgprot().

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

