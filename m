Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZFPQRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZFPQRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZFPQRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:17:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60628 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZFPQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:17:34 -0400
Message-ID: <4A37C592.2030407@novell.com>
Date: Tue, 16 Jun 2009 12:17:22 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based	notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com>
In-Reply-To: <20090616154150.GA17494@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig558B4F6F4D4469AA3477D0F4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig558B4F6F4D4469AA3477D0F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 16, 2009 at 11:20:18AM -0400, Gregory Haskins wrote:
>  =20
>>>>> eventfd can't detect this state. But the callers know in what conte=
xt they are.
>>>>> So the *caller* of eventfd_signal_task makes sure of this: if you a=
re in a task,
>>>>> you can call eventfd_signal_task() if not, you must call eventfd_si=
gnal.
>>>>>
>>>>>
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Hmm, this is an interesting idea, but I think it would be problemati=
c in
>>>> real-world applications for the long-term.  For instance, the -rt tr=
ee
>>>> and irq-threads .config option in the process of merging into mainli=
ne
>>>> changes context types for established code.  Therefore, what might b=
e
>>>> "hardirq/softirq" logic today may execute in a kthread tomorrow.
>>>>    =20
>>>>        =20
>>> That's OK, it's always safe to call eventfd_signal: eventfd_signal_ta=
sk is just
>>> an optimization. I think everyone not in the context of a system call=
 or vmexit
>>> can just call eventfd_signal_task.
>>>  =20
>>>      =20
>>                                  ^^^^^^^^^^^^^^^^^^^^
>>
>> I assume you meant s/eventfd_signal_task/eventfd_signal there?
>>    =20
>
> Yea. Sorry.
>  =20

np.  I knew what you meant ;)
>  =20
>>>  =20
>>>      =20
>>>>  I
>>>> think its dangerous to try to solve the problem with caller provided=

>>>> info:  the caller may be ignorant of its true state.
>>>>    =20
>>>>        =20
>>> I assume this wasn't clear enough: the idea is that you only
>>> calls eventfd_signal_task if you know you are on a systemcall path.
>>> If you are ignorant of the state, call eventfd_signal.
>>>  =20
>>>      =20
>> Well, its not a matter of correctness.  Its more for optimal
>> performance.  If I have PCI pass-though injecting interrupts from
>> hardirq in mainline, clearly eventfd_signal() is proper.  In -rt, the
>> hardirq is transparently converted to a kthread, so technically
>> eventfd_signal_task() would work
>>    =20
>
> I think it's wrong to sleep for a long time while handling interrupts e=
ven if
> you technically can with threaded interrupts.

Well, this is somewhat of an orthogonal issue so I don't want to open
this can of worms per se.

But, one of the long-term goals of the threaded-irq construct is to
eliminate the need for the traditional "bh" contexts to do work.  The
idea, of course, is that the threaded-irq context can do all of the work
traditionally shunted to tasklets/softirqs/workqueues directly, so why
bother switching contexts.  So, the short answer is that its not
necessarily wrong to sleep or to do significant processing from a
threaded-irq.

In any case, threaded-irqs are just one example.  I will try to
highlight others below.

>  For that matter, I think you can
> sleep while within a spinlock if preempt is on
Yes, in fact the spinlocks are mutexes in this mode, so the locks
themselves can sleep.


> , but that does not mean you
> should - and I think you will get warnings in the log if you do. No?
>
>  =20
Nope, sleeping is fine (voluntary or involuntary).  The idea is its all
governed by priority, and priority-inheritance, and a scheduler that is
free to make fine-grained decisions (due to the broadly preemptible
kernel).  But this is getting off-topic so I will stop.

>> (at least for the can_sleep() part, not
>> for current->mm per se).  But in this case, the PCI logic would not kn=
ow
>> it was converted to a kthread.  It all happens transparently in the
>> low-level code and the pci code is unmodified.
>>
>> In this case, your proposal would have the passthrough path invoking
>> irqfd with eventfd_signal().  It  would therefore still shunt to a
>> workqueue to inject the interrupt, even though it would have been
>> perfectly fine to just inject it directly because taking
>> mutex_lock(&kvm->irq_lock) is legal.
>>    =20
>
> This specific issue should just be addressed by making it possible
> to inject the interrupt from an atomic context.
>  =20

I assume you mean
s/mutex_lock(&kvm->irq_lock)/spin_lock(&kvm->irq_lock)?  If so, I agree
this is a good idea.  TBH: I am more concerned about the iosignalfd path
w.r.t. the premptiblity of the callback.  We can optimize the virtio-net
interface, for instance, once we make this ->signal() callback
preemptible.  Having irqfd ->signal() preemptible is just a bonus, but
we could work around it by fixing irq_lock as well, I agree.

