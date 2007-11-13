Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXKMKsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXKMKsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKMKr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:47:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:41024 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXKMKr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:47:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IhrcjD7ZSdsC9iBZLaPV/hAP+T+9rdTJpng0ypojeWxBhI/nJsLdVfFVnpe3AN3rlv4AlZwT+sO+rV8XdQyLdRSmeRDkyLDoIacaxcSPHbZHZAODd40V80HImLraD/MFf/YHW8gufpxM+03IQ7qDjuPVODuyKeTw4JtPsKMuL2Y=
Message-ID: <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
Date: Tue, 13 Nov 2007 16:17:57 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: prasanna@in.ibm.com, davem@davemloft.net, anil.s.keshavamurthy@intel.com
In-Reply-To: <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 12:09 AM, Abhishek Sagar <sagar.abhishek@gmail.com> wrote:
> Whoops...sry for the repeated email..emailer trouble.

Expecting this one to makes it to the list. Summary again:

This patch introduces a provision to specify a user-defined callback
to run at function entry to complement the return handler in
kretprobes. Currently, whenever a kretprobe is registered, a user can
specify a callback (return-handler) to be run each time the target
function returns. This is also not guaranteed and is limited by the
number of concurrently pending return instances of the target function
in the current process's context.

This patch will now allow registration of another user defined handler
which is guaranteed to run each time the current return instance is
allocated and the return handler is set-up. Conversely, if the
entry-handler returns an error, it'll cause the current return
instance to be dropped and the return handler will also not run. The
purpose is to provide flexibility to do certain kinds of function
level profiling using kretprobes. By being able to register function
entry and return handlers, kretprobes will now be able to reduce an
extra probe registration (and associated race) for scenarios where an
entry handler is required to capture the function call/entry event
along with the corresponding function exit event.

Hope these simple changes would suffice; all suggestions/corrections
are welcome.


Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff -X /home/sagara/kprobes/dontdiff -upNr
linux-2.6.24-rc2/include/linux/kprobes.h
linux-2.6.24-rc2_kp/include/linux/kprobes.h
--- linux-2.6.24-rc2/include/linux/kprobes.h	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/include/linux/kprobes.h	2007-11-13
16:04:35.000000000 +0530
@@ -152,6 +152,7 @@ static inline int arch_trampoline_kprobe
 struct kretprobe {
 	struct kprobe kp;
 	kretprobe_handler_t handler;
+	kretprobe_handler_t entry_handler;
 	int maxactive;
 	int nmissed;
 	struct hlist_head free_instances;
diff -X /home/sagara/kprobes/dontdiff -upNr
linux-2.6.24-rc2/kernel/kprobes.c linux-2.6.24-rc2_kp/kernel/kprobes.c
--- linux-2.6.24-rc2/kernel/kprobes.c	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2_kp/kernel/kprobes.c	2007-11-13 16:04:17.000000000 +0530
@@ -694,12 +694,22 @@ static int __kprobes pre_handler_kretpro
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
+			arch_prepare_kretprobe(ri, &copy);
+			if (rp->entry_handler(ri, &copy))
+				goto out; /* skip current kretprobe instance */
+			*regs = copy;
+		} else {
+			arch_prepare_kretprobe(ri, regs);
+		}

 		/* XXX(hch): why is there no hlist_move_head? */
 		hlist_del(&ri->uflist);
@@ -707,6 +717,7 @@ static int __kprobes pre_handler_kretpro
 		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
 	} else
 		rp->nmissed++;
+out:
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 	return 0;
 }
