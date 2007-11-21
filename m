Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXKUKVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXKUKVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXKUKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:20:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:16738 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbXKUKUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pzmd/vcGSGd2n2XEbTtzSUgcZJ3hB7dtkva4HFJjDK/PBSG0vWzu6AHo9wsAZw6aG9LyaV0n06iE8k/57vKyVqwIdnV+kXRVjOZkPbX6JQRGnVlb5ZqKK511loBpsUlrsDlVZKTt5MoZS70fzT5PrNkJVz51EzWwX+iQd6RWVK8=
Message-ID: <863e9df20711210220i34f0b844u14c79daa54727c21@mail.gmail.com>
Date: Wed, 21 Nov 2007 15:50:54 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195624524.3705.20.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com> <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150516w6ee27172j159deaad06d0e5e8@mail.gmail.com>
	 <1195161370.3804.96.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
	 <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711190426t4dca674g54986d1520240894@mail.gmail.com>
	 <1195624524.3705.20.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Jim Keniston <jkenisto@us.ibm.com> wrote:
> I have one minor suggestion on the code -- see below -- but I'm willing
> to ack that with or without the suggested change.  Please also see
> suggestions on kprobes.txt and the demo program.

Thanks...I've made the necessary changes. More comments below.

> It would be more consistent with the existing text in kprobes.txt to add
> a subsection labeled "User's entry handler (rp->entry_handler):" and
> document the entry_handler there.

I've moved almost all of the entry_handler discussion in a separate section.

