Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZLUQ5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZLUQ5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZLUQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:56:59 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56509 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbZLUQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=MQ2rlCkhtpjKsiTsSFcBGuN07wVMYKedfFcuMckgghIgARNKMz+rduM+UYDpfRk3hx
         xljQZmFIhUkRfo3jGnCirFmTF/PpiyM+GAX5Eugu1ENOGbMm+I7cnTRWUBSR92bhdAaM
         qbJ602rW74TgfGV7dyDr1+ofa3KHff3iinImo=
Message-ID: <4B2FA8D4.3050206@gmail.com>
Date: Mon, 21 Dec 2009 11:56:52 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA4F2.8000401@redhat.com>
In-Reply-To: <4B2FA4F2.8000401@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7301845D4EE6557F3C7FF88"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7301845D4EE6557F3C7FF88
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/21/09 11:40 AM, Avi Kivity wrote:
> On 12/21/2009 06:37 PM, Anthony Liguori wrote:
>> Since virtio-pci supports MSI-X, there should be no IO exits on
>> host->guest notification other than EOI in the virtual APIC.  This is
>> a light weight exit today and will likely disappear entirely with
>> newer hardware.
>=20
> I'm working on disappearing EOI exits on older hardware as well.  Same
> idea as the old TPR patching, without most of the magic.
>=20

While I applaud any engineering effort that results in more optimal
execution, if you are talking about what we have discussed in the past
its not quite in the same league as my proposal.

You are talking about the ability to optimize the final EOI if there are
no pending interrupts remaining, right?  The problem with this approach
is it addresses the wrong side of the curve: That is, it optimizes the
code as its about to go io-idle.  You still have to take an extra exit
for each injection during the heat of battle, which is when you actually
need it most.

To that front, what I have done is re-used the lockless shared-memory
concept for even "interrupt injection".  Lockless shared-memory rings
have the property that both producer and consumer can simultaneously
manipulate the ring.  So what we do in alacrityvm is deliver shm-signals
(shm-signal =3D=3D "interrupt" in vbus) over a ring so that the host can
inject a signal to a running vcpu and a vcpu can complete an
ack/re-inject cycle directly from vcpu context.  Therefore, we only need
a physical IDT injection when the vcpu is io-idle transitioning to
io-busy, and remain completely in parallel guest/host context until we
go idle again.

That said, your suggestion would play nicely with the above mentioned
scheme, so I look forward to seeing it in the tree.  Feel free to send
me patches for testing.

Kind Regards,
-Greg


--------------enigC7301845D4EE6557F3C7FF88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksvqNQACgkQP5K2CMvXmqG5awCeOuLFbi2MEgrRDRqh1mitBPXn
HcMAnjSTCWIGaQHXyxAOr5XJZ/yw47mr
=Y2Zz
-----END PGP SIGNATURE-----

--------------enigC7301845D4EE6557F3C7FF88--
