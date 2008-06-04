Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbYFDXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbYFDXo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763223AbYFDXn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:43:57 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:21014 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763180AbYFDXnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=Cs/13cQA44g6q4b0PmlV3NqqlyRbjgkffRbc2t0cDFJbJq092V0ddrBkH40bMwMboZ
         PyiKLBQdE4sBCGWO6Gh93NCOLq0TQXRQR8/IoMgfSEI9UL4xSsTq6jpkkRTtuY3p8vfK
         QnrrWc/KqFCSdsP2m7q+w3PY0uffQaX4blelA=
Message-ID: <76bd70e30806041643j4d632a6exf64b29c34173d40f@mail.gmail.com>
Date: Wed, 4 Jun 2008 19:43:47 -0400
From: "Chuck Lever" <chuck.lever@oracle.com>
Reply-To: chucklever@gmail.com
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
X-Google-Sender-Auth: 7a6bb930e95c7c64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel-

On Wed, Jun 4, 2008 at 7:33 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Having experienced 'mount.nfs4: internal error' when mounting nfsv4 in
> the past, I have a minimal test-case I sometimes run:
>
> $ while :; do mount -t nfs4 filer:/store /store; umount /store; done
>
> After ~100 iterations, I saw the 'mount.nfs4: internal error',
> followed by symptoms of memory corruption [1], a locking issue with
> the reporting [2] and another (related?) memory-corruption issue
> (off-by-1?) [3]. A little analysis shows memory being overwritten by
> (likely) a poison value, which gets complicated if it's not
> use-after-free...
>
> Anyone dare confirm this issue? NFSv4 server is x86-64 Ubuntu 8.04
> 2.6.24-18, client U8.04 2.6.26-rc4; batteries included [4].

We have some other reports of late model kernels with memory
corruption issues during NFS mount.  The problem is that by the time
these canaries start singing, the evidence of what did the corrupting
is long gone.

> I'm happy to decode addresses, test patches etc.

If these crashes are more or less reliably reproduced, it would be
helpful if you could do a 'git bisect' on the client to figure out at
what point in the kernel revision history this problem was introduced.

Have you seen the problem on client kernels earlier than 2.6.25?

