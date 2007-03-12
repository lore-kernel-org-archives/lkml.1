Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXCLXBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXCLXBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXCLXBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:01:47 -0400
Received: from betty.cbit.net.au ([202.55.154.10]:54220 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbXCLXBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:01:46 -0400
Date: Tue, 13 Mar 2007 10:01:37 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, torvalds@linux-foundation.org
Subject: Re: Make sure we populate the initroot filesystem late enough
Message-ID: <20070312230137.GA8304@keitarou>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou> <1172558897.11949.43.camel@localhost.localdomain> <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org> <1172644987.11949.90.camel@localhost.localdomain> <1172657584.3452.51.camel@pmac.infradead.org> <1172709056.5852.6.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1172709056.5852.6.camel@concordia.ozlabs.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 01, 2007 at 09:30:56AM +0900, Michael Ellerman wrote:
> On Wed, 2007-02-28 at 10:13 +0000, David Woodhouse wrote:
>> On Wed, 2007-02-28 at 07:43 +0100, Benjamin Herrenschmidt wrote:
> >> I wouldn't be that sure ... I've had problems in the past with PMU bas=
ed
> >> cpufreq... looks like flushing all caches and hard-resetting the
> >> processor on the fly when there can be pending DMAs might be a source =
of
> >> trouble... especially on CPUs that don't have working cache flush HW
> >> assist.=20
>>=20
>> I've seen it on a PowerMac3,1 (400MHz G4) where we don't have cpufreq.
>> I've also seen it on the latest 1.5GHz Mac Mini, and on my shinybook.
>> They all fall over with the latest kernel, although the shinybook only
>> does so immediately when booted with mem=3D512M. The shinybook does crash
>> later with new kernels though; I don't yet know why. It could be the
>> same thing, or it could be something different. That one seemed to
>> appear between Fedora's 2.6.19-1.2913 and 2.6.19-1.2914 kernels, where
>> we did nothing but turned CONFIG_SYSFS_DEPRECATED on.
>>=20
>> I don't blame cpufreq. At various times I've been equally convinced that
>> it was due to CONFIG_KPROBES, and Linus' initrd-moving patch.

> Is there any pattern to the way it dies? Or is it just randomly dieing
> somewhere depending on which config options you have enabled?

> This is starting to sound reminiscent of a bug I chased for a while last
> year on Power5, but didn't find. It was "fixed" on some machines by
> disabling CONFIG_KEXEC, and/or other random unrelated CONFIG options.
> Unfortunately it magically stopped reproducing so I never caught it :/

Hmm. The crash came back after I booted into Mac OS X and back. It was howe=
ver
a different crash, I believe it was coming from the USB modules (as it would
keep going when it happened, and get another crash, which tended to scroll =
away
too fast for me to capture) but I believe it was still getting down into the
slab code and actually dying there.

However, reverting the reversion of
8d610dd52dd1da696e199e4b4545f33a2a5de5c6 and instead applying
the following patch:

diff -ru linux-source-2.6.20.orig/arch/powerpc/mm/init_32.c linux-source-2.=
6.20/arch/powerpc/mm/init_32.c
--- linux-source-2.6.20.orig/arch/powerpc/mm/init_32.c  2007-02-05 05:44:54=
=2E000000000 +1100
+++ linux-source-2.6.20/arch/powerpc/mm/init_32.c       2007-03-10 11:03:56=
=2E000000000 +1100
@@ -244,7 +244,8 @@
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
        if (start < end)
-               printk ("Freeing initrd memory: %ldk freed\n", (end - start=
) >> 10);
+               printk ("NOT Freeing initrd memory: %ldk freed\n", (end - s=
tart) >> 10);
+       return;
        for (; start < end; start +=3D PAGE_SIZE) {
                ClearPageReserved(virt_to_page(start));
                init_page_count(virt_to_page(start));

which if I recall correctly David Woodhouse posted to this thread,
seems to have fixed it.

I dunno if it's relevant, but my initrd.img is 13193315 bytes long,
(ie 99 bytes over 12884k) and the above logs:
"NOT Freeing initrd memory: 12888k freed"
which makes sense...

I of course completely failed to think to check this with the crashing
kernel, if it seems relevant I can roll back to it and get the numbers.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF9dvRexDuohKLFuARAh4QAKDKNXF6fcVv3tNDHqhX5Aacs42XygCgovnC
bxt6+VXtdcAdzNUTOEBl+AQ=
=0CbQ
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
