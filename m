Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYHVMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYHVMzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYHVMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:55:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:38209 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYHVMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LmsCTLiB699MR7wnzOyvB4lV847sVS/K2U6sXaADmXYGDQHZtveqXYdpaeeJ2F+NgY
         SwRk1EJNyyCZQXDSbe+l6HEbRGkoqwi0gAXgu+cBEIUpAEZGY6a0gw8DcqiL4NI8Sbm0
         v1N7DQnTD7FOBLazKqTXZWx0kOFgkynYD2ERE=
Message-ID: <59929f7a0808220555r5a0b972cl5db047f74d7cabec@mail.gmail.com>
Date: Fri, 22 Aug 2008 14:55:30 +0200
From: "Esben Nielsen" <nielsen.esben@googlemail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH RT RFC v4 1/8] add generalized priority-inheritance interface
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       David.Holmes@sun.com, jkacur@gmail.com
In-Reply-To: <20080815202823.668.26199.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080815202408.668.23736.stgit@dev.haskins.net>
	 <20080815202823.668.26199.stgit@dev.haskins.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disclaimer: I am no longer actively involved and I must admit I might
have lost out on much of
what have been going on since I contributed to the PI system 2 years
ago. But I allow myself to comment
anyway.

On Fri, Aug 15, 2008 at 10:28 PM, Gregory Haskins <ghaskins@novell.com> wrote:
> The kernel currently addresses priority-inversion through priority-
> inheritence.  However, all of the priority-inheritence logic is
> integrated into the Real-Time Mutex infrastructure.  This causes a few
> problems:
>
>  1) This tightly coupled relationship makes it difficult to extend to
>    other areas of the kernel (for instance, pi-aware wait-queues may
>    be desirable).
>  2) Enhancing the rtmutex infrastructure becomes challenging because
>    there is no seperation between the locking code, and the pi-code.
>
> This patch aims to rectify these shortcomings by designing a stand-alone
> pi framework which can then be used to replace the rtmutex-specific
> version.  The goal of this framework is to provide similar functionality
> to the existing subsystem, but with sole focus on PI and the
> relationships between objects that can boost priority, and the objects
> that get boosted.

This is really a good idea. When I had time (2 years ago) to actively
work on these problem
I also came to the conclusion that PI should be more general than just
the rtmutex. Preemptive RCU
was the example which drove it.

But I do disagree that general objects should get boosted: The end
targets are always tasks. The objects might
be boosted as intermediate steps, but priority end the only applies to tasks.

I also have a few comments to the actual design:

> ....
> +
> +Multiple sinks per Node:
> +
> +We allow multiple sinks to be associated with a node.  This is a slight departure from the previous implementation which had the notion of only a single sink (i.e. "task->pi_blocked_on").  The reason why we added the ability to add more than one sink was not to change the default chaining model (I.e. multiple boost targets), but rather to add a flexible notification mechanism that is peripheral to the chain, which are informally called "leaf sinks".
> +
> +Leaf-sinks are boostable objects that do not perpetuate a chain per se.  Rather, they act as endpoints to a priority boosting.  Ultimately, every chain ends with a leaf-sink, which presumably will act on the new priority information.  However, there may be any number of leaf-sinks along a chain as well.  Each one will act on its localized priority in its own implementation specific way.  For instance, a task_struct pi-leaf may change the priority of the task and reschedule it if necessary.  Whereas an rwlock leaf-sink may boost a list of reader-owners.

This is bad from a RT point of view: You have a hard time determininig
the number of sinks per node. An rw-lock could have an arbitrary
number of readers (is supposed to really). Therefore
you have no chance of knowing how long the boost/deboost operation
will take. And you also know for how long the boosted tasks stay
boosted. If there can be an arbitrary number of
such tasks you can no longer be deterministic.

> ...
> +
> +#define MAX_PI_DEPENDENCIES 5


WHAT??? There is a finite lock depth defined. I know we did that
originally but it wasn't hardcoded (as far as I remember) and
it was certainly not as low as 5.

Remember: PI is used by the user space futeces as well!

