Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZAEUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZAEUc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZAEUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:32:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:48355 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751768AbZAEUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:32:16 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/OTNVYiZTOqHzj0Mq7D5+OTJii4LPXdyyGmz4VHj
	3QXuRtUyJkMtx0
Date: Mon, 5 Jan 2009 21:31:53 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090105203153.GC11244@alice>
References: <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com> <20090104233855.GA17021@alice> <20090105022827.GA8080@linux.vnet.ibm.com> <20090105121409.GA5783@alice> <20090105180037.GH6959@linux.vnet.ibm.com> <20090105185655.GA11244@alice> <20090105193602.GL6959@linux.vnet.ibm.com> <20090105200012.GB11244@alice> <20090105201631.GO6959@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090105201631.GO6959@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 21:28:32 up 11:25,  9 users,  load average: 1.15, 1.00, 0.63
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Jan 05, 2009 at 09:01:45PM +0100, Eric Sesterhenn wrote:
> > hi,
> > 
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Mon, Jan 05, 2009 at 07:56:55PM +0100, Eric Sesterhenn wrote:
> > > 
> > > Wow!!!  Am I reading this correctly?  Does the above "call" instruction
> > > -really- call one byte into itself?  That is what the hex for the x86
> > > instruction -looks- like it is doing, but I cannot see what would have
> > > possessed the compiler to generate this code.
> > 
> > Compiler is gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)
> 
> I am using 4.1.3, for whatever it is worth.  (Ancient, I know!)
> 
> > > When I compile on a 32-bit x86 machine, I don't see the above "call"
> > > instruction.  Other than that, the code I see looks consistent.
> > > 
> > > >      9f0:       eb 1d                   jmp    a0f <rcu_stutter_wait+0x27>
> > > >      9f2:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
> > > >      9f9:       b8 01 00 00 00          mov    $0x1,%eax
> > > >      9fe:       75 0a                   jne    a0a <rcu_stutter_wait+0x22>
> > > >      a00:       b8 e8 03 00 00          mov    $0x3e8,%eax
> > > >      a05:       e8 fc ff ff ff          call   a06 <rcu_stutter_wait+0x1e>
> > > >      a0a:       e8 fc ff ff ff          call   a0b <rcu_stutter_wait+0x23>
> > > >      a0f:       83 3d 6c 00 00 00 00    cmpl   $0x0,0x6c
> > > > 			^---------- this line
> > > 
> > > This looks like the first test in the "while" loop.
> > > 
> > > >      a16:       75 09                   jne    a21 <rcu_stutter_wait+0x39>
> > > >      a18:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
> > > >      a1f:       75 09                   jne    a2a <rcu_stutter_wait+0x42>
> > > >      a21:       83 3d 50 1a 00 00 00    cmpl   $0x0,0x1a50
> > > >      a28:       74 c8                   je     9f2 <rcu_stutter_wait+0xa>
> > > >      a2a:       5d                      pop    %ebp
> > > >      a2b:       c3                      ret
> > > 
> > > The corresponding C code is as follows:
> > > 
> > > static void
> > > rcu_stutter_wait(void)
> > > {
> > > 	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
> > > 		if (rcutorture_runnable)
> > > 			schedule_timeout_interruptible(1);
> > > 		else
> > > 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
> > > 	}
> > > }
> > > 
> > > I don't see much opportunity for a page fault here...  This is the
> > > binary I get when I compile it, though not as a module:
> > > 
> > > 0000085a <rcu_stutter_wait>:
> > >      85a:	55                   	push   %ebp
> > >      85b:	89 e5                	mov    %esp,%ebp
> > >      85d:	eb 1d                	jmp    87c <rcu_stutter_wait+0x22>
> > >      85f:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
> > >      866:	b8 01 00 00 00       	mov    $0x1,%eax
> > >      86b:	75 0a                	jne    877 <rcu_stutter_wait+0x1d>
> > >      86d:	b8 e8 03 00 00       	mov    $0x3e8,%eax
> > >      872:	e8 fc ff ff ff       	call   873 <rcu_stutter_wait+0x19>
> > >      877:	e8 fc ff ff ff       	call   878 <rcu_stutter_wait+0x1e>
> > >      87c:	83 3d 14 00 00 00 00 	cmpl   $0x0,0x14
> > >      883:	75 09                	jne    88e <rcu_stutter_wait+0x34>
> > >      885:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
> > >      88c:	75 09                	jne    897 <rcu_stutter_wait+0x3d>
> > >      88e:	83 3d 08 1a 00 00 00 	cmpl   $0x0,0x1a08
> > >      895:	74 c8                	je     85f <rcu_stutter_wait+0x5>
> > >      897:	5d                   	pop    %ebp
> > >      898:	c3                   	ret    
> > > 
> > > I confess, I am confused!!!
> > 
> > on the other box with a different gcc version
> > 
> > gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) 
> > 
> > d1902e90 is the start of rcu_stutter_wait
> > 
> > [  533.391719] d087e000 d1902e90
> > [  533.392294] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
> > [  541.000139] BUG: unable to handle kernel paging request at d1902efd
> > [  541.000423] IP: [<d1902efd>] 0xd1902efd
> > [  541.000660] *pde = 0f08f067 *pte = 00000000 
> > [  541.000867] Oops: 0000 [#1] DEBUG_PAGEALLOC
> > [  541.001126] last sysfs file: /sys/block/sda/size
> > [  541.001246] Modules linked in: nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> > [  541.002235] 
> > [  541.002334] Pid: 5292, comm: rcu_torture_wri Not tainted (2.6.28 #84) 
> > [  541.002470] EIP: 0060:[<d1902efd>] EFLAGS: 00010296 CPU: 0
> > [  541.002598] EIP is at 0xd1902efd
> > [  541.002767] EAX: 00000000 EBX: d19073c0 ECX: 00000000 EDX: 00000000
> > [  541.002900] ESI: 0000000a EDI: 00000000 EBP: c7b63fb8 ESP: c7b63fb8
> > [  541.003033]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > [  541.003160] Process rcu_torture_wri (pid: 5292, ti=c7b63000 task=c7b09710 task.ti=c7b63000)
> > [  541.003400] Stack:
> > [  541.003497]  c7b63fd0 d19032c1 00000000 00000000 00000000 d1903200 c7b63fe0 c013d80a
> > [  541.004022]  c013d7d0 00000000 00000000 c0103cf3 cef6ee70 00000000 00000000 00000000
> > [  541.004022]  00000201 000004b4
> > [  541.004022] Call Trace:
> > [  541.004022]  [<c013d80a>] ? kthread+0x3a/0x70
> > [  541.004022]  [<c013d7d0>] ? kthread+0x0/0x70
> > [  541.004022]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> > [  541.004022] Code:  Bad EIP value.
> > [  541.004022] EIP: [<d1902efd>] 0xd1902efd SS:ESP 0068:c7b63fb8
> > [  541.004022] ---[ end trace cb3b10c2bb94b4e3 ]---
> > 
> > 
> > 00000e90 <rcu_stutter_wait>:
> >      e90:	55                   	push   %ebp
> >      e91:	89 e5                	mov    %esp,%ebp
> >      e93:	90                   	nop    
> >      e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
> >      e98:	a1 98 00 00 00       	mov    0x98,%eax
> >      e9d:	85 c0                	test   %eax,%eax
> >      e9f:	75 09                	jne    eaa <rcu_stutter_wait+0x1a>
> >      ea1:	a1 00 00 00 00       	mov    0x0,%eax
> >      ea6:	85 c0                	test   %eax,%eax
> >      ea8:	75 36                	jne    ee0 <rcu_stutter_wait+0x50>
> >      eaa:	a1 88 1a 00 00       	mov    0x1a88,%eax
> >      eaf:	85 c0                	test   %eax,%eax
> >      eb1:	75 2d                	jne    ee0 <rcu_stutter_wait+0x50>
> >      eb3:	8b 15 00 00 00 00    	mov    0x0,%edx
> >      eb9:	85 d2                	test   %edx,%edx
> >      ebb:	74 2b                	je     ee8 <rcu_stutter_wait+0x58>
> >      ebd:	b8 01 00 00 00       	mov    $0x1,%eax
> >      ec2:	e8 fc ff ff ff       	call   ec3 <rcu_stutter_wait+0x33>
> >      ec7:	a1 98 00 00 00       	mov    0x98,%eax
> >      ecc:	85 c0                	test   %eax,%eax
> >      ece:	74 d1                	je     ea1 <rcu_stutter_wait+0x11>
> >      ed0:	a1 88 1a 00 00       	mov    0x1a88,%eax
> >      ed5:	85 c0                	test   %eax,%eax
> >      ed7:	74 da                	je     eb3 <rcu_stutter_wait+0x23>
> >      ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> >      ee0:	5d                   	pop    %ebp
> >      ee1:	c3                   	ret    
> >      ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> >      ee8:	b8 fa 00 00 00       	mov    $0xfa,%eax
> >      eed:	e8 fc ff ff ff       	call   eee <rcu_stutter_wait+0x5e>
> 
> Here we are again calling one byte into the current instruction!!!
> 
> Or am I misinterpreting this code?
> 
> >      ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> >      ef8:	e8 fc ff ff ff       	call   ef9 <rcu_stutter_wait+0x69>
> >      efd:	8d 76 00             	lea    0x0(%esi),%esi
> > 			   ^------------- here
> > 
> > This one looks more like it can explain a page fault
> 
> I don't understand why there are indirections in the assembly given the
> C code for rcu_stutter_wait().
> 
> >      f00:	eb 96                	jmp    e98 <rcu_stutter_wait+0x8>
> >      f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> >      f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

ok, after trying to find out if the ubuntu gccs are broken, i stumbled
upon this:
http://forum.soft32.com/linux/Strange-problem-disassembling-shared-lib-ftopict439936.html

Seems the difference is that you dont compile it as a module and the
jump is perfectly normal, it gets overwritten when the stuff is loaded
objdump -dr gives me

00000e90 <rcu_stutter_wait>:
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	90                   	nop    
     e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e98:	a1 98 00 00 00       	mov    0x98,%eax
			e99: R_386_32	.bss
     e9d:	85 c0                	test   %eax,%eax
     e9f:	75 09                	jne    eaa <rcu_stutter_wait+0x1a>
     ea1:	a1 00 00 00 00       	mov    0x0,%eax
			ea2: R_386_32	rcutorture_runnable
     ea6:	85 c0                	test   %eax,%eax
     ea8:	75 36                	jne    ee0 <rcu_stutter_wait+0x50>
     eaa:	a1 88 1a 00 00       	mov    0x1a88,%eax
			eab: R_386_32	.bss
     eaf:	85 c0                	test   %eax,%eax
     eb1:	75 2d                	jne    ee0 <rcu_stutter_wait+0x50>
     eb3:	8b 15 00 00 00 00    	mov    0x0,%edx
			eb5: R_386_32	rcutorture_runnable
     eb9:	85 d2                	test   %edx,%edx
     ebb:	74 2b                	je     ee8 <rcu_stutter_wait+0x58>
     ebd:	b8 01 00 00 00       	mov    $0x1,%eax
     ec2:	e8 fc ff ff ff       	call   ec3 <rcu_stutter_wait+0x33>
			ec3: R_386_PC32	schedule_timeout_interruptible
     ec7:	a1 98 00 00 00       	mov    0x98,%eax
			ec8: R_386_32	.bss
     ecc:	85 c0                	test   %eax,%eax
     ece:	74 d1                	je     ea1 <rcu_stutter_wait+0x11>
     ed0:	a1 88 1a 00 00       	mov    0x1a88,%eax
			ed1: R_386_32	.bss
     ed5:	85 c0                	test   %eax,%eax
     ed7:	74 da                	je     eb3 <rcu_stutter_wait+0x23>
     ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ee0:	5d                   	pop    %ebp
     ee1:	c3                   	ret    
     ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ee8:	b8 fa 00 00 00       	mov    $0xfa,%eax
     eed:	e8 fc ff ff ff       	call   eee <rcu_stutter_wait+0x5e>
			eee: R_386_PC32	round_jiffies_relative
     ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ef8:	e8 fc ff ff ff       	call   ef9 <rcu_stutter_wait+0x69>
			ef9: R_386_PC32	schedule_timeout_interruptible
     efd:	8d 76 00             	lea    0x0(%esi),%esi

here is the deref ------------------------^

     f00:	eb 96                	jmp    e98 <rcu_stutter_wait+0x8>
     f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

