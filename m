Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbXAXQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbXAXQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXAXQv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:51:57 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:57595 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbXAXQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:51:56 -0500
Date: Wed, 24 Jan 2007 11:51:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       ltt-dev@shafik.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Douglas Niehaus <niehaus@eecs.ku.edu>, systemtap@sources.redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: [PATCH 1/2] lockdep missing barrier()
Message-ID: <20070124165150.GC4979@Krystal>
References: <20061220235216.GA28643@Krystal> <OFAB3D8A6C.1643F2D3-ON80257262.000581E4-80257262.00088F04@uk.ibm.com> <20070116175624.GA16022@Krystal> <20070123202637.970e467b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070123202637.970e467b.akpm@osdl.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 09:50:18 up 154 days, 11:57,  4 users,  load average: 0.35, 0.41, 0.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@osdl.org) wrote:
> On Tue, 16 Jan 2007 12:56:24 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > This patch adds a barrier() to lockdep.c lockdep_recursion updates. This
> > variable behaves like the preemption count and should therefore use similar
> > memory barriers.
> > 
> > This patch applies on 2.6.20-rc4-git3.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -166,12 +166,14 @@ static struct list_head chainhash_table[CHAINHASH_SIZE];
> >  void lockdep_off(void)
> >  {
> >  	current->lockdep_recursion++;
> > +	barrier();
> >  }
> >  
> >  EXPORT_SYMBOL(lockdep_off);
> >  
> >  void lockdep_on(void)
> >  {
> > +	barrier();
> >  	current->lockdep_recursion--;
> >  }
> 
> I am allergic to undocumented barriers.  It is often unobvious what the
> barrier is supposed to protect against, yielding mystifying code.  This is
> one such case.
> 
> Please add code comments.

It looks like my fix was not the right one, but looking at the code in more
depth, another fix seems to be required. Summary : the order of locking in
vprintk() should be changed.


lockdep on/off used in : printk and nmi_enter/exit.

* In kernel/printk.c :

vprintk() does :

preempt_disable()
local_irq_save()
lockdep_off()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
lockdep_on()
local_irq_restore()
preempt_enable()

The goals here is to make sure we do not call printk() recursively from
kernel/lockdep.c:__lock_acquire() (called from spin_* and down/up) nor from
kernel/lockdep.c:trace_hardirqs_on/off() (called from local_irq_restore/save).
It can then potentially call printk() through mark_held_locks/mark_lock.

It correctly protects against the spin_lock call and the up/down call, but it
does not protect against local_irq_restore.

If we change the locking so it becomes correct :

preempt_disable()
lockdep_off()
local_irq_save()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
local_irq_restore()
lockdep_on()
preempt_enable()

Everything should be fine without a barrier(), because the
local_irq_save/restore will hopefully make sure the compiler won't reorder the
memory writes across cli()/sti() and the lockdep_recursion variable belongs to
the current task.



* In include/linux/hardirq.h:nmi_enter()/nmi_exit()

Used, for instance, in arch/i386/kernel/traps.c:do_nmi()
Calls nmi_enter : (notice : possibly no barrier between lockdep_off() and the
end of the nmi_enter() code with the "right" config options : preemption
disabled)
#define nmi_enter()             do { lockdep_off(); irq_enter(); } while (0)
#define irq_enter()                                     \
        do {                                            \
                account_system_vtime(current);          \
                add_preempt_count(HARDIRQ_OFFSET);      \
                trace_hardirq_enter();                  \
        } while (0)
# define add_preempt_count(val) do { preempt_count() += (val); } while (0)
# define trace_hardirq_enter()  do { current->hardirq_context++; } while (0)

Then calls, for instance, arch/i386/kernel/nmi.c:nmi_watchdog_tick(),
which takes a spinlock and may also call printk.

Because we are within a context where irqs are disabled and we use the
per-task lockdep_recursion only within the current task, there is no need to
make it appear ordered to other CPUs. Also, the compiler should not reorder the
lockdep_off() and the call to kernel/lockdep.c:__lock_acquire(), because they
both access the same variable : current->lockdep_recursion. So the NMI case
seems fine without a memory barrier.

Mathieu

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
