Return-Path: <linux-kernel-owner+w=401wt.eu-S1946198AbXBPSZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946198AbXBPSZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946192AbXBPSZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:25:09 -0500
Received: from main.gmane.org ([80.91.229.2]:32823 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946194AbXBPSZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:25:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Richardson <mcr@sandelman.ca>
Subject: failure of cache_alloc_refill to terminate
Date: Fri, 16 Feb 2007 12:25:26 -0500
Message-ID: <er4pev$bv$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: desk.marajade.sandelman.ca
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running a UserModeLinux of  2.6.19-rc4 vintage. It failed
to stop properly on halt.

Yes, there is some custom code in it, and it is possible that some memory
got walked on.   Attaching GDB to it, shows that it is stuck in:

slab.c, cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)

in the loop for: while (batchcount > 0) {..}
because the decrement:
     while (slabp->inuse < cachep->num && batchcount--) {

is never performed.
I don't know why slabp->inuse < cachep->num, but because it
it is never true, the batchcount never gets decremented.

Since, I think the point of the batchcount was to prevent it
from trying too hard, I am uncertain if it was intended that
the batchcount not decrement if the inuse check fails.

I think the point was to limit how many things we add to
the slab at once.

(Yes, I suspect that the slab got corrupted.)
The stack trace is:

#0  cache_alloc_refill (cachep=0x8800600, flags=208) at mm/slab.c:2954
#1  0x080bfbf0 in __kmalloc (size=1024, flags=<value optimized out>)
     at mm/slab.c:3085
#2  0x080d8c34 in alloc_fd_array (num=256) at include/linux/slab.h:146
#3  0x080d91da in alloc_fdtable (nr=255) at fs/file.c:274
#4  0x080d926a in expand_fdtable (files=0x8c12a80, nr=255) at fs/file.c:304
#5  0x080d9315 in expand_files (files=0x8c12a80, nr=255) at fs/file.c:347
#6  0x0807fffb in dup_fd (oldf=0x82d1480, errorp=0x840fe3c)
     at kernel/fork.c:679
#7  0x08080237 in copy_files (clone_flags=17, tsk=0x8771380)
     at kernel/fork.c:764
#8  0x08080706 in copy_process (clone_flags=17, stack_start=3214960796,
     regs=0x86894b4, stack_size=0, parent_tidptr=0x0, child_tidptr=0x0,
     pid=952) at kernel/fork.c:1107
#9  0x080810cd in do_fork (clone_flags=17, stack_start=3214960796,
     regs=0x86894b4, stack_size=0, parent_tidptr=0x0, child_tidptr=0x0)
     at kernel/fork.c:1368
#10 0x080628b8 in sys_fork () at arch/um/kernel/syscall.c:34
#11 0x08065492 in handle_syscall (r=0x86894b4)
     at arch/um/kernel/skas/syscall.c:38
#12 0x08078647 in handle_trap (pid=6063, regs=0x86894b4, local_using_sysemu=2)
     at arch/um/os-Linux/skas/process.c:151
#13 0x08078d95 in userspace (regs=0x86894b4)
     at arch/um/os-Linux/skas/process.c:302
#14 0x08065104 in fork_handler () at arch/um/kernel/skas/process.c:96
#15 0x00000000 in ?? ()
(gdb)

which is not really specific to rebooting/shutdown.

