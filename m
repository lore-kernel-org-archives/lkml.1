Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbXKPRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbXKPRu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbXKPRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:50:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:63350 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbXKPRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:50:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d5QiF2n9eXzkgFDSabMP1T3hnIo5LhXuQ9wAK9zz8k+EnwQb9ZVJthLB4HF1k2EVVaV4+4ROoo5yYK9kme2CYm83hnWhvN5/H4KGdsxo41IAkoXeA9paH7/c/k2rnhdF3DYdbocKTNVdL50yWq/lIfBfegHWAZuaIchh7nrn6E0=
Message-ID: <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
Date: Fri, 16 Nov 2007 23:20:09 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195161370.3804.96.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150516w6ee27172j159deaad06d0e5e8@mail.gmail.com>
	 <1195161370.3804.96.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 2:46 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> > > Lacking a solution to #1a, I think Abhishek's approach provides a
> > > reasonable solution to problem #1.
> >
> > If you're not convinced that problem #1 isn't appropriately handled,
>
> I don't know where you got that idea.  Reread my last sentence above.
>
> My concern is that your patch fixes one symptom (number of function
> returns reported < number of function entries reported), but not the
> root cause (we can fail to report some function returns).  If fixing one
> symptom is the best we can do, then I have no real objection to that.
>
> Of course, we need to keep in mind that you're adding an externally
> visible feature that would need to be maintained, so it demands more
> scrutiny than a simple bug fix.

Agreed.

> > There are three problems in the "data pouch" approach, which is a
> > generalized case of Srinivasa's timestamp case:
> >
> > 1. It bloats the size of each return instance to a run-time defined
> > value. I'm certain that quite a few memory starved ARM kprobes users
> > would certainly be wishing they could install more probes on their
> > system without taking away too much from the precious memory pools
> > which can impact their system performance. This is not a deal breaker
> > though, just an annoyance.
>
> entry_info is, by default, a zero-length array, which adds nothing to
> the size of a uretprobe_instance -- at least on the 3 architectures I've
> tested on (i386, x86_64, powerpc).

Strange, because from what I could gather, the data pouch patch had
the following in the kretprobe registration routine:


for (i = 0; i < rp->maxactive; i++) {
-		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
+		inst = kmalloc((sizeof(struct kretprobe_instance)
+				+ rp->entry_info_sz), GFP_KERNEL);


rp->entry_info_sz is presumably the size of the private data structure
of the registering module. This is the bloat I was referring to. But
this difference should've showed up in your tests...?

> >
> > 2. Forces user entry/return handlers to use ri->entry_info (see
> > Kevin's patch) even if their design only wanted such private data to
> > be used in certain instances.
>
> No, it doesn't.  Providing a feature isn't the same as forcing people to
> use the feature.

>From the portion of the patch quoted above, it seems that there is
private data allocation at registration time per-instance in one go.
First of all, not all maxactive instances get used frequently. Even if
they do, the fact that this private data would be used by the user
handlers for a particular instance is also an assumption. So I guess
it is better to leave allocation to the handlers and provide them with
a data pointer in ri.

> > Therefore ideally, any per-instance data
> > allocation should be left to user entry handlers, IMO. Even if we
> > allow a pouch for private data in a return instance, the user handlers
> > would still need be aware of "return instances" to actually use them
> > globally.
> >
> > 3. It's redundant. 'ri' can uniquely identify any entry-return handler
> > pair. This itself solves your problem #2. It only moves the onus of
> > private data allocation to user handlers.
>
> Having ri available at function entry time is definitely a win, but
> maintaining separate data structures and using ri to map to the right
> one is no trivial task.  (It's a lot easier if you pre-allocate the
> maximum number of data structures you'll need -- presumably matching
> rp->maxactive -- but then you have at least the same amount of "bloat"
> as with the data pouch approach.)

True, some kind of data pointer/pouch is essential.

> I suggest you show us a probe module that captures data at function
> entry and reports it upon return, exploiting your proposed patch.
> Profiling would be a reasonable example, but something where multiple
> values are captured might be more relevant.  (Your example below doesn't
> count because it doesn't work.)  Then I'll code up the same example
> using your enhancement + the data pouch enhancement, and we can compare.

I'll send a sample module which uses data pointer provided in ri in my
next response.

> Of course, the data pouch enhancement would build nicely atop your
> enhancement, so it could be proposed and considered separately.

Ok.

> >
> > > Review of Abhishek's patch:
> > >
> > > I see no reason to save a copy of *regs and pass that to the entry
> > > handler.  Passing the real regs pointer is good enough for other kprobe
> > > handlers.
> >
> > No, a copy is required because if the entry_handler() returns error (a
> > voluntary miss), then there has to be a way to roll-back all the
> > changes that arch_prepare_kretprobe() and entry_handler() made to
> > *regs. Such an instance is considered "aborted".
>
> No.  Handlers shouldn't be writing to the pt_regs struct unless they
> want to change the operation of the probed code.  If an entry handler
> scribbles on *regs and then decides to "abort", it's up to that handler
> to restore the contents of *regs.  It's that way with all kprobe and
> kretprobe handlers, and the proposed entry handler is no different, as
> far as I can see.

I had the copy mainly to undo the effect of arch_prepare_kretprobe()
on regs if entry_handler decided to abort. But I think it didn't serve
that purpose as well since arch_prepare_kretprobe() ends up modifying
the stack on x86. So I've gotten rid of the copy now. The
entry_handler now gets called before arch_prepare_kretprobe() and
therefore shouldn't expect to use ri->ret_addr. In effect the
entry_handler is an early decision maker on whether the return
instance setup should even take place for current function hit or not.

> > Wouldn't the return addresses be different for recursive/nested calls?
>
> Not for recursive calls.  Think about it.  Or write a little program
> that calls a recursive function like factorial(), and have factorial()
> report the value of __builtin_return_address(0) each time it's called.

Oh yea got it...I was stuck with the nested call case and forgot about
direct recursion :)

> > > > The fact that ri is passed to both handlers should allow any user
> > > > handler to identify each of these cases and take appropriate
> > > > synchronization action pertaining to its private data, if needed.
> > >
> > > I don't think Abhishek has made his case here.  See below.
> > >
> > > >
> > > > > (Hence I feel sol a) would be nice).
> > > >
> > > > With an entry-handler, any module aiming to profile running time of a
> > > > function (say) can simply do the following without being "return
> > > > instance" conscious. Note however that I'm not trying to address just
> > > > this scenario but trying to provide a general way to use
> > > > entry-handlers in kretprobes:
> > > >
> > > > static unsigned  long flag = 0; /* use bit 0 as a global flag */
> > > > unsigned long long entry, exit;
> > > >
> > > > int my_entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> > > > {
> > > >     if (!test_and_set_bit(0, &flag))
> > > >     /* this instance claims the first entry to kretprobe'd function */
> > > >         entry = sched_clock();
> > > >         /* do other stuff */
> > > >         return 0; /* right on! */
> > > >     }
> > > >     return 1; /* error: no return instance to be allocated for this
> > > > function entry */
> > > > }
> > > >
> > > > /* will only be called iff flag == 1 */
> > > > int my_return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> > > > {
> > > >     BUG_ON(!flag);
> > > >     exit = sched_clock();
> > > >     set_bit(0, &flag);
> > > > }
> > > >
> > > > I think something like this should do the trick for you.
> > >
> > > Since flag is static, it seems to me that if there were instances of the
> > > probed function active concurrently in multiple tasks, only the
> > > first-called instance would be  profiled.
> >
> > Oh that's right, or we could use a per-cpu flag which would restrict
> > us to only one profiling instance per processor.
>
> If the probed function can sleep, then it could return on a different
> CPU; a per-cpu flag wouldn't work in such cases.

