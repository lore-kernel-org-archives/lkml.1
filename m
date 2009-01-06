Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZAFCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZAFCPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZAFCPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:15:17 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51118 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZAFCPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:15:12 -0500
Date: Mon, 5 Jan 2009 18:15:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090106021506.GA23052@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090105022827.GA8080@linux.vnet.ibm.com> <20090105121409.GA5783@alice> <20090105180037.GH6959@linux.vnet.ibm.com> <20090105185655.GA11244@alice> <20090105193602.GL6959@linux.vnet.ibm.com> <20090105200012.GB11244@alice> <20090105201631.GO6959@linux.vnet.ibm.com> <20090105203153.GC11244@alice> <20090105221836.GT6959@linux.vnet.ibm.com> <20090106002912.GA21071@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20090106002912.GA21071@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2009 at 04:29:12PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 05, 2009 at 02:18:36PM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 05, 2009 at 09:31:53PM +0100, Eric Sesterhenn wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Mon, Jan 05, 2009 at 09:01:45PM +0100, Eric Sesterhenn wrote:
> > > > > hi,
> > > > > 
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Mon, Jan 05, 2009 at 07:56:55PM +0100, Eric Sesterhenn wrote:
> > > > > > 
> > > > > > Wow!!!  Am I reading this correctly?  Does the above "call" instruction
> > > > > > -really- call one byte into itself?  That is what the hex for the x86
> > > > > > instruction -looks- like it is doing, but I cannot see what would have
> > > > > > possessed the compiler to generate this code.
> > > > > 
> > > > > Compiler is gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)
> > > > 
> > > > I am using 4.1.3, for whatever it is worth.  (Ancient, I know!)
> > > > 
> > > > > > When I compile on a 32-bit x86 machine, I don't see the above "call"
> > > > > > instruction.  Other than that, the code I see looks consistent.
> > > > > > 
> > > > > > >      9f0:       eb 1d                   jmp    a0f <rcu_stutter_wait+0x27>
> > > > > > >      9f2:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
> > > > > > >      9f9:       b8 01 00 00 00          mov    $0x1,%eax
> > > > > > >      9fe:       75 0a                   jne    a0a <rcu_stutter_wait+0x22>
> > > > > > >      a00:       b8 e8 03 00 00          mov    $0x3e8,%eax
> > > > > > >      a05:       e8 fc ff ff ff          call   a06 <rcu_stutter_wait+0x1e>
> > > > > > >      a0a:       e8 fc ff ff ff          call   a0b <rcu_stutter_wait+0x23>
> > > > > > >      a0f:       83 3d 6c 00 00 00 00    cmpl   $0x0,0x6c
> > > > > > > 			^---------- this line
> > > > > > 
> > > > > > This looks like the first test in the "while" loop.
> > > > > > 
> > > > > > >      a16:       75 09                   jne    a21 <rcu_stutter_wait+0x39>
> > > > > > >      a18:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
> > > > > > >      a1f:       75 09                   jne    a2a <rcu_stutter_wait+0x42>
> > > > > > >      a21:       83 3d 50 1a 00 00 00    cmpl   $0x0,0x1a50
> > > > > > >      a28:       74 c8                   je     9f2 <rcu_stutter_wait+0xa>
> > > > > > >      a2a:       5d                      pop    %ebp
> > > > > > >      a2b:       c3                      ret
> > > > > > 
> > > > > > The corresponding C code is as follows:
> > > > > > 
> > > > > > static void
> > > > > > rcu_stutter_wait(void)
> > > > > > {
> > > > > > 	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
> > > > > > 		if (rcutorture_runnable)
> > > > > > 			schedule_timeout_interruptible(1);
> > > > > > 		else
> > > > > > 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
> > > > > > 	}
> > > > > > }
> > > > > > 
> > > > > > I don't see much opportunity for a page fault here...  This is the
> > > > > > binary I get when I compile it, though not as a module:
> > > > > > 
> > > > > > 0000085a <rcu_stutter_wait>:
> > > > > >      85a:	55                   	push   %ebp
> > > > > >      85b:	89 e5                	mov    %esp,%ebp
> > > > > >      85d:	eb 1d                	jmp    87c <rcu_stutter_wait+0x22>
> > > > > >      85f:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
> > > > > >      866:	b8 01 00 00 00       	mov    $0x1,%eax
> > > > > >      86b:	75 0a                	jne    877 <rcu_stutter_wait+0x1d>
> > > > > >      86d:	b8 e8 03 00 00       	mov    $0x3e8,%eax
> > > > > >      872:	e8 fc ff ff ff       	call   873 <rcu_stutter_wait+0x19>
> > > > > >      877:	e8 fc ff ff ff       	call   878 <rcu_stutter_wait+0x1e>
> > > > > >      87c:	83 3d 14 00 00 00 00 	cmpl   $0x0,0x14
> > > > > >      883:	75 09                	jne    88e <rcu_stutter_wait+0x34>
> > > > > >      885:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
> > > > > >      88c:	75 09                	jne    897 <rcu_stutter_wait+0x3d>
> > > > > >      88e:	83 3d 08 1a 00 00 00 	cmpl   $0x0,0x1a08
> > > > > >      895:	74 c8                	je     85f <rcu_stutter_wait+0x5>
> > > > > >      897:	5d                   	pop    %ebp
> > > > > >      898:	c3                   	ret    
> > > > > > 
> > > > > > I confess, I am confused!!!
> > > > > 
> > > > > on the other box with a different gcc version
> > > > > 
> > > > > gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) 
> > > > > 
> > > > > d1902e90 is the start of rcu_stutter_wait
> > > > > 
> > > > > [  533.391719] d087e000 d1902e90
> > > > > [  533.392294] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
> > > > > [  541.000139] BUG: unable to handle kernel paging request at d1902efd
> > > > > [  541.000423] IP: [<d1902efd>] 0xd1902efd
> > > > > [  541.000660] *pde = 0f08f067 *pte = 00000000 
> > > > > [  541.000867] Oops: 0000 [#1] DEBUG_PAGEALLOC
> > > > > [  541.001126] last sysfs file: /sys/block/sda/size
> > > > > [  541.001246] Modules linked in: nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> > > > > [  541.002235] 
> > > > > [  541.002334] Pid: 5292, comm: rcu_torture_wri Not tainted (2.6.28 #84) 
> > > > > [  541.002470] EIP: 0060:[<d1902efd>] EFLAGS: 00010296 CPU: 0
> > > > > [  541.002598] EIP is at 0xd1902efd
> > > > > [  541.002767] EAX: 00000000 EBX: d19073c0 ECX: 00000000 EDX: 00000000
> > > > > [  541.002900] ESI: 0000000a EDI: 00000000 EBP: c7b63fb8 ESP: c7b63fb8
> > > > > [  541.003033]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > > > > [  541.003160] Process rcu_torture_wri (pid: 5292, ti=c7b63000 task=c7b09710 task.ti=c7b63000)
> > > > > [  541.003400] Stack:
> > > > > [  541.003497]  c7b63fd0 d19032c1 00000000 00000000 00000000 d1903200 c7b63fe0 c013d80a
> > > > > [  541.004022]  c013d7d0 00000000 00000000 c0103cf3 cef6ee70 00000000 00000000 00000000
> > > > > [  541.004022]  00000201 000004b4
> > > > > [  541.004022] Call Trace:
> > > > > [  541.004022]  [<c013d80a>] ? kthread+0x3a/0x70
> > > > > [  541.004022]  [<c013d7d0>] ? kthread+0x0/0x70
> > > > > [  541.004022]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> > > > > [  541.004022] Code:  Bad EIP value.
> > > > > [  541.004022] EIP: [<d1902efd>] 0xd1902efd SS:ESP 0068:c7b63fb8
> > > > > [  541.004022] ---[ end trace cb3b10c2bb94b4e3 ]---
> > > > > 
> > > > > 
> > > > > 00000e90 <rcu_stutter_wait>:
> > > > >      e90:	55                   	push   %ebp
> > > > >      e91:	89 e5                	mov    %esp,%ebp
> > > > >      e93:	90                   	nop    
> > > > >      e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
> > > > >      e98:	a1 98 00 00 00       	mov    0x98,%eax
> > > > >      e9d:	85 c0                	test   %eax,%eax
> > > > >      e9f:	75 09                	jne    eaa <rcu_stutter_wait+0x1a>
> > > > >      ea1:	a1 00 00 00 00       	mov    0x0,%eax
> > > > >      ea6:	85 c0                	test   %eax,%eax
> > > > >      ea8:	75 36                	jne    ee0 <rcu_stutter_wait+0x50>
> > > > >      eaa:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > > >      eaf:	85 c0                	test   %eax,%eax
> > > > >      eb1:	75 2d                	jne    ee0 <rcu_stutter_wait+0x50>
> > > > >      eb3:	8b 15 00 00 00 00    	mov    0x0,%edx
> > > > >      eb9:	85 d2                	test   %edx,%edx
> > > > >      ebb:	74 2b                	je     ee8 <rcu_stutter_wait+0x58>
> > > > >      ebd:	b8 01 00 00 00       	mov    $0x1,%eax
> > > > >      ec2:	e8 fc ff ff ff       	call   ec3 <rcu_stutter_wait+0x33>
> > > > >      ec7:	a1 98 00 00 00       	mov    0x98,%eax
> > > > >      ecc:	85 c0                	test   %eax,%eax
> > > > >      ece:	74 d1                	je     ea1 <rcu_stutter_wait+0x11>
> > > > >      ed0:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > > >      ed5:	85 c0                	test   %eax,%eax
> > > > >      ed7:	74 da                	je     eb3 <rcu_stutter_wait+0x23>
> > > > >      ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > > > >      ee0:	5d                   	pop    %ebp
> > > > >      ee1:	c3                   	ret    
> > > > >      ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > > > >      ee8:	b8 fa 00 00 00       	mov    $0xfa,%eax
> > > > >      eed:	e8 fc ff ff ff       	call   eee <rcu_stutter_wait+0x5e>
> > > > 
> > > > Here we are again calling one byte into the current instruction!!!
> > > > 
> > > > Or am I misinterpreting this code?
> > > > 
> > > > >      ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > > > >      ef8:	e8 fc ff ff ff       	call   ef9 <rcu_stutter_wait+0x69>
> > > > >      efd:	8d 76 00             	lea    0x0(%esi),%esi
> > > > > 			   ^------------- here
> > > > > 
> > > > > This one looks more like it can explain a page fault
> > > > 
> > > > I don't understand why there are indirections in the assembly given the
> > > > C code for rcu_stutter_wait().
> > > > 
> > > > >      f00:	eb 96                	jmp    e98 <rcu_stutter_wait+0x8>
> > > > >      f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > > > >      f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
> > > 
> > > ok, after trying to find out if the ubuntu gccs are broken, i stumbled
> > > upon this:
> > > http://forum.soft32.com/linux/Strange-problem-disassembling-shared-lib-ftopict439936.html
> > > 
> > > Seems the difference is that you dont compile it as a module and the
> > > jump is perfectly normal, it gets overwritten when the stuff is loaded
> > > objdump -dr gives me
> > > 
> > > 00000e90 <rcu_stutter_wait>:
> > >      e90:	55                   	push   %ebp
> > >      e91:	89 e5                	mov    %esp,%ebp
> > >      e93:	90                   	nop    
> > >      e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
> > >      e98:	a1 98 00 00 00       	mov    0x98,%eax
> > > 			e99: R_386_32	.bss
> > >      e9d:	85 c0                	test   %eax,%eax
> > >      e9f:	75 09                	jne    eaa <rcu_stutter_wait+0x1a>
> > >      ea1:	a1 00 00 00 00       	mov    0x0,%eax
> > > 			ea2: R_386_32	rcutorture_runnable
> > >      ea6:	85 c0                	test   %eax,%eax
> > >      ea8:	75 36                	jne    ee0 <rcu_stutter_wait+0x50>
> > >      eaa:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > 			eab: R_386_32	.bss
> > >      eaf:	85 c0                	test   %eax,%eax
> > >      eb1:	75 2d                	jne    ee0 <rcu_stutter_wait+0x50>
> > >      eb3:	8b 15 00 00 00 00    	mov    0x0,%edx
> > > 			eb5: R_386_32	rcutorture_runnable
> > >      eb9:	85 d2                	test   %edx,%edx
> > >      ebb:	74 2b                	je     ee8 <rcu_stutter_wait+0x58>
> > >      ebd:	b8 01 00 00 00       	mov    $0x1,%eax
> > >      ec2:	e8 fc ff ff ff       	call   ec3 <rcu_stutter_wait+0x33>
> > > 			ec3: R_386_PC32	schedule_timeout_interruptible
> > >      ec7:	a1 98 00 00 00       	mov    0x98,%eax
> > > 			ec8: R_386_32	.bss
> > >      ecc:	85 c0                	test   %eax,%eax
> > >      ece:	74 d1                	je     ea1 <rcu_stutter_wait+0x11>
> > >      ed0:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > 			ed1: R_386_32	.bss
> > >      ed5:	85 c0                	test   %eax,%eax
> > >      ed7:	74 da                	je     eb3 <rcu_stutter_wait+0x23>
> > >      ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > >      ee0:	5d                   	pop    %ebp
> > >      ee1:	c3                   	ret    
> > >      ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > >      ee8:	b8 fa 00 00 00       	mov    $0xfa,%eax
> > >      eed:	e8 fc ff ff ff       	call   eee <rcu_stutter_wait+0x5e>
> > > 			eee: R_386_PC32	round_jiffies_relative
> > >      ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > >      ef8:	e8 fc ff ff ff       	call   ef9 <rcu_stutter_wait+0x69>
> > > 			ef9: R_386_PC32	schedule_timeout_interruptible
> > >      efd:	8d 76 00             	lea    0x0(%esi),%esi
> > > 
> > > here is the deref ------------------------^
> > 
> > Ah!!!  We are getting a page fault while cleaning up the stack frame?
> > 
> > Ouch!
> > 
> > >      f00:	eb 96                	jmp    e98 <rcu_stutter_wait+0x8>
> > >      f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > >      f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
> 
> And now I can run this.  gcc v3.4.4 gives yet a different error:
> 
> divide error: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
> CPU 1 
> Modules linked in: [last unloaded: rcutorture]
> Pid: 3369, comm: rcu_torture_rea Not tainted 2.6.28-autokern1 #1
> RIP: 0010:[<ffffffffa0000142>]  [<ffffffffa0000142>] 0xffffffffa0000142
> RSP: 0000:ffff88007f0afeb0  EFLAGS: 00010246
> RAX: 00000000def36d6a RBX: ffffffffa0006850 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88007ecf1600 RDI: ffff88007f0afef0
> RBP: 0000000000000dd4 R08: ffff88007f0ae000 R09: ffffffff8037c7d9
> R10: 0000000000000000 R11: ffffffff8037c7d9 R12: 0000000000000000
> R13: 000000000000000a R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8800e3801c00(0000) knlGS:00000000f7f3ab80
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000080dc87c CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rcu_torture_rea (pid: 3369, threadinfo ffff88007f0ae000, task ffff88007ecf5d80)
> Stack:
>  ffffffff8037c7d9 ffffffffa000090d ffff88007ecfdec0 ffff88007ec17eb0
>  0000000000000001 ffffffffa00006e6 0000000000000000 ffff8800e3488000
>  c744ca136d6adef3 0000000000000256 0000000000000000 ffffffffa0000807
> Call Trace:
>  [<ffffffff8037c7d9>] ? delay_tsc+0x0/0x99
>  [<ffffffff80245b94>] ? kthread+0x3d/0x63
>  [<ffffffff8020c3ea>] ? child_rip+0xa/0x20
>  [<ffffffff80245b57>] ? kthread+0x0/0x63
>  [<ffffffff8020c3e0>] ? child_rip+0x0/0x20
> Code: 58 c3 56 bf 01 00 00 00 e8 88 bd 22 e0 59 31 c0 c3 41 51 e8 69 ff ff ff 48 63 15 0a 58 00 00 48 69 d2 90 01 00 00 48 89 d1 31 d2 <48> f7 f1 48 85 d2 75 0c 41 58 bf 78 1b 0d 00 e9 32 c7 37 e0 5f 
> RIP  [<ffffffffa0000142>] 0xffffffffa0000142
>  RSP <ffff88007f0afeb0>
> 
> I will see what I can find from this.

Hello, Eric,

Just for grins, I built the 2.6.28 kernel/rcutorture.c on b58602a.  It
insmoded and rmmoded without errors.

Could you please try this on your setup?  I have attached this file in
case that helps.

							Thanx, Paul

--FL5UXtIhxfXey3p5
Content-Type: text/x-csrc; charset=us-ascii
Content-Description: kernel/rcutorture.c
Content-Disposition: attachment; filename="rcutorture.c"

/*
 * Read-Copy Update module-based torture test facility
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2005, 2006
 *
 * Authors: Paul E. McKenney <paulmck@us.ibm.com>
 *          Josh Triplett <josh@freedesktop.org>
 *
 * See also:  Documentation/RCU/torture.txt
 */
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/err.h>
#include <linux/spinlock.h>
#include <linux/smp.h>
#include <linux/rcupdate.h>
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <asm/atomic.h>
#include <linux/bitops.h>
#include <linux/completion.h>
#include <linux/moduleparam.h>
#include <linux/percpu.h>
#include <linux/notifier.h>
#include <linux/freezer.h>
#include <linux/cpu.h>
#include <linux/delay.h>
#include <linux/stat.h>
#include <linux/srcu.h>
#include <linux/slab.h>
#include <asm/byteorder.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
              "Josh Triplett <josh@freedesktop.org>");

static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
static int nfakewriters = 4;	/* # fake writer threads */
static int stat_interval;	/* Interval between stats, in seconds. */
				/*  Defaults to "only at end of test". */
static int verbose;		/* Print more debug info. */
static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
static int stutter = 5;		/* Start/stop testing interval (in sec) */
static int irqreader = 1;	/* RCU readers from irq (timers). */
static char *torture_type = "rcu"; /* What RCU implementation to torture. */

module_param(nreaders, int, 0444);
MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
module_param(nfakewriters, int, 0444);
MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
module_param(stat_interval, int, 0444);
MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
module_param(verbose, bool, 0444);
MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
module_param(test_no_idle_hz, bool, 0444);
MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
module_param(shuffle_interval, int, 0444);
MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
module_param(stutter, int, 0444);
MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
module_param(irqreader, int, 0444);
MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
module_param(torture_type, charp, 0444);
MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");

#define TORTURE_FLAG "-torture:"
#define PRINTK_STRING(s) \
	do { printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
#define VERBOSE_PRINTK_STRING(s) \
	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
#define VERBOSE_PRINTK_ERRSTRING(s) \
	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)

static char printk_buf[4096];

static int nrealreaders;
static struct task_struct *writer_task;
static struct task_struct **fakewriter_tasks;
static struct task_struct **reader_tasks;
static struct task_struct *stats_task;
static struct task_struct *shuffler_task;
static struct task_struct *stutter_task;

#define RCU_TORTURE_PIPE_LEN 10

struct rcu_torture {
	struct rcu_head rtort_rcu;
	int rtort_pipe_count;
	struct list_head rtort_free;
	int rtort_mbtest;
};

static int fullstop = 0;	/* stop generating callbacks at test end. */
static LIST_HEAD(rcu_torture_freelist);
static struct rcu_torture *rcu_torture_current = NULL;
static long rcu_torture_current_version = 0;
static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
static DEFINE_SPINLOCK(rcu_torture_lock);
static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
	{ 0 };
static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_batch) =
	{ 0 };
