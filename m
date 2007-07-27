Return-Path: <linux-kernel-owner+w=401wt.eu-S935533AbXG0Toz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533AbXG0Toz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXG0Tor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:44:47 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57738 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbXG0Toq (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:44:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kylene Hall <kjhall@us.ibm.com>, tpm@selhorst.net,
       linux-kernel@vger.kernel.org,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Fri, 27 Jul 2007 11:07:01 PDT."
             <20070727110701.be3a8459.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <23659.1185400994@turing-police.cc.vt.edu> <20070725203737.85871711.akpm@linux-foundation.org> <5208.1185508832@turing-police.cc.vt.edu> <23912.1185542889@turing-police.cc.vt.edu>
            <20070727110701.be3a8459.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185565477_3506P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Jul 2007 15:44:37 -0400
Message-ID: <26949.1185565477@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185565477_3506P
Content-Type: text/plain; charset=us-ascii

On Fri, 27 Jul 2007 11:07:01 PDT, Andrew Morton said:
> On Fri, 27 Jul 2007 09:28:09 -0400
> Valdis.Kletnieks@vt.edu wrote:

> > And we have a winner.  In my bisect 'hunt' file, I ended at:
> > 
> > fs-use-kmem_cache_zalloc-instead.patch GOOD
> > # remove-kconfig-setting-config_debug_shirq.patch: Ingo worried
> > remove-kconfig-setting-config_debug_shirq.patch BAD
> 
> Thanks for working that out.

Hey, it's what I'm here for. :)

> > Looks like Ingo was right. :)  As a cross-check, I tested a 'GOOD' kernel,
> > but rebuilt with CONFIG_DEBUG_SHIRQ=y, and that *also* died. 

> Fernando, those patches are just too scary for me because of stuff like
> this.
> 
> Perhaps we should look at implementing this new behaviour on a per-driver
> basis?  Pass smoe new flag into request_irq(), perhaps?

Has anybody else hit an actual problem with this, or is the borkage restricted
to this one driver?  And, quite frankly, given that *before*, the driver would
try and reject 5 different unused IRQs and then complain when it found one in
use, I'm not totally convinced that the driver wasn't on crack *before*.  The
only thing I've been able to prove to myself is that it's acting differently,
but I'm pretty sure that *both* before and after are broken, just in different
ways.

I'd not fault Fernando's patch here - if I'd enabled the DEBUG_SHIRQ on
previous kernels, I'd have spotted it then.  I never enabled it because I
didn't know I had drivers that might have bugs in that area.

Kylene or somebody else who actually understands the TPM chipsets would have
to provide guidance on how it's *supposed* to work, and I'm certainly willing
to testbed patches.

For what it's worth - I actually read the source some more, discovered the
module parm 'interrupts=0' (which forces polling mode), and managed to get
things at least semi-working with the libtpm-2.0 test suite:

~/src/libtpm-2.0/utils % ./tpm_demo 
TPM version 1.1.0.0
24 PCR registers are available
PCR-00: 48 88 FD B3 F6 04 AF 54 9F 6A 53 19 96 38 4F BF 02 52 3F C7 
PCR-01: 5B 93 BB A0 A6 64 A7 10 52 59 4A 70 95 B2 07 75 77 03 45 0B 
PCR-02: 5B 93 BB A0 A6 64 A7 10 52 59 4A 70 95 B2 07 75 77 03 45 0B 
PCR-03: 5B 93 BB A0 A6 64 A7 10 52 59 4A 70 95 B2 07 75 77 03 45 0B 
PCR-04: 7D 89 C5 0D C7 E5 2F F1 2C 56 0C C2 84 40 FD ED 06 B4 D6 B7 
PCR-05: 23 E4 5B 96 79 C4 52 F7 4A EA 76 04 46 FF BB D1 02 D0 3D 27 
PCR-06: 5B 93 BB A0 A6 64 A7 10 52 59 4A 70 95 B2 07 75 77 03 45 0B 
PCR-07: 5B 93 BB A0 A6 64 A7 10 52 59 4A 70 95 B2 07 75 77 03 45 0B 
PCR-08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-09: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-11: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-12: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-13: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-14: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-15: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-16: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-17: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-18: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-19: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-20: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-21: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-22: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-23: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
3 Key slots are available
No keys are loaded
Unable to read Pubek

Unsure why it reports TPM 1.1 here, and 1.2 when the driver initializes.
But at least I've gotten the chip to do a "Hello World!", so that's progress. :)



--==_Exmh_1185565477_3506P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGqkslcC3lWbTT17ARAr9zAJ9fvS0KPUG+3AdfZHgtxKOMQkYnZgCg0xMU
7SEwTwtsEyOz4lnpn00tsbw=
=qLZ3
-----END PGP SIGNATURE-----

--==_Exmh_1185565477_3506P--
