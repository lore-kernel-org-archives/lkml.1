Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZKILtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZKILtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZKILtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:49:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZKILtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:49:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 12:50:31 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091250.31626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For the last couple of days I've been trying to debug resume problems on
Toshiba Portege R500 that seem to be to a leakage of preempt_count in the
"events" thread.

To start with, more-or-less since 2.6.32-rc4 I've been observing a
resume-from-hibernation issue causing the box to hang solid, apparently during
the final switch from a VT to X (it ends up with the X cursor in the black
background).  Initially I thought it was related to the graphics driver (i915),
but I didn't use KMS on this box and the non-KMS suspend-resume handling
hasn't really changed in there since 2.6.31.

However, after 2.6.32-rc6 I started to observe similar symptoms during resume
from suspend to RAM.  Then, I thought it was a separate issue and tried to
narrow it down.  I thought it might be related to the VGA framebuffer, so I
started to boot with vga=0 and it turned out that it apparently was a NULL
pointer dereference in worker_thread() of the "events" thread (with the
graphics framebuffer the box just hanged with the X cursor in the black
backgroung, sometimes it managed to display the windows and then hanged).

I'm saying "apparently", because I've never been able to see the entire oops
message.  I only saw a call trace pointing to autoremove_wake_function() and
saying that RIP was somewhere in worker_thread(), so I used gdb to find the
code this address corresponded to and it turned out to be the first instruction
of __list_del().  This, in turn, appeared to mean that the list_del_init() in
run_workqueue(), which was inlined, hit the NULL pointer and that seemed quite
strange to me.

Nevertheless, I started to search for commits that might have caused this
to happen and I first found out that the problem was not reproducible without
commit 9905d1b411946fb3fb228e8c6529fd94afda8a92 (PM / yenta: Split resume into
early and late parts (rev. 4)) from myself, but this commit didn't do anything
that might result in the observed behavior.  Moreover, it didn't cause any
problems to happen when applied on top of 2.6.31.5 on the very same box with
a very similar .config.  So, I thought that the commit just made the issue more
likely to happen and I started to use it as a "trigger" in further debugging.

Next, I started to look for kernel versions in which I was able to reproduce
the problem and I found that it was already present in 2.6.32-rc1 (or
2.6.32-rc2), so apparently it had to be introduced during the merge window.
So, I thought I'd carry out a bisection of the merge window commits and
I verified that the problem was not reproducible with the kernel where
commit 5d1fe0c98f2aef99fb57aaf6dd25e793c186cea3 was the head
(approximately in the middle of the merge window).  However, in the next
step of bisection, in which commit c720f5655df159a630fa0290a0bd67c93e92b0bf was
the head, I got the following call trace:

[ 2016.865041] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/29920                                                                                         
[ 2016.865344] caller is vmstat_update+0x13/0x48                                          
[ 2016.865522] Pid: 29920, comm: events/1 Not tainted 2.6.31-tst #158                     
[ 2016.865700] Call Trace:                                                                
[ 2016.865877]  [<ffffffff811608e8>] debug_smp_processor_id+0xc4/0xd4                     
[ 2016.866052]  [<ffffffff810a9ae1>] vmstat_update+0x13/0x48                              
[ 2016.866232]  [<ffffffff81051ee6>] worker_thread+0x18b/0x22a                            
[ 2016.866409]  [<ffffffff810a9ace>] ? vmstat_update+0x0/0x48                             
[ 2016.866578]  [<ffffffff810556a5>] ? autoremove_wake_function+0x0/0x38                  
[ 2016.866749]  [<ffffffff81288803>] ? _spin_unlock_irqrestore+0x35/0x37                  
[ 2016.866935]  [<ffffffff81051d5b>] ? worker_thread+0x0/0x22a                            
[ 2016.867113]  [<ffffffff8105547d>] kthread+0x69/0x71                                    
[ 2016.867278]  [<ffffffff8100c1aa>] child_rip+0xa/0x20                                   
[ 2016.867450]  [<ffffffff81055414>] ? kthread+0x0/0x71                                   
[ 2016.867618]  [<ffffffff8100c1a0>] ? child_rip+0x0/0x20                                 
[ 2016.867781] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/29920                                                                                         
[ 2016.868077] caller is vmstat_update+0x2e/0x48                                          
[ 2016.868239] Pid: 29920, comm: events/1 Not tainted 2.6.31-tst #158                     
[ 2016.868406] Call Trace:                                                                
[ 2016.868576]  [<ffffffff811608e8>] debug_smp_processor_id+0xc4/0xd4                     
[ 2016.868756]  [<ffffffff810a9afc>] vmstat_update+0x2e/0x48                              
[ 2016.868938]  [<ffffffff81051ee6>] worker_thread+0x18b/0x22a                            
[ 2016.869121]  [<ffffffff810a9ace>] ? vmstat_update+0x0/0x48                             
[ 2016.869292]  [<ffffffff810556a5>] ? autoremove_wake_function+0x0/0x38                  
[ 2016.869466]  [<ffffffff81288803>] ? _spin_unlock_irqrestore+0x35/0x37                  
[ 2016.869635]  [<ffffffff81051d5b>] ? worker_thread+0x0/0x22a                            
[ 2016.869808]  [<ffffffff8105547d>] kthread+0x69/0x71                                    
[ 2016.869979]  [<ffffffff8100c1aa>] child_rip+0xa/0x20                                   
[ 2016.870149]  [<ffffffff81055414>] ? kthread+0x0/0x71                                   
[ 2016.870317]  [<ffffffff8100c1a0>] ? child_rip+0x0/0x20

where, according to gdb, worker_thread+0x18b corresponded to the

if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {

condition in run_workqueue().  That didn't kill the box, but I wonder if the
leakage of preempt_count may lead to the solid hang observed before.

I also am not sure if I should mark this commit as "bad" or "good" in the
bisection process.

Please advise.

Rafael