static atomic_t rcu_torture_wcount[RCU_TORTURE_PIPE_LEN + 1];
static atomic_t n_rcu_torture_alloc;
static atomic_t n_rcu_torture_alloc_fail;
static atomic_t n_rcu_torture_free;
static atomic_t n_rcu_torture_mberror;
static atomic_t n_rcu_torture_error;
static long n_rcu_torture_timers = 0;
static struct list_head rcu_torture_removed;

static int stutter_pause_test = 0;

#if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
#define RCUTORTURE_RUNNABLE_INIT 1
#else
#define RCUTORTURE_RUNNABLE_INIT 0
#endif
int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;

/*
 * Allocate an element from the rcu_tortures pool.
 */
static struct rcu_torture *
rcu_torture_alloc(void)
{
	struct list_head *p;

	spin_lock_bh(&rcu_torture_lock);
	if (list_empty(&rcu_torture_freelist)) {
		atomic_inc(&n_rcu_torture_alloc_fail);
		spin_unlock_bh(&rcu_torture_lock);
		return NULL;
	}
	atomic_inc(&n_rcu_torture_alloc);
	p = rcu_torture_freelist.next;
	list_del_init(p);
	spin_unlock_bh(&rcu_torture_lock);
	return container_of(p, struct rcu_torture, rtort_free);
}

