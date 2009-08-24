Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZHXUAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZHXUAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZHXUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:00:30 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:47959 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZHXUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=SvgLO3GQrMYbNrqwVTJsjzaTC3mSZB745QF0RY1XzNBIgDGA8NXPnbQBRFjXrUo03M
         OyhNdOgFbOgWVp6YY7S/rNIgNGbE6ZOTa51YoMA6eE8+jolbV/xjQK7vUzLNMmfcWYxP
         gax8UWn7eL9FwlMEOWmjVTptO6M9nhM6CWoiA=
Message-ID: <4A92F158.9050003@gmail.com>
Date: Mon, 24 Aug 2009 16:00:24 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: alacrityvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com> <4A8E7D32.8040209@gmail.com> <4A92E3B1.5080002@codemonkey.ws>
In-Reply-To: <4A92E3B1.5080002@codemonkey.ws>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig720FE92AA81E9EAD776B232B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig720FE92AA81E9EAD776B232B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Anthony,

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> Gregory Haskins wrote:
>> =20
>>> Ingo Molnar wrote:
>>>   =20
>>>> We all love faster code and better management interfaces and tons of=

>>>> your prior patches got accepted by Avi. This time you didnt even
>>>> _try_ to improve virtio.
>>>>      =20
>>> Im sorry, but you are mistaken:
>>>
>>> http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/02443.html
>>>
>>>    =20
>>
>> BTW: One point that I forgot to point out in this most recent thread
>> that I am particularly proud of here is the design of the vbus
>> shared-memory model.  Despite some claims to the contrary; not only is=

>> it possible to improve virtio with vbus (as evident by the patch
>> referenced above)...I specifically designed vbus with virtio
>> considerations in mind from the start!  In fact, the design is conduci=
ve
>> to accelerating a variety of other models as well.  Read on for detail=
s.
>>
>> Vbus was designed it to be _agnostic_ to the shm algorithm in general.=

>> This allows you to, of course, run ring algorithms (such as virtqueues=
,
>> or IOQs), but really any other designs as well, such as shared-tables,=

>> etc.
>>
>> A guest driver sees the following interface:
>>
>> struct vbus_device_proxy_ops {
>>     int (*open)(struct vbus_device_proxy *dev, int version, int flags)=
;
>>     int (*close)(struct vbus_device_proxy *dev, int flags);
>>     int (*shm)(struct vbus_device_proxy *dev, int id, int prio,
>>            void *ptr, size_t len,
>>            struct shm_signal_desc *sigdesc, struct shm_signal **signal=
,
>>            int flags);
>>     int (*call)(struct vbus_device_proxy *dev, u32 func,
>>             void *data, size_t len, int flags);
>>     void (*release)(struct vbus_device_proxy *dev);
>> };
>>
>> note the ops->shm() method.  This allows the driver to register some
>> arbitrary pointer (ptr, len) with the host, optionally embedding a
>> shm_signal_desc object in the memory.  If "sigdesc" is non-null, the
>> connector will allocate and return a fully formed shm_signal object in=

>> **signal.
>>  =20
>=20
> Fundamentally, how is this different than the virtio->add_buf concept?

=46rom my POV, they are at different levels.  Calling vbus->shm() is for
establishing a shared-memory region including routing the memory and
signal-path contexts.  You do this once at device init time, and then
run some algorithm on top (such as a virtqueue design).

virtio->add_buf() OTOH, is a run-time function.  You do this to modify
the shared-memory region that is already established at init time by
something like vbus->shm().  You would do this to queue a network
packet, for instance.

That said, shm-signal's closest analogy to virtio would be vq->kick(),
vq->callback(), vq->enable_cb(), and vq->disable_cb().  The difference
is that the notification mechanism isn't associated with a particular
type of shared-memory construct (such as a virt-queue), but instead can
be used with any shared-mem algorithm (at least, if I designed it properl=
y).

The closest analogy for vbus->shm() to virtio would be
vdev->config->find_vqs().  Again, the difference is that the algorithm
(ring, etc) is not dictated by the call.  You then overlay something
like virtqueue on top.

>=20
> virtio provides a mechanism to register scatter/gather lists, associate=

> a handle with them, and provides a mechanism for retrieving notificatio=
n
> that the buffer has been processed.

Yes, and I agree this is very useful for many/most algorithms...but not
all.  Sometimes you don't want ring-like semantics, but instead want
something like an idempotent table.  (Think of things like interrupt
controllers, timers, etc).

Rings, of course, have a trait that all updates are retained in fifo
order.  For many things (e.g. network, block io, etc), this is exactly
what you want.  If I say "send packet X" now, and "send packet Y" later,
I want the system to do both (and perhaps in that order), so a ring
scheme works well.

However, sometimes you may want to say "time is now X", and later "time
is now Y".  The update value of 'X' is technically superseded by Y and
is stale.  But a ring may allow both to exist in-flight within the shm
simultaneously if the recipient (guest or host) is lagging, and the X
may be processed even though its data is now irrelevant.  What we really
want is the transform of X->Y to invalidate anything else in flight so
that only Y is visible.

So in a case like this, we may want a different algorithm.  Something
like a table which always contains the current/valid value, and a way to
signal in both directions when something interesting happens to that data=
=2E

If you think about it, a ring is a superset of this construct...the ring
meta-data is the "shared-table" (e.g. HEAD ptr, TAIL ptr, COUNT, etc).
So we start by introducing the basic shm concept, and allow the next
layer (virtio/virtqueue) in the stack to refine it for its needs.


>=20
> vbus provides a mechanism to register a single buffer with an integer
> handle, priority, and a signaling mechanism.

Again, I think we are talking about two different layers.  You would
never put entries into a virtio-ring of different priority.  This
doesn't make sense, as they would just get linearized by the fifo.

What you *would* do is possibly make multiple virtqueues, each with a
different priority (for instance, say 8-rx queues for virtio-net).

>=20
> So virtio provides builtin support for scatter/gathers whereas vbus
> models priority.  But fundamentally, they seem like almost identical
> concepts.

I would say that virtqueue and IOQ are a much closer analogy in terms of
comparison at the scatter-gather level.  The virtio device model itself
is similar to a vbus device-model except its oriented towards the
virtqueue ring design.  In addition, a big part of vbus is also what
happens _behind_ the device model.

>=20
> If we added priority to virtio->add_buf, would it be equivalent in your=

> mind functionally speaking?

As indicated above, this wouldn't be sane.  A better design (IMO) is to
use a ring per priority.

>=20
> What does one do with priority, btw?

There are, of course, many answers to that question.  One particularly
trivial example is 802.1p networking.  So, for instance, you can
classify and prioritize network traffic so that things like
control/timing packets are higher priority than best-effort HTTP.  Doing
this "right" means you have end-to-end priority within the system (e.g.
your switch/fabric, nics, interrupt controllers, etc).  Today, virt is
fairly far removed from being fully integrated in this sense, but the
vbus project is addressing this short-coming.

HTH,

Kind Regards,
-Greg


--------------enig720FE92AA81E9EAD776B232B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqS8VgACgkQP5K2CMvXmqHcAwCfVgM078DlOjrBxjkqlUqbZwlf
2YIAn0qmoOzbQa3dDkm9G9Tkpzsyk8EA
=aMKL
-----END PGP SIGNATURE-----

--------------enig720FE92AA81E9EAD776B232B--
