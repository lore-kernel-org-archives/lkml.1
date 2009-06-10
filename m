Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZFJPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZFJPbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759903AbZFJPbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:31:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbZFJPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:31:47 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <200906082254.30138.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906032351.01900.rjw@sisk.pl> <1244125570.22576.78.camel@johannes.local>
	 <200906082254.30138.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TC/v+ydbMYWJzJoMOGHW"
Date: Wed, 10 Jun 2009 16:24:42 +0200
Message-Id: <1244643882.18481.62.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TC/v+ydbMYWJzJoMOGHW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 22:54 +0200, Rafael J. Wysocki wrote:
> On Thursday 04 June 2009, Johannes Berg wrote:
> > Alright, I have managed to trace this.
> >=20
> > http://johannes.sipsolutions.net/files/hibernate-delay-dmesg.txt
> >=20
> > has the dmesg, you can clearly see the delay:
> > [50265.143330] ACPI: Waking up from system sleep state S4
> > [50265.679141] HDA Intel 0000:00:08.0: restoring config space at offset=
 0x1 (was 0xb00006, writing 0xb00002)
> > [50265.689525] forcedeth 0000:00:0a.0: restoring config space at offset=
 0x1 (was 0xb00003, writing 0xb00007)
> > [50265.699775] ahci 0000:00:0b.0: restoring config space at offset 0x1 =
(was 0xb00403, writing 0xb00407)
> > [50286.294910] pci 0000:00:03.2: PME# disabled
>=20
> Quite frankly, it looks like resume_device_irqs() itself causes the delay=
 to happen.
>=20
> The next step would be to put a couple of printk()s in there and see whic=
h part
> of it triggers the delay.

--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -56,8 +56,11 @@ void resume_device_irqs(void)
                if (!(desc->status & IRQ_SUSPENDED))
                        continue;
=20
+               printk(KERN_DEBUG "lock irq %d\n", irq);
                spin_lock_irqsave(&desc->lock, flags);
+               printk(KERN_DEBUG "locked\n");
                __enable_irq(desc, irq, true);
+               printk(KERN_DEBUG "enabled\n");
                spin_unlock_irqrestore(&desc->lock, flags);
        }
 }


and I get:
[63702.285944] ACPI: Waking up from system sleep state S4
[63702.811457] HDA Intel 0000:00:08.0: restoring config space at offset 0x1=
 (was 0xb00006, writing 0xb00002)
[63702.819369] pci 0000:00:09.0: restoring config space at offset 0x7 (was =
0x228000f0, writing 0x428000f0)
[63702.827574] forcedeth 0000:00:0a.0: restoring config space at offset 0x1=
 (was 0xb00003, writing 0xb00007)
[63702.836052] ahci 0000:00:0b.0: restoring config space at offset 0x1 (was=
 0xb00403, writing 0xb00407)
[63702.845288] lock irq 9
[63702.853902] locked
[63702.862433] enabled
[63702.870967] lock irq 17
[63702.879377] locked
[63702.880964] enabled
[63702.895811] lock irq 18
[63702.903919] locked
[63702.911879] enabled
[63702.919781] lock irq 19
[63702.927595] locked
[63702.935260] enabled
[63702.942989] lock irq 20
[63702.950764] locked
[63702.958425] enabled
[63702.966061] lock irq 25
[63702.973641] locked
[63702.981102] enabled
[63722.620744] pci 0000:00:03.2: PME# disabled
[63722.628069] ohci_hcd 0000:00:04.0: PME# disabled

so it doesn't look like the delay is there.

johannes

--=-TC/v+ydbMYWJzJoMOGHW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL8ImAAoJEODzc/N7+Qmas+oP/iBhkcFXMzMXp3cbZV/bF74q
PlzbQ+QIg7Nizf0MdQRvhh6D3IfyZpWaqhXQU2KkNs+F85X2qg+mLzDcXAwej4yY
Hxbc2M6MVkaE/wcRUNEgvhQVc9HvdfYmaBU0/nrtsLi2gjuxHI2J0N8FaWOyjl16
DcB0tl77qSbHQPRcRCVyxGib+rNz1+JiyylGv65oQWZuTtquYbalMThIOU6eya7z
Z6O1EfVfidW9MdUMdHFLQ1MR+0C/KRQ40EWJDCTLODO/mmQ2ptKU1j6cNdriHFhR
o3fDVY29p8FbBbYQOM+MKWq7K1MqsxLcjok/NjEbL9xupCg/sJ64C01Ai7AoSPzM
lD+5XOLukoRpX1R1jn3OfDNvXGF4TCIbhMxMn8u/KlnNlhAP+vJgQf2PSeNfPsg2
Qw5GtapVId1gcgTlB2Ih1D+GzAx5vCnmygfmjvaEa31Ll2OeyeDtbC5oIAnAvNAC
9iFl4excOsapLHfebhiNJoYeQQgsEUQGHJ+VJg0yn247P8J+QTS4ZB5VVbtXeLkF
fMiXLDF4oJNwOMMYtwMmbwTHeouVAoiUHVMETwm232444KduAoLNf2eVQqqG+xrN
iKl6Q07jw0+X9qOSm7s6atmGuPk8kcEuOiUnhs7cleOaHMtPnCGY4RZh/f9zBV62
bgaI3sk/g+23UMoLpXkC
=rVUv
-----END PGP SIGNATURE-----

--=-TC/v+ydbMYWJzJoMOGHW--