/*
 * Free an element to the rcu_tortures pool.
 */
static void
rcu_torture_free(struct rcu_torture *p)
{
	atomic_inc(&n_rcu_torture_free);
	spin_lock_bh(&rcu_torture_lock);
	list_add_tail(&p->rtort_free, &rcu_torture_freelist);
	spin_unlock_bh(&rcu_torture_lock);
}

struct rcu_random_state {
	unsigned long rrs_state;
	long rrs_count;
};

#define RCU_RANDOM_MULT 39916801  /* prime */
#define RCU_RANDOM_ADD	479001701 /* prime */
#define RCU_RANDOM_REFRESH 10000

#define DEFINE_RCU_RANDOM(name) struct rcu_random_state name = { 0, 0 }

/*
 * Crude but fast random-number generator.  Uses a linear congruential
 * generator, with occasional help from cpu_clock().
 */
static unsigned long
rcu_random(struct rcu_random_state *rrsp)
{
	if (--rrsp->rrs_count < 0) {
		rrsp->rrs_state +=
			(unsigned long)cpu_clock(raw_smp_processor_id());
		rrsp->rrs_count = RCU_RANDOM_REFRESH;
	}
	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
	return swahw32(rrsp->rrs_state);
}

static void
rcu_stutter_wait(void)
{
	while (stutter_pause_test || !rcutorture_runnable)
		if (rcutorture_runnable)
			schedule_timeout_interruptible(1);
		else
			schedule_timeout_interruptible(round_jiffies_relative(HZ));
}

