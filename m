Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbYE1O1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbYE1O1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYE1O1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:27:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYE1O1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:27:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2874.1211980355@redhat.com>
References: <2874.1211980355@redhat.com> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
Cc: dhowells@redhat.com, Pekka J Enberg <penberg@cs.helsinki.fi>,
       clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 15:27:09 +0100
Message-ID: <29309.1211984829@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Works for SLAB and SLUB.  SLOB breaks well before getting to anything these
> patches affect.

Okay, I've fixed things so that it gets things aligned properly with SLOB.
This patch doesn't work for SLOB because SLOB doesn't set PG_slab on its
pages.  This causes:

	kernel BUG at mm/nommu.c:129!

Or, as gdb sees it:

Break 00000002

Program received signal SIGABRT, Aborted.
0xc0055498 in kobjsize (objp=<value optimized out>) at mm/nommu.c:129
(gdb) list
124	
125		if (PageCompound(page))
126			return PAGE_SIZE << compound_order(page);
127	
128		BUG_ON(page->index < 0);
129		BUG_ON(page->index >= MAX_ORDER);
130	
131		return (PAGE_SIZE << page->index);
132	}
133	
(gdb) bt
#0  0xc0055498 in kobjsize (objp=<value optimized out>) at mm/nommu.c:129
#1  0xc0056408 in do_mmap_pgoff (file=0xc08f7d00, addr=3231711232, len=536128, prot=5, 
    flags=3758096383, pgoff=<value optimized out>) at mm/nommu.c:1010
#2  0xc008b988 in elf_fdpic_map_file (params=0xc0849eac, file=0xc08f7d00, mm=0xc0989ee0, 
    what=0xc01cc00c "executable") at mm.h:1105
#3  0xc008cb98 in load_elf_fdpic_binary (bprm=0xc0988e68, regs=<value optimized out>)
    at fs/binfmt_elf_fdpic.c:345
#4  0xc0060d90 in search_binary_handler (bprm=0xc0988e68, regs=0xc0849f90) at fs/exec.c:1215
#5  0xc0061d24 in do_execve (filename=<value optimized out>, argv=0xc01e1c38, envp=0xc01e1bb0, 
    regs=0xc0849f90) at fs/exec.c:1327
#6  0xc000aab0 in sys_execve (name=<value optimized out>, argv=0xc01e1c38, envp=0xc01e1bb0)
    at arch/frv/kernel/process.c:267
#7  0xc00095e0 in __syscall_call () at arch/frv/kernel/entry.S:898
#8  0xc00095e0 in __syscall_call () at arch/frv/kernel/entry.S:898
(gdb) p/x *page
$3 = {flags = 0x40000840, _count = {counter = 0x1}, {_mapcount = {counter = 0x1cfbffff}, {
      inuse = 0x1cfb, objects = 0xffff}}, {{private = 0x0, mapping = 0x0}, slab = 0x0, 
    first_page = 0x0}, {index = 0xc0980056, freelist = 0xc0980056}, lru = {next = 0xc08107b8, 
    prev = 0xc01e51f0}}
(gdb) up
#1  0xc0056408 in do_mmap_pgoff (file=0xc08f7d00, addr=3231711232, len=536128, prot=5, 
    flags=3758096383, pgoff=<value optimized out>) at mm/nommu.c:1010
(gdb) list
1005		if (vma->vm_flags & VM_MAPPED_COPY) {
1006			realalloc += kobjsize(result);
1007			askedalloc += len;
1008		}
1009	
1010		realalloc += kobjsize(vma);
1011		askedalloc += sizeof(*vma);
1012	
1013		current->mm->total_vm += len >> PAGE_SHIFT;
1014	


PG_active is set (0x00000040), but not PG_slab (0x00000080).  The VMA object
in question is allocated using kzalloc().

David