Hmmm...since disabling preemption from entry_handler won't work, a
more practical approach would be to associate all return instances to
tasks. I'll try to come up with an example to exploit the per-task
return instance associativity.

> >
> > > Jim Keniston
> >
> > --
> > Thanks & Regards
> > Abhishek Sagar
> >
> > ---
> > Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> >
> > diff -upNr linux-2.6.24-rc2/include/linux/kprobes.h
> > linux-2.6.24-rc2_kp/include/linux/kprobes.h
> > --- linux-2.6.24-rc2/include/linux/kprobes.h  2007-11-07 03:27:46.000000000 +0530
> > +++ linux-2.6.24-rc2_kp/include/linux/kprobes.h       2007-11-15
> > 15:49:39.000000000 +0530
> > @@ -152,6 +152,7 @@ static inline int arch_trampoline_kprobe
> >  struct kretprobe {
> >       struct kprobe kp;
> >       kretprobe_handler_t handler;
> > +     kretprobe_handler_t entry_handler;
> >       int maxactive;
> >       int nmissed;
> >       struct hlist_head free_instances;
> > diff -upNr linux-2.6.24-rc2/kernel/kprobes.c
> > linux-2.6.24-rc2_kp/kernel/kprobes.c
> > --- linux-2.6.24-rc2/kernel/kprobes.c 2007-11-07 03:27:46.000000000 +0530
> > +++ linux-2.6.24-rc2_kp/kernel/kprobes.c      2007-11-15 16:00:57.000000000 +0530
> > @@ -694,12 +694,24 @@ static int __kprobes pre_handler_kretpro
> >       spin_lock_irqsave(&kretprobe_lock, flags);
> >       if (!hlist_empty(&rp->free_instances)) {
> >               struct kretprobe_instance *ri;
> > +             struct pt_regs copy;
>
> NAK.  Saving and restoring regs is expensive and inconsistent with
> existing kprobes usage.

Revising the patch with the suggested change:

---
Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

diff -upNr linux-2.6.24-rc2/include/linux/kprobes.h
linux-2.6.24-rc2_kp/include/linux/kprobes.h
--- linux-2.6.24-rc2/include/linux/kprobes.h	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/include/linux/kprobes.h	2007-11-16
22:50:24.000000000 +0530
@@ -152,6 +152,7 @@ static inline int arch_trampoline_kprobe
 struct kretprobe {
 	struct kprobe kp;
 	kretprobe_handler_t handler;
+	kretprobe_handler_t entry_handler;
 	int maxactive;
 	int nmissed;
 	struct hlist_head free_instances;
@@ -164,6 +165,7 @@ struct kretprobe_instance {
 	struct kretprobe *rp;
 	kprobe_opcode_t *ret_addr;
 	struct task_struct *task;
+	void *data;
 };

 struct kretprobe_blackpoint {
diff -upNr linux-2.6.24-rc2/kernel/kprobes.c
linux-2.6.24-rc2_kp/kernel/kprobes.c
--- linux-2.6.24-rc2/kernel/kprobes.c	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/kernel/kprobes.c	2007-11-16 22:53:46.000000000 +0530
@@ -699,6 +699,14 @@ static int __kprobes pre_handler_kretpro
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
+		ri->data = NULL;
+
+		if (rp->entry_handler) {
+			if (rp->entry_handler(ri, regs)) {
+				spin_unlock_irqrestore(&kretprobe_lock, flags);
+				return 0; /* voluntary miss */
+			}
+		}
 		arch_prepare_kretprobe(ri, regs);

 		/* XXX(hch): why is there no hlist_move_head? */