/*
 * Operations vector for selecting different types of tests.
 */

struct rcu_torture_ops {
	void (*init)(void);
	void (*cleanup)(void);
	int (*readlock)(void);
	void (*readdelay)(struct rcu_random_state *rrsp);
	void (*readunlock)(int idx);
	int (*completed)(void);
	void (*deferredfree)(struct rcu_torture *p);
	void (*sync)(void);
	void (*cb_barrier)(void);
	int (*stats)(char *page);
	int irqcapable;
	char *name;
};
static struct rcu_torture_ops *cur_ops = NULL;

/*
 * Definitions for rcu torture testing.
 */

static int rcu_torture_read_lock(void) __acquires(RCU)
{
	rcu_read_lock();
	return 0;
}

static void rcu_read_delay(struct rcu_random_state *rrsp)
{
	long delay;
	const long longdelay = 200;

	/* We want there to be long-running readers, but not all the time. */

	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay);
	if (!delay)
		udelay(longdelay);
}

static void rcu_torture_read_unlock(int idx) __releases(RCU)
{
	rcu_read_unlock();
}

static int rcu_torture_completed(void)
{
	return rcu_batches_completed();
}

static void
rcu_torture_cb(struct rcu_head *p)
{
	int i;
	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);

	if (fullstop) {
		/* Test is ending, just drop callbacks on the floor. */
		/* The next initialization will pick up the pieces. */
		return;
	}
	i = rp->rtort_pipe_count;
	if (i > RCU_TORTURE_PIPE_LEN)
		i = RCU_TORTURE_PIPE_LEN;
	atomic_inc(&rcu_torture_wcount[i]);
	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
		rp->rtort_mbtest = 0;
		rcu_torture_free(rp);
	} else
		cur_ops->deferredfree(rp);
}

static void rcu_torture_deferred_free(struct rcu_torture *p)
{
	call_rcu(&p->rtort_rcu, rcu_torture_cb);
}

static struct rcu_torture_ops rcu_ops = {
	.init = NULL,
	.cleanup = NULL,
	.readlock = rcu_torture_read_lock,
	.readdelay = rcu_read_delay,
	.readunlock = rcu_torture_read_unlock,
	.completed = rcu_torture_completed,
	.deferredfree = rcu_torture_deferred_free,
	.sync = synchronize_rcu,
	.cb_barrier = rcu_barrier,
	.stats = NULL,
	.irqcapable = 1,
	.name = "rcu"
};

static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
{
	int i;
	struct rcu_torture *rp;
	struct rcu_torture *rp1;

	cur_ops->sync();
	list_add(&p->rtort_free, &rcu_torture_removed);
	list_for_each_entry_safe(rp, rp1, &rcu_torture_removed, rtort_free) {
		i = rp->rtort_pipe_count;
		if (i > RCU_TORTURE_PIPE_LEN)
			i = RCU_TORTURE_PIPE_LEN;
		atomic_inc(&rcu_torture_wcount[i]);
		if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
			rp->rtort_mbtest = 0;
			list_del(&rp->rtort_free);
			rcu_torture_free(rp);
		}
	}
}

