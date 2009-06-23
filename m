Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZFWBED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZFWBED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZFWBDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:03:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:14547 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZFWBDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=iEeuPHgEwF32CfebeWAKYQiflQqSdj2U4r1C2s4kgS69E8M9vOE2NbyWtHOa/RTlpB
         tikBPDoVnU88yeWlx7JPocUJEwOFJL2E1TYZ0BEmTvzdJoNOZwiTGnSkoEbGIUE3clQJ
         frpH2PxGjz1fwIcgcwVGmZl605PaYQldFRPuI=
Message-ID: <4A4029F7.6070502@gmail.com>
Date: Mon, 22 Jun 2009 21:03:51 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig20A44C819EE54E5F4A3A7FE9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20A44C819EE54E5F4A3A7FE9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> So up in userspace, the vbus pci-device would have an open reference t=
o
>> the kvm guest (derived from /dev/kvm) and an open reference to a vbus
>> (derived from /dev/vbus).  Lets call these kvmfd, and vbusfd,
>> respectively.  For something like an interrupt, we would hook the poin=
t
>> where the PCI-MSI interrupt is assigned, and would do the following:
>>
>> gsi =3D kvm_irq_route_gsi();
>> fd =3D eventfd(0, 0);
>> ioctl(kvmfd, KVM_IRQFD_ASSIGN, {fd, gsi});
>> ioctl(vbusfd, VBUS_SHMSIGNAL_ASSIGN, {sigid, fd});
>>
>> So userspace orchestrated the assignment of this one eventfd to a KVM
>> consumer, and a VBUS producer.  The two subsystems do not care about t=
he
>> details of the other side of the link, per se.  VBUS just knows that i=
t
>> can eventfd_signal() its memory region to tell whomever is listening
>> that it changed.  Likewise, KVM just knows to inject "gsi" when it get=
s
>> signalled.  You could equally have given "fd" to a userspace thread fo=
r
>> either producer or consumer roles, or any other combination.
>>
>> If we were doing PCI-passthough, substitute the last SHMSIGNAL_ASSIGN
>> ioctl call with some PCI_PASSTHROUGH_ASSIGN verb and you get the idea.=

>>
>> The important thing is that once this is established, userspace doesn'=
t
>> necessarily care about the fd anymore.  So now the question is: do we
>> keep it around for other things?  Do we keep it around because we don'=
t
>> want KVM to see the POLLHUP, or do we address the "release" code so th=
at
>> it works even if userspace issued close(fd) at this point.  I am not
>> sure what the answer is, but this is the scenario we are concerned wit=
h
>> in this thread.  In the example above, vbus is free to produce events =
on
>> its eventfd until it gets a SHMSIGNAL_DEASSIGN request.
>>    =20
>
> I see.
> The thing remains, that in order to reliably handle generic=20
> producer/consumer scenarios you'd need a reference counting similar to =

> pipes, where the notion of producer and consumer is very well defined.
>  =20

I see your point.

Well, I think the more important thing here is that we address the
races, and add support for DEASSIGN.  We can do both of those things
with any of the patches that you and I have been kicking around.  So
what I propose is that we move forward with whatever patch you bless as
proper for now.  This producer-release issue is pretty minor in the
grand scheme of things.  We can always just have userspace hold the fd.

I can either take in the last one you sent, or it sounds like you wanted
to possibly do another round of cleanup?  Whatever the case may be, let
me know and we can coordinate with Andrew/Avi on what tree to pull it
into.  It sounds like riding in kvm.git is the perhaps the most logical.

Thanks Davide,
-Greg


--------------enig20A44C819EE54E5F4A3A7FE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAKfcACgkQP5K2CMvXmqGZTwCePf2budtlHlQiaIJ7ArQMDg/T
HmkAoIeKaCI68M5dn9s3vCE/ONkq4zDX
=xHav
-----END PGP SIGNATURE-----

--------------enig20A44C819EE54E5F4A3A7FE9--
