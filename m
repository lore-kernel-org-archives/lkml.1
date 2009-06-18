Return-Path: <linux-kernel-owner+w=401wt.eu-S1763982AbZFROB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763982AbZFROB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbZFROBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:01:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59630 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZFROBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:01:18 -0400
Message-ID: <4A3A48AB.2080206@novell.com>
Date: Thu, 18 Jun 2009 10:01:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com> <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig44993618D615FFC0EF4417B9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig44993618D615FFC0EF4417B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 17 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> I am not clear on what you are asking here.  So in case this was a
>> sincere question on how things work, here is a highlight of the typica=
l
>> flow of a packet that ingresses on a physical adapter and routes to KV=
M
>> via vbus.
>>
>> a) interrupt from eth to host wakes the cpu out of idle, enters
>> interrupt-context.
>> b) ISR runs, disables interrupts on the eth, schedules softirq-net-rx
>> c) ISR completes, kernel checks softirq state before IRET, runs pendin=
g
>> softirq-net-rx in interrupt context to NAPI-poll the ethernet
>> d) packet is pulled out of eth into a layer-2 bridge, and switched to
>> the appropriate switch-port (which happens to be a venet-tap (soon to =
be
>> virtio-net based) device.  The packet is queued to the tap as an xmit
>> request, and the tap's tx-thread is awoken.
>> e) the xmit call returns, the napi-poll completes, and the
>> softirq-net-rx terminates.  The kernel does an IRET to exit interrupt
>> context.
>> f) the scheduler runs and sees the tap's tx-thread is ready to run,
>> schedules it in.
>> g) the tx-thread awakens, dequeues the posted skb, copies it to the
>> virtio-ring, and finally raises an interrupt on irqfd with eventfd_sig=
nal().
>>    =20
>
> Heh, Gregory, this isn't a job interview. You didn't have to actually=20
> detail everything ;)  Glad you did though, so we've something to talk=20
> later.
>  =20

:)

>
>
>  =20
>> At this point, all of the data has been posted to the virtio-ring in
>> shared memory between the host and guest.  All that is left is to inje=
ct
>> the interrupt so the guest knows to process the ring.  We call the
>> eventfd_signal() from kthread context.  However, the callback to injec=
t
>> the interrupt is invoked with the wqh spinlock held so we are forced t=
o
>> defer the interrupt injection to a workqueue so the kvm->lock can be
>> safely acquired.  This adds additional latency (~7us) in a path that i=
s
>> only a handful of microseconds to being with.  I can post LTTV
>> screenshots, if it would be helpful to visualize this.
>>    =20
>
> So, what you're trying to say, is that the extra wakeup required by you=
r=20
> schedule_work() processing, makes actually a difference in the time it =

> takes to go from a) to g),

Yes

>  where there are at least two other kernel=20
> thread wakeups?
>  =20
Actually there is only one (the tx-thread) aside from the eventfd
imposed workqueue one.  Incidentally, I would love to get rid of the
other thread too, so I am not just picking on eventfd ;).  The other is
a lot harder since it has to update the virtio-ring and may need to page
in guest memory to do so.


> Don't think in terms of microbenchs,

