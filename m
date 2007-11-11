Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbXKKWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbXKKWKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXKKWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:10:20 -0500
Received: from rk.rkuhn.info ([88.198.164.84]:38220 "EHLO mailhost.rkuhn.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXKKWKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:10:18 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 17:10:17 EST
In-Reply-To: <200711111106.53494.elendil@planet.nl>
References: <200711111106.53494.elendil@planet.nl>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-18--384611834"
Message-Id: <09A755B9-27C1-4B54-834C-FDA9EE806042@e18.physik.tu-muenchen.de>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: Bind mount bug?
Date: Sun, 11 Nov 2007 23:00:36 +0100
To: Frans Pop <elendil@planet.nl>
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-18--384611834
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed

Hi Frans!

Let's see whether I can explain this (I'm not a guru...)

On 11 Nov 2007, at 11:06, Frans Pop wrote:

> I'm not sure whether this is a bug or expected behavior.
> Suppose I create a "looped" bind mount situation as follows.
>
> # mkdir test
> # touch test/foo
> # mkdir bindtest
> # touch bindtest/bar
> # mkdir bindtest/test
> # mount --bind test/ bindtest/test/
> # ls bindtest/test/
> foo
> # mount --bind bindtest/ test/

This mounts the bindtest/ tree on test/ _without_ copying the mount  
points which are found on subtrees. This is necessary to avoid loops  
in the filesystem (bind mounts are somewhat like hardlinks on  
directories, just without the headaches).

> # ls test/
> bar  test
> # ls test/test/
> #
>
This lists the contents of the original bintest/test/ directory which  
you created above. Creating e.g. a file in there stores that file  
physically in bindtest/test/bla, where "test" does _not_ mean the  
bind mount but the underlying directory here.

> I'd expected the last command to list "foo", but it shows an empty  
> dir.
> Shouldn't it also show the original contents of test (as they were  
> before
> the first bind mount)?
>
> # mount | grep test
> /root/test on /root/bindtest/test type none (rw,bind)
> /root/bindtest on /root/test type none (rw,bind)
>
You see, the bindtest/test/ mount was not propagated to test/test/.  
This is very much by design. You can e.g. do

# mkdir -p test/test
# mount --bind test test/test
# ls test/test
test
# ls test/test/test
#

so there is no loop (`find test` would actually say that it  
terminates because it has detected a loop, so it cannot be used to  
test this).

# touch test/test/test/a
# ls test/test/test
a
# ls test/test
# umount test/test
# ls test/test
a
#

So, you see, test/test/test/a was (as it should) physically created  
in test/test, where it is shadowed by the bind mount as long as that  
is not removed. Nothing vanishes into "thin air" ;-)

Ciao,
                     Roland

--
TU Muenchen, Physik-Department E18, James-Franck-Str., 85748 Garching
Telefon 089/289-12575; Telefax 089/289-12570
--
CERN office: 892-1-D23 phone: +41 22 7676540 mobile: +41 76 487 4482
--
Any society that would give up a little liberty to gain a little
security will deserve neither and lose both.  - Benjamin Franklin
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GS/CS/M/MU d-(++) s:+ a-> C+++ UL++++ P+++ L+++ E(+) W+ !N K- w--- M 
+ !V Y+
PGP++ t+(++) 5 R+ tv-- b+ DI++ e+++>++++ h---- y+++
------END GEEK CODE BLOCK------



--Apple-Mail-18--384611834
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (Darwin)

iD8DBQFHN3uJI4MWO8QIRP0RAnYbAKCIrXY3QJ6o+O9atbKIp+dNtqCZQgCff+Mm
qxx1PMEeH/iTfFrwdMFPUG4=
=wyKL
-----END PGP SIGNATURE-----

--Apple-Mail-18--384611834--