static void rcu_sync_torture_init(void)
{
	INIT_LIST_HEAD(&rcu_torture_removed);
}

static struct rcu_torture_ops rcu_sync_ops = {
	.init = rcu_sync_torture_init,
	.cleanup = NULL,
	.readlock = rcu_torture_read_lock,
	.readdelay = rcu_read_delay,
	.readunlock = rcu_torture_read_unlock,
	.completed = rcu_torture_completed,
	.deferredfree = rcu_sync_torture_deferred_free,
	.sync = synchronize_rcu,
	.cb_barrier = NULL,
	.stats = NULL,
	.irqcapable = 1,
	.name = "rcu_sync"
};

/*
 * Definitions for rcu_bh torture testing.
 */

static int rcu_bh_torture_read_lock(void) __acquires(RCU_BH)
{
	rcu_read_lock_bh();
	return 0;
}

static void rcu_bh_torture_read_unlock(int idx) __releases(RCU_BH)
{
	rcu_read_unlock_bh();
}

static int rcu_bh_torture_completed(void)
{
	return rcu_batches_completed_bh();
}

static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
{
	call_rcu_bh(&p->rtort_rcu, rcu_torture_cb);
}

struct rcu_bh_torture_synchronize {
	struct rcu_head head;
	struct completion completion;
};

static void rcu_bh_torture_wakeme_after_cb(struct rcu_head *head)
{
	struct rcu_bh_torture_synchronize *rcu;

	rcu = container_of(head, struct rcu_bh_torture_synchronize, head);
	complete(&rcu->completion);
}

static void rcu_bh_torture_synchronize(void)
{
	struct rcu_bh_torture_synchronize rcu;

	init_completion(&rcu.completion);
	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
	wait_for_completion(&rcu.completion);
}

static struct rcu_torture_ops rcu_bh_ops = {
	.init = NULL,
	.cleanup = NULL,
	.readlock = rcu_bh_torture_read_lock,
	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
	.readunlock = rcu_bh_torture_read_unlock,
	.completed = rcu_bh_torture_completed,
	.deferredfree = rcu_bh_torture_deferred_free,
	.sync = rcu_bh_torture_synchronize,
	.cb_barrier = rcu_barrier_bh,
	.stats = NULL,
	.irqcapable = 1,
	.name = "rcu_bh"
};

static struct rcu_torture_ops rcu_bh_sync_ops = {
	.init = rcu_sync_torture_init,
	.cleanup = NULL,
	.readlock = rcu_bh_torture_read_lock,
	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
	.readunlock = rcu_bh_torture_read_unlock,
	.completed = rcu_bh_torture_completed,
	.deferredfree = rcu_sync_torture_deferred_free,
	.sync = rcu_bh_torture_synchronize,
	.cb_barrier = NULL,
	.stats = NULL,
	.irqcapable = 1,
	.name = "rcu_bh_sync"
};

/*
 * Definitions for srcu torture testing.
 */

static struct srcu_struct srcu_ctl;

static void srcu_torture_init(void)
{
	init_srcu_struct(&srcu_ctl);
	rcu_sync_torture_init();
}

static void srcu_torture_cleanup(void)
{
	synchronize_srcu(&srcu_ctl);
	cleanup_srcu_struct(&srcu_ctl);
}

static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
{
	return srcu_read_lock(&srcu_ctl);
}

static void srcu_read_delay(struct rcu_random_state *rrsp)
{
	long delay;
	const long uspertick = 1000000 / HZ;
	const long longdelay = 10;

	/* We want there to be long-running readers, but not all the time. */

	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
	if (!delay)
		schedule_timeout_interruptible(longdelay);
}

static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
{
	srcu_read_unlock(&srcu_ctl, idx);
}

static int srcu_torture_completed(void)
{
	return srcu_batches_completed(&srcu_ctl);
}

static void srcu_torture_synchronize(void)
{
	synchronize_srcu(&srcu_ctl);
}