I'm not.  This goes directly to end-application visible performance.=20
These types of bottlenecks directly affect the IOPS rate in quantifiable
ways of the subsystem in question (and once I re-stablize the vbus tree
against the latest kvm/*fd code, I will post some numbers).  This is
particularly true for request-response type operations where stack
latency is the key gating factor.  Consider things like high-performance
shared-nothing clusters to a ramdisk (yes, these exist and have
relevance).  The overhead of the subsystem can be very low, and is
usually gated by the transaction throughput, which is gated by the IOPS
rate of the medium.  A 7us bump when we are only talking about dozens of
microseconds overall is a huge percentage.  Other examples might be
high-resolution clock sync (ala ptpd) or FSI trading applications.

The ultimate goal here is to get something like a KVM guest on par with
baremetal to allow the convergence of the HPC space with the
data-center/cloud trend of utilizing VMs as the compute fabric.=20
Baremetal doesn't have a similar context switch in its stack, and these
little microsecond bumps here and there are the reason why we are not
quite at baremetal levels today with KVM.  Therefore, I am working
through trying to eliminate them.

To flip it around on you: try telling a group like the netdev guys that
they should put extra context switches into the stack because they don't
really matter.  Be sure to wear extra thick asbestos. ;)

>  think in how much are those 7us (are=20
> they? really? this is a sync, on-cpu, kernel thread, wake up) are=20
> impacting the whole path.
> Everything looks worthwhile in microbenches.
>
>
>
>
>  =20
>> Right, understood, and note that this is precisely why I said it would=

>> oops.  What I was specifically trying to highlight is that its not lik=
e
>> this change imposes new requirements on the existing callbacks.  I als=
o
>> wanted to highlight that its not really eventfd's concern what the
>> callback tries to do, per se (if it wants to sleep it can try, it just=

>> wont work).  Any reasonable wakeup callback in existence would already=

>> assume it cannot sleep, and they wouldn't even try to begin with.
>>
>> On the other hand, what I am introducing here (specifically to eventfd=

>> callbacks, not wait-queues [*]) is the possibility of removing this
>> restriction under the proper circumstances.  It would only be apparent=

>> of this change iff the callback in question tried to test for this (e.=
g.
>> checking preemptible()) state.  It is thus opt-in, and existing code
>> does not break.
>>    =20
>
> The interface is just ugly IMO.

Well, everyone is of course entitled to an opinion, but with all due
respect I think you are looking at this backwards. ;)

>  You have eventfd_signal() that can sleep,=20
> or not, depending on the registered ->signal() function implementations=
=2E
> This is pretty bad, a lot worse than the theoretical us spent in the=20
> schedule_work() processing.
>  =20

I wouldn't describe it that way.  Whether eventfd_signal() sleeps or not
even under your control as it is.  Really what we have is an interface
(eventfd_signal()) that must support being invoked from atomic-context.=20
As an interface designer, you should never be saying "can this sleep",
but rather "what contexts is it legal to call this interface".   You
have already spec'd that eventfd_signal() is atomic-safe, and I am not
proposing to change that.  It is, and always will be (unless we screw
up) atomic safe.

Consider kmalloc(GFP_KERNEL), and kmalloc(GFP_ATOMIC).  The former says
you must call this from process context, and the latter says you may
call it from atomic context.  If you think about it, this is technically
orthogonal to whether it can sleep or not, even though people have
become accustomed to associating atomic =3D=3D cant-sleep, because today
that is true (at least in mainline).  As a counter example, in -rt,
atomic context *is* process context, and kmalloc(GFP_ATOMIC) can in fact
sleep.  But all the code still works unmodified because -rt is still
ensuring that the interface contract is met: it works in atomic-context
(its just that atomic-context is redefined ;)

So, all that aside: I restate that eventfd should *not* care about what
its clients do, as long as they meet the requirements of the interface.=20
In this case, the requirement is that they need to work from atomic
context (and with my proposal, they still will).  Its really a question
of should eventfd artificially create an atomic context in some kind of
attempt to enforce that?  The answer, IMO, is that it shouldn't if it
doesn't have to, and there are already community accepted patterns (e.g.
RCU) for accomplishing that.=20

One could also make a secondary argument that holding a spinlock across
a critical section of arbitrary complexity is probably not ideal.  Its
fine for quick wake_ups as you originally designed eventfd for.=20
However, now that we are exploring the generalization of the callback
interface beyond simple wake-ups, this should probably be re-evaluated
independent of my current requirements for low-latency.

The fact is that eventfd is a really neat general signaling idiom.=20
However, its currently geared towards "signaling =3D wakeup".  As we have=

proven with this KVM *fd effort, this is not necessarily accurate to
describe all use cases, nor is it optimal.  I'd like to address that.=20
An alternative, of course, is that we make a private anon-fd solution
within KVM.  However, it will be so similar to eventfd so it just seems
wasteful if it can be avoided.

Kind Regards,
-Greg


--------------enig44993618D615FFC0EF4417B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6SKsACgkQlOSOBdgZUxlzOwCgi44jGQF6qOyJhfvZHtdfnvh6
q5gAnRINz4R+rZFL+JL2/Q4UQjXPGdqT
=obqI
-----END PGP SIGNATURE-----

--------------enig44993618D615FFC0EF4417B9--