> >  static struct kretprobe my_kretprobe = {
> > -     .handler = ret_handler,
> > -     /* Probe up to 20 instances concurrently. */
> > -     .maxactive = 20
> > +     .handler = return_handler,
> > +     .entry_handler = entry_handler,
> > +     .data_size = sizeof(struct my_data),
> > +     .maxactive = 1, /* profile one invocation at a time */
>
> I don't like the idea of setting maxactive = 1 here.  That's not normal
> kretprobes usage, which is what we're trying to illustrate here.  This
> is no place for splitting hairs about profiling recursive functions.

I've reverted back to ".maxactive = 20". In any case, there is no need
to protect against recursive instances of sys_open.

> > @@ -699,6 +699,14 @@ static int __kprobes pre_handler_kretpro
> >                                struct kretprobe_instance, uflist);
> >               ri->rp = rp;
> >               ri->task = current;
> > +
> > +             if (rp->entry_handler) {
> > +                     if (rp->entry_handler(ri, regs)) {
>
> Could also be
>        if (rp->entry_handler && rp->entry_handler(ri, regs)) {

Done.

---
Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

diff -upNr linux-2.6.24-rc3/Documentation/kprobes.txt
linux-2.6.24-rc3_kp/Documentation/kprobes.txt
--- linux-2.6.24-rc3/Documentation/kprobes.txt	2007-11-17
10:46:36.000000000 +0530
+++ linux-2.6.24-rc3_kp/Documentation/kprobes.txt	2007-11-21
15:20:53.000000000 +0530
@@ -96,7 +96,9 @@ or in registers (e.g., for x86_64 or for
 The jprobe will work in either case, so long as the handler's
 prototype matches that of the probed function.

-1.3 How Does a Return Probe Work?
+1.3 Return Probes
+
+1.3.1 How Does a Return Probe Work?

 When you call register_kretprobe(), Kprobes establishes a kprobe at
 the entry to the function.  When the probed function is called and this
@@ -107,7 +109,7 @@ At boot time, Kprobes registers a kprobe

 When the probed function executes its return instruction, control
 passes to the trampoline and that probe is hit.  Kprobes' trampoline
-handler calls the user-specified handler associated with the kretprobe,
+handler calls the user-specified return handler associated with the kretprobe,
 then sets the saved instruction pointer to the saved return address,
 and that's where execution resumes upon return from the trap.

@@ -131,6 +133,30 @@ zero when the return probe is registered
 time the probed function is entered but there is no kretprobe_instance
 object available for establishing the return probe.

+1.3.2 Kretprobe entry-handler
+
+Kretprobes also provides an optional user-specified handler which runs
+on function entry. This handler is specified by setting the entry_handler
+field of the kretprobe struct. Whenever the kprobe placed by kretprobe at the
+function entry is hit, the user-defined entry_handler, if any, is invoked.
+If the entry_handler returns 0 (success) then a corresponding return handler
+is guaranteed to be called upon function return. If the entry_handler
+returns a non-zero error then Kprobes leaves the return address as is, and
+the kretprobe has no further effect for that particular function instance.
+
+Multiple entry and return handler invocations are matched using the unique
+kretprobe_instance object associated with them. Additionally, a user
+may also specify per return-instance private data to be part of each
+kretprobe_instance object. This is especially useful when sharing private
+data between corresponding user entry and return handlers. The size of each
+private data object can be specified at kretprobe registration time by
+setting the data_size field of the kretprobe struct. This data can be
+accessed through the data field of each kretprobe_instance object.
+
+In case probed function is entered but there is no kretprobe_instance
+object available, then in addition to incrementing the nmissed count,
+the user entry_handler invocation is also skipped.
+
 2. Architectures Supported

 Kprobes, jprobes, and return probes are implemented on the following
@@ -273,6 +299,8 @@ of interest:
 - ret_addr: the return address
 - rp: points to the corresponding kretprobe object
 - task: points to the corresponding task struct
+- data: points to per return-instance private data; see "Kretprobe entry-
+  handler" for details.

 The regs_return_value(regs) macro provides a simple abstraction to
 extract the return value from the appropriate register as defined by
@@ -555,23 +583,46 @@ report failed calls to sys_open().
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/ktime.h>

 static const char *probed_func = "sys_open";

-/* Return-probe handler: If the probed function fails, log the return value. */
-static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+/* per-instance private data */
+struct my_data {
+	ktime_t entry_stamp;
+};
+
+static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	struct my_data *data;
+
+	if(!current->mm)
+		return 1; /* skip kernel threads */
+
+	data = (struct my_data *)ri->data;
+	data->entry_stamp = ktime_get();
+	return 0;
+}
+
+static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	int retval = regs_return_value(regs);
-	if (retval < 0) {
-		printk("%s returns %d\n", probed_func, retval);
-	}
+	struct my_data *data = (struct my_data *)ri->data;
+	s64 delta;
+	ktime_t now = ktime_get();
+
+	delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
+	if (retval < 0) /* probed function failed; log retval and duration */
+		printk("%s: return val = %d (duration = %lld ns)\n",
+		       probed_func, retval, delta);
 	return 0;
 }

 static struct kretprobe my_kretprobe = {
-	.handler = ret_handler,
-	/* Probe up to 20 instances concurrently. */
-	.maxactive = 20
+	.handler = return_handler,
+	.entry_handler = entry_handler,
+	.data_size = sizeof(struct my_data),
+	.maxactive = 20, /* probe up to 20 instances concurrently */
 };

 static int __init kretprobe_init(void)
@@ -580,10 +631,10 @@ static int __init kretprobe_init(void)
 	my_kretprobe.kp.symbol_name = (char *)probed_func;

 	if ((ret = register_kretprobe(&my_kretprobe)) < 0) {
-		printk("register_kretprobe failed, returned %d\n", ret);
+		printk("Failed to register kretprobe!\n");
 		return -1;
 	}
-	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
+	printk("Kretprobe active on %s\n", my_kretprobe.kp.symbol_name);
 	return 0;
 }

@@ -591,7 +642,7 @@ static void __exit kretprobe_exit(void)
 {
 	unregister_kretprobe(&my_kretprobe);
 	printk("kretprobe unregistered\n");
-	/* nmissed > 0 suggests that maxactive was set too low. */
+	/* nmissed > 0 suggests that maxactive was set too low */
 	printk("Missed probing %d instances of %s\n",
 		my_kretprobe.nmissed, probed_func);
 }
diff -upNr linux-2.6.24-rc3/include/linux/kprobes.h
linux-2.6.24-rc3_kp/include/linux/kprobes.h
--- linux-2.6.24-rc3/include/linux/kprobes.h	2007-11-17 10:46:36.000000000 +0530
+++ linux-2.6.24-rc3_kp/include/linux/kprobes.h	2007-11-21
13:40:48.000000000 +0530
@@ -152,8 +152,10 @@ static inline int arch_trampoline_kprobe
 struct kretprobe {
 	struct kprobe kp;
 	kretprobe_handler_t handler;
+	kretprobe_handler_t entry_handler;
 	int maxactive;
 	int nmissed;
+	size_t data_size;
 	struct hlist_head free_instances;
 	struct hlist_head used_instances;
 };
@@ -164,6 +166,7 @@ struct kretprobe_instance {
 	struct kretprobe *rp;
 	kprobe_opcode_t *ret_addr;
 	struct task_struct *task;
+	char data[0];
 };

 struct kretprobe_blackpoint {
diff -upNr linux-2.6.24-rc3/kernel/kprobes.c
linux-2.6.24-rc3_kp/kernel/kprobes.c
--- linux-2.6.24-rc3/kernel/kprobes.c	2007-11-17 10:46:36.000000000 +0530
+++ linux-2.6.24-rc3_kp/kernel/kprobes.c	2007-11-21 13:41:57.000000000 +0530
@@ -699,6 +699,12 @@ static int __kprobes pre_handler_kretpro
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
+
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+				spin_unlock_irqrestore(&kretprobe_lock, flags);
+				return 0;
+		}
+
 		arch_prepare_kretprobe(ri, regs);

 		/* XXX(hch): why is there no hlist_move_head? */
@@ -745,7 +751,8 @@ int __kprobes register_kretprobe(struct
 	INIT_HLIST_HEAD(&rp->used_instances);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
-		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
+		inst = kmalloc(sizeof(struct kretprobe_instance) +
+			       rp->data_size, GFP_KERNEL);
 		if (inst == NULL) {
 			free_rp_inst(rp);
 			return -ENOMEM;
