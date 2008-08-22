Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYHVQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYHVQKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYHVQKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:10:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56982 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYHVQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:10:30 -0400
Message-ID: <48AEE460.6030802@novell.com>
Date: Fri, 22 Aug 2008 12:08:00 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Esben Nielsen <nielsen.esben@googlemail.com>
CC: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       David.Holmes@sun.com, jkacur@gmail.com
Subject: Re: [PATCH RT RFC v4 1/8] add generalized priority-inheritance interface
References: <20080815202408.668.23736.stgit@dev.haskins.net>	 <20080815202823.668.26199.stgit@dev.haskins.net> <59929f7a0808220555r5a0b972cl5db047f74d7cabec@mail.gmail.com> <48AEBBD6.6010707@novell.com>
In-Reply-To: <48AEBBD6.6010707@novell.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig69828E6DA2A01058867044CF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig69828E6DA2A01058867044CF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Esben,
>   Thank you for the review.  Comments inline.
>
> Esben Nielsen wrote:
>  =20
>> Disclaimer: I am no longer actively involved and I must admit I might
>> have lost out on much of
>> what have been going on since I contributed to the PI system 2 years
>> ago. But I allow myself to comment
>> anyway.
>>
>> On Fri, Aug 15, 2008 at 10:28 PM, Gregory Haskins <ghaskins@novell.com=
> wrote:
>>  =20
>>    =20
>>> The kernel currently addresses priority-inversion through priority-
>>> inheritence.  However, all of the priority-inheritence logic is
>>> integrated into the Real-Time Mutex infrastructure.  This causes a fe=
w
>>> problems:
>>>
>>>  1) This tightly coupled relationship makes it difficult to extend to=

>>>    other areas of the kernel (for instance, pi-aware wait-queues may
>>>    be desirable).
>>>  2) Enhancing the rtmutex infrastructure becomes challenging because
>>>    there is no seperation between the locking code, and the pi-code.
>>>
>>> This patch aims to rectify these shortcomings by designing a stand-al=
one
>>> pi framework which can then be used to replace the rtmutex-specific
>>> version.  The goal of this framework is to provide similar functional=
ity
>>> to the existing subsystem, but with sole focus on PI and the
>>> relationships between objects that can boost priority, and the object=
s
>>> that get boosted.
>>>    =20
>>>      =20
>> This is really a good idea. When I had time (2 years ago) to actively
>> work on these problem
>> I also came to the conclusion that PI should be more general than just=

>> the rtmutex. Preemptive RCU
>> was the example which drove it.
>>
>> But I do disagree that general objects should get boosted: The end
>> targets are always tasks. The objects might
>> be boosted as intermediate steps, but priority end the only applies to=
 tasks.
>>  =20
>>    =20
> Actually I fully agree with you here.  Its probably just poor wording o=
n
> my part, but this is exactly what happens.  We may "boost" arbitrary
> objects on the way to boosting a task...but the intermediate objects ar=
e
> just there to help find our way to the proper tasks.  Ultimately
> everything ends up at the scheduler eventually ;)
>
>  =20
>> I also have a few comments to the actual design:
>>
>>  =20
>>    =20
>>> ....
>>> +
>>> +Multiple sinks per Node:
>>> +
>>> +We allow multiple sinks to be associated with a node.  This is a sli=
ght departure from the previous implementation which had the notion of on=
ly a single sink (i.e. "task->pi_blocked_on").  The reason why we added t=
he ability to add more than one sink was not to change the default chaini=
ng model (I.e. multiple boost targets), but rather to add a flexible noti=
fication mechanism that is peripheral to the chain, which are informally =
called "leaf sinks".
>>> +
>>> +Leaf-sinks are boostable objects that do not perpetuate a chain per =
se.  Rather, they act as endpoints to a priority boosting.  Ultimately, e=
very chain ends with a leaf-sink, which presumably will act on the new pr=
iority information.  However, there may be any number of leaf-sinks along=
 a chain as well.  Each one will act on its localized priority in its own=
 implementation specific way.  For instance, a task_struct pi-leaf may ch=
ange the priority of the task and reschedule it if necessary.  Whereas an=
 rwlock leaf-sink may boost a list of reader-owners.
>>>    =20
>>>      =20
>> This is bad from a RT point of view: You have a hard time determininig=

