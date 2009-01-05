Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZAETgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZAETgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZAETgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:36:05 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33746 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbZAETgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:36:04 -0500
Date: Mon, 5 Jan 2009 11:36:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090105193602.GL6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com> <20090104233855.GA17021@alice> <20090105022827.GA8080@linux.vnet.ibm.com> <20090105121409.GA5783@alice> <20090105180037.GH6959@linux.vnet.ibm.com> <20090105185655.GA11244@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105185655.GA11244@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 07:56:55PM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Jan 05, 2009 at 01:14:09PM +0100, Eric Sesterhenn wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > 
> > > Could the popular rcu function be registered by rcutorture, but when
> > > we remove the module the callback is no longer valid? I can compile
> > > a kernel just fine and with other stress tests i did not see any oops so
> > > far.
> > 
> > One approach would be to print out the address of rcutorture's RCU
> > callbacks at rcutorture module initialization time (in rcu_torture_init()
> > in kernel/rcutorture.c).  The two callbacks are rcu_torture_cb() and
> > rcu_bh_torture_wakeme_after_cb().  Unless you are specifying the 
> > "torture_type" parameter to rcutorture, only the first one should be in
> > use.
> 
> with a printk(KERN_ERR "rcu_torture_cb: %p rcu_bh_torture_wakeme_after_cb:
> %p\n", rcu_torture_cb, rcu_bh_torture_wakeme_after_cb);

Cool!

> [   65.135468] rcu_torture_cb: d0af7d1b rcu_bh_torture_wakeme_after_cb:
> d0af7bec
> [   65.135672] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
> stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
> irqreader=1
> [   71.171603] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   71.171954] IP: [<d0af7a0f>] 0xd0af7a0f
> [   71.192822] *pde = 00000000 
> [   71.196513] Oops: 0002 [#1] PREEMPT DEBUG_PAGEALLOC
> [   71.196826] last sysfs file: /sys/block/ram9/range
> [   71.197010] Modules linked in: [last unloaded: rcutorture]
> [   71.197010] 
> [   71.197010] Pid: 4861, comm: rcu_torture_wri Tainted: G        W
> (2.6.28-05716-gfe0bdec-dirty #171) System Name
> [   71.197010] EIP: 0060:[<d0af7a0f>] EFLAGS: 00010282 CPU: 0
> [   71.197010] EIP is at 0xd0af7a0f
> [   71.197010] EAX: 00000000 EBX: d0afbc20 ECX: c04f5cef EDX: c98abf7c
> [   71.197010] ESI: d0af7df0 EDI: 00000000 EBP: c98abfc4 ESP: c98abfc4
> [   71.197010]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [   71.197010] Process rcu_torture_wri (pid: 4861, ti=c98ab000
> task=c9890d00 task.ti=c98ab000)
> [   71.197010] Stack:
> [   71.197010]  c98abfd0 d0af7eeb 00000000 c98abfe0 c0137364 c0137326
> 00000000 00000000
> [   71.197010]  c0103643 c981fea4 00000000 00000000 00000000 00000000
> 00000000
> [   71.197010] Call Trace:
> [   71.197010]  [<c0137364>] ? kthread+0x3e/0x66
> [   71.197010]  [<c0137326>] ? kthread+0x0/0x66
> [   71.197010]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
> [   71.197010] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> [   71.197010] EIP: [<d0af7a0f>] 0xd0af7a0f SS:ESP 0068:c98abfc4
> [   71.301103] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> If i interpret this correctly, this corresponds to
> 
> 000009e8 <rcu_stutter_wait>:
>      9e8:       55                      push   %ebp
>      9e9:       89 e5                   mov    %esp,%ebp
>      9eb:       e8 fc ff ff ff          call   9ec <rcu_stutter_wait+0x4>

Wow!!!  Am I reading this correctly?  Does the above "call" instruction
-really- call one byte into itself?  That is what the hex for the x86
instruction -looks- like it is doing, but I cannot see what would have
possessed the compiler to generate this code.

When I compile on a 32-bit x86 machine, I don't see the above "call"
instruction.  Other than that, the code I see looks consistent.

>      9f0:       eb 1d                   jmp    a0f <rcu_stutter_wait+0x27>
>      9f2:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
>      9f9:       b8 01 00 00 00          mov    $0x1,%eax
>      9fe:       75 0a                   jne    a0a <rcu_stutter_wait+0x22>
>      a00:       b8 e8 03 00 00          mov    $0x3e8,%eax
>      a05:       e8 fc ff ff ff          call   a06 <rcu_stutter_wait+0x1e>
>      a0a:       e8 fc ff ff ff          call   a0b <rcu_stutter_wait+0x23>
>      a0f:       83 3d 6c 00 00 00 00    cmpl   $0x0,0x6c
> 			^---------- this line

This looks like the first test in the "while" loop.

>      a16:       75 09                   jne    a21 <rcu_stutter_wait+0x39>
>      a18:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
>      a1f:       75 09                   jne    a2a <rcu_stutter_wait+0x42>
>      a21:       83 3d 50 1a 00 00 00    cmpl   $0x0,0x1a50
>      a28:       74 c8                   je     9f2 <rcu_stutter_wait+0xa>
>      a2a:       5d                      pop    %ebp
>      a2b:       c3                      ret

The corresponding C code is as follows:

static void
rcu_stutter_wait(void)
{
	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
		if (rcutorture_runnable)
			schedule_timeout_interruptible(1);
		else
			schedule_timeout_interruptible(round_jiffies_relative(HZ));
	}
}

I don't see much opportunity for a page fault here...  This is the
binary I get when I compile it, though not as a module:

0000085a <rcu_stutter_wait>:
     85a:	55                   	push   %ebp
     85b:	89 e5                	mov    %esp,%ebp
     85d:	eb 1d                	jmp    87c <rcu_stutter_wait+0x22>
     85f:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
     866:	b8 01 00 00 00       	mov    $0x1,%eax
     86b:	75 0a                	jne    877 <rcu_stutter_wait+0x1d>
     86d:	b8 e8 03 00 00       	mov    $0x3e8,%eax
     872:	e8 fc ff ff ff       	call   873 <rcu_stutter_wait+0x19>
     877:	e8 fc ff ff ff       	call   878 <rcu_stutter_wait+0x1e>
     87c:	83 3d 14 00 00 00 00 	cmpl   $0x0,0x14
     883:	75 09                	jne    88e <rcu_stutter_wait+0x34>
     885:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0
     88c:	75 09                	jne    897 <rcu_stutter_wait+0x3d>
     88e:	83 3d 08 1a 00 00 00 	cmpl   $0x0,0x1a08
     895:	74 c8                	je     85f <rcu_stutter_wait+0x5>
     897:	5d                   	pop    %ebp
     898:	c3                   	ret    

I confess, I am confused!!!

							Thanx, Paul
