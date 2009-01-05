Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZAES5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZAES5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZAES5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:57:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:38473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752443AbZAES5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:57:07 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+31wNNVrC3N0xKatEWVZm6JUY8thb01TMq8LxReE
	D4jxHxm91Y3Ydb
Date: Mon, 5 Jan 2009 19:56:55 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090105185655.GA11244@alice>
References: <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com> <20090104233855.GA17021@alice> <20090105022827.GA8080@linux.vnet.ibm.com> <20090105121409.GA5783@alice> <20090105180037.GH6959@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090105180037.GH6959@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 19:46:49 up  9:43, 11 users,  load average: 0.20, 0.49, 0.39
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Jan 05, 2009 at 01:14:09PM +0100, Eric Sesterhenn wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > 
> > Could the popular rcu function be registered by rcutorture, but when
> > we remove the module the callback is no longer valid? I can compile
> > a kernel just fine and with other stress tests i did not see any oops so
> > far.
> 
> One approach would be to print out the address of rcutorture's RCU
> callbacks at rcutorture module initialization time (in rcu_torture_init()
> in kernel/rcutorture.c).  The two callbacks are rcu_torture_cb() and
> rcu_bh_torture_wakeme_after_cb().  Unless you are specifying the 
> "torture_type" parameter to rcutorture, only the first one should be in
> use.

with a printk(KERN_ERR "rcu_torture_cb: %p rcu_bh_torture_wakeme_after_cb:
%p\n", rcu_torture_cb, rcu_bh_torture_wakeme_after_cb);



[   65.135468] rcu_torture_cb: d0af7d1b rcu_bh_torture_wakeme_after_cb:
d0af7bec
[   65.135672] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
irqreader=1
[   71.171603] BUG: unable to handle kernel NULL pointer dereference at
(null)
[   71.171954] IP: [<d0af7a0f>] 0xd0af7a0f
[   71.192822] *pde = 00000000 
[   71.196513] Oops: 0002 [#1] PREEMPT DEBUG_PAGEALLOC
[   71.196826] last sysfs file: /sys/block/ram9/range
[   71.197010] Modules linked in: [last unloaded: rcutorture]
[   71.197010] 
[   71.197010] Pid: 4861, comm: rcu_torture_wri Tainted: G        W
(2.6.28-05716-gfe0bdec-dirty #171) System Name
[   71.197010] EIP: 0060:[<d0af7a0f>] EFLAGS: 00010282 CPU: 0
[   71.197010] EIP is at 0xd0af7a0f
[   71.197010] EAX: 00000000 EBX: d0afbc20 ECX: c04f5cef EDX: c98abf7c
[   71.197010] ESI: d0af7df0 EDI: 00000000 EBP: c98abfc4 ESP: c98abfc4
[   71.197010]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   71.197010] Process rcu_torture_wri (pid: 4861, ti=c98ab000
task=c9890d00 task.ti=c98ab000)
[   71.197010] Stack:
[   71.197010]  c98abfd0 d0af7eeb 00000000 c98abfe0 c0137364 c0137326
00000000 00000000
[   71.197010]  c0103643 c981fea4 00000000 00000000 00000000 00000000
00000000
[   71.197010] Call Trace:
[   71.197010]  [<c0137364>] ? kthread+0x3e/0x66
[   71.197010]  [<c0137326>] ? kthread+0x0/0x66
[   71.197010]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
[   71.197010] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
[   71.197010] EIP: [<d0af7a0f>] 0xd0af7a0f SS:ESP 0068:c98abfc4
[   71.301103] ---[ end trace 4eaa2a86a8e2da22 ]---

If i interpret this correctly, this corresponds to

000009e8 <rcu_stutter_wait>:
     9e8:       55                      push   %ebp
     9e9:       89 e5                   mov    %esp,%ebp
     9eb:       e8 fc ff ff ff          call   9ec <rcu_stutter_wait+0x4>
     9f0:       eb 1d                   jmp    a0f <rcu_stutter_wait+0x27>
     9f2:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
     9f9:       b8 01 00 00 00          mov    $0x1,%eax
     9fe:       75 0a                   jne    a0a <rcu_stutter_wait+0x22>
     a00:       b8 e8 03 00 00          mov    $0x3e8,%eax
     a05:       e8 fc ff ff ff          call   a06 <rcu_stutter_wait+0x1e>
     a0a:       e8 fc ff ff ff          call   a0b <rcu_stutter_wait+0x23>
     a0f:       83 3d 6c 00 00 00 00    cmpl   $0x0,0x6c
			^---------- this line
     a16:       75 09                   jne    a21 <rcu_stutter_wait+0x39>
     a18:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0
     a1f:       75 09                   jne    a2a <rcu_stutter_wait+0x42>
     a21:       83 3d 50 1a 00 00 00    cmpl   $0x0,0x1a50
     a28:       74 c8                   je     9f2 <rcu_stutter_wait+0xa>
     a2a:       5d                      pop    %ebp
     a2b:       c3                      ret

Greetings, Eric
