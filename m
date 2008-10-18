Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbYJROE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbYJROE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYJROEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:04:48 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63289 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYJROEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:04:47 -0400
To: paulmck@linux.vnet.ibm.com, serue@us.ibm.com
Cc: sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20081015012916.GF6874@linux.vnet.ibm.com>
	<48F6BD8E.4050402@nttdata.co.jp>
	<20081016151003.GA6772@linux.vnet.ibm.com>
	<48F84DAB.4060002@nttdata.co.jp>
	<20081017145630.GC6706@linux.vnet.ibm.com>
In-Reply-To: <20081017145630.GC6706@linux.vnet.ibm.com>
Message-Id: <200810182304.JDC12476.JFSHLVMOQFtOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 18 Oct 2008 23:04:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> On Fri, Oct 17, 2008 at 05:32:43PM +0900, Kentaro Takeda wrote:
> > However, to ensure the reader gets up-to-date value, we need to use 
> > smp_read_barrier_depends() (which is expanded to "mb()" for SMP on 
> > Alpha, "read_barrier_depends()" for SMP on H8300, "((void)0)" for SMP 
> > on M68K-nommu, "((void)0)" for M68K, "do { } while (0)" otherwise) 
> > whenever the reader fetches an element in a list.
> 
> Yep.  You will also need the ACCESS_ONCE() on the pointer fetch in order
> to suppress aggressive compiler optimizations.  The rcu_dereference()
> primitive packages them up nicely.

So, I should use rcu_dereference() rather than smp_read_barrier_depends().
I see.

> > > But fair enough.  How about the following?
> > > 
> > >         #define worm_dereference()        rcu_dereference()
> > >         #define worm_assign_pointer()        rcu_assign_pointer()
> > > 
> > So, I understood that the rcu_dereference() and rcu_assign_pointer() 
> > are not only for RCU. They are needed to ensure the reader gets 
> > up-to-date value. Then, their names should be var_dereference() and 
> > var_assign_pointer() or something, shouldn't they? The "rcu_" prefix 
> > and comments on rcu_dereference in include/linux/rcupdate.h sound for 
> > me that they are used for variables protected by RCU locking 
> > mechanism only...
> 
> Well, there are 200+ uses of rcu_dereference() for RCU, so it would
> 99.5%+ accurate to retain the "rcu_" prefix.  ;-)
> 
> Once we have several non-RCU uses, we can probably do a much better
> job of coming up with a good name for the underlying independent-of-RCU
> primitive.  So we should stick with rcu_dereference() as the name of the
> underlying primitive for now, and re-evaluate the naming in a year or
> after another five non-RCU uses of rcu_dereference() appear, whichever
> comes later.  (My current guess for names are "pointer_subscribe()"
> for rcu_dereference() and "pointer_publish()" for rcu_assign_pointer(),
> but who knows?)
> 
> Fair enough?

Agreed.

> TOMOYO can tolerate reading the complete garbage that would appear if
> the pointer was assigned before the pointed-to fields are initialized?
> I must confess that I am having a hard time believing that.  Please
> explain how this works.

Maybe I'm misunderstanding what "mb()" can do.

I inserted "mb()" between the initialization of the pointed-to field and
the assignment of the pointer like

  static inline void list1_add_tail_mb(struct list1_head *new,
                                       struct list1_head *head)
  {
          struct list1_head *pos = head;
  
          new->next = head;
          mb(); /* Avoid out-of-order execution. */
          while (pos->next != head)
                  pos = pos->next;
          pos->next = new;
  }

to ensure that 'new->next' comes to point to 'head' before 'pos->next' comes to
point to 'new', for arch/ia64/include/asm/system.h says:

  /*
   * Macros to force memory ordering.  In these descriptions, "previous"
   * and "subsequent" refer to program order; "visible" means that all
   * architecturally visible effects of a memory access have occurred
   * (at a minimum, this means the memory has been read or written).
   *
   *   wmb():     Guarantees that all preceding stores to memory-
   *              like regions are visible before any subsequent
   *              stores and that all following stores will be
   *              visible only after all previous stores.
   *   rmb():     Like wmb(), but for reads.
   *   mb():      wmb()/rmb() combo, i.e., all previous memory
   *              accesses are visible before all subsequent
   *              accesses and vice versa.  This is also known as
   *              a "fence."
   *
   * Note: "mb()" and its variants cannot be used as a fence to order
   * accesses to memory mapped I/O registers.  For that, mf.a needs to
   * be used.  However, we don't want to always use mf.a because (a)
   * it's (presumably) much slower than mf and (b) mf.a is supported for
   * sequential memory pages only.
   */

But http://www.rdrop.com/users/paulmck/scalability/paper/ordering.2007.09.19a.pdf says:

  On these systems, there are three orderings that must be accounted for:
  1. Program order:
     the order of the program's object code as seen by the CPU
  2. Execution order:
     The execution order can differ from program order due to both compiler and
     CPU implementation optimizations.
  3. Perceived order:

And I noticed that the comment in arch/ia64/include/asm/system.h uses
"program order", not "execution order".
Therefore, I have to also care "execution order".

I assumed that the "program order" == "execution order" and I thought:

  The reader will read the appended element (i.e. 'new->next') only if
  the reader can reach (i.e. 'pos->next' == 'new') the appended element.
  The reader won't read the appended element (i.e. 'new->next') as long as
  the reader can't reach (i.e. 'pos->next' == 'head') the appended element.

However, since "execution order" != "program order", you are mentioning that
I have to call smp_read_barrier_depends() which can control "execution order".
Am I right?

Regards.
