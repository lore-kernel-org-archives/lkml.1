Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZHWIF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZHWIF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 04:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZHWIF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 04:05:57 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40720 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbZHWIFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 04:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TyuMZlwrLiKGi/itaE3Pyw4qocRB1LGd27EphwuKBQTEXl8Wo2kunCygRKhiJ/HGP1
         TWN/8xZ0OgPgZm7FZiUs1f1Z3gSYYYE3SUkrTXgg+EzYBC5S2Lvvf3F+QLPhjKP0kqqp
         KYWN/z+t23MgZv4PJAbx2fnjb3wQHxs0LTtdU=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       andrew motron <akpm@osdl.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251012621.14003.71.camel@marge.simson.net>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net>  <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 14:05:57 +0300
Message-Id: <1251025557.3810.65.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-08-23 at 09:30 +0200, Mike Galbraith wrote:
> On Sun, 2009-08-23 at 12:09 +0300, raz ben yehuda wrote:
> > On Sun, 2009-08-23 at 07:21 +0200, Mike Galbraith wrote:
> 
> > > Seems to me this boils down to a different way to make a SW box in a HW
> > > box, which already exists.  What does this provide that  partitioning a
> > > box with csets and virtualization doesn't?
> > OFFSCHED does not compete with cpu sets nor virtualization.it is
> > different.
> > 
> > 1. Neither virtuallization nor cpu sets provide hard real time. OFFSCHED
> > does this with a little cost and no impact on the OS.OFFSCHED is not
> > just accurate , it is also extremely fast,after all, it is NMI'ed
> > processor.
> 
> Why not?  Why can't I run an RT kernel with an RTOS guest and let it do
> it's deadline management thing?
Have you ever tested how long a single context switch cost ? can you run
this system with a 1us accuracy ? you cannot.try ftrac'ing your system.
the interrupt alone costs several hundreds nano seconds. By the time you
will be reaching your code, the deadline will be nearly gone.  
> > 2. OFFSCHED has a access to every piece of memory in the system. so it
> > can act as a centry for the system, or use linux facilities. Also, the
> > kernel can access OFFSCHED memory, it is the same address space.
> 
> Hm.  That appears to be a self negating argument.
correct. but I can receive packets over napi and transmit packets over hard_start_xmit
much faster than any guest OS. I can disable interrupts and move to poll
mode, thus helping the operating system. can a guest OS help linux?  
> > 3. OFFSCHED can improve the linux OS ( NAPI,OFFSCHED firewall,RTOP ),
> > while a guest OS cannot.
> > 
> > 4. cpu sets cannot replace softirqs and hardirqs. OFFSCHED can. cpu sets
> > deals with kernel threads and user space threads. in OFFSCHED we use
> > offlets.
> 
> Which still looks like OS-fu to me.
I do not understand this remark.
> > 5. cpu sets and  virtualization are services provided by the kernel to
> > the "system".who serves the kernel ? who protects the kernel ?
> 
> If either one can diddle the others ram, they are in no way isolated or
> protected, so can't even defend against their own bugs.
correct. but the same applies for a hosting OS. as you said , it is a
self negating argument. what if your system is attacked by a RT task
that saturate all cpu time, you will not even be able to know what is
wrong with your system. in OFFSCHED-RTOP I show that even when attacked
by a malicious task, I still can see the problem because I can access
the task list and dump it to a remote machine. It is even possible to
"kill it" with the offlet-server ( still need to write the killing
thing ).
> What protects a hard RT deadline from VM pressure, memory bandwidth
> consumption etc etc?  Looks to me like it's soft RT, because you can't
> control the external variables.
what does protect guest OS from the host ? also, In one of my
applications I wrote my own pre-allocation system, OFFSCHED used only
its own pools. so VM was never a problem and it is a true hard real time
system. as for memory bandwidth pressure OFFSCHED is not protected from.
But if you design your application to use small footprint, you will be
able to stay in the processor cache. when you have a kernel thread, lazy
TLB is not always promised. Can you say your RT task will never be
preempted ?  
And again, if RTAI or anything of the like has facilities for this kind
of problems, OFFSCHED can use them as well.
> > 6. offlets gives the programmer full control over an entire processor.
> > no preemption, no interrupts, no quiesce. you know what happens , and
> > when it happens.
> 
> If I can route interrupts such that only say network interrupts are
> delivered to my cset/vm core, and the guest OS is a custom high speed
> low drag application, I just don't see much difference.
There are other tasks a system must walk through , for example, a
processor must walk through a quiesce state, which means you cannot have
your real time thread running forever without loosing processor from
time to time. and how would you prevent RCU starvation ? what about
IPI ? 
> > I have this hard real time system several years on my SMP/MC/SMT
> > machines. It serves me well. The core of OFFSCHED patch was 4 lines.
> > So,i simply compile a ***entirely regular*** linux bzImage and that's
> > it. It did not mess with drivers, spinlocks, softirqs ..., OFFSCHED just
> > directed the cpu_down to my own hard real time piece of code. The rest
> > of the kernel remained the same.
> 
> Aaaaanyway, I'm not saying it's not a useful thing to do, just saying I
> don't see any reason you can't get essentially the same result with
> what's in the kernel now.
I thank you for your interest.
> 	-Mike
> 

