Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXKONQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXKONQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXKONQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:16:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:36518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbXKONQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XTXti9kKTzN8WLBwAkXh/ZnqTb/IBXq/CTrUxoom1mVRYqaKYRdIdG8chGelxCzsyELhanxTReRzTiS04/S+uMZT7Gjk1dzYlHmKna57Zk/wTeYE4meVZwPLT7Dab0PDq19U6NIuA31/diU7nN77hXXdaORT2EQY3cAWgI+l6cA=
Message-ID: <863e9df20711150516w6ee27172j159deaad06d0e5e8@mail.gmail.com>
Date: Thu, 15 Nov 2007 18:46:07 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 4:21 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> On Wed, 2007-11-14 at 19:00 +0530, Abhishek Sagar wrote:
>
> First of all, some general comments.  We seem to be trying to solve two
> problems here:
> 1. Prevent the asymmetry in entry- vs. return-handler calls that can
> develop when we temporarily run out of kretprobe_instances.  E.g., if we
> have m kretprobe "misses", we may report n calls but only (n-m) returns.

That has already been taken care of. The entry-handler is called iff
'hlist_empty(&rp->free_instances)' is false. Additionally, if
entry_handler() returns an error then the corresponding return handler
is also not called because that particular "return instance" is
aborted/voluntarily-missed. Hence the following guarantee is implied:

No. of return handler calls = No. of entry_handler calls which
returned 0 (success).

The number of failed entry_handler calls doesn't update any kind of
ri->voluntary_nmissed count since the user handlers are internally
aware of them (unlike ri->nmissed).

> 2. Simplify the task of correlating data (e.g., timestamps) between
> function entry and function return.

Right. Srinivasa and you have been hinting at the use of per-instance
private data for the same. I think ri should be enough.

> Problem #1 wouldn't exist if we could solve problem #1a:
> 1a. Ensure that we never run out of kretprobe_instances (for some
> appropriate value of "never").
>
> I've thought of various approaches to #1a -- e.g., allocate
> kretprobe_instances from GFP_ATOMIC memory when we're out of
> preallocated instances -- but I've never found time to pursue them.
> This might be a good time to brainstorm solutions to that problem.
>
> Lacking a solution to #1a, I think Abhishek's approach provides a
> reasonable solution to problem #1.

If you're not convinced that problem #1 isn't appropriately handled,
we should look for something like that I guess.

> I don't think it takes us very far toward solving #2, though.  I agree
> with Srinivasa that it would be more helpful if we could store the data
> collected at function-entry time right in the kretprobe_instance. Kevin
> Stafford prototyped this "data pouch" idea a couple of years ago --
> http://sourceware.org/ml/systemtap/2005-q3/msg00593.html
> -- but an analogous feature was implemented at a higher level in
> SystemTap.  Either approach -- in kprobes or SystemTap -- would benefit
> from a fix to #1 (or #1a).

There are three problems in the "data pouch" approach, which is a
generalized case of Srinivasa's timestamp case:

1. It bloats the size of each return instance to a run-time defined
value. I'm certain that quite a few memory starved ARM kprobes users
would certainly be wishing they could install more probes on their
system without taking away too much from the precious memory pools
which can impact their system performance. This is not a deal breaker
though, just an annoyance.

