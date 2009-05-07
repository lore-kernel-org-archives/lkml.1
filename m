Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbZEGU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbZEGU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbZEGU0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:26:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59154 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbZEGU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=AsT/4PDq4spQ/7DYGY/yyBCWz3On91Whd1PLGfULvap99vie2gr3iqqBmep/rLJsC+
         ehZtWYN2yCQ8v30zOx8bZKqBXtCtyHDcYWooD1k315iwVcdkmwB3dZWXHVfpWKOSRU2J
         6kCBKZ2EfmKqtt29p7bOTAvJB5XTAWEiAJTJw=
Message-ID: <4A0343F5.5070509@gmail.com>
Date: Thu, 07 May 2009 16:26:29 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <4A033101.8050106@gmail.com> <4A0339D2.3050600@redhat.com> <4A033F6E.3010604@novell.com> <4A03416D.8020405@redhat.com>
In-Reply-To: <4A03416D.8020405@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD9C97017455108BF2838FCB4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD9C97017455108BF2838FCB4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> Oh yes.  But don't call it dynhc - like Chris says it's the wrong
>>> semantic.
>>>
>>> Since we want to connect it to an eventfd, call it HC_NOTIFY or
>>> HC_EVENT or something along these lines.  You won't be able to pass
>>> any data, but that's fine.  Registers are saved to memory anyway.
>>>    =20
>> Ok, but how would you access the registers since you would presumably
>> only be getting a waitq::func callback on the eventfd.  Or were you
>> saying that more data, if required, is saved in a side-band memory
>> location?  I can see the latter working.=20
>
> Yeah.  You basically have that side-band in vbus shmem (or the virtio
> ring).

Ok, got it.
>
>>  I can't wrap my head around
>> the former.
>>  =20
>
> I only meant that registers aren't faster than memory, since they are
> just another memory location.
>
> In fact registers are accessed through a function call (not that that
> takes any time these days).
>
>
>>> Just to make sure we have everything plumbed down, here's how I see
>>> things working out (using qemu and virtio, use sed to taste):
>>>
>>> 1. qemu starts up, sets up the VM
>>> 2. qemu creates virtio-net-server
>>> 3. qemu allocates six eventfds: irq, stopirq, notify (one set for tx
>>> ring, one set for rx ring)
>>> 4. qemu connects the six eventfd to the data-available,
>>> data-not-available, and kick ports of virtio-net-server
>>> 5. the guest starts up and configures virtio-net in pci pin mode
>>> 6. qemu notices and decides it will manage interrupts in user space
>>> since this is complicated (shared level triggered interrupts)
>>> 7. the guest OS boots, loads device driver
>>> 8. device driver switches virtio-net to msix mode
>>> 9. qemu notices, plumbs the irq fds as msix interrupts, plumbs the
>>> notify fds as notifyfd
>>> 10. look ma, no hands.
>>>
>>> Under the hood, the following takes place.
>>>
>>> kvm wires the irqfds to schedule a work item which fires the
>>> interrupt.  One day the kvm developers get their act together and
>>> change it to inject the interrupt directly when the irqfd is signalle=
d
>>> (which could be from the net softirq or somewhere similarly nasty).
>>>
>>> virtio-net-server wires notifyfd according to its liking.  It may
>>> schedule a thread, or it may execute directly.
>>>
>>> And they all lived happily ever after.
>>>    =20
>>
>> Ack.  I hope when its all said and done I can convince you that the
>> framework to code up those virtio backends in the kernel is vbus ;)
>
> If vbus doesn't bring significant performance advantages, I'll prefer
> virtio because of existing investment.

Just to clarify: vbus is just the container/framework for the in-kernel
models.  You can implement and deploy virtio devices inside the
container (tho I haven't had a chance to sit down and implement one
yet).  Note that I did publish a virtio transport in the last few series
to demonstrate how that might work, so its just ripe for the picking if
someone is so inclined.

So really the question is whether you implement the in-kernel virtio
backend in vbus, in some other framework, or just do it standalone.

-Greg




--------------enigD9C97017455108BF2838FCB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDQ/YACgkQP5K2CMvXmqEQDACfUexyoIc7fLEVKqth2T+nVqzZ
R74An3ZgnB/pJFMrPLZgz9whw8393V7N
=3nmz
-----END PGP SIGNATURE-----

--------------enigD9C97017455108BF2838FCB4--
