Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZHXV2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZHXV2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZHXV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:28:52 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:35808 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZHXV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=jBgm9htnMe564z7y8OPR/q0SuCU8laNaoE0EezX63VAvWRMwIFvT3YbfJX5IbzVvgt
         ztTdEzUlo+vXk0+7Er4K3AfILXjHrcG94sTPvTWOvs81RyLwrSHnRZluhKDOy+tFLHh5
         cLJ/Coo85gAcordR79kdJsT8eqZ27+BgQiTsM=
Message-ID: <4A93060F.10506@gmail.com>
Date: Mon, 24 Aug 2009 17:28:47 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: alacrityvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com> <4A8E7D32.8040209@gmail.com> <4A92E3B1.5080002@codemonkey.ws> <4A92F158.9050003@gmail.com>
In-Reply-To: <4A92F158.9050003@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9A56BD77621679BE9071DB22"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9A56BD77621679BE9071DB22
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Anthony Liguori wrote:
>> Fundamentally, how is this different than the virtio->add_buf concept?=

>=20
> From my POV, they are at different levels.  Calling vbus->shm() is for
> establishing a shared-memory region including routing the memory and
> signal-path contexts.  You do this once at device init time, and then
> run some algorithm on top (such as a virtqueue design).
>=20
> virtio->add_buf() OTOH, is a run-time function.  You do this to modify
> the shared-memory region that is already established at init time by
> something like vbus->shm().  You would do this to queue a network
> packet, for instance.
>=20
> That said, shm-signal's closest analogy to virtio would be vq->kick(),
> vq->callback(), vq->enable_cb(), and vq->disable_cb().  The difference
> is that the notification mechanism isn't associated with a particular
> type of shared-memory construct (such as a virt-queue), but instead can=

> be used with any shared-mem algorithm (at least, if I designed it prope=
rly).
>=20
> The closest analogy for vbus->shm() to virtio would be
> vdev->config->find_vqs().  Again, the difference is that the algorithm
> (ring, etc) is not dictated by the call.  You then overlay something
> like virtqueue on top.

BTW: Another way to think of this is that virtio->add_buf() is really
"buffer assignment", whereas "vbus->shm()" is "buffer sharing".  The
former is meant to follow an "assign, consume, re-assign, reclaim"
model, where the changing pointer ownership implicitly serializes the
writability of the buffer.  Its used (quite effectively) for things like
passing a network-packet around.

Conversely, the latter case ("buffer sharing") is designed for
concurrent writers.  Its used for things like ring-metadata,
shared-table designs, etc.  Anything that generally is designed for a
longer-term, parallel update model, instead of a consume/reclaim model.

Whether we realize it or not, we generally build buffer-assignment
algorithms on top of buffer-sharing algorithms.  Therefore, while virtio
technically has both of these components, it only exposes the former
(buffer-assignment) as a user-extensible ABI (vq->add_buf).  The latter
(buffer-sharing) is inextricably linked to the underlying virtqueue ABI
(vdev->find_vqs) (or, at least it is today).

This is why I keep emphasizing that they are different layers of the
same stack.  From a device point of view, virtio adds a robust ring
model with buffer-assignment capabilities, support for scatter-gather,
etc.  Vbus underneath it provides a robust buffer-sharing design with
considerations for things like end-to-end prioritization, mitigation of
various virt-like inefficiencies (hypercalls, interrupts, eois, spurious
re-signals), etc.

The idea is you can then join the two together to do something like
build 8-rx virtqueues for your virtio-net to support prio.  If you take
these things into consideration on the backend design as well, you can
actually tie it in end-to-end to gain performance and capabilities not
previously available in KVM (or possibly any virt platform).

HTH,

Kind Regards,
-Greg


--------------enig9A56BD77621679BE9071DB22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqTBg8ACgkQP5K2CMvXmqE1YQCffFZn+ZfRE06URRotS5Z1d2ah
Oi8An02GIPCibUehe7xy9H6GdykyGRfg
=/Uwl
-----END PGP SIGNATURE-----

--------------enig9A56BD77621679BE9071DB22--