>> the number of sinks per node. An rw-lock could have an arbitrary
>> number of readers (is supposed to really). Therefore
>> you have no chance of knowing how long the boost/deboost operation
>> will take. And you also know for how long the boosted tasks stay
>> boosted. If there can be an arbitrary number of
>> such tasks you can no longer be deterministic.
>>  =20
>>    =20
>
> While you may have a valid concern about what rwlocks can do to
> determinism, not that we already have PI enabled rwlocks before my
> patch, so I am not increasing nor decreasing determinism in this
> regard.  That being said, Steven Rostedt (author of the pi-rwlocks,
> CC'd) has facilities to manage this (such as limiting the number of
> readers to num_online_cpus) which this design would retain.  Long story=

> short, I do not believe I have made anything worse here, so this is a
> different discussion if you are still concerned.
>
>
>  =20
>>  =20
>>    =20
>>> ...
>>> +
>>> +#define MAX_PI_DEPENDENCIES 5
>>>    =20
>>>      =20
>> WHAT??? There is a finite lock depth defined. I know we did that
>> originally but it wasn't hardcoded (as far as I remember) and
>> it was certainly not as low as 5.
>>  =20
>>    =20
>
> Note that this is simply in reference to how many direct sinks you can
> link to a node, not how long the resulting chain can grow.  The chain
> depth is actually completely unconstrained by the design.  I chose "5"
> here because typically we need 1 sink for the next link in the chain,
> and 1 sink for local notifications.  The other 3 are there for head-roo=
m
> (we often hit 3-4 as we transition between nodes (add one node -> delet=
e
> another, etc).
>  =20

To clarify what I meant here:  If you think of a normal linked-list node
having a single "next" pointer, this implementation is like each node
having up to 5 "next" pointers.   However typically only 1-2 are used,
and all but one will usually point to a "leaf" node, meaning it does not
form a chain but terminates processing locally.  Typically there will be
only one link to something that forms a chain with other nodes.  I did
this because I realized the pattern (boost/deboost/update) was similar
whether the node was a leaf or a chain-link, so I unified both behind
the single pi_sink interface.

That being understood, note that as with any linked-list, the nodes can
still have an arbitrary chaining depth (and I will fix this to be
iterative instead of recursive, as previously mentioned).

> You are not the first to comment about this, however, so it makes me
> realize it is not very clear ;)  I will comment the code better.
>
>
>  =20
>> Remember: PI is used by the user space futeces as well!
>>  =20
>>    =20
>
> Yes, and on a slight tangent from your point, this incidentally is
> actually a problem in the design such that I need to respin at least a
> v5.  My current design uses recursion against the sink->update()
> methods, which Peter Zijlstra pointed out would blow up with large
> userpspace chains.  My next version will forgo the recursion in favor o=
f
> an iterative method more reminiscent of the original design.
>
>  =20
>>  =20
>>    =20
>>> ....
>>> +/*
>>> + * _pi_node_update - update the chain
>>> + *
>>> + * We loop through up to MAX_PI_DEPENDENCIES times looking for stale=
 entries
>>> + * that need to propagate up the chain.  This is a step-wise process=
 where we
>>> + * have to be careful about locking and preemption.  By trying MAX_P=
I_DEPs
>>> + * times, we guarantee that this update routine is an effective barr=
ier...
>>> + * all modifications made prior to the call to this barrier will hav=
e completed.
>>> + *
>>> + * Deadlock avoidance: This node may participate in a chain of nodes=
 which
>>> + * form a graph of arbitrary structure.  While the graph should tech=
nically
>>> + * never close on itself barring any bugs, we still want to protect =
against
>>> + * a theoretical ABBA deadlock (if for nothing else, to prevent lock=
dep
>>> + * from detecting this potential).  To do this, we employ a dual-loc=
king
>>> + * scheme where we can carefully control the order.  That is: node->=
lock
>>> + * protects most of the node's internal state, but it will never be =
held
>>> + * across a chain update.  sinkref->lock, on the other hand, can be =
held
>>> + * across a boost/deboost, and also guarantees proper execution orde=
r. Also
>>> + * note that no locks are held across an sink->update.
>>> + */
>>> +static int
>>> +_pi_node_update(struct pi_sink *sink, unsigned int flags)
>>> +{
>>> +       struct pi_node    *node =3D node_of(sink);
>>> +       struct pi_sinkref *sinkref;
>>> +       unsigned long      iflags;
>>> +       int                count =3D 0;
>>> +       int                i;
>>> +       int                pprio;
>>> +       struct updater     updaters[MAX_PI_DEPENDENCIES];
>>> +
>>> +       spin_lock_irqsave(&node->lock, iflags);
>>> +
>>> +       pprio =3D node->prio;
>>> +
>>> +       if (!plist_head_empty(&node->srcs))
>>> +               node->prio =3D plist_first(&node->srcs)->prio;
>>> +       else
>>> +               node->prio =3D MAX_PRIO;
>>> +
>>> +       list_for_each_entry(sinkref, &node->sinks, list) {
>>> +               /*
>>> +                * If the priority is changing, or if this is a
>>> +                * BOOST/DEBOOST, we consider this sink "stale"
>>> +                */
>>> +               if (pprio !=3D node->prio
>>> +                   || sinkref->state !=3D pi_state_boosted) {
>>> +                       struct updater *iter =3D &updaters[count++];
>>>    =20
>>>      =20
>> What prevents count from overrun?
>>  =20
>>    =20
>
> The node->sinks list will never have more than MAX_PI_DEPs in it, by de=
sign.
>
>  =20
>>  =20
>>    =20
>>> +
>>> +                       BUG_ON(!atomic_read(&sinkref->sink->refs));
>>> +                       _pi_sink_get(sinkref);
>>> +
>>> +                       iter->update  =3D 1;
>>> +                       iter->sinkref =3D sinkref;
>>> +                       iter->sink     =3D sinkref->sink;
>>> +               }
>>> +       }
>>> +
>>> +       spin_unlock(&node->lock);
>>> +
>>> +       for (i =3D 0; i < count; ++i) {
>>> +               struct updater    *iter =3D &updaters[i];
>>> +               unsigned int       lflags =3D PI_FLAG_DEFER_UPDATE;
>>> +               struct pi_sink    *sink;
>>> +
>>> +               sinkref =3D iter->sinkref;
>>> +               sink =3D iter->sink;
>>> +
>>> +               spin_lock(&sinkref->lock);
>>> +
>>> +               switch (sinkref->state) {
>>> +               case pi_state_boost:
>>> +                       sinkref->state =3D pi_state_boosted;
>>> +                       /* Fall through */
>>> +               case pi_state_boosted:
>>> +                       sink->ops->boost(sink, &sinkref->src, lflags)=
;
>>> +                       break;
>>> +               case pi_state_deboost:
>>> +                       sink->ops->deboost(sink, &sinkref->src, lflag=
s);
>>> +                       sinkref->state =3D pi_state_free;
>>> +
>>> +                       /*
>>> +                        * drop the ref that we took when the sinkref=

>>> +                        * was allocated.  We still hold a ref from
>>> +                        * above.
>>> +                        */
>>> +                       _pi_sink_put_all(node, sinkref);
>>> +                       break;
>>> +               case pi_state_free:
>>> +                       iter->update =3D 0;
>>> +                       break;
>>> +               default:
>>> +                       panic("illegal sinkref type: %d", sinkref->st=
ate);
>>> +               }
>>> +
>>> +               spin_unlock(&sinkref->lock);
>>> +
>>> +               /*
>>> +                * We will drop the sinkref reference while still hol=
ding the
>>> +                * preempt/irqs off so that the memory is returned sy=
nchronously
>>> +                * to the system.
>>> +                */
>>> +               _pi_sink_put_local(node, sinkref);
>>> +       }
>>> +
>>> +       local_irq_restore(iflags);
>>>    =20
>>>      =20
>> Yack! You keep interrupts off while doing the chain.
>>    =20
>
> Actually, not quite.  The first pass (with interrupts off) simply sets
> the new priority value at each local element (limited to 5, typically
> 1-2).  Short and sweet.  Its the "update" that happens next (with
> interrupts/preemption enabled) that updates the chain.
>
>
>  =20
>>  I think my main
>> contribution to the PI system 2 years ago was to do this preemptively.=

>> I.e. there was points in the loop where interrupts and preemption
>> where turned on.
>>  =20
>>    =20
>
> I agree this is important, but I think you will see with further review=

> that this is in fact what I do too.
>
>  =20
>> Remember: It goes into user space again. An evil user could craft an
>> application with a very long lock depth and keep higher priority real
>> time tasks from running for an arbitrary long time (if
>> no limit on the lock depth is set, which is bad because it will be too=

>> low in some cases.)
>>
>> But as I said I have had no time to watch what has actually been going=

>> on in the kernel for the last 2 years roughly. The said defects might
>> have creeped in by other contributers already :-(
>>
>> Esben
>>  =20
>>    =20
>
> Esben,
>   Your review and insight are very much appreciated.  I will be sure to=

> address the concerns mentioned above and CC you on the next release.
>
> Thanks again,
> -Greg
>
>
>  =20



--------------enig69828E6DA2A01058867044CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiu5GEACgkQlOSOBdgZUxlvxACdHVxkFiaXYD2WKyUPhJ77kUUJ
UusAoIwcs3dNqOzoLWx3c1l4iZrr48ha
=m0Sp
-----END PGP SIGNATURE-----

--------------enig69828E6DA2A01058867044CF--
