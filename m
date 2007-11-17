Return-Path: <linux-kernel-owner+w=401wt.eu-S934414AbXKQA4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414AbXKQA4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 19:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762650AbXKQAz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 19:55:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53710 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXKQAz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:55:57 -0500
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
From: Jim Keniston <jkenisto@us.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
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
	 <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 16:54:51 -0800
Message-Id: <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It'd be helpful to see others (especially kprobes maintainers) chime in
on this.  In particular, if doing kmalloc/kfree of GFP_ATOMIC data at
kretprobe-hit time is OK, as in Abhishek's approach, then we could also
use GFP_ATOMIC (or at least GFP_NOWAIT) allocations to make up the
difference when we run low on kretprobe_instances.

More comments below.

On Fri, 2007-11-16 at 23:20 +0530, Abhishek Sagar wrote:
> On Nov 16, 2007 2:46 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
...
> 
> > > There are three problems in the "data pouch" approach, which is a
> > > generalized case of Srinivasa's timestamp case:
> > >
> > > 1. It bloats the size of each return instance to a run-time defined
> > > value. I'm certain that quite a few memory starved ARM kprobes users
> > > would certainly be wishing they could install more probes on their
> > > system without taking away too much from the precious memory pools
> > > which can impact their system performance. This is not a deal breaker
> > > though, just an annoyance.
> >
> > entry_info is, by default, a zero-length array, which adds nothing to
> > the size of a uretprobe_instance -- at least on the 3 architectures I've
> > tested on (i386, x86_64, powerpc).
> 
> Strange, because from what I could gather, the data pouch patch had
> the following in the kretprobe registration routine:
> 
> 
> for (i = 0; i < rp->maxactive; i++) {
> -		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
> +		inst = kmalloc((sizeof(struct kretprobe_instance)
> +				+ rp->entry_info_sz), GFP_KERNEL);
> 
> 
> rp->entry_info_sz is presumably the size of the private data structure
> of the registering module.

... which is zero for kretprobes that don't use the data pouch.

> This is the bloat I was referring to. But
> this difference should've showed up in your tests...?

What bloat?  On my 32-bit system, the pouch to hold struct prof_data in
your test_module example would be 20 bytes.  (For comparison,
sizeof(struct kretprobe_instance) = 28, btw.)  Except for functions like
schedule(), where a lot of tasks can be sleeping at the same time, an
rp->maxactive value of 5 or 10 is typically plenty.  That's 100-200
bytes of "bloat" spent at registration time (GFP_KERNEL), at least some
of which will be saved at probe-hit time (GFP_ATOMIC).  (And if somebody
says, "I always use a much higher value of rp->maxactive," then he/she's
probably not really worried about bloat.)

> 
> > >
> > > 2. Forces user entry/return handlers to use ri->entry_info (see
> > > Kevin's patch) even if their design only wanted such private data to
> > > be used in certain instances.
> >
> > No, it doesn't.  Providing a feature isn't the same as forcing people to
> > use the feature.
> 
> From the portion of the patch quoted above, it seems that there is
> private data allocation at registration time per-instance in one go.
> First of all, not all maxactive instances get used frequently. Even if
> they do, the fact that this private data would be used by the user
> handlers for a particular instance is also an assumption. So I guess
> it is better to leave allocation to the handlers and provide them with
> a data pointer in ri.

But as noted in my review of your sample module, hand-crafted, per-hit
allocation is more expensive both in terms of execution time and code
size/complexity.

> 
...
> > >
> > > 3. It's redundant. 'ri' can uniquely identify any entry-return handler
> > > pair. This itself solves your problem #2. It only moves the onus of
> > > private data allocation to user handlers.
> >
> > Having ri available at function entry time is definitely a win, but
> > maintaining separate data structures and using ri to map to the right
> > one is no trivial task.  
...
> 
> True, some kind of data pointer/pouch is essential.

Yes.  If the pouch idea is too weird, then the data pointer is a good
compromise.

With the above reservations, your enclosed patch looks OK.

You should provide a patch #2 that updates Documentation/kprobes.txt.
Maybe that will yield a little more review from other folks.

> 
> > I suggest you show us a probe module that captures data at function
> > entry and reports it upon return, exploiting your proposed patch.
> > Profiling would be a reasonable example, but something where multiple
> > values are captured might be more relevant.  (Your example below doesn't
> > count because it doesn't work.)  Then I'll code up the same example
> > using your enhancement + the data pouch enhancement, and we can compare.
> 
> I'll send a sample module which uses data pointer provided in ri in my
> next response.

Got it.  Thanks.  I've already commented.

Jim

> 
> > Of course, the data pouch enhancement would build nicely atop your
> > enhancement, so it could be proposed and considered separately.
> 
> Ok.
> 
> > >
> > > > Review of Abhishek's patch:
...
> Revising the patch with the suggested change:
> 
> ---
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> 
> diff -upNr linux-2.6.24-rc2/include/linux/kprobes.h
> linux-2.6.24-rc2_kp/include/linux/kprobes.h
> --- linux-2.6.24-rc2/include/linux/kprobes.h	2007-11-07 03:27:46.000000000 +0530
> +++ linux-2.6.24-rc2_kp/include/linux/kprobes.h	2007-11-16
> 22:50:24.000000000 +0530
> @@ -152,6 +152,7 @@ static inline int arch_trampoline_kprobe
>  struct kretprobe {
>  	struct kprobe kp;
>  	kretprobe_handler_t handler;
> +	kretprobe_handler_t entry_handler;
>  	int maxactive;
>  	int nmissed;
>  	struct hlist_head free_instances;
> @@ -164,6 +165,7 @@ struct kretprobe_instance {
>  	struct kretprobe *rp;
>  	kprobe_opcode_t *ret_addr;
>  	struct task_struct *task;
> +	void *data;
>  };
> 
>  struct kretprobe_blackpoint {
> diff -upNr linux-2.6.24-rc2/kernel/kprobes.c
> linux-2.6.24-rc2_kp/kernel/kprobes.c
> --- linux-2.6.24-rc2/kernel/kprobes.c	2007-11-07 03:27:46.000000000 +0530
> +++ linux-2.6.24-rc2_kp/kernel/kprobes.c	2007-11-16 22:53:46.000000000 +0530
> @@ -699,6 +699,14 @@ static int __kprobes pre_handler_kretpro
>  				 struct kretprobe_instance, uflist);
>  		ri->rp = rp;
>  		ri->task = current;
> +		ri->data = NULL;
> +
> +		if (rp->entry_handler) {
> +			if (rp->entry_handler(ri, regs)) {
> +				spin_unlock_irqrestore(&kretprobe_lock, flags);
> +				return 0; /* voluntary miss */
> +			}
> +		}
>  		arch_prepare_kretprobe(ri, regs);
> 
>  		/* XXX(hch): why is there no hlist_move_head? */