static int srcu_torture_stats(char *page)
{
	int cnt = 0;
	int cpu;
	int idx = srcu_ctl.completed & 0x1;

	cnt += sprintf(&page[cnt], "%s%s per-CPU(idx=%d):",
		       torture_type, TORTURE_FLAG, idx);
	for_each_possible_cpu(cpu) {
		cnt += sprintf(&page[cnt], " %d(%d,%d)", cpu,
			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
	}
	cnt += sprintf(&page[cnt], "\n");
	return cnt;
}

static struct rcu_torture_ops srcu_ops = {
	.init = srcu_torture_init,
	.cleanup = srcu_torture_cleanup,
	.readlock = srcu_torture_read_lock,
	.readdelay = srcu_read_delay,
	.readunlock = srcu_torture_read_unlock,
	.completed = srcu_torture_completed,
	.deferredfree = rcu_sync_torture_deferred_free,
	.sync = srcu_torture_synchronize,
	.cb_barrier = NULL,
	.stats = srcu_torture_stats,
	.name = "srcu"
};

/*
 * Definitions for sched torture testing.
 */

static int sched_torture_read_lock(void)
{
	preempt_disable();
	return 0;
}

static void sched_torture_read_unlock(int idx)
{
	preempt_enable();
}

static int sched_torture_completed(void)
{
	return 0;
}

static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
{
	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
}

static void sched_torture_synchronize(void)
{
	synchronize_sched();
}

static struct rcu_torture_ops sched_ops = {
	.init = rcu_sync_torture_init,
	.cleanup = NULL,
	.readlock = sched_torture_read_lock,
	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
	.readunlock = sched_torture_read_unlock,
	.completed = sched_torture_completed,
	.deferredfree = rcu_sched_torture_deferred_free,
	.sync = sched_torture_synchronize,
	.cb_barrier = rcu_barrier_sched,
	.stats = NULL,
	.irqcapable = 1,
	.name = "sched"
};

static struct rcu_torture_ops sched_ops_sync = {
	.init = rcu_sync_torture_init,
	.cleanup = NULL,
	.readlock = sched_torture_read_lock,
	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
	.readunlock = sched_torture_read_unlock,
	.completed = sched_torture_completed,
	.deferredfree = rcu_sync_torture_deferred_free,
	.sync = sched_torture_synchronize,
	.cb_barrier = NULL,
	.stats = NULL,
	.name = "sched_sync"
};

/*
 * RCU torture writer kthread.  Repeatedly substitutes a new structure
 * for that pointed to by rcu_torture_current, freeing the old structure
 * after a series of grace periods (the "pipeline").
 */
static int
rcu_torture_writer(void *arg)
{
	int i;
	long oldbatch = rcu_batches_completed();
	struct rcu_torture *rp;
	struct rcu_torture *old_rp;
	static DEFINE_RCU_RANDOM(rand);

	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
	set_user_nice(current, 19);

	do {
		schedule_timeout_uninterruptible(1);
		if ((rp = rcu_torture_alloc()) == NULL)
			continue;
		rp->rtort_pipe_count = 0;
		udelay(rcu_random(&rand) & 0x3ff);
		old_rp = rcu_torture_current;
		rp->rtort_mbtest = 1;
		rcu_assign_pointer(rcu_torture_current, rp);
		smp_wmb();
		if (old_rp) {
			i = old_rp->rtort_pipe_count;
			if (i > RCU_TORTURE_PIPE_LEN)
				i = RCU_TORTURE_PIPE_LEN;
			atomic_inc(&rcu_torture_wcount[i]);
			old_rp->rtort_pipe_count++;
			cur_ops->deferredfree(old_rp);
		}
		rcu_torture_current_version++;
		oldbatch = cur_ops->completed();
		rcu_stutter_wait();
	} while (!kthread_should_stop() && !fullstop);
	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
	while (!kthread_should_stop())
		schedule_timeout_uninterruptible(1);
	return 0;
}

/*
 * RCU torture fake writer kthread.  Repeatedly calls sync, with a random
 * delay between calls.
 */
static int
rcu_torture_fakewriter(void *arg)
{
	DEFINE_RCU_RANDOM(rand);

	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
	set_user_nice(current, 19);

	do {
		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
		udelay(rcu_random(&rand) & 0x3ff);
		cur_ops->sync();
		rcu_stutter_wait();
	} while (!kthread_should_stop() && !fullstop);

	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
	while (!kthread_should_stop())
		schedule_timeout_uninterruptible(1);
	return 0;
}

/*
 * RCU torture reader from timer handler.  Dereferences rcu_torture_current,
 * incrementing the corresponding element of the pipeline array.  The
 * counter in the element should never be greater than 1, otherwise, the
 * RCU implementation is broken.
 */
static void rcu_torture_timer(unsigned long unused)
{
	int idx;
	int completed;
	static DEFINE_RCU_RANDOM(rand);
	static DEFINE_SPINLOCK(rand_lock);
	struct rcu_torture *p;
	int pipe_count;

	idx = cur_ops->readlock();
	completed = cur_ops->completed();
	p = rcu_dereference(rcu_torture_current);
	if (p == NULL) {
		/* Leave because rcu_torture_writer is not yet underway */
		cur_ops->readunlock(idx);
		return;
	}
	if (p->rtort_mbtest == 0)
		atomic_inc(&n_rcu_torture_mberror);
	spin_lock(&rand_lock);
	cur_ops->readdelay(&rand);
	n_rcu_torture_timers++;
	spin_unlock(&rand_lock);
	preempt_disable();
	pipe_count = p->rtort_pipe_count;
	if (pipe_count > RCU_TORTURE_PIPE_LEN) {
		/* Should not happen, but... */
		pipe_count = RCU_TORTURE_PIPE_LEN;
	}
	++__get_cpu_var(rcu_torture_count)[pipe_count];
	completed = cur_ops->completed() - completed;
	if (completed > RCU_TORTURE_PIPE_LEN) {
		/* Should not happen, but... */
		completed = RCU_TORTURE_PIPE_LEN;
	}
	++__get_cpu_var(rcu_torture_batch)[completed];
	preempt_enable();
	cur_ops->readunlock(idx);
}

/*
 * RCU torture reader kthread.  Repeatedly dereferences rcu_torture_current,
 * incrementing the corresponding element of the pipeline array.  The
 * counter in the element should never be greater than 1, otherwise, the
 * RCU implementation is broken.
 */
static int
rcu_torture_reader(void *arg)
{
	int completed;
	int idx;
	DEFINE_RCU_RANDOM(rand);
	struct rcu_torture *p;
	int pipe_count;
	struct timer_list t;

	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
	set_user_nice(current, 19);
	if (irqreader && cur_ops->irqcapable)
		setup_timer_on_stack(&t, rcu_torture_timer, 0);

	do {
		if (irqreader && cur_ops->irqcapable) {
			if (!timer_pending(&t))
				mod_timer(&t, 1);
		}
		idx = cur_ops->readlock();
		completed = cur_ops->completed();
		p = rcu_dereference(rcu_torture_current);
		if (p == NULL) {
			/* Wait for rcu_torture_writer to get underway */
			cur_ops->readunlock(idx);
			schedule_timeout_interruptible(HZ);
			continue;
		}
		if (p->rtort_mbtest == 0)
			atomic_inc(&n_rcu_torture_mberror);
		cur_ops->readdelay(&rand);
		preempt_disable();
		pipe_count = p->rtort_pipe_count;
		if (pipe_count > RCU_TORTURE_PIPE_LEN) {
			/* Should not happen, but... */
			pipe_count = RCU_TORTURE_PIPE_LEN;
		}
		++__get_cpu_var(rcu_torture_count)[pipe_count];
		completed = cur_ops->completed() - completed;
		if (completed > RCU_TORTURE_PIPE_LEN) {
			/* Should not happen, but... */
			completed = RCU_TORTURE_PIPE_LEN;
		}
		++__get_cpu_var(rcu_torture_batch)[completed];
		preempt_enable();
		cur_ops->readunlock(idx);
		schedule();
		rcu_stutter_wait();
	} while (!kthread_should_stop() && !fullstop);
	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
	if (irqreader && cur_ops->irqcapable)
		del_timer_sync(&t);
	while (!kthread_should_stop())
		schedule_timeout_uninterruptible(1);
	return 0;
}

/*
 * Create an RCU-torture statistics message in the specified buffer.
 */
static int
rcu_torture_printk(char *page)
{
	int cnt = 0;
	int cpu;
	int i;
	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
	long batchsummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };

	for_each_possible_cpu(cpu) {
		for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
			pipesummary[i] += per_cpu(rcu_torture_count, cpu)[i];
			batchsummary[i] += per_cpu(rcu_torture_batch, cpu)[i];
		}
	}
	for (i = RCU_TORTURE_PIPE_LEN - 1; i >= 0; i--) {
		if (pipesummary[i] != 0)
			break;
	}
	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
	cnt += sprintf(&page[cnt],
		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
		       "rtmbe: %d nt: %ld",
		       rcu_torture_current,
		       rcu_torture_current_version,
		       list_empty(&rcu_torture_freelist),
		       atomic_read(&n_rcu_torture_alloc),
		       atomic_read(&n_rcu_torture_alloc_fail),
		       atomic_read(&n_rcu_torture_free),
		       atomic_read(&n_rcu_torture_mberror),
		       n_rcu_torture_timers);
	if (atomic_read(&n_rcu_torture_mberror) != 0)
		cnt += sprintf(&page[cnt], " !!!");
	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
	if (i > 1) {
		cnt += sprintf(&page[cnt], "!!! ");
		atomic_inc(&n_rcu_torture_error);
		WARN_ON_ONCE(1);
	}
	cnt += sprintf(&page[cnt], "Reader Pipe: ");
	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
		cnt += sprintf(&page[cnt], " %ld", pipesummary[i]);
	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
	cnt += sprintf(&page[cnt], "Reader Batch: ");
	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
		cnt += sprintf(&page[cnt], " %ld", batchsummary[i]);
	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
	cnt += sprintf(&page[cnt], "Free-Block Circulation: ");
	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
		cnt += sprintf(&page[cnt], " %d",
			       atomic_read(&rcu_torture_wcount[i]));
	}
	cnt += sprintf(&page[cnt], "\n");
	if (cur_ops->stats)
		cnt += cur_ops->stats(&page[cnt]);
	return cnt;
}

