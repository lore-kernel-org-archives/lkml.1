Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZHUKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZHUKzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZHUKzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:55:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:18689 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZHUKzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=YKsGwTzC4gq9TjvSklCEkmc+tK62QPS4PWIlQE5VVMZ14hQWTIwQMk33jxqInC/iPl
         paqGD120zcwmVhUeUWr6o2mL2L6Zkz2dIXfl/UmdLJvtXX1U5d9UAauXMLkkMxNdR8qc
         Fn8krW02SwDWoQs6iLTnUHvYzX1kUCZtNJ0fU=
Message-ID: <4A8E7D32.8040209@gmail.com>
Date: Fri, 21 Aug 2009 06:55:46 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: alacrityvm-devel@lists.sourceforge.net
CC: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com>
In-Reply-To: <4A8B7F17.6050100@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig21C7E34769AEC051A0D5C62A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig21C7E34769AEC051A0D5C62A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Ingo Molnar wrote:
>>
>> We all love faster code and better management interfaces and tons=20
>> of your prior patches got accepted by Avi. This time you didnt even=20
>> _try_ to improve virtio.
>=20
> Im sorry, but you are mistaken:
>=20
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/02443.html
>=20

BTW: One point that I forgot to point out in this most recent thread
that I am particularly proud of here is the design of the vbus
shared-memory model.  Despite some claims to the contrary; not only is
it possible to improve virtio with vbus (as evident by the patch
referenced above)...I specifically designed vbus with virtio
considerations in mind from the start!  In fact, the design is conducive
to accelerating a variety of other models as well.  Read on for details.

Vbus was designed it to be _agnostic_ to the shm algorithm in general.
This allows you to, of course, run ring algorithms (such as virtqueues,
or IOQs), but really any other designs as well, such as shared-tables, et=
c.

A guest driver sees the following interface:

struct vbus_device_proxy_ops {
	int (*open)(struct vbus_device_proxy *dev, int version, int flags);
	int (*close)(struct vbus_device_proxy *dev, int flags);
	int (*shm)(struct vbus_device_proxy *dev, int id, int prio,
		   void *ptr, size_t len,
		   struct shm_signal_desc *sigdesc, struct shm_signal **signal,
		   int flags);
	int (*call)(struct vbus_device_proxy *dev, u32 func,
		    void *data, size_t len, int flags);
	void (*release)(struct vbus_device_proxy *dev);
};

note the ops->shm() method.  This allows the driver to register some
arbitrary pointer (ptr, len) with the host, optionally embedding a
shm_signal_desc object in the memory.  If "sigdesc" is non-null, the
connector will allocate and return a fully formed shm_signal object in
**signal.

shm-signal (posted in patch 1/6, I believe) is a generalization of the
basic mechanism you need for emitting and catching events via any
shared-memory based design.  It includes interrupt/hypercall mitigation
support which is independent of the actual shm algorithm (e.g. ring,
table, etc).  This means that we can get the event mitigation code (e.g.
disable unecessary interrupts/hypercalls, prevent spurious re-calls,
etc) in once place (and, ideally, correct), and things like the ring
algorithm (or table design, etc) can focus on their value-add, instead
of re-inventing the mitigation code each time.

You can then build your higher-layer algorithms (rings, tables, etc) in
terms of the shm-signal library.  As a matter of fact, if you look at
the patch referenced above, it implements the virtqueue->kick() method
on top of shm-signal.  IOQs follow a similar pattern.  And the RT
enhancements will, for instance, be using a table design for the
scheduler/interrupt control.

In short, vbus is the result of my experience in dealing with issues
like IO in virt.  I thought long and hard about where the issues were
for high-performance, low-latency, software-to-software IO for a
wide-variety of applications and environments.  I then tried to
systematically solve those problems at various key points in the stack
to promote maximum flexibility and reuse of those enhancements.  So we
see things like this generalization of async event mitigation with the
shm/shm-signal design, low-latency "hypercalls", reusable backend models
(which support both a variety of virt, as well as physical system use), e=
tc.

Part of this flexibility means that we do not want to rely on something
like PCI because it's not necessarily available/logical in all
platforms/environments.  So rather than force such environments to fit
into a PCI ABI, we start over again and offer an ABI specific to the
actual goals (high-performance, low-latency, software-to-software IO).

Yes, that means we will possibly take some lumps in the short-term
before these concepts and support for them are ubiquitous (like PCI, USB
are today).  But, like all things, you have to start somewhere.  The PCI
guys didn't try to make PCI look like ISA, and the USB guys didn't try
to make USB look like PCI.  It took a little while for support for such
notions to catch on, but eventually all relevant platforms supported
them.  I am going for the same thing here.  Sometimes, the existing
model just doesn't fit well and you have to re-evaluate.

I hope that this helps clarify some of the design of vbus and why I
believe it to be worth considering.  I will plan on taking this email as
the first entry on the wiki as a "design series" (or something like
that) and update it regularly with other aspects of the design.

Kind Regards,
-Greg






--------------enig21C7E34769AEC051A0D5C62A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqOfTIACgkQP5K2CMvXmqGR/wCdE5coQLIMFXo8l78KmfNuruOa
9mkAnit5+LOWEex73vCDs6so4eC5d7Fw
=UxVo
-----END PGP SIGNATURE-----

--------------enig21C7E34769AEC051A0D5C62A--