> --- [1]
>
> We see RAX (pointing to a structure) getting overwritten with the
> poison value, so is 0x6b6b6b6b6b6b6b6b:
>
> [4294454.232202] general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> [4294454.232328] CPU 1
> [4294454.232379] Modules linked in: snd_hda_intel snd_pcm snd_timer
> snd soundcore snd_page_alloc usbhid hid
> [4294454.232623] Pid: 6795, comm: mount.nfs4 Not tainted 2.6.26-rc4-200 #2
> [4294454.232657] RIP: 0010:[<ffffffff8024a12a>]  [<ffffffff8024a12a>]
> task_rq_lock+0x3a/0xa0
> [4294454.232723] RSP: 0018:ffff8100707cf878  EFLAGS: 00010002
> [4294454.232756] RAX: 6b6b6b6b6b6b6b6b RBX: ffffffff808542c0 RCX:
> 0000000000000001
> [4294454.232794] RDX: ffff81007dd52490 RSI: ffff8100707cf8b8 RDI:
> 0000000000000000
> [4294454.233077] RBP: ffff8100707cf898 R08: 0000000000000001 R09:
> 0000000000000001
> [4294454.233077] R10: 0000000000000002 R11: 0000000000000001 R12:
> ffffffff808542c0
> [4294454.233077] R13: ffff81007e378000 R14: ffff8100707cf8b8 R15:
> ffff81007ebf77e0
> [4294454.233077] FS:  00007f42363566e0(0000) GS:ffff81007fb41320(0000)
> knlGS:0000000000000000
> [4294454.233077] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [4294454.233077] CR2: 00000000023dc000 CR3: 0000000070711000 CR4:
> 00000000000026e0
> [4294454.233077] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [4294454.233077] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [4294454.233077] Process mount.nfs4 (pid: 6795, threadinfo
> ffff8100707ce000, task ffff81007dd52490)
> [4294454.233077] Stack:  000000000000000f ffff81007e378000
> ffff81007d46fc60 0000000000000000
> [4294454.233077]  ffff8100707cf8e8 ffffffff8024a4af ffff8100707cf8d8
> ffffffff80413d78
> [4294454.233077]  0000000000000286 ffff81007e378000 00000000fffffffb
> ffff81007d46fc60
> [4294454.233077] Call Trace:
> [4294454.233077]  [<ffffffff8024a4af>] try_to_wake_up+0x3f/0x210
> [4294454.233077]  [<ffffffff80413d78>] ? __spin_lock_init+0x38/0x70
> [4294454.233077]  [<ffffffff8024a6b0>] wake_up_process+0x10/0x20
> [4294454.233077]  [<ffffffff80269803>] kthread_stop+0x43/0x90
> [4294454.233077]  [<ffffffff8035ea5b>] nfs_callback_down+0x3b/0x50
> [4294454.233077]  [<ffffffff80338f95>] nfs_free_client+0xb5/0x100
> [4294454.233077]  [<ffffffff80339174>] nfs_put_client+0x64/0x90
> [4294454.233111]  [<ffffffff803397fd>] nfs4_set_client+0x16d/0x1e0
> [4294454.233111]  [<ffffffff8033a0cf>] nfs4_create_server+0x9f/0x440
> [4294454.233111]  [<ffffffff802bd1f8>] ? check_object+0x228/0x260
> [4294454.233111]  [<ffffffff802bc8cf>] ? init_object+0x4f/0x90
> [4294454.233111]  [<ffffffff802be780>] ? __slab_alloc+0xc0/0x550
> [4294454.233111]  [<ffffffff803440fb>] ? nfs4_get_sb+0x45b/0x580
> [4294454.233111]  [<ffffffff802c040f>] ? __kmalloc_track_caller+0x7f/0x110
> [4294454.233111]  [<ffffffff8027850f>] ? trace_hardirqs_on+0xbf/0x150
> [4294454.233111]  [<ffffffff803440fb>] ? nfs4_get_sb+0x45b/0x580
> [4294454.233111]  [<ffffffff80343fbe>] nfs4_get_sb+0x31e/0x580
> [4294454.233111]  [<ffffffff802be780>] ? __slab_alloc+0xc0/0x550
> [4294454.233111]  [<ffffffff802df96e>] ? alloc_vfsmnt+0x13e/0x180
> [4294454.233111]  [<ffffffff802c0aa3>] ? __kmalloc+0x83/0x110
> [4294454.233111]  [<ffffffff8027850f>] ? trace_hardirqs_on+0xbf/0x150
> [4294454.233111]  [<ffffffff802df96e>] ? alloc_vfsmnt+0x13e/0x180
> [4294454.233111]  [<ffffffff802c8098>] vfs_kern_mount+0x58/0xc0
> [4294454.233111]  [<ffffffff802c816e>] do_kern_mount+0x4e/0x100
> [4294454.233111]  [<ffffffff802e0f09>] do_new_mount+0x89/0xb0
> [4294454.233111]  [<ffffffff802e10fa>] do_mount+0x1ca/0x200
> [4294454.233111]  [<ffffffff80226af3>] ? restore_args+0x0/0x30
> [4294454.233111]  [<ffffffff802de77f>] ? copy_mount_options+0xff/0x170
> [4294454.233111]  [<ffffffff802e11c4>] sys_mount+0x94/0xf0
> [4294454.233111]  [<ffffffff805b2048>] ? trace_hardirqs_on_thunk+0x35/0x3a
> [4294454.233111]  [<ffffffff8022649b>] system_call_after_swapgs+0x7b/0x80
> [4294454.233111]
> [4294454.233111]
> [4294454.233111] Code: 74 24 18 49 89 fd 48 89 1c 24 49 89 f6 4c 89 64
> 24 08 49 c7 c4 c0 42 85 80 9c 58 fa 49 89 06 4c 89 e3 e8 aa b7 02 00
> 49 8b 45 08 <8b> 40 18 48 8b 04 c5 e0 a3 78 80 48 03 58 08 48 89 df e8
> df 82
> [4294454.235716] RIP  [<ffffffff8024a12a>] task_rq_lock+0x3a/0xa0
> [4294454.235716]  RSP <ffff8100707cf878>
> [4294454.235716] ---[ end trace 7cecf860834b072f ]---
>
> This corresponds to:
>
> ffffffff8024a0f0 <task_rq_lock>:
> task_rq_lock():
> /store/kernel/linux/kernel/sched.c:993
> ffffffff8024a0f0:       55                      push   %rbp
> ffffffff8024a0f1:       48 89 e5                mov    %rsp,%rbp
> ffffffff8024a0f4:       48 83 ec 20             sub    $0x20,%rsp
> ffffffff8024a0f8:       4c 89 6c 24 10          mov    %r13,0x10(%rsp)
> ffffffff8024a0fd:       4c 89 74 24 18          mov    %r14,0x18(%rsp)
> ffffffff8024a102:       49 89 fd                mov    %rdi,%r13
> ffffffff8024a105:       48 89 1c 24             mov    %rbx,(%rsp)
> ffffffff8024a109:       49 89 f6                mov    %rsi,%r14
> ffffffff8024a10c:       4c 89 64 24 08          mov    %r12,0x8(%rsp)
> ffffffff8024a111:       49 c7 c4 c0 42 85 80    mov    $0xffffffff808542c0,%r12
> native_save_fl():
> /store/kernel/linux/include/asm/irqflags.h:15
> ffffffff8024a118:       9c                      pushfq
> ffffffff8024a119:       58                      pop    %rax
> native_irq_disable():
> /store/kernel/linux/include/asm/irqflags.h:34
> ffffffff8024a11a:       fa                      cli
> task_rq_lock():
> /store/kernel/linux/kernel/sched.c:997
> ffffffff8024a11b:       49 89 06                mov    %rax,(%r14)
> /store/kernel/linux/kernel/sched.c:998
> ffffffff8024a11e:       4c 89 e3                mov    %r12,%rbx
> /store/kernel/linux/kernel/sched.c:997
> ffffffff8024a121:       e8 aa b7 02 00          callq
> ffffffff802758d0 <trace_hardirqs_off>
> /store/kernel/linux/kernel/sched.c:998
> ffffffff8024a126:       49 8b 45 08             mov    0x8(%r13),%rax
> ffffffff8024a12a:       8b 40 18                mov    0x18(%rax),%eax
>  <---- load from bad address
> ffffffff8024a12d:       48 8b 04 c5 e0 a3 78    mov    -0x7f875c20(,%rax,8),%rax
> ffffffff8024a134:       80
> ffffffff8024a135:       48 03 58 08             add    0x8(%rax),%rbx
> /store/kernel/linux/kernel/sched.c:999
> ffffffff8024a139:       48 89 df                mov    %rbx,%rdi
> ffffffff8024a13c:       e8 df 82 36 00          callq
> ffffffff805b2420 <_spin_lock>
> /store/kernel/linux/kernel/sched.c:1000
> ffffffff8024a141:       49 8b 45 08             mov    0x8(%r13),%rax
> ffffffff8024a145:       8b 40 18                mov    0x18(%rax),%eax
> ffffffff8024a148:       48 8b 04 c5 e0 a3 78    mov    -0x7f875c20(,%rax,8),%rax
>
> Which corresponds to:
>
> static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
>        __acquires(rq->lock)
> {
>        struct rq *rq;
>
>        for (;;) {
>                local_irq_save(*flags);
>                rq = task_rq(p);    <-----
>
> --- [2]
>
> [4294454.235716] BUG: sleeping function called from invalid context at
> kernel/rwsem.c:21
> [4294454.235716] in_atomic():0, irqs_disabled():1
> [4294454.235716] INFO: lockdep is turned off.
> [4294454.235716] irq event stamp: 5294
> [4294454.235716] hardirqs last  enabled at (5293):
> [<ffffffff8027863d>] debug_check_no_locks_freed+0x9d/0x150
> [4294454.235716] hardirqs last disabled at (5294):
> [<ffffffff8024a126>] task_rq_lock+0x36/0xa0
> [4294454.235716] softirqs last  enabled at (5260):
> [<ffffffff8057e18d>] xprt_disconnect_done+0x4d/0x70
> [4294454.235716] softirqs last disabled at (5256):
> [<ffffffff805b248f>] _spin_lock_bh+0xf/0x70
> [4294454.235716] Pid: 6795, comm: mount.nfs4 Tainted: G      D
> 2.6.26-rc4-200 #2
> [4294454.235716]
> [4294454.235716] Call Trace:
> [4294454.235716]  [<ffffffff802758c0>] ? print_irqtrace_events+0x110/0x120
> [4294454.235716]  [<ffffffff8024a0b0>] __might_sleep+0xf0/0x130
> [4294454.235716]  [<ffffffff805b0f10>] down_read+0x20/0x70
> [4294454.235716]  [<ffffffff802852f5>] acct_collect+0x45/0x1d0
> [4294454.235716]  [<ffffffff80257bda>] do_exit+0x18a/0x870
> [4294454.235716]  [<ffffffff802474ee>] ? __wake_up+0x4e/0x70
> [4294454.235716]  [<ffffffff805b3586>] oops_end+0x86/0x90
> [4294454.235716]  [<ffffffff8022820e>] die+0x5e/0x90
> [4294454.235716]  [<ffffffff805b3d99>] do_general_protection+0x149/0x160
> [4294454.235716]  [<ffffffff805b306d>] error_exit+0x0/0xa9
> [4294454.235716]  [<ffffffff8024a12a>] ? task_rq_lock+0x3a/0xa0
> [4294454.235716]  [<ffffffff8024a126>] ? task_rq_lock+0x36/0xa0
> [4294454.235716]  [<ffffffff8024a4af>] ? try_to_wake_up+0x3f/0x210
> [4294454.235716]  [<ffffffff80413d78>] ? __spin_lock_init+0x38/0x70
> [4294454.235716]  [<ffffffff8024a6b0>] ? wake_up_process+0x10/0x20
> [4294454.235716]  [<ffffffff80269803>] ? kthread_stop+0x43/0x90
> [4294454.235716]  [<ffffffff8035ea5b>] ? nfs_callback_down+0x3b/0x50
> [4294454.235716]  [<ffffffff80338f95>] ? nfs_free_client+0xb5/0x100
> [4294454.235716]  [<ffffffff80339174>] ? nfs_put_client+0x64/0x90
> [4294454.235716]  [<ffffffff803397fd>] ? nfs4_set_client+0x16d/0x1e0
> [4294454.235716]  [<ffffffff8033a0cf>] ? nfs4_create_server+0x9f/0x440
> [4294454.235716]  [<ffffffff802bd1f8>] ? check_object+0x228/0x260
> [4294454.235716]  [<ffffffff802bc8cf>] ? init_object+0x4f/0x90
> [4294454.235716]  [<ffffffff802be780>] ? __slab_alloc+0xc0/0x550
> [4294454.235716]  [<ffffffff803440fb>] ? nfs4_get_sb+0x45b/0x580
> [4294454.235716]  [<ffffffff802c040f>] ? __kmalloc_track_caller+0x7f/0x110
> [4294454.235716]  [<ffffffff8027850f>] ? trace_hardirqs_on+0xbf/0x150
> [4294454.235716]  [<ffffffff803440fb>] ? nfs4_get_sb+0x45b/0x580
> [4294454.235716]  [<ffffffff80343fbe>] ? nfs4_get_sb+0x31e/0x580
> [4294454.235716]  [<ffffffff802be780>] ? __slab_alloc+0xc0/0x550
> [4294454.235716]  [<ffffffff802df96e>] ? alloc_vfsmnt+0x13e/0x180
> [4294454.235716]  [<ffffffff802c0aa3>] ? __kmalloc+0x83/0x110
> [4294454.235716]  [<ffffffff8027850f>] ? trace_hardirqs_on+0xbf/0x150
> [4294454.235716]  [<ffffffff802df96e>] ? alloc_vfsmnt+0x13e/0x180
> [4294454.235716]  [<ffffffff802c8098>] ? vfs_kern_mount+0x58/0xc0
> [4294454.235716]  [<ffffffff802c816e>] ? do_kern_mount+0x4e/0x100
> [4294454.235716]  [<ffffffff802e0f09>] ? do_new_mount+0x89/0xb0
> [4294454.235716]  [<ffffffff802e10fa>] ? do_mount+0x1ca/0x200
> [4294454.235716]  [<ffffffff80226af3>] ? restore_args+0x0/0x30
> [4294454.235716]  [<ffffffff802de77f>] ? copy_mount_options+0xff/0x170
> [4294454.235716]  [<ffffffff802e11c4>] ? sys_mount+0x94/0xf0
> [4294454.235716]  [<ffffffff805b2048>] ? trace_hardirqs_on_thunk+0x35/0x3a
> [4294454.235716]  [<ffffffff8022649b>] ? system_call_after_swapgs+0x7b/0x80
>
> --- [3]
>
> [4294554.177842]
> =============================================================================
> [4294554.177842] BUG task_struct: Poison overwritten
> [4294554.177842]
> -----------------------------------------------------------------------------
> [4294554.177842]
> [4294554.177842] INFO: 0xffff81007e378010-0xffff81007e378010. First
> byte 0x6c instead of 0x6b
> [4294554.177842] INFO: Allocated in copy_process+0x9c/0x1320 age=90681
> cpu=0 pid=2
> [4294554.177842] INFO: Freed in free_task+0x38/0x40 age=90670 cpu=1 pid=0
> [4294554.177842] INFO: Slab 0xffffe20001b9c240 objects=3 used=1
> fp=0xffff81007e378000 flags=0x1000000000020c3
> [4294554.177842] INFO: Object 0xffff81007e378000 @offset=0 fp=0xffff81007e37a490
> [4294554.177842]
> [4294554.177898]   Object 0xffff81007e378000:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.177898]   Object 0xffff81007e378010:  6c 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b lkkkkkkkkkkkkkkk
> [4294554.177898]   Object 0xffff81007e378020:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.178773]   Object 0xffff81007e378030:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.178773]   Object 0xffff81007e378040:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.179768]   Object 0xffff81007e378050:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.179768]   Object 0xffff81007e378060:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.179768]   Object 0xffff81007e378070:  6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [4294554.180765]  Redzone 0xffff81007e37a440:  bb bb bb bb bb bb bb bb
>                        »»»»»»»»
> [4294554.180765]  Padding 0xffff81007e37a480:  5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [4294554.180765] Pid: 6807, comm: lesspipe Tainted: G      D   2.6.26-rc4-200 #2
> [4294554.180765]
> [4294554.180765] Call Trace:
> [4294554.180765]  [<ffffffff802bcc09>] print_trailer+0xf9/0x160
> [4294554.180765]  [<ffffffff802bcd24>] check_bytes_and_report+0xb4/0xe0
> [4294554.180765]  [<ffffffff802bd079>] check_object+0xa9/0x260
> [4294554.180765]  [<ffffffff802beb23>] __slab_alloc+0x463/0x550
> [4294554.180765]  [<ffffffff80251cac>] ? copy_process+0x9c/0x1320
> [4294554.180765]  [<ffffffff80251cac>] ? copy_process+0x9c/0x1320
> [4294554.180765]  [<ffffffff802bedb0>] kmem_cache_alloc+0xc0/0xd0
> [4294554.180765]  [<ffffffff80251cac>] copy_process+0x9c/0x1320
> [4294554.180765]  [<ffffffff80253062>] do_fork+0x82/0x2a0
> [4294554.180765]  [<ffffffff805b2b30>] ? _spin_unlock+0x30/0x60
> [4294554.180765]  [<ffffffff802c36fb>] ? fd_install+0x5b/0x70
> [4294554.180765]  [<ffffffff8022649b>] ? system_call_after_swapgs+0x7b/0x80
> [4294554.180765]  [<ffffffff802245f3>] sys_clone+0x23/0x30
> [4294554.180765]  [<ffffffff80226837>] ptregscall_common+0x67/0xb0
> [4294554.180765]
> [4294554.180765] FIX task_struct: Restoring
> 0xffff81007e378010-0xffff81007e378010=0x6b
> [4294554.180765]
> [4294554.180765] FIX task_struct: Marking all objects used
>
> --- [4]
>
> CONFIG_64BIT=y
> # CONFIG_X86_32 is not set
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> # CONFIG_GENERIC_GPIO is not set
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_AOUT=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> # CONFIG_KTIME_SCALAR is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=16
> # CONFIG_CGROUPS is not set
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_GROUP_SCHED is not set
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> CONFIG_RELAY=y
> # CONFIG_NAMESPACES is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_EMBEDDED=y
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> # CONFIG_PCSPKR_PLATFORM is not set
> # CONFIG_COMPAT_BRK is not set
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> CONFIG_MARKERS=y
> CONFIG_OPROFILE=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_KRETPROBES=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> # CONFIG_HAVE_DMA_ATTRS is not set
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLOCK_COMPAT=y
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_AS is not set
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PREEMPT_NOTIFIERS=y
> # CONFIG_CLASSIC_RCU is not set
>
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_X86_RDC321X is not set
> # CONFIG_X86_VSMP is not set
> # CONFIG_PARAVIRT_GUEST is not set
> CONFIG_MEMTEST_BOOTPARAM=y
> CONFIG_MEMTEST_BOOTPARAM_VALUE=1
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_CPU=y
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_P6_NOP=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> # CONFIG_CALGARY_IOMMU is not set
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=2
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_TRACE=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_I8K is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_NUMA=y
> # CONFIG_K8_NUMA is not set
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NODES_SPAN_OTHER_NODES=y
> # CONFIG_NUMA_EMU is not set
> CONFIG_NODES_SHIFT=6
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_MIGRATION=y
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MTRR=y
> CONFIG_X86_PAT=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x200000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_COMPAT_VDSO is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
>
> #
> # Power management options
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROCFS_POWER=y
> CONFIG_ACPI_SYSFS_POWER=y
> CONFIG_ACPI_PROC_EVENT=y
> # CONFIG_ACPI_AC is not set
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_BAY=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_NUMA=y
> CONFIG_ACPI_WMI=y
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
>
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> # CONFIG_CPU_FREQ_DEBUG is not set
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
>
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=y
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
>
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_DMAR is not set
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_LEGACY is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_HT_IRQ=y
> CONFIG_ISA_DMA_API=y
> CONFIG_K8_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
>
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> # CONFIG_BINFMT_MISC is not set
> CONFIG_IA32_EMULATION=y
> # CONFIG_IA32_AOUT is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
>
> #
> # Networking
> #
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> # CONFIG_IP_MULTIPLE_TABLES is not set
> # CONFIG_IP_ROUTE_MULTIPATH is not set
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE is not set
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> # CONFIG_INET_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=y
> # CONFIG_INET_DIAG is not set
> CONFIG_TCP_CONG_ADVANCED=y
> # CONFIG_TCP_CONG_BIC is not set
> CONFIG_TCP_CONG_CUBIC=y
> # CONFIG_TCP_CONG_WESTWOOD is not set
> # CONFIG_TCP_CONG_HTCP is not set
> # CONFIG_TCP_CONG_HSTCP is not set
> # CONFIG_TCP_CONG_HYBLA is not set
> # CONFIG_TCP_CONG_VEGAS is not set
> # CONFIG_TCP_CONG_SCALABLE is not set
> # CONFIG_TCP_CONG_LP is not set
> # CONFIG_TCP_CONG_VENO is not set
> # CONFIG_TCP_CONG_YEAH is not set
> # CONFIG_TCP_CONG_ILLINOIS is not set
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IP_VS is not set
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=y
> # CONFIG_NF_CT_ACCT is not set
> CONFIG_NF_CONNTRACK_MARK=y
> # CONFIG_NF_CONNTRACK_EVENTS is not set
> # CONFIG_NF_CT_PROTO_DCCP is not set
> CONFIG_NF_CT_PROTO_GRE=y
> # CONFIG_NF_CT_PROTO_SCTP is not set
> # CONFIG_NF_CT_PROTO_UDPLITE is not set
> # CONFIG_NF_CONNTRACK_AMANDA is not set
> CONFIG_NF_CONNTRACK_FTP=y
> # CONFIG_NF_CONNTRACK_H323 is not set
> # CONFIG_NF_CONNTRACK_IRC is not set
> # CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
> CONFIG_NF_CONNTRACK_PPTP=y
> # CONFIG_NF_CONNTRACK_SANE is not set
> CONFIG_NF_CONNTRACK_SIP=y
> # CONFIG_NF_CONNTRACK_TFTP is not set
> # CONFIG_NF_CT_NETLINK is not set
> CONFIG_NETFILTER_XTABLES=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
> # CONFIG_NETFILTER_XT_TARGET_DSCP is not set
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> # CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> # CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
> # CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
> # CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
> # CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> # CONFIG_NETFILTER_XT_MATCH_DCCP is not set
> # CONFIG_NETFILTER_XT_MATCH_DSCP is not set
> # CONFIG_NETFILTER_XT_MATCH_ESP is not set
> CONFIG_NETFILTER_XT_MATCH_HELPER=y
> # CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
> CONFIG_NETFILTER_XT_MATCH_LENGTH=y
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=y
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> # CONFIG_NETFILTER_XT_MATCH_OWNER is not set
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
> # CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
> # CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
> # CONFIG_NETFILTER_XT_MATCH_REALM is not set
> # CONFIG_NETFILTER_XT_MATCH_SCTP is not set
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> # CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
> # CONFIG_NETFILTER_XT_MATCH_STRING is not set
> # CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
> # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> CONFIG_NETFILTER_XT_MATCH_U32=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=y
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_RECENT=y
> # CONFIG_IP_NF_MATCH_ECN is not set
> # CONFIG_IP_NF_MATCH_AH is not set
> # CONFIG_IP_NF_MATCH_TTL is not set
> # CONFIG_IP_NF_MATCH_ADDRTYPE is not set
> CONFIG_IP_NF_FILTER=y
> # CONFIG_IP_NF_TARGET_REJECT is not set
> CONFIG_IP_NF_TARGET_LOG=y
> # CONFIG_IP_NF_TARGET_ULOG is not set
> CONFIG_NF_NAT=y
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=y
> CONFIG_IP_NF_TARGET_REDIRECT=y
> # CONFIG_IP_NF_TARGET_NETMAP is not set
> # CONFIG_NF_NAT_SNMP_BASIC is not set
> CONFIG_NF_NAT_PROTO_GRE=y
> CONFIG_NF_NAT_FTP=y
> # CONFIG_NF_NAT_IRC is not set
> # CONFIG_NF_NAT_TFTP is not set
> # CONFIG_NF_NAT_AMANDA is not set
> CONFIG_NF_NAT_PPTP=y
> # CONFIG_NF_NAT_H323 is not set
> CONFIG_NF_NAT_SIP=y
> CONFIG_IP_NF_MANGLE=y
> # CONFIG_IP_NF_TARGET_ECN is not set
> # CONFIG_IP_NF_TARGET_TTL is not set
> # CONFIG_IP_NF_TARGET_CLUSTERIP is not set
> # CONFIG_IP_NF_RAW is not set
> # CONFIG_IP_NF_ARPTABLES is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> CONFIG_NET_SCHED=y
>
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> CONFIG_NET_SCH_HTB=y
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> # CONFIG_NET_SCH_RR is not set
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> # CONFIG_NET_SCH_NETEM is not set
> CONFIG_NET_SCH_INGRESS=y
>
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> # CONFIG_NET_CLS_ROUTE4 is not set
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> # CONFIG_NET_CLS_RSVP is not set
> # CONFIG_NET_CLS_RSVP6 is not set
> CONFIG_NET_CLS_FLOW=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> # CONFIG_NET_EMATCH_TEXT is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=y
> # CONFIG_NET_ACT_NAT is not set
> CONFIG_NET_ACT_PEDIT=m
> # CONFIG_NET_ACT_SIMP is not set
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_TCPPROBE is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
>
> #
> # Wireless
> #
> CONFIG_CFG80211=y
> CONFIG_NL80211=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_MAC80211=m
>
> #
> # Rate control algorithm selection
> #
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> # CONFIG_MAC80211_RC_DEFAULT_NONE is not set
>
> #
> # Selecting 'y' for an algorithm will
> #
>
> #
> # build the algorithm into mac80211.
> #
> CONFIG_MAC80211_RC_DEFAULT="pid"
> CONFIG_MAC80211_RC_PID=y
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
> # CONFIG_MAC80211_DEBUG is not set
> # CONFIG_IEEE80211 is not set
> CONFIG_RFKILL=m
> CONFIG_RFKILL_INPUT=m
> CONFIG_RFKILL_LEDS=y
> # CONFIG_NET_9P is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_STANDALONE is not set
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=4
> CONFIG_BLK_DEV_RAM_SIZE=8192
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_SRP is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ACPI is not set
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_ATA_GENERIC=y
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> CONFIG_PATA_PLATFORM=y
> CONFIG_PATA_SCH=y
> # CONFIG_MD is not set
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> # CONFIG_NETDEVICES_MULTIQUEUE is not set
> # CONFIG_IFB is not set
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_NET_ETHERNET is not set
> CONFIG_MII=y
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> CONFIG_E1000E=y
> CONFIG_E1000E_ENABLED=y
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> CONFIG_ATL1=y
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> CONFIG_WLAN_80211=y
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> # CONFIG_LIBERTAS is not set
> # CONFIG_AIRO is not set
> # CONFIG_HERMES is not set
> # CONFIG_ATMEL is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_P54_COMMON is not set
> CONFIG_ATH5K=m
> # CONFIG_ATH5K_DEBUG is not set
> CONFIG_IWLWIFI=m
> CONFIG_IWLCORE=m
> # CONFIG_IWLWIFI_LEDS is not set
> CONFIG_IWLWIFI_RFKILL=y
> # CONFIG_IWL4965 is not set
> # CONFIG_IWL3945 is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_RT2X00 is not set
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=m
>
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> # CONFIG_INPUT_KEYBOARD is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>
> #
> # Hardware I/O ports
> #
> # CONFIG_SERIO is not set
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_DEVKMEM=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> # CONFIG_SERIAL_8250_PCI is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=2
> CONFIG_SERIAL_8250_RUNTIME_UARTS=2
> # CONFIG_SERIAL_8250_EXTENDED is not set
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_CONSOLE_POLL=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> CONFIG_RTC=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> # CONFIG_HPET_RTC_IRQ is not set
> CONFIG_HPET_MMAP=y
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> # CONFIG_I2C is not set
> # CONFIG_SPI is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_CORETEMP=m
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83627HF is not set
> CONFIG_SENSORS_W83627EHF=m
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_APPLESMC is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=y
> # CONFIG_WATCHDOG is not set
>
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> # CONFIG_SSB is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
>
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_VIDEO_SELECT is not set
> CONFIG_DUMMY_CONSOLE=y
>
> #
> # Sound
> #
> CONFIG_SOUND=m
>
> #
> # Advanced Linux Sound Architecture
> #
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> # CONFIG_SND_SEQUENCER is not set
> # CONFIG_SND_MIXER_OSS is not set
> # CONFIG_SND_PCM_OSS is not set
> # CONFIG_SND_RTCTIMER is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> # CONFIG_SND_VERBOSE_PROCFS is not set
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
>
> #
> # Generic devices
> #
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
>
> #
> # PCI devices
> #
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> # CONFIG_SND_HDA_HWDEP is not set
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> # CONFIG_SND_HDA_CODEC_VIA is not set
> # CONFIG_SND_HDA_CODEC_ATIHDMI is not set
> CONFIG_SND_HDA_CODEC_CONEXANT=y
> CONFIG_SND_HDA_CODEC_CMEDIA=y
> # CONFIG_SND_HDA_CODEC_SI3054 is not set
> CONFIG_SND_HDA_GENERIC=y
> CONFIG_SND_HDA_POWER_SAVE=y
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_HIFIER is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
>
> #
> # USB devices
> #
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_USX2Y is not set
> # CONFIG_SND_USB_CAIAQ is not set
>
> #
> # System on Chip audio support
> #
> # CONFIG_SND_SOC is not set
>
> #
> # ALSA SoC audio for Freescale SOCs
> #
>
> #
> # SoC Audio for the Texas Instruments OMAP
> #
>
> #
> # Open Sound System
> #
> # CONFIG_SOUND_PRIME is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=m
> # CONFIG_HID_DEBUG is not set
> # CONFIG_HIDRAW is not set
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> # CONFIG_HID_FF is not set
> # CONFIG_USB_HIDDEV is not set
>
> #
> # USB HID Boot Protocol drivers
> #
> # CONFIG_USB_KBD is not set
> # CONFIG_USB_MOUSE is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
>
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=y
> # CONFIG_USB_WDM is not set
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_DPCM is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_LIBUSUAL is not set
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> # CONFIG_USB_MON is not set
>
> #
> # USB port drivers
> #
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> # CONFIG_USB_EZUSB is not set
> # CONFIG_USB_SERIAL_GENERIC is not set
> # CONFIG_USB_SERIAL_AIRCABLE is not set
> # CONFIG_USB_SERIAL_AIRPRIME is not set
> # CONFIG_USB_SERIAL_ARK3116 is not set
> # CONFIG_USB_SERIAL_BELKIN is not set
> # CONFIG_USB_SERIAL_CH341 is not set
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> # CONFIG_USB_SERIAL_CP2101 is not set
> # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> # CONFIG_USB_SERIAL_EMPEG is not set
> CONFIG_USB_SERIAL_FTDI_SIO=y
> # CONFIG_USB_SERIAL_FUNSOFT is not set
> # CONFIG_USB_SERIAL_VISOR is not set
> # CONFIG_USB_SERIAL_IPAQ is not set
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> # CONFIG_USB_SERIAL_GARMIN is not set
> # CONFIG_USB_SERIAL_IPW is not set
> # CONFIG_USB_SERIAL_IUU is not set
> # CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
> # CONFIG_USB_SERIAL_KEYSPAN is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> # CONFIG_USB_SERIAL_MOS7720 is not set
> # CONFIG_USB_SERIAL_MOS7840 is not set
> # CONFIG_USB_SERIAL_MOTOROLA is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> # CONFIG_USB_SERIAL_PL2303 is not set
> # CONFIG_USB_SERIAL_OTI6858 is not set
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_HP4X is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> # CONFIG_USB_SERIAL_TI is not set
> # CONFIG_USB_SERIAL_CYBERJACK is not set
> # CONFIG_USB_SERIAL_XIRCOM is not set
> # CONFIG_USB_SERIAL_OPTION is not set
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_DEBUG is not set
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_AUERSWALD is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> # CONFIG_LEDS_CLASS is not set
>
> #
> # LED drivers
> #
>
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_UIO is not set
>
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_FS_XATTR is not set
> # CONFIG_EXT4DEV_FS is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
>
> #
> # Miscellaneous filesystems
> #
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> # CONFIG_NFS_V3 is not set
> CONFIG_NFS_V4=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V3=y
> # CONFIG_NFSD_V3_ACL is not set
> CONFIG_NFSD_V4=y
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> CONFIG_SUNRPC_BIND34=y
> CONFIG_RPCSEC_GSS_KRB5=y
> # CONFIG_RPCSEC_GSS_SPKM3 is not set
> # CONFIG_SMB_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
>
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="cp437"
> CONFIG_NLS_CODEPAGE_437=m
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=m
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=m
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_DETECT_SOFTLOCKUP=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_SELFTEST=y
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_SLUB_STATS=y
> CONFIG_DEBUG_PREEMPT=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_SG=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_LKDTM is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> CONFIG_KGDB_SERIAL_CONSOLE=y
> # CONFIG_KGDB_TESTS is not set
> # CONFIG_NONPROMISC_DEVMEM is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_DIRECT_GBPAGES=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> # CONFIG_DEBUG_NX_TEST is not set
> CONFIG_X86_MPPARSE=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=1
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> CONFIG_CPA_DEBUG=y
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_MANAGER=y
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
>
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
>
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=m
> # CONFIG_CRYPTO_AES_X86_64 is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=m
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_X86_64 is not set
>
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> # CONFIG_CRYPTO_LZO is not set
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> CONFIG_KVM_INTEL=y
> # CONFIG_KVM_AMD is not set
> # CONFIG_KVM_TRACE is not set
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> # CONFIG_CRC_CCITT is not set
> # CONFIG_CRC16 is not set
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y

-- 
Chuck Lever