> ....
> +/*
> + * _pi_node_update - update the chain
> + *
> + * We loop through up to MAX_PI_DEPENDENCIES times looking for stale entries
> + * that need to propagate up the chain.  This is a step-wise process where we
> + * have to be careful about locking and preemption.  By trying MAX_PI_DEPs
> + * times, we guarantee that this update routine is an effective barrier...
> + * all modifications made prior to the call to this barrier will have completed.
> + *
> + * Deadlock avoidance: This node may participate in a chain of nodes which
> + * form a graph of arbitrary structure.  While the graph should technically
> + * never close on itself barring any bugs, we still want to protect against
> + * a theoretical ABBA deadlock (if for nothing else, to prevent lockdep
> + * from detecting this potential).  To do this, we employ a dual-locking
> + * scheme where we can carefully control the order.  That is: node->lock
> + * protects most of the node's internal state, but it will never be held
> + * across a chain update.  sinkref->lock, on the other hand, can be held
> + * across a boost/deboost, and also guarantees proper execution order. Also
> + * note that no locks are held across an sink->update.
> + */
> +static int
> +_pi_node_update(struct pi_sink *sink, unsigned int flags)
> +{
> +       struct pi_node    *node = node_of(sink);
> +       struct pi_sinkref *sinkref;
> +       unsigned long      iflags;
> +       int                count = 0;
> +       int                i;
> +       int                pprio;
> +       struct updater     updaters[MAX_PI_DEPENDENCIES];
> +
> +       spin_lock_irqsave(&node->lock, iflags);
> +
> +       pprio = node->prio;
> +
> +       if (!plist_head_empty(&node->srcs))
> +               node->prio = plist_first(&node->srcs)->prio;
> +       else
> +               node->prio = MAX_PRIO;
> +
> +       list_for_each_entry(sinkref, &node->sinks, list) {
> +               /*
> +                * If the priority is changing, or if this is a
> +                * BOOST/DEBOOST, we consider this sink "stale"
> +                */
> +               if (pprio != node->prio
> +                   || sinkref->state != pi_state_boosted) {
> +                       struct updater *iter = &updaters[count++];

What prevents count from overrun?

> +
> +                       BUG_ON(!atomic_read(&sinkref->sink->refs));
> +                       _pi_sink_get(sinkref);
> +
> +                       iter->update  = 1;
> +                       iter->sinkref = sinkref;
> +                       iter->sink     = sinkref->sink;
> +               }
> +       }
> +
> +       spin_unlock(&node->lock);
> +
> +       for (i = 0; i < count; ++i) {
> +               struct updater    *iter = &updaters[i];
> +               unsigned int       lflags = PI_FLAG_DEFER_UPDATE;
> +               struct pi_sink    *sink;
> +
> +               sinkref = iter->sinkref;
> +               sink = iter->sink;
> +
> +               spin_lock(&sinkref->lock);
> +
> +               switch (sinkref->state) {
> +               case pi_state_boost:
> +                       sinkref->state = pi_state_boosted;
> +                       /* Fall through */
> +               case pi_state_boosted:
> +                       sink->ops->boost(sink, &sinkref->src, lflags);
> +                       break;
> +               case pi_state_deboost:
> +                       sink->ops->deboost(sink, &sinkref->src, lflags);
> +                       sinkref->state = pi_state_free;
> +
> +                       /*
> +                        * drop the ref that we took when the sinkref
> +                        * was allocated.  We still hold a ref from
> +                        * above.
> +                        */
> +                       _pi_sink_put_all(node, sinkref);
> +                       break;
> +               case pi_state_free:
> +                       iter->update = 0;
> +                       break;
> +               default:
> +                       panic("illegal sinkref type: %d", sinkref->state);
> +               }
> +
> +               spin_unlock(&sinkref->lock);
> +
> +               /*
> +                * We will drop the sinkref reference while still holding the
> +                * preempt/irqs off so that the memory is returned synchronously
> +                * to the system.
> +                */
> +               _pi_sink_put_local(node, sinkref);
> +       }
> +
> +       local_irq_restore(iflags);

Yack! You keep interrupts off while doing the chain. I think my main
contribution to the PI system 2 years ago was to do this preemptively.
I.e. there was points in the loop where interrupts and preemption
where turned on.

Remember: It goes into user space again. An evil user could craft an
application with a very long lock depth and keep higher priority real
time tasks from running for an arbitrary long time (if
no limit on the lock depth is set, which is bad because it will be too
low in some cases.)

But as I said I have had no time to watch what has actually been going
on in the kernel for the last 2 years roughly. The said defects might
have creeped in by other contributers already :-(

Esben
