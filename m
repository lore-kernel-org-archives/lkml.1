Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152Ab0ATB7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0ATB7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 20:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033Ab0ATB7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 20:59:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:13472 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0ATB7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 20:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mNbdyP6S3lBCHrOFqqpYc17HjNyyZkXuh22VyEG/T1EqpQbR7iJTXX/YGBYyNbTtB9
         9hAl8Rhff+um3BMoDd6Mm+4q53quX2Vo2NtdXP98I00QckGxPJt8ZsMmvnC89DQLkSoN
         waqLpxTGWi4jKH4Gi19SZWJ8mz9MluFiForcM=
MIME-Version: 1.0
Date: Wed, 20 Jan 2010 01:59:51 +0000
Message-ID: <6278d2221001191759l625875c0g841b90d9dadd09f0@mail.gmail.com>
Subject: [2.6.33-rc4] crash in slab_alloc (kmem_cache_alloc)...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With stock (debug and non-debug) 2.6.33-rc4, I'm hitting a bug during
boot in SLUB's slab_alloc [1].

>From the disassembly [2] and code correlation [3], we see c->offset
(ie RAX) is 0 but the previous freelist pointer (assigned to object)
is 0x88007fb080180000 - the address after the top byte looks entirely
plausible, since FS and CR2 are loaded with values in the same region,
so it's clear the top byte has been overwritten, hence the protection
fault on that address.

Since freelist is the first member in the kmem_cache_cpu, it's
plausible that this could have been overwritten due to an off-by-one
on the previous object (or redzoning, though doesn't look like the
slab redzoning), or from users of adjacent (non-slab?) objects going
out of bounds.

Any suggestions/visibility from SLUB experts?

Also, is it expected that the instructions in the 'Code:' line don't
reach the faulting instruction? I guess the count was reduced to keep
the reports neat, though it now makes matching the assembly less
reliable when needed, no?

Let me know if posting the config/vmlinux etc will prove useful.

Thanks,
  Daniel

--- [1]

