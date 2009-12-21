Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZLUQE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZLUQE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZLUQE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:04:27 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:57152 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZLUQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=eozfyWsBeg9vfP6POyG9zNp+/CX++wqKq0Jjq4gcaG7ub4i+CkpWtMyvkHNQq59UMX
         7bItbZTNICdBENC6P3atBAz7katnBmASE/+/x9g40ylOUljCrPnxdF30arruAQWcA5tm
         r3I+vnP+iT4OZ7mS52yQik0zUqJRyemGS+hy4=
Message-ID: <4B2F9C85.7070202@gmail.com>
Date: Mon, 21 Dec 2009 11:04:21 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com>
In-Reply-To: <4B2F978D.7010602@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA6ABE7F8984A78C23050489"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA6ABE7F8984A78C23050489
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/21/09 10:43 AM, Avi Kivity wrote:
> On 12/21/2009 05:34 PM, Gregory Haskins wrote:
>>
>>> I think it would be fair to point out that these patches have been
>>> objected to
>>> by the KVM folks quite extensively,
>>>     =20
>> Actually, these patches have nothing to do with the KVM folks.  You ar=
e
>> perhaps confusing this with the hypervisor-side discussion, of which
>> there is indeed much disagreement.
>>   =20
>=20
> This is true, though these drivers are fairly pointless for
> virtualization without the host side support.

The host side support is available in various forms (git tree, rpm, etc)
from our project page.  I would encourage any interested parties to
check it out:

Here is the git tree

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dsummary

Here are some RPMs:

http://download.opensuse.org/repositories/devel://LLDC://alacrity/openSUS=
E_11.1/

And the main project site:

http://developer.novell.com/wiki/index.php/AlacrityVM

>=20
> I did have a few issues with the guest drivers:
> - the duplication of effort wrt virtio.  These drivers don't cover
> exactly the same problem space, but nearly so.

Virtio itself is more or less compatible with this effort, as we have
discussed (see my virtio-vbus transport, for instance).  I have issues
with some of the design decisions in the virtio device and ring models,
but they are minor in comparison to the beef I have with the virtio-pci
transport as a whole.

> - no effort at scalability - all interrupts are taken on one cpu

Addressed by the virtual-interrupt controller.  This will enable us to
route shm-signal messages to a core, under guidance from the standard
irq-balance facilities.

> - the patches introduce a new virtual interrupt controller for dubious
> (IMO) benefits

See above.  Its not fully plumbed yet, which is perhaps the reason for
the confusion as to its merits.  Eventually I will trap the affinity
calls and pass them to the host, too.  Today, it at least lets us see
the shm-signal statistics under /proc/interrupts, which is nice and is
consistent with other IO mechanisms.


>=20
>>  From my research, the reason why virt in general, and KVM in particul=
ar
>> suffers on the IO performance front is as follows: IOs
>> (traps+interrupts) are more expensive than bare-metal, and real hardwa=
re
>> is naturally concurrent (your hbas and nics are effectively parallel
>> execution engines, etc).
>>
>> Assuming my observations are correct, in order to squeeze maximum
>> performance from a given guest, you need to do three things:  A)
>> eliminate as many IOs as you possibly can, B) reduce the cost of the
>> ones you can't avoid, and C) run your algorithms in parallel to emulat=
e
>> concurrent silicon.
>>   =20
>=20
> All these are addressed by vhost-net without introducing new drivers.

No, B and C definitely are, but A is lacking.  And the performance
suffers as a result in my testing (vhost-net still throws a ton of exits
as its limited by virtio-pci and only adds about 1Gb/s to virtio-u, far
behind venet even with things like zero-copy turned off).

I will also point out that these performance aspects are only a subset
of the discussion, since we are also addressing things like
qos/priority, alternate fabric types, etc.  I do not expect you to
understand and agree where I am going per se.  We can have that
discussion when I once again ask you for merge consideration.  But if
you say "they are the same" I will call you on it, because they are
demonstrably unique capability sets.

Kind Regards,
-Greg





--------------enigBA6ABE7F8984A78C23050489
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksvnIUACgkQP5K2CMvXmqEeogCfTBPdZTYWADhSQEAkbB1/wsA+
FmUAn1gxfTCbQ30HoNTD2yiBCSI2MyPx
=6Zuc
-----END PGP SIGNATURE-----

--------------enigBA6ABE7F8984A78C23050489--
