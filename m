Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbZFQVs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbZFQVs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZFQVsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:48:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40055 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZFQVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:48:16 -0400
Message-ID: <4A39649C.4020602@novell.com>
Date: Wed, 17 Jun 2009 17:48:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE5A996B14EC37045C48942E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE5A996B14EC37045C48942E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 17 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>
>>    =20
>>> How much the (possible, but not certain) kernel thread context switch=
 time=20
>>> weighs in the overall KVM IRQ service time?
>>>  =20
>>>      =20
>> Generally each one is costing me about 7us on average.  For something
>> like high-speed networking, we have a path that has about 30us of
>> base-line overhead.  So one additional ctx-switch puts me at base+7 ( =
=3D
>> ~37us), two puts me in base+2*7 (=3D ~44us).  So in that context (no p=
un
>> intended ;), it hurts quite a bit.  I'll be the first to admit that no=
t
>> everyone (most?) will care about latency, though.  But FWIW, I do.
>>    =20
>
> And how a frame reception is handled in Linux nowadays?
>  =20

I am not clear on what you are asking here.  So in case this was a
sincere question on how things work, here is a highlight of the typical
flow of a packet that ingresses on a physical adapter and routes to KVM
via vbus.

a) interrupt from eth to host wakes the cpu out of idle, enters
interrupt-context.
b) ISR runs, disables interrupts on the eth, schedules softirq-net-rx
c) ISR completes, kernel checks softirq state before IRET, runs pending
softirq-net-rx in interrupt context to NAPI-poll the ethernet
d) packet is pulled out of eth into a layer-2 bridge, and switched to
the appropriate switch-port (which happens to be a venet-tap (soon to be
virtio-net based) device.  The packet is queued to the tap as an xmit
request, and the tap's tx-thread is awoken.
e) the xmit call returns, the napi-poll completes, and the
softirq-net-rx terminates.  The kernel does an IRET to exit interrupt
context.
f) the scheduler runs and sees the tap's tx-thread is ready to run,
schedules it in.
g) the tx-thread awakens, dequeues the posted skb, copies it to the
virtio-ring, and finally raises an interrupt on irqfd with eventfd_signal=
().

At this point, all of the data has been posted to the virtio-ring in
shared memory between the host and guest.  All that is left is to inject
the interrupt so the guest knows to process the ring.  We call the
eventfd_signal() from kthread context.  However, the callback to inject
the interrupt is invoked with the wqh spinlock held so we are forced to
defer the interrupt injection to a workqueue so the kvm->lock can be
safely acquired.  This adds additional latency (~7us) in a path that is
only a handful of microseconds to being with.  I can post LTTV
screenshots, if it would be helpful to visualize this.

The reasons we need the workqueue is:

A) kvm is currently implemented with a mutex for IRQ injection, so its
sleepy
B) the wqh used in eventfd wake_up() creates an non-preemptible section
when the callback is invoked.

We can (and should) address (A), but this is but one example in a common
pattern.  We will run into similar issues in other places (such as with
iosignalfd), so I would like to address (B) as well.  My patch attempts
to do that by re-implementing the callback mechanism as something other
than wait-queue based. It then adds a wait-queue as a default client of
the new interface.

Therefore, the eventfd clients that want traditional vanilla wakeups can
go right ahead and use the non-preemptible wait-queue methods as they
always have.  However, the clients that want (potentially) preemptive
callbacks can use the new interface: eventfd_notifier_register(), armed
with the knowledge that it can only sleep if the eventfd_signal() caller
was not in-atomic at the time.  Thus the dynamic state check ala
preemptible().  Without the check, the client should assume it is not
preemptible, as always.
>
>
>  =20
>> True, but thats the notifiee's burden, not eventfd's.  And its always
>> going to be opt-in.  Even today, someone is free to either try to slee=
p
>> (which will oops on the might_sleep()), ...
>>    =20
>
> No, today you just can't sleep. As you can't sleep in any=20
> callback-registered wakeups, like epoll, for example.
>  =20

Right, understood, and note that this is precisely why I said it would
oops.  What I was specifically trying to highlight is that its not like
this change imposes new requirements on the existing callbacks.  I also
wanted to highlight that its not really eventfd's concern what the
callback tries to do, per se (if it wants to sleep it can try, it just
wont work).  Any reasonable wakeup callback in existence would already
assume it cannot sleep, and they wouldn't even try to begin with.

On the other hand, what I am introducing here (specifically to eventfd
callbacks, not wait-queues [*]) is the possibility of removing this
restriction under the proper circumstances.  It would only be apparent
of this change iff the callback in question tried to test for this (e.g.
checking preemptible()) state.  It is thus opt-in, and existing code
does not break.

Thanks Davide,
-Greg

[*]: I contemplated solving this problem generally at the wait-queue
level, but quickly abandoned the idea.  The reason is that something
like *RCU has the properties of being particularly lightweight in the
fast/common/read-path, but being particularly heavyweight in the
slow/uncommon/writer-path.  Contrast that with something like a
traditional lock/mutex which is middleweight in all circumstances.

Something like a wait-queue has a heavy dose of both "writers" (tasks
being added to the queue) as well as "readers" (walking the queue to
invoke callbacks).  RCU would be particularly painful here.  Contrast
this to the way I wrote the patch for eventfd:  The "writer" path is
pretty rare ("add me to be notified" generally happens once at eventfd
init), whereas the "reader" path ("tell me when someone signals") is
fairly common.  RCU is a good candidate here to get rid of the spinlock
held during the walk, while still maintaining thread-saftey w.r.t. the
notifier list.  Therefore I think updating eventfd makes more sense than
the more general case of wait-queues.  More importantly, I do not think
this compromises the integrity of eventfd.  Its applicable for a general
signaling idiom, IMHO, and its why I am comfortable pushing the patch
out to you.





--------------enigEE5A996B14EC37045C48942E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko5ZJwACgkQlOSOBdgZUxn5xQCdGXUbOQmtZI2/HaoXw6r6q3oS
wfIAnRdclxYCiKtx9MPpFIUNqY5lyrCr
=tZmd
-----END PGP SIGNATURE-----

--------------enigEE5A996B14EC37045C48942E--
