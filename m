Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXL0GFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXL0GFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 01:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXL0GFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 01:05:04 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57050 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXL0GFD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 01:05:03 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: 2.6.24-rc6-mm1 - drivers/char/tpm/tpm_bios.c oddness?
In-Reply-To: Your message of "Sat, 22 Dec 2007 23:30:56 PST."
             <20071222233056.d652743e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198735493_11278P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Dec 2007 01:04:53 -0500
Message-ID: <14152.1198735493@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198735493_11278P
Content-Type: text/plain; charset="UTF-8"
Content-Id: <14139.1198735485.1@turing-police.cc.vt.edu>
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Dec 2007 23:30:56 PST, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6=
/2.6.24-rc6-mm1/

Looks like an uninitialized variable dereference for SEPARATOR events:

# mount -t securityfs none /sys/kernel/security/
# ls /sys/kernel/security/
tpm0
# l /sys/kernel/security/tpm0/
total 0
0 -r--r----- 1 root root 0 2007-12-26 23:28 ascii_bios_measurements
0 -r--r----- 1 root root 0 2007-12-26 23:28 binary_bios_measurements
# cat /sys/kernel/security/tpm0/ascii_bios_measurements =

 0 0000000000000000000000000000000000000000 07 [S-CRTM Contents]
 0 0000000000000000000000000000000000000000 07 [S-CRTM Contents]
 0 0000000000000000000000000000000000000000 07 [S-CRTM Contents]
 0 0000000000000000000000000000000000000000 07 [S-CRTM Contents]
 4 c1e25c3f6b0dc78d57296aa2870ca6f782ccf80f 05 [Calling INT 19h]
 0 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 1 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 2 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 3 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 4 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 5 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 6 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 7 85e53271e14006f0265921d02d4d736cdc580b0b 04 [=C3=BF]
 4 38f30a0a967fcf2bfee1e3b2971de540115048c8 05 [Returned INT 19h]
 4 f9d3a33e4ba6109fb60e8df6ec0f10330733c8b2 0c [Compact Hash]
 5 9bd5c812613f67ce1c75d0ea48b9933a547683cb 0c [Compact Hash]

Looks like the problem is likely in get_event_name:

        case NONHOST_INFO:
                name =3D tcpa_event_type_strings[event->event_type];
                n_len =3D strlen(name);
                break;
        case SEPARATOR:
        case ACTION:
                if (MAX_TEXT_EVENT > event->event_size) {
                        name =3D event_entry;
                        n_len =3D event->event_size;
                }
                break;

Should there be a 'break;' after the SEPARATOR line?  Given the name, it
probably doesn't have a name/length pair attached to an event, right?



--==_Exmh_1198735493_11278P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHc0CFcC3lWbTT17ARAhiTAKDGb73umGgJ98bM86OBzK8YGlGNlgCgxF+N
aK5zXa3YNamnYoDSv32x0WY=
=YIDV
-----END PGP SIGNATURE-----

--==_Exmh_1198735493_11278P--
