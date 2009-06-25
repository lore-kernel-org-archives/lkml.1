Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZFYRcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZFYRcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZFYRcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:32:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51643 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZFYRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:32:31 -0400
Message-ID: <4A43B4A6.8050001@novell.com>
Date: Thu, 25 Jun 2009 13:32:22 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: avi@redhat.com
CC: Davide Libenzi <davidel@xmailserver.org>,
       Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <200906241255.54709.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com> <200906252112.24730.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906250922530.9517@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906250922530.9517@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig00BB5D016687135EE39C46E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig00BB5D016687135EE39C46E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 25 Jun 2009, Rusty Russell wrote:
>
>  =20
>> On Thu, 25 Jun 2009 08:15:11 am Davide Libenzi wrote:
>>    =20
>>> Some components would like to know if userspace dropped the fd, and t=
ake
>>> proper action accordingly (release resources, drop module instances,
>>> etc...).
>>>      =20
>> Like to know?  Possibly.  Need to know?  Not anything I've seen so far=
=2E
>>
>> If userspace creates the fd, component grab a ref and if userspace wan=
ts that=20
>> fd completely freed must close the fd *and* tell component.  Simple, r=
ace free=20
>> and explicit.  All wins.
>>
>> As this discussion shows, doing some kind of implies non-reference is =
hard,=20
>> complex and racy.
>>    =20
>
> Easier, we agree. Not doing anything is always easier, provided the=20
> userspace interface allows for it.
> Cleaner, I'm not sure. Again, it depends from the userspace interface, =
but=20
> usually when you close(2) something, you expect the kernel to react=20
> accordingly, and not on relying on userspace issuing extra calls in ord=
er=20
> to proper cleanup the kernel context.
> This is even more true when the eventfd is the sole handle to the visis=
ble=20
> userspace interface.
> In such cases, not taking proper action on close(2) and requiring extra=
=20
> calls, would lead to designing interface with the close-no-really-i-mea=
n-it
> patterns.
>  =20

Avi,
  Davide's argument is compelling in favor of considering the latest
irqfd fixes I pushed.  You could run into weirdness if we tried to
revert to the old requirement on explicit DEASSIGN ioctl once we start
doing things like handing the fd to other apps/components.  Its cleaner
IMO to retain the implicit-deassign-on-close behavior.

Since v5 also restores optional explicit DEASSIGN support, the only
downside to accepting my patches (vs reverting POLLHUP completely) is
the complexity required to deal with POLLHUP.  But this has been
substantially reduced and clarified since yesterdays review, and I am
reasonably confident the protocol is sound.

Please take a close look at it and consider for merging, if you would.

Thanks,
-Greg



--------------enig00BB5D016687135EE39C46E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDtKYACgkQlOSOBdgZUxlzmgCaA7MYPiXjPAArCNIt9sfZsz2M
0PgAn26Hj6zMyXJGZj9BhBGnP+AW57D8
=pf8y
-----END PGP SIGNATURE-----

--------------enig00BB5D016687135EE39C46E6--
