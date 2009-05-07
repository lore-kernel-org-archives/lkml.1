Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbZEGUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbZEGUHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZEGUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:07:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50718 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZEGUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:07:22 -0400
Message-ID: <4A033F6E.3010604@novell.com>
Date: Thu, 07 May 2009 16:07:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <4A033101.8050106@gmail.com> <4A0339D2.3050600@redhat.com>
In-Reply-To: <4A0339D2.3050600@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18DE39683411468A55AA2DEE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18DE39683411468A55AA2DEE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> Don't - it's broken.  It will also catch device assignment mmio and
>>> hypercall them.
>>>
>>>    =20
>> Ah.  Crap.
>>
>> Would you be conducive if I continue along with the dynhc() approach
>> then?
>>  =20
>
> Oh yes.  But don't call it dynhc - like Chris says it's the wrong
> semantic.
>
> Since we want to connect it to an eventfd, call it HC_NOTIFY or
> HC_EVENT or something along these lines.  You won't be able to pass
> any data, but that's fine.  Registers are saved to memory anyway.
Ok, but how would you access the registers since you would presumably
only be getting a waitq::func callback on the eventfd.  Or were you
saying that more data, if required, is saved in a side-band memory
location?  I can see the latter working.  I can't wrap my head around
the former.

>
> And btw, given that eventfd and the underlying infrastructure are so
> flexible, it's probably better to go back to your original "irqfd gets
> fd from userspace" just to be consistent everywhere.
>
> (no, I'm not deliberately making you rewrite that patch again and
> again... it's going to be a key piece of infrastructure so I want to
> get it right)

Ok, np.  Actually now that Davide showed me the waitq::func trick, the
fd technically doesn't even need to be an eventfd per se.  We can just
plain-old "fget()" it and attach via the f_ops->poll() as I do in v5.=20
Ill submit this later today.

>
>
> Just to make sure we have everything plumbed down, here's how I see
> things working out (using qemu and virtio, use sed to taste):
>
> 1. qemu starts up, sets up the VM
> 2. qemu creates virtio-net-server
> 3. qemu allocates six eventfds: irq, stopirq, notify (one set for tx
> ring, one set for rx ring)
> 4. qemu connects the six eventfd to the data-available,
> data-not-available, and kick ports of virtio-net-server
> 5. the guest starts up and configures virtio-net in pci pin mode
> 6. qemu notices and decides it will manage interrupts in user space
> since this is complicated (shared level triggered interrupts)
> 7. the guest OS boots, loads device driver
> 8. device driver switches virtio-net to msix mode
> 9. qemu notices, plumbs the irq fds as msix interrupts, plumbs the
> notify fds as notifyfd
> 10. look ma, no hands.
>
> Under the hood, the following takes place.
>
> kvm wires the irqfds to schedule a work item which fires the
> interrupt.  One day the kvm developers get their act together and
> change it to inject the interrupt directly when the irqfd is signalled
> (which could be from the net softirq or somewhere similarly nasty).
>
> virtio-net-server wires notifyfd according to its liking.  It may
> schedule a thread, or it may execute directly.
>
> And they all lived happily ever after.

Ack.  I hope when its all said and done I can convince you that the
framework to code up those virtio backends in the kernel is vbus ;)  But
even if not, this should provide enough plumbing that we can all coexist
together peacefully.

Thanks,
-Greg


--------------enig18DE39683411468A55AA2DEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDP24ACgkQlOSOBdgZUxm69wCcCPCev2+s3BSkxXuodxNvLYGc
4DkAn0NQIo1aYAuWcu6z3/TeDQ+1uoN7
=x+MJ
-----END PGP SIGNATURE-----

--------------enig18DE39683411468A55AA2DEE--
