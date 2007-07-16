Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbXGPUi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbXGPUi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbXGPUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:38:05 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:40493 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757179AbXGPUiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:38:04 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Build error with latest git
Date: Mon, 16 Jul 2007 23:37:24 +0300
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com
References: <469BC420.8080204@lwfinger.net>
In-Reply-To: <469BC420.8080204@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4205166.LMu8CfhCbW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707162337.27213.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4205166.LMu8CfhCbW
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


[Adding needed CC's]=20

16 Tem 2007 Pts tarihinde, Larry Finger =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> Using the latest git pull (commit
> abce891a10559343d8ac9f79b46d78afdba63a40), I get the following linker
> error:
>
> block/built-in.o: In function `bsg_init':
> bsg.c:(.init.text+0x43d): undefined reference to `scsi_register_interface'
>
> This is on an x86_64 system with the following .config:

I've hit that also (current git cannot compiled with CONFIG_BLK_DEV_BSG=3Dy
), if i'm not wrongly interpret the Makefile it seems a ordering issue;

Makefile
=2E..
ifeq ($(KBUILD_EXTMOD),)
core-y=C2=B7 =C2=B7   +=3D kernel/ mm/ fs/ ipc/ security/ crypto/ block/
=2E..
vmlinux-init :=3D $(head-y) $(init-y)
vmlinux-main :=3D $(core-y) $(libs-y) $(drivers-y) $(net-y)
=2E..

but block block/bsg.c uses "scsi_register_interface" exported by=20
drivers/scsi/scsi_sysfs.c which lives in drivers-y. Moving bsg in=20
drivers/scsi seems solves this issues, see following

Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>

 block/Kconfig                 |    8 --------
 block/Makefile                |    1 -
 drivers/scsi/Kconfig          |    8 ++++++++
 drivers/scsi/Makefile         |    1 +
 {block =3D> drivers/scsi}/bsg.c |    0=20
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 1d16b08..2859351 100644
=2D-- a/block/Kconfig
+++ b/block/Kconfig
@@ -51,12 +51,4 @@ config LSF
=20
 endif # BLOCK
=20
=2Dconfig BLK_DEV_BSG
=2D	bool "Block layer SG support"
=2D	depends on SCSI && EXPERIMENTAL
=2D	default y
=2D	---help---
=2D	Saying Y here will enable generic SG (SCSI generic) v4
=2D	support for any block device.
=2D
 source block/Kconfig.iosched
diff --git a/block/Makefile b/block/Makefile
index 959feeb..4b84d0d 100644
=2D-- a/block/Makefile
+++ b/block/Makefile
@@ -4,7 +4,6 @@
=20
 obj-$(CONFIG_BLOCK) :=3D elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl=
=2Eo
=20
=2Dobj-$(CONFIG_BLK_DEV_BSG)	+=3D bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+=3D noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+=3D as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+=3D deadline-iosched.o
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3727231..fbb06de 100644
=2D-- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -81,6 +81,14 @@ config BLK_DEV_SD
 	  In this case, do not compile the driver for your SCSI host adapter
 	  (below) as a module either.
=20
+config BLK_DEV_BSG
+	 bool "Block layer SG support"
+	depends on SCSI && EXPERIMENTAL
+	default y
+	---help---
+	Saying Y here will enable generic SG (SCSI generic) v4
+	support for any block device.
+
 config CHR_DEV_ST
 	tristate "SCSI tape support"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 0f86895..15de029 100644
=2D-- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -139,6 +139,7 @@ obj-$(CONFIG_CHR_DEV_ST)	+=3D st.o
 obj-$(CONFIG_CHR_DEV_OSST)	+=3D osst.o
 obj-$(CONFIG_BLK_DEV_SD)	+=3D sd_mod.o
 obj-$(CONFIG_BLK_DEV_SR)	+=3D sr_mod.o
+obj-$(CONFIG_BLK_DEV_BSG)	+=3D bsg.o
 obj-$(CONFIG_CHR_DEV_SG)	+=3D sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+=3D ch.o
=20
diff --git a/block/bsg.c b/drivers/scsi/bsg.c
similarity index 100%
rename from block/bsg.c
rename to drivers/scsi/bsg.c



Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart4205166.LMu8CfhCbW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGm9cHy7E6i0LKo6YRAhZuAKCIR3vFdLa78BS2XKgOT2ttJXd5fgCfZabO
HLTU/c2JGUhWZEZYKGyCK7U=
=Cj1h
-----END PGP SIGNATURE-----

--nextPart4205166.LMu8CfhCbW--