/*
 * Print torture statistics.  Caller must ensure that there is only
 * one call to this function at a given time!!!  This is normally
 * accomplished by relying on the module system to only have one copy
 * of the module loaded, and then by giving the rcu_torture_stats
 * kthread full control (or the init/cleanup functions when rcu_torture_stats
 * thread is not running).
 */
static void
rcu_torture_stats_print(void)
{
	int cnt;

	cnt = rcu_torture_printk(printk_buf);
	printk(KERN_ALERT "%s", printk_buf);
}

/*
 * Periodically prints torture statistics, if periodic statistics printing
 * was specified via the stat_interval module parameter.
 *
 * No need to worry about fullstop here, since this one doesn't reference
 * volatile state or register callbacks.
 */
static int
rcu_torture_stats(void *arg)
{
	VERBOSE_PRINTK_STRING("rcu_torture_stats task started");
	do {
		schedule_timeout_interruptible(stat_interval * HZ);
		rcu_torture_stats_print();
	} while (!kthread_should_stop());
	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
	return 0;
}

static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */

/* Shuffle tasks such that we allow @rcu_idle_cpu to become idle. A special case
 * is when @rcu_idle_cpu = -1, when we allow the tasks to run on all CPUs.
 */
static void rcu_torture_shuffle_tasks(void)
{
	cpumask_t tmp_mask;
	int i;

	cpus_setall(tmp_mask);
	get_online_cpus();

	/* No point in shuffling if there is only one online CPU (ex: UP) */
	if (num_online_cpus() == 1) {
		put_online_cpus();
		return;
	}

	if (rcu_idle_cpu != -1)
		cpu_clear(rcu_idle_cpu, tmp_mask);

	set_cpus_allowed_ptr(current, &tmp_mask);

	if (reader_tasks) {
		for (i = 0; i < nrealreaders; i++)
			if (reader_tasks[i])
				set_cpus_allowed_ptr(reader_tasks[i],
						     &tmp_mask);
	}

	if (fakewriter_tasks) {
		for (i = 0; i < nfakewriters; i++)
			if (fakewriter_tasks[i])
				set_cpus_allowed_ptr(fakewriter_tasks[i],
						     &tmp_mask);
	}

	if (writer_task)
		set_cpus_allowed_ptr(writer_task, &tmp_mask);

	if (stats_task)
		set_cpus_allowed_ptr(stats_task, &tmp_mask);

	if (rcu_idle_cpu == -1)
		rcu_idle_cpu = num_online_cpus() - 1;
	else
		rcu_idle_cpu--;

	put_online_cpus();
}

/* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
 * system to become idle at a time and cut off its timer ticks. This is meant
 * to test the support for such tickless idle CPU in RCU.
 */
static int
rcu_torture_shuffle(void *arg)
{
	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task started");
	do {
		schedule_timeout_interruptible(shuffle_interval * HZ);
		rcu_torture_shuffle_tasks();
	} while (!kthread_should_stop());
	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
	return 0;
}

/* Cause the rcutorture test to "stutter", starting and stopping all
 * threads periodically.
 */
static int
rcu_torture_stutter(void *arg)
{
	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
	do {
		schedule_timeout_interruptible(stutter * HZ);
		stutter_pause_test = 1;
		if (!kthread_should_stop())
			schedule_timeout_interruptible(stutter * HZ);
		stutter_pause_test = 0;
	} while (!kthread_should_stop());
	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
	return 0;
}

static inline void
rcu_torture_print_module_parms(char *tag)
{
	printk(KERN_ALERT "%s" TORTURE_FLAG
		"--- %s: nreaders=%d nfakewriters=%d "
		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
		"shuffle_interval=%d stutter=%d irqreader=%d\n",
		torture_type, tag, nrealreaders, nfakewriters,
		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
		stutter, irqreader);
}

