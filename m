Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXKSM0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXKSM0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXKSM0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:26:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:34332 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXKSM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZXQXLYm8rFzUcuUwNWcNtwSNHpWIN9WHpJ+JV3/Si7KpB4YkFqou2+1miE4nFXRHfXiEbF3TXk9OHhyPYKUmD9vqEkFBvvhipaIH0h38v78fDzheY0Yw/Q+XjbzGrV3Ib97QclxzHz2NXjYmr1/zmKnDawZJ7pMXu5L5VZR9rvA=
Message-ID: <863e9df20711190426t4dca674g54986d1520240894@mail.gmail.com>
Date: Mon, 19 Nov 2007 17:56:38 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com> <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150516w6ee27172j159deaad06d0e5e8@mail.gmail.com>
	 <1195161370.3804.96.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
	 <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 6:24 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> > True, some kind of data pointer/pouch is essential.
>
> Yes.  If the pouch idea is too weird, then the data pointer is a good
> compromise.
>
> With the above reservations, your enclosed patch looks OK.
>
> You should provide a patch #2 that updates Documentation/kprobes.txt.
> Maybe that will yield a little more review from other folks.

The inlined patch provides support for an optional user entry-handler
in kretprobes. It also adds provision for private data to be held in
each return instance based on Kevin Stafford's "data pouch" approach.
Kretprobe usage example in Documentation/kprobes.txt has also been
updated to demonstrate the usage of entry-handlers.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---
diff -upNr linux-2.6.24-rc2/Documentation/kprobes.txt
linux-2.6.24-rc2_kp/Documentation/kprobes.txt
--- linux-2.6.24-rc2/Documentation/kprobes.txt	2007-11-07
03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/Documentation/kprobes.txt	2007-11-19
17:41:27.000000000 +0530
@@ -100,16 +100,21 @@ prototype matches that of the probed fun

 When you call register_kretprobe(), Kprobes establishes a kprobe at
 the entry to the function.  When the probed function is called and this
-probe is hit, Kprobes saves a copy of the return address, and replaces
-the return address with the address of a "trampoline."  The trampoline
-is an arbitrary piece of code -- typically just a nop instruction.
-At boot time, Kprobes registers a kprobe at the trampoline.
-
-When the probed function executes its return instruction, control
-passes to the trampoline and that probe is hit.  Kprobes' trampoline
-handler calls the user-specified handler associated with the kretprobe,
-then sets the saved instruction pointer to the saved return address,
-and that's where execution resumes upon return from the trap.
+probe is hit, the user defined entry_handler is invoked (optional). If
+the entry_handler returns 0 (success) or is not present, then Kprobes
+saves a copy of the return address, and replaces the return address
+with the address of a "trampoline."  If the entry_handler returns a
+non-zero error, the function executes as normal, as if no probe was
+installed on it. The trampoline is an arbitrary piece of code --
+typically just a nop instruction. At boot time, Kprobes registers a
+kprobe at the trampoline.
+
+After the trampoline return address is planted, when the probed function
+executes its return instruction, control passes to the trampoline and
+that probe is hit.  Kprobes' trampoline handler calls the user-specified
+return handler associated with the kretprobe, then sets the saved
+instruction pointer to the saved return address, and that's where
+execution resumes upon return from the trap.

 While the probed function is executing, its return address is
 stored in an object of type kretprobe_instance.  Before calling
@@ -117,6 +122,9 @@ register_kretprobe(), the user sets the
 kretprobe struct to specify how many instances of the specified
 function can be probed simultaneously.  register_kretprobe()
 pre-allocates the indicated number of kretprobe_instance objects.
+Additionally, a user may also specify per-instance private data to
+be part of each return instance. This is useful when using kretprobes
+with a user entry_handler (see "register_kretprobe" for details).

 For example, if the function is non-recursive and is called with a
 spinlock held, maxactive = 1 should be enough.  If the function is
@@ -129,7 +137,8 @@ It's not a disaster if you set maxactive
 some probes.  In the kretprobe struct, the nmissed field is set to
 zero when the return probe is registered, and is incremented every
 time the probed function is entered but there is no kretprobe_instance
-object available for establishing the return probe.
+object available for establishing the return probe. A miss also prevents
+user entry_handler from being invoked.

 2. Architectures Supported

@@ -258,6 +267,16 @@ Establishes a return probe for the funct
 rp->kp.addr.  When that function returns, Kprobes calls rp->handler.
 You must set rp->maxactive appropriately before you call
 register_kretprobe(); see "How Does a Return Probe Work?" for details.
+An optional entry-handler can also be specified by initializing
+rp->entry_handler. This handler is called at the beginning of the
+probed function (except for instances exceeding rp->maxactive). On
+success the entry_handler return 0, which guarantees invocation of
+a corresponding return handler. Corresponding entry and return handler
+invocations can be matched using the return instance (ri) passed to them.
+Also, each ri can hold per-instance private data (ri->data), whose size
+is determined by rp->data_size. If the entry_handler returns a non-zero
+error, the current return instance is skipped and no return handler is
+called for the current instance.

 register_kretprobe() returns 0 on success, or a negative errno
 otherwise.
@@ -555,23 +574,46 @@ report failed calls to sys_open().
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
+	.maxactive = 1, /* profile one invocation at a time */
 };

 static int __init kretprobe_init(void)
@@ -580,10 +622,10 @@ static int __init kretprobe_init(void)
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

@@ -591,7 +633,6 @@ static void __exit kretprobe_exit(void)
 {
 	unregister_kretprobe(&my_kretprobe);
 	printk("kretprobe unregistered\n");
-	/* nmissed > 0 suggests that maxactive was set too low. */
 	printk("Missed probing %d instances of %s\n",
 		my_kretprobe.nmissed, probed_func);
 }
diff -upNr linux-2.6.24-rc2/include/linux/kprobes.h
linux-2.6.24-rc2_kp/include/linux/kprobes.h
--- linux-2.6.24-rc2/include/linux/kprobes.h	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/include/linux/kprobes.h	2007-11-19
15:56:20.000000000 +0530
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
diff -upNr linux-2.6.24-rc2/kernel/kprobes.c
linux-2.6.24-rc2_kp/kernel/kprobes.c
--- linux-2.6.24-rc2/kernel/kprobes.c	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/kernel/kprobes.c	2007-11-19 15:34:18.000000000 +0530
@@ -699,6 +699,14 @@ static int __kprobes pre_handler_kretpro
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
+
+		if (rp->entry_handler) {
+			if (rp->entry_handler(ri, regs)) {
+				spin_unlock_irqrestore(&kretprobe_lock, flags);
+				return 0;				
+			}
+		}
+
 		arch_prepare_kretprobe(ri, regs);

 		/* XXX(hch): why is there no hlist_move_head? */
@@ -745,7 +753,8 @@ int __kprobes register_kretprobe(struct
 	INIT_HLIST_HEAD(&rp->used_instances);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
-		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
+		inst = kmalloc(sizeof(struct kretprobe_instance) +
+			       rp->data_size, GFP_KERNEL);
 		if (inst == NULL) {
 			free_rp_inst(rp);
 			return -ENOMEM;