general protection fault: 0000 [#1] SMP

last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/subsystem_device

CPU 0

Pid: 2239, comm: rpc.nfsd Tainted: G        W  2.6.33-rc4-311s #1 Crestline/OEM

RIP: 0010:[<ffffffff810c67b0>]  [<ffffffff810c67b0>] kmem_cache_alloc+0x60/0x130

RSP: 0018:ffff88007cb99a68  EFLAGS: 00010086

RAX: 0000000000000000 RBX: 88007fb080180000 RCX: ffffffff81391577

RDX: ffff88007fbc4c60 RSI: 0000000000000020 RDI: ffffffff818114f8

RBP: ffff88007cb99aa8 R08: ffff880001a0fc40 R09: 0000000000000020

R10: 0000000000000000 R11: 0000000000000011 R12: ffffffff818114f8

R13: 0000000000000020 R14: 0000000000000246 R15: 0000000000000020

FS:  00007f02c934b6f0(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000

CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b

CR2: 00007f02c8efca7c CR3: 000000007d127000 CR4: 00000000000006f0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Process rpc.nfsd (pid: 2239, threadinfo ffff88007cb98000, task ffff88007cad5820)

Stack:

 ffff88007904ca00 ffff88007d17a840 ffff88007904ca00 ffff88007fbc4c60

<0> 000000000000c4c6 ffff88007d17a840 000000000000c4c6 ffffffff819b9240

<0> ffff88007cb99ac8 ffffffff81391577 000000000000c4c6 ffff88007fbc4c60

Call Trace:

 [<ffffffff81391577>] inet_bind_bucket_create+0x17/0x60

 [<ffffffff81393663>] inet_csk_get_port+0x233/0x370

 [<ffffffff813b6883>] inet_bind+0x113/0x1e0

 [<ffffffff8133943b>] kernel_bind+0xb/0x10

 [<ffffffff813df9c2>] svc_create_socket+0x122/0x340

 [<ffffffff813d32f0>] ? rpc_call_sync+0x50/0x70

 [<ffffffff813e386b>] ? rpcb_register_call+0x1b/0x60

 [<ffffffff813e3c0d>] ? rpcb_register+0x9d/0xf0

 [<ffffffff813dfc16>] svc_tcp_create+0x16/0x20

 [<ffffffff813ea595>] svc_create_xprt+0x175/0x2b0

 [<ffffffff81187f87>] T.694+0x67/0x70

 [<ffffffff811604c0>] ? write_ports+0x0/0x280

 [<ffffffff81188044>] lockd_up+0xb4/0x210

 [<ffffffff811604c0>] ? write_ports+0x0/0x280

 [<ffffffff81160481>] __write_ports_addfd+0x91/0xd0

 [<ffffffff811605b0>] write_ports+0xf0/0x280

 [<ffffffff8109fd62>] ? __get_free_pages+0x12/0x50

 [<ffffffff8109fea1>] ? get_zeroed_page+0x11/0x20

 [<ffffffff811604c0>] ? write_ports+0x0/0x280

 [<ffffffff811613be>] nfsctl_transaction_write+0x6e/0x90

 [<ffffffff810cc198>] vfs_write+0xb8/0x150

 [<ffffffff810cc30c>] sys_write+0x4c/0x80

 [<ffffffff81002cab>] system_call_fastpath+0x16/0x1b

Code: 85 86 00 00 00 9c 41 5e fa 65 8b 04 25 d0 cc 00 00 48 98 4d 8b
84 c4 88 00 00 00 49 8b 18 45

RIP  [<ffffffff810c67b0>] kmem_cache_alloc+0x60/0x130

 RSP <ffff88007cb99a68>

---[ end trace 93d72a36b9146f24 ]---

Kernel panic - not syncing: Fatal exception in interrupt


--- [2]

$ objdump -dl vmlinux
...
get_cpu_slab():
/net/kernel/linux/mm/slub.c:248
ffffffff810c6796:       48 98                   cltq
ffffffff810c6798:       4d 8b 84 c4 88 00 00    mov    0x88(%r12,%rax,8),%r8
ffffffff810c679f:       00
slab_alloc():
/net/kernel/linux/mm/slub.c:1727
ffffffff810c67a0:       49 8b 18                mov    (%r8),%rbx
/net/kernel/linux/mm/slub.c:1726
ffffffff810c67a3:       45 8b 48 18             mov    0x18(%r8),%r9d
/net/kernel/linux/mm/slub.c:1727
ffffffff810c67a7:       48 85 db                test   %rbx,%rbx
ffffffff810c67aa:       74 79                   je
ffffffff810c6825 <kmem_cache_alloc+0xd5>
/net/kernel/linux/mm/slub.c:1733
ffffffff810c67ac:       41 8b 40 14             mov    0x14(%r8),%eax
ffffffff810c67b0:       48 8b 04 c3             mov
(%rbx,%rax,8),%rax <-- trapped
ffffffff810c67b4:       49 89 00                mov    %rax,(%r8)

--- [3]

static __always_inline void *slab_alloc(struct kmem_cache *s,
                gfp_t gfpflags, int node, unsigned long addr)
{
        void **object;
        struct kmem_cache_cpu *c;
        unsigned long flags;
        unsigned int objsize;

        gfpflags &= gfp_allowed_mask;

        lockdep_trace_alloc(gfpflags);
        might_sleep_if(gfpflags & __GFP_WAIT);

        if (should_failslab(s->objsize, gfpflags))
                return NULL;

        local_irq_save(flags);
        c = get_cpu_slab(s, smp_processor_id());
        objsize = c->objsize;
        if (unlikely(!c->freelist || !node_match(c, node)))

                object = __slab_alloc(s, gfpflags, node, addr, c);

        else {
                object = c->freelist;
                c->freelist = object[c->offset];   <--- trapped
                stat(c, ALLOC_FASTPATH);
        }
        local_irq_restore(flags);

        if (unlikely(gfpflags & __GFP_ZERO) && object)
                memset(object, 0, objsize);

        kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
        kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);

        return object;
}
-- 
Daniel J Blueman
