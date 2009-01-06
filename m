Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZAFHrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZAFHrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZAFHrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:47:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:37069 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750711AbZAFHrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:47:12 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19AZIAqQMhA4FfD9U+khO+Nkd9cZfYM6cBnY6g6pK
	fz5C4Li0SRmlqS
Date: Tue, 6 Jan 2009 08:47:07 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090106074707.GA5975@alice>
References: <20090105121409.GA5783@alice> <20090105180037.GH6959@linux.vnet.ibm.com> <20090105185655.GA11244@alice> <20090105193602.GL6959@linux.vnet.ibm.com> <20090105200012.GB11244@alice> <20090105201631.GO6959@linux.vnet.ibm.com> <20090105203153.GC11244@alice> <20090105221836.GT6959@linux.vnet.ibm.com> <20090106002912.GA21071@linux.vnet.ibm.com> <20090106021506.GA23052@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090106021506.GA23052@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 08:45:31 up 11 min,  7 users,  load average: 0.28, 0.35, 0.23
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Jan 05, 2009 at 04:29:12PM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 05, 2009 at 02:18:36PM -0800, Paul E. McKenney wrote:
> > > >      e98:	a1 98 00 00 00       	mov    0x98,%eax
> > > > 			e99: R_386_32	.bss
> > > >      e9d:	85 c0                	test   %eax,%eax
> > > >      e9f:	75 09                	jne    eaa <rcu_stutter_wait+0x1a>
> > > >      ea1:	a1 00 00 00 00       	mov    0x0,%eax
> > > > 			ea2: R_386_32	rcutorture_runnable
> > > >      ea6:	85 c0                	test   %eax,%eax
> > > >      ea8:	75 36                	jne    ee0 <rcu_stutter_wait+0x50>
> > > >      eaa:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > > 			eab: R_386_32	.bss
> > > >      eaf:	85 c0                	test   %eax,%eax
> > > >      eb1:	75 2d                	jne    ee0 <rcu_stutter_wait+0x50>
> > > >      eb3:	8b 15 00 00 00 00    	mov    0x0,%edx
> > > > 			eb5: R_386_32	rcutorture_runnable
> > > >      eb9:	85 d2                	test   %edx,%edx
> > > >      ebb:	74 2b                	je     ee8 <rcu_stutter_wait+0x58>
> > > >      ebd:	b8 01 00 00 00       	mov    $0x1,%eax
> > > >      ec2:	e8 fc ff ff ff       	call   ec3 <rcu_stutter_wait+0x33>
> > > > 			ec3: R_386_PC32	schedule_timeout_interruptible
> > > >      ec7:	a1 98 00 00 00       	mov    0x98,%eax
> > > > 			ec8: R_386_32	.bss
> > > >      ecc:	85 c0                	test   %eax,%eax
> > > >      ece:	74 d1                	je     ea1 <rcu_stutter_wait+0x11>
> > > >      ed0:	a1 88 1a 00 00       	mov    0x1a88,%eax
> > > > 			ed1: R_386_32	.bss
> > > >      ed5:	85 c0                	test   %eax,%eax
> > > >      ed7:	74 da                	je     eb3 <rcu_stutter_wait+0x23>
> > > >      ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > > >      ee0:	5d                   	pop    %ebp
> > > >      ee1:	c3                   	ret    
> > > >      ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > > >      ee8:	b8 fa 00 00 00       	mov    $0xfa,%eax
> > > >      eed:	e8 fc ff ff ff       	call   eee <rcu_stutter_wait+0x5e>
> > > > 			eee: R_386_PC32	round_jiffies_relative
> > > >      ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> > > >      ef8:	e8 fc ff ff ff       	call   ef9 <rcu_stutter_wait+0x69>
> > > > 			ef9: R_386_PC32	schedule_timeout_interruptible
> > > >      efd:	8d 76 00             	lea    0x0(%esi),%esi
> > > > 
> > > > here is the deref ------------------------^
> > > 
> > > Ah!!!  We are getting a page fault while cleaning up the stack frame?
> > > 
> > > Ouch!
> > > 
> > > >      f00:	eb 96                	jmp    e98 <rcu_stutter_wait+0x8>
> > > >      f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
> > > >      f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
> > 
> > And now I can run this.  gcc v3.4.4 gives yet a different error:
> > 
> > divide error: 0000 [#1] PREEMPT SMP 
> > last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
> > CPU 1 
> > Modules linked in: [last unloaded: rcutorture]
> > Pid: 3369, comm: rcu_torture_rea Not tainted 2.6.28-autokern1 #1
> > RIP: 0010:[<ffffffffa0000142>]  [<ffffffffa0000142>] 0xffffffffa0000142
> > RSP: 0000:ffff88007f0afeb0  EFLAGS: 00010246
> > RAX: 00000000def36d6a RBX: ffffffffa0006850 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffff88007ecf1600 RDI: ffff88007f0afef0
> > RBP: 0000000000000dd4 R08: ffff88007f0ae000 R09: ffffffff8037c7d9
> > R10: 0000000000000000 R11: ffffffff8037c7d9 R12: 0000000000000000
> > R13: 000000000000000a R14: 0000000000000000 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff8800e3801c00(0000) knlGS:00000000f7f3ab80
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00000000080dc87c CR3: 0000000000201000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process rcu_torture_rea (pid: 3369, threadinfo ffff88007f0ae000, task ffff88007ecf5d80)
> > Stack:
> >  ffffffff8037c7d9 ffffffffa000090d ffff88007ecfdec0 ffff88007ec17eb0
> >  0000000000000001 ffffffffa00006e6 0000000000000000 ffff8800e3488000
> >  c744ca136d6adef3 0000000000000256 0000000000000000 ffffffffa0000807
> > Call Trace:
> >  [<ffffffff8037c7d9>] ? delay_tsc+0x0/0x99
> >  [<ffffffff80245b94>] ? kthread+0x3d/0x63
> >  [<ffffffff8020c3ea>] ? child_rip+0xa/0x20
> >  [<ffffffff80245b57>] ? kthread+0x0/0x63
> >  [<ffffffff8020c3e0>] ? child_rip+0x0/0x20
> > Code: 58 c3 56 bf 01 00 00 00 e8 88 bd 22 e0 59 31 c0 c3 41 51 e8 69 ff ff ff 48 63 15 0a 58 00 00 48 69 d2 90 01 00 00 48 89 d1 31 d2 <48> f7 f1 48 85 d2 75 0c 41 58 bf 78 1b 0d 00 e9 32 c7 37 e0 5f 
> > RIP  [<ffffffffa0000142>] 0xffffffffa0000142
> >  RSP <ffff88007f0afeb0>
> > 
> > I will see what I can find from this.
> 
> Hello, Eric,
> 
> Just for grins, I built the 2.6.28 kernel/rcutorture.c on b58602a.  It
> insmoded and rmmoded without errors.
> 
> Could you please try this on your setup?  I have attached this file in
> case that helps.

works like a charm

Greetings, Eric