>  =20
>>  Perhaps I am over-optimizing, but
>> this is the scenario I am concerned about and what I was trying to
>> address with preemptible()/can_sleep().
>>    =20
>
> What, a path that is never invoked without threaded interrupts?
> Yes, I would say it currently looks like an over-optimization.
>  =20

You are only seeing part of the picture though.  This is a cascading
pattern.
>  =20
>> I think your idea is a good one to address the current->mm portion.  I=
t
>> would only ever be safe to access the MM context from syscall/vmexit
>> context, as you point out.  Therefore, I see no problem with
>> implementing something like iosignalfd with eventfd_signal_task().
>>
>> But accessing current->mm is only a subset of the use-cases.  The othe=
r
>> use-cases would include the ability to sleep, and possibly the ability=

>> to address other->mm.  For these latter cases, I really only need the
>> "can_sleep()" behavior, not the full blown "can_access_current_mm()". =

>> Additionally, the eventfd_signal_task() data at least for iosignalfd i=
s
>> superfluous:  I already know that I can access current->mm by virtue o=
f
>> the design.
>>    =20
>
> Maybe I misunderstand what iosignalfd is - isn't it true that you get e=
ventfd
> and kvm will signal that when guest performs io write to a specific
> address, and then drivers can get eventfd and poll it to detect
> these writes?
>  =20

Correct.

> If yes, you have no way to know that the other end of eventfd
> is connected to kvm, so you don't know you can access current->mm.
>  =20

Well, my intended use for them *does* know its connected to KVM.=20
Perhaps there will be others that do not in the future, but like I said
it could be addressed as those actually arise.


>  =20
>> So since I cannot use it accurately for the hardirq/threaded-irq type
>> case, and I don't actually need it for the iosignalfd case, I am not
>> sure its the right direction (at least for now).  I do think it might
>> have merit for syscal/vmexit uses outside of iosignalfd, but I do not
>> see a current use-case for it so perhaps it can wait until one arises.=

>>
>> -Greg
>>    =20
>
> But, it addresses the CONFIG_PREEMPT off case, which your design doesn'=
t
> seem to.
>  =20

Well, the problem is that it only addresses it partially in a limited
set of circumstances, and doesn't address the broader problem.  I'll
give you an example:

(First off, lets assume that we are not going to have
eventfd_signal_task(), but rather eventfd_signal() with two option
flags: EVENTFD_SIGNAL_CANSLEEP, and EVENTFD_SIGNAL_CURRENTVALID

Today vbus-enet has a rx-thread and a tx-thread at least partially
because I need process-context to do the copy_to_user(other->mm) type
stuff (and we will need similar for our virtio-net backend as well).  I
also utilize irqfd to do interrupt injection.  Now, since I know that I
have kthread_context, I could modify vbus-enet to inject interrupts with
EVENTFD_SIGNAL_CANSLEEP set, and this is fine.  I know that is safe.

However, the problem is above that!  I would like to optimize out the
tx-thread to begin with with a similar "can_sleep()" pattern whenever
possible.

For instance, if the netif stack calls me to do a transmit and it
happens to be in a sleepable context, it would be nice to just skip
waking up the tx-thread.  I would therefore just do the
copy_to_user(other->mm) + irqfd directly in the netif callback, thereby
skipping the context switch.

So the problem is a pattern that I would like to address generally
outside of just eventfd: "can I be sleepy"?  If yes, do it now, if not
defer it.

So if the stack calls me in a preemptible state, I would like to detect
that and optimize my deferment mechanisms away.  This isn't something
that happens readily today given the way the stacks locking and
softirq-net work, but its moving in that direction (for instance,
threaded softirqs).

This is why I am pushing for a run-time detection mechanism (like
can_sleep()), as opposed to something in the eventfd interface level
(like EVENTFD_SIGNAL_CANSLEEP).  I think at least the CURRENTVALID idea
is a great one, I just don't have a current need for it.  That said, I
do not have a problem with modifing eventfd to provide such information
if Davide et. al. ack it as well.

Does this all make sense?

-Greg



--------------enig558B4F6F4D4469AA3477D0F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3xZMACgkQlOSOBdgZUxny8ACggqMk0Diqn6ekSbH7LJwLc1w7
dcQAnRSdL2QBYU7QDMjfL2pzKfszKlq2
=u2SB
-----END PGP SIGNATURE-----

--------------enig558B4F6F4D4469AA3477D0F4--
