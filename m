Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZFPPUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZFPPUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZFPPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:20:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58690 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZFPPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:20:28 -0400
Message-ID: <4A37B832.6040206@novell.com>
Date: Tue, 16 Jun 2009 11:20:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based	notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com>
In-Reply-To: <20090616145502.GA1102@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1DFC59B2E08587DFA7F684C3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1DFC59B2E08587DFA7F684C3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 16, 2009 at 10:48:27AM -0400, Gregory Haskins wrote:
>  =20
>>>>>> +static void _eventfd_notify(struct eventfd_ctx *ctx)
>>>>>> +{
>>>>>> +	struct eventfd_notifier *en;
>>>>>> +	int idx;
>>>>>> +
>>>>>> +	idx =3D srcu_read_lock(&ctx->srcu);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * The goal here is to allow the notification to be preemptible
>>>>>> +	 * as often as possible.  We cannot achieve this with the basic
>>>>>> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
>>>>>> +	 * we have an internal srcu list mechanism of which the wqh is
>>>>>> +	 * a client.
>>>>>> +	 *
>>>>>> +	 * Not all paths will invoke this function in process context.
>>>>>> +	 * Callers should check for suitable state before assuming they
>>>>>> +	 * can sleep (such as with preemptible()).  Paul McKenney assure=
s
>>>>>> +	 * me that srcu_read_lock is compatible with in-atomic, as long =
as
>>>>>> +	 * the code within the critical section is also compatible.
>>>>>> +	 */
>>>>>> +	list_for_each_entry_rcu(en, &ctx->nh, list)
>>>>>> +		en->ops->signal(en);
>>>>>> +
>>>>>> +	srcu_read_unlock(&ctx->srcu, idx);
>>>>>> +}
>>>>>> +
>>>>>>  /*
>>>>>>   * Adds "n" to the eventfd counter "count". Returns "n" in case o=
f
>>>>>>   * success, or a value lower then "n" in case of coutner overflow=
=2E
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> This is ugly, isn't it? With CONFIG_PREEMPT=3Dno preemptible() is a=
lways false.
>>>>>
>>>>> Further, to do useful things it might not be enough that you can sl=
eep:
>>>>> with iofd you also want to access current task with e.g. copy from =
user.
>>>>>
>>>>> Here's an idea: let's pass a flag to ->signal, along the lines of
>>>>> signal_is_task, that tells us that it is safe to use current, and a=
dd
>>>>> eventfd_signal_task() which is the same as eventfd_signal but lets =
everyone
>>>>> know that it's safe to both sleep and use current->mm.
>>>>>
>>>>> Makes sense?
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> It does make sense, yes.  What I am not clear on is how would eventf=
d
>>>> detect this state such as to populate such flags, and why cant the
>>>> ->signal() CB do the same?
>>>>
>>>> Thanks Michael,
>>>> -Greg
>>>>
>>>>    =20
>>>>        =20
>>> eventfd can't detect this state. But the callers know in what context=
 they are.
>>> So the *caller* of eventfd_signal_task makes sure of this: if you are=
 in a task,
>>> you can call eventfd_signal_task() if not, you must call eventfd_sign=
al.
>>>
>>>
>>>  =20
>>>      =20
>> Hmm, this is an interesting idea, but I think it would be problematic =
in
>> real-world applications for the long-term.  For instance, the -rt tree=

>> and irq-threads .config option in the process of merging into mainline=

>> changes context types for established code.  Therefore, what might be
>> "hardirq/softirq" logic today may execute in a kthread tomorrow.
>>    =20
>
> That's OK, it's always safe to call eventfd_signal: eventfd_signal_task=
 is just
> an optimization. I think everyone not in the context of a system call o=
r vmexit
> can just call eventfd_signal_task.
>  =20
                                 ^^^^^^^^^^^^^^^^^^^^

I assume you meant s/eventfd_signal_task/eventfd_signal there?

>  =20
>>  I
>> think its dangerous to try to solve the problem with caller provided
>> info:  the caller may be ignorant of its true state.
>>    =20
>
> I assume this wasn't clear enough: the idea is that you only
> calls eventfd_signal_task if you know you are on a systemcall path.
> If you are ignorant of the state, call eventfd_signal.
>  =20

Well, its not a matter of correctness.  Its more for optimal
performance.  If I have PCI pass-though injecting interrupts from
hardirq in mainline, clearly eventfd_signal() is proper.  In -rt, the
hardirq is transparently converted to a kthread, so technically
eventfd_signal_task() would work (at least for the can_sleep() part, not
for current->mm per se).  But in this case, the PCI logic would not know
it was converted to a kthread.  It all happens transparently in the
low-level code and the pci code is unmodified.

In this case, your proposal would have the passthrough path invoking
irqfd with eventfd_signal().  It  would therefore still shunt to a
workqueue to inject the interrupt, even though it would have been
perfectly fine to just inject it directly because taking
mutex_lock(&kvm->irq_lock) is legal.  Perhaps I am over-optimizing, but
this is the scenario I am concerned about and what I was trying to
address with preemptible()/can_sleep().

I think your idea is a good one to address the current->mm portion.  It
would only ever be safe to access the MM context from syscall/vmexit
context, as you point out.  Therefore, I see no problem with
implementing something like iosignalfd with eventfd_signal_task().

But accessing current->mm is only a subset of the use-cases.  The other
use-cases would include the ability to sleep, and possibly the ability
to address other->mm.  For these latter cases, I really only need the
"can_sleep()" behavior, not the full blown "can_access_current_mm()".=20
Additionally, the eventfd_signal_task() data at least for iosignalfd is
superfluous:  I already know that I can access current->mm by virtue of
the design.

So since I cannot use it accurately for the hardirq/threaded-irq type
case, and I don't actually need it for the iosignalfd case, I am not
sure its the right direction (at least for now).  I do think it might
have merit for syscal/vmexit uses outside of iosignalfd, but I do not
see a current use-case for it so perhaps it can wait until one arises.

-Greg

>  =20
>>  IMO, the ideal
>> solution needs to be something we can detect at run-time.
>>
>> Thanks Michael,
>> -Greg
>>
>>    =20
>
>
>  =20



--------------enig1DFC59B2E08587DFA7F684C3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3uDIACgkQlOSOBdgZUxlwKwCePg1HRLyvdFasYmG8zqeT6MPE
JxQAnR9tT01lZD/5irg/UJLiz9sr4K+N
=0LDm
-----END PGP SIGNATURE-----

--------------enig1DFC59B2E08587DFA7F684C3--