2. Forces user entry/return handlers to use ri->entry_info (see
Kevin's patch) even if their design only wanted such private data to
be used in certain instances. Therefore ideally, any per-instance data
allocation should be left to user entry handlers, IMO. Even if we
allow a pouch for private data in a return instance, the user handlers
would still need be aware of "return instances" to actually use them
globally.

3. It's redundant. 'ri' can uniquely identify any entry-return handler
pair. This itself solves your problem #2. It only moves the onus of
private data allocation to user handlers.

> Review of Abhishek's patch:
>
> I see no reason to save a copy of *regs and pass that to the entry
> handler.  Passing the real regs pointer is good enough for other kprobe
> handlers.

No, a copy is required because if the entry_handler() returns error (a
voluntary miss), then there has to be a way to roll-back all the
changes that arch_prepare_kretprobe() and entry_handler() made to
*regs. Such an instance is considered "aborted".

> And if a handler on i386 uses &regs->esp as the value of the
> stack pointer (which is correct -- long story), it'll get the wrong
> value if its regs arg points at the copy.

That's a catch! I've made the fix (see inlined patch below). It now
passes regs instead of &copy to both the entry_handler() and
arch_prepare_kretprobe().

> More comments below.
[snip]
> > 1. Multiple function entries from various tasks (the one you've just
> > pointed out).
> > 2. Multiple kretprobe registration on the same function.
> > 3. Nested calls of kretprobe'd function.
> >
> > In cases 1 and 3, the following information can be used to match
> > corresponding entry and return handlers inside a user handler (if
> > needed):
> >
> > (ri->task, ri->ret_addr)
> > where ri is struct kretprobe_instance *
> >
> > This tuple should uniquely identify a return address (right?).
>
> But if it's a recursive function, there could be multiple instances in
> the same task with the same return address.  The stack pointer would be
> different, FWIW.

Wouldn't the return addresses be different for recursive/nested calls?
I think the only case where the return addresses would be same is when
multiple return probes are installed on the same function.

> > The fact that ri is passed to both handlers should allow any user
> > handler to identify each of these cases and take appropriate
> > synchronization action pertaining to its private data, if needed.
>
> I don't think Abhishek has made his case here.  See below.
>
> >
> > > (Hence I feel sol a) would be nice).
> >
> > With an entry-handler, any module aiming to profile running time of a
> > function (say) can simply do the following without being "return
> > instance" conscious. Note however that I'm not trying to address just
> > this scenario but trying to provide a general way to use
> > entry-handlers in kretprobes:
> >
> > static unsigned  long flag = 0; /* use bit 0 as a global flag */
> > unsigned long long entry, exit;
> >
> > int my_entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> > {
> >     if (!test_and_set_bit(0, &flag))
> >     /* this instance claims the first entry to kretprobe'd function */
> >         entry = sched_clock();
> >         /* do other stuff */
> >         return 0; /* right on! */
> >     }
> >     return 1; /* error: no return instance to be allocated for this
> > function entry */
> > }
> >
> > /* will only be called iff flag == 1 */
> > int my_return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> > {
> >     BUG_ON(!flag);
> >     exit = sched_clock();
> >     set_bit(0, &flag);
> > }
> >
> > I think something like this should do the trick for you.
>
> Since flag is static, it seems to me that if there were instances of the
> probed function active concurrently in multiple tasks, only the
> first-called instance would be  profiled.

Oh that's right, or we could use a per-cpu flag which would restrict
us to only one profiling instance per processor.

> Jim Keniston

--
Thanks & Regards
Abhishek Sagar

---
Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

diff -upNr linux-2.6.24-rc2/include/linux/kprobes.h
linux-2.6.24-rc2_kp/include/linux/kprobes.h
--- linux-2.6.24-rc2/include/linux/kprobes.h	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/include/linux/kprobes.h	2007-11-15
15:49:39.000000000 +0530
@@ -152,6 +152,7 @@ static inline int arch_trampoline_kprobe
 struct kretprobe {
 	struct kprobe kp;
 	kretprobe_handler_t handler;
+	kretprobe_handler_t entry_handler;
 	int maxactive;
 	int nmissed;
 	struct hlist_head free_instances;
diff -upNr linux-2.6.24-rc2/kernel/kprobes.c
linux-2.6.24-rc2_kp/kernel/kprobes.c
--- linux-2.6.24-rc2/kernel/kprobes.c	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/kernel/kprobes.c	2007-11-15 16:00:57.000000000 +0530
@@ -694,12 +694,24 @@ static int __kprobes pre_handler_kretpro
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
 		struct kretprobe_instance *ri;
+		struct pt_regs copy;

 		ri = hlist_entry(rp->free_instances.first,
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
-		arch_prepare_kretprobe(ri, regs);
+
+		if (rp->entry_handler) {
+			copy = *regs;
+			arch_prepare_kretprobe(ri, regs);
+			if (rp->entry_handler(ri, regs)) {
+				*regs = copy;
+				spin_unlock_irqrestore(&kretprobe_lock, flags);
+				return 0; /* skip current kretprobe instance */
+			}
+		} else {
+			arch_prepare_kretprobe(ri, regs);
+		}

 		/* XXX(hch): why is there no hlist_move_head? */
 		hlist_del(&ri->uflist);