static void
rcu_torture_cleanup(void)
{
	int i;

	fullstop = 1;
	if (stutter_task) {
		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
		kthread_stop(stutter_task);
	}
	stutter_task = NULL;
	if (shuffler_task) {
		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
		kthread_stop(shuffler_task);
	}
	shuffler_task = NULL;

	if (writer_task) {
		VERBOSE_PRINTK_STRING("Stopping rcu_torture_writer task");
		kthread_stop(writer_task);
	}
	writer_task = NULL;

	if (reader_tasks) {
		for (i = 0; i < nrealreaders; i++) {
			if (reader_tasks[i]) {
				VERBOSE_PRINTK_STRING(
					"Stopping rcu_torture_reader task");
				kthread_stop(reader_tasks[i]);
			}
			reader_tasks[i] = NULL;
		}
		kfree(reader_tasks);
		reader_tasks = NULL;
	}
	rcu_torture_current = NULL;

	if (fakewriter_tasks) {
		for (i = 0; i < nfakewriters; i++) {
			if (fakewriter_tasks[i]) {
				VERBOSE_PRINTK_STRING(
					"Stopping rcu_torture_fakewriter task");
				kthread_stop(fakewriter_tasks[i]);
			}
			fakewriter_tasks[i] = NULL;
		}
		kfree(fakewriter_tasks);
		fakewriter_tasks = NULL;
	}

	if (stats_task) {
		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stats task");
		kthread_stop(stats_task);
	}
	stats_task = NULL;

	/* Wait for all RCU callbacks to fire.  */

	if (cur_ops->cb_barrier != NULL)
		cur_ops->cb_barrier();

	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */

	if (cur_ops->cleanup)
		cur_ops->cleanup();
	if (atomic_read(&n_rcu_torture_error))
		rcu_torture_print_module_parms("End of test: FAILURE");
	else
		rcu_torture_print_module_parms("End of test: SUCCESS");
}

static int __init
rcu_torture_init(void)
{
	int i;
	int cpu;
	int firsterr = 0;
	static struct rcu_torture_ops *torture_ops[] =
		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
		  &srcu_ops, &sched_ops, &sched_ops_sync, };

	/* Process args and tell the world that the torturer is on the job. */
	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
		cur_ops = torture_ops[i];
		if (strcmp(torture_type, cur_ops->name) == 0)
			break;
	}
	if (i == ARRAY_SIZE(torture_ops)) {
		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
		       torture_type);
		return (-EINVAL);
	}
	if (cur_ops->init)
		cur_ops->init(); /* no "goto unwind" prior to this point!!! */

	if (nreaders >= 0)
		nrealreaders = nreaders;
	else
		nrealreaders = 2 * num_online_cpus();
	rcu_torture_print_module_parms("Start of test");
	fullstop = 0;

	/* Set up the freelist. */

	INIT_LIST_HEAD(&rcu_torture_freelist);
	for (i = 0; i < ARRAY_SIZE(rcu_tortures); i++) {
		rcu_tortures[i].rtort_mbtest = 0;
		list_add_tail(&rcu_tortures[i].rtort_free,
			      &rcu_torture_freelist);
	}

	/* Initialize the statistics so that each run gets its own numbers. */

	rcu_torture_current = NULL;
	rcu_torture_current_version = 0;
	atomic_set(&n_rcu_torture_alloc, 0);
	atomic_set(&n_rcu_torture_alloc_fail, 0);
	atomic_set(&n_rcu_torture_free, 0);
	atomic_set(&n_rcu_torture_mberror, 0);
	atomic_set(&n_rcu_torture_error, 0);
	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
		atomic_set(&rcu_torture_wcount[i], 0);
	for_each_possible_cpu(cpu) {
		for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
			per_cpu(rcu_torture_count, cpu)[i] = 0;
			per_cpu(rcu_torture_batch, cpu)[i] = 0;
		}
	}

	/* Start up the kthreads. */

	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
	writer_task = kthread_run(rcu_torture_writer, NULL,
				  "rcu_torture_writer");
	if (IS_ERR(writer_task)) {
		firsterr = PTR_ERR(writer_task);
		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
		writer_task = NULL;
		goto unwind;
	}
	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
	                           GFP_KERNEL);
	if (fakewriter_tasks == NULL) {
		VERBOSE_PRINTK_ERRSTRING("out of memory");
		firsterr = -ENOMEM;
		goto unwind;
	}
	for (i = 0; i < nfakewriters; i++) {
		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
		                                  "rcu_torture_fakewriter");
		if (IS_ERR(fakewriter_tasks[i])) {
			firsterr = PTR_ERR(fakewriter_tasks[i]);
			VERBOSE_PRINTK_ERRSTRING("Failed to create fakewriter");
			fakewriter_tasks[i] = NULL;
			goto unwind;
		}
	}
	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
			       GFP_KERNEL);
	if (reader_tasks == NULL) {
		VERBOSE_PRINTK_ERRSTRING("out of memory");
		firsterr = -ENOMEM;
		goto unwind;
	}
	for (i = 0; i < nrealreaders; i++) {
		VERBOSE_PRINTK_STRING("Creating rcu_torture_reader task");
		reader_tasks[i] = kthread_run(rcu_torture_reader, NULL,
					      "rcu_torture_reader");
		if (IS_ERR(reader_tasks[i])) {
			firsterr = PTR_ERR(reader_tasks[i]);
			VERBOSE_PRINTK_ERRSTRING("Failed to create reader");
			reader_tasks[i] = NULL;
			goto unwind;
		}
	}
	if (stat_interval > 0) {
		VERBOSE_PRINTK_STRING("Creating rcu_torture_stats task");
		stats_task = kthread_run(rcu_torture_stats, NULL,
					"rcu_torture_stats");
		if (IS_ERR(stats_task)) {
			firsterr = PTR_ERR(stats_task);
			VERBOSE_PRINTK_ERRSTRING("Failed to create stats");
			stats_task = NULL;
			goto unwind;
		}
	}
	if (test_no_idle_hz) {
		rcu_idle_cpu = num_online_cpus() - 1;
		/* Create the shuffler thread */
		shuffler_task = kthread_run(rcu_torture_shuffle, NULL,
					  "rcu_torture_shuffle");
		if (IS_ERR(shuffler_task)) {
			firsterr = PTR_ERR(shuffler_task);
			VERBOSE_PRINTK_ERRSTRING("Failed to create shuffler");
			shuffler_task = NULL;
			goto unwind;
		}
	}
	if (stutter < 0)
		stutter = 0;
	if (stutter) {
		/* Create the stutter thread */
		stutter_task = kthread_run(rcu_torture_stutter, NULL,
					  "rcu_torture_stutter");
		if (IS_ERR(stutter_task)) {
			firsterr = PTR_ERR(stutter_task);
			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
			stutter_task = NULL;
			goto unwind;
		}
	}
	return 0;

unwind:
	rcu_torture_cleanup();
	return firsterr;
}

module_init(rcu_torture_init);
module_exit(rcu_torture_cleanup);

--FL5UXtIhxfXey3p5--
