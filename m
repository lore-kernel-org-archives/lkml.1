Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYGFKxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYGFKxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 06:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYGFKw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 06:52:56 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:39545 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYGFKwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 06:52:55 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 06:52:55 EDT
Message-ID: <25e301c8df53$6a525780$f9b5a8c0@pii350>
From: "Gilles Espinasse" <g.esp@free.fr>
To: =?iso-8859-1?Q?Marian_Aldenh=F6vel?= 
	<marian.aldenhoevel@mba-software.de>
Cc: <linux-kernel@vger.kernel.org>
References: <4860959E.6020207@mba-software.de> <1214471767.48635e574384b@imp.free.fr> <48708724.6020904@mba-software.de>
Subject: Re: Building a kernel for SiS55-based system.
Date: Sun, 6 Jul 2008 12:31:13 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_25E0_01C8DF64.2D91C270"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_25E0_01C8DF64.2D91C270
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit


----- Original Message ----- 
From: "Marian Aldenhövel" <marian.aldenhoevel@mba-software.de>
To: "Gilles Espinasse" <g.esp@free.fr>
Cc: <linux-kernel@vger.kernel.org>
Sent: Sunday, July 06, 2008 10:49 AM
Subject: Re: Building a kernel for SiS55-based system.


>> What version of gcc,binutils?
>
> Gcc: 4.2.3
> Binutils: 2.18.50.0.3
>
>> Could you try with distrib images to know if it could be related to your
>> compilation system
>
> As I have to boot off CF card, the system does not have a hard disk and
does
> not like to boot off my USB-CD-Drive, my choices in prebuilt-Distributions
> are a bit limited.
>
- usb or classic floppy?
If you have that, you could try the test images I have made for IPCop
http://g.esp.free.fr/download/ipcop-1.9.2-boot.img
http://g.esp.free.fr/download/ipcop-1.9.2-root-1.img
http://g.esp.free.fr/download/ipcop-1.9.2-root-2.img

6ed40c877c9d47103a498193d65e4fea  ipcop-1.9.2-boot.img
ea7f81b3cdcfdae3eb42227e5bb9423e  ipcop-1.9.2-root-1.img
c2b442569c863841571f01eeac1f0882  ipcop-1.9.2-root-2.img
that's should boot any 486 (even with mmu emulation) or better with 16 MB
memory.
You need three floppies without error.
Corresponding kernel (2.6.24) .config is available at
http://ipcop.svn.sourceforge.net/viewvc/ipcop/ipcop/trunk/config/kernel/

- or booting from usb key?
- pxe-boot
pxe is the easiest way for testing but require some infrastructure.
You need a tftp server, a dhcp server and a card that support pxe.

If your bios does not support pxe with a built-in card, try with an e100
card.
All e100 nic cards I have support pxe boot and have a nice prompt at boot
after bios start.
You may prefere to update the nic pxe stack, all my e100 cards has been
updated with proboot.exe v10.3 (boot agent v4.19). I haven't tried more
recent versions.

Any modified isolinux.cfg could be modified to support pxe boot, you just
have to adjust the path from tftproot.
For example with Ubuntu, put the files in place with
mount -o loop ubuntu-8.04-mini.iso iso-test
mkdir -p /var/tfpt/ubuntu/x86/8.04 # /var/tfpt is my tftproot, yours may
vary
cd iso-test
cp * /var/tfpt/ubuntu/x86/8.04

Attached is the patch that modify the path in original Ubuntu isolinux.cfg
to match installed files

Add to the dhcp server in dhcp.conf (this is for ISC dhcp)
host fooname
{
 hardware ethernet aa:bb:cc:dd:ee:ff; (set the real MAC address)
 fixed-address 192.168.<ip to the machine>;
 next-server 192.168.<ip to tftp server>;
 filename "pxelinux.0";
 option host-name "fooname";
}

Then set the link for nic MAC address to isolinux.cfg
cd /var/tftp/pxelinux.cfg
ln -sf ../ubuntu/x86/8.04/isolinux.cfg 01-aa-bb-cc-dd-ee-ff (lowercase for
a..f letters, always 01 prefix)

And the machine should be ready to boot from network.

Gilles

------=_NextPart_000_25E0_01C8DF64.2D91C270
Content-Type: application/octet-stream;
	name="ubuntu-8.04-x86pxe-isolinux.cfg.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ubuntu-8.04-x86pxe-isolinux.cfg.patch"

--- ubuntu/x86/8.04/isolinux.cfg.orig	2008-07-06 10:40:31.000000000 +0200=0A=
+++ ubuntu/x86/8.04/isolinux.cfg	2008-07-06 10:40:49.000000000 +0200=0A=
@@ -1,39 +1,39 @@=0A=
 =0A=
-DISPLAY boot.txt=0A=
+DISPLAY /ubuntu/x86/8.04/boot.txt=0A=
 =0A=
-F1 f1.txt=0A=
-F2 f2.txt=0A=
-F3 f3.txt=0A=
-F4 f4.txt=0A=
-F5 f5.txt=0A=
-F6 f6.txt=0A=
-F7 f7.txt=0A=
-F8 f8.txt=0A=
-F9 f9.txt=0A=
-F0 f10.txt=0A=
+F1 /ubuntu/x86/8.04/f1.txt=0A=
+F2 /ubuntu/x86/8.04/f2.txt=0A=
+F3 /ubuntu/x86/8.04/f3.txt=0A=
+F4 /ubuntu/x86/8.04/f4.txt=0A=
+F5 /ubuntu/x86/8.04/f5.txt=0A=
+F6 /ubuntu/x86/8.04/f6.txt=0A=
+F7 /ubuntu/x86/8.04/f7.txt=0A=
+F8 /ubuntu/x86/8.04/f8.txt=0A=
+F9 /ubuntu/x86/8.04/f9.txt=0A=
+F0 /ubuntu/x86/8.04/f10.txt=0A=
 =0A=
 DEFAULT install=0A=
 =0A=
 LABEL install=0A=
-	kernel linux=0A=
-	append vga=3Dnormal initrd=3Dinitrd.gz -- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append vga=3Dnormal initrd=3D/ubuntu/x86/8.04/initrd.gz -- =0A=
 LABEL linux=0A=
-	kernel linux=0A=
-	append vga=3Dnormal initrd=3Dinitrd.gz -- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append vga=3Dnormal initrd=3D/ubuntu/x86/8.04/initrd.gz -- =0A=
 LABEL cli=0A=
-	kernel linux=0A=
-	append tasks=3Dstandard pkgsel/language-pack-patterns=3D =
pkgsel/install-language-support=3Dfalse vga=3Dnormal initrd=3Dinitrd.gz =
-- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append tasks=3Dstandard pkgsel/language-pack-patterns=3D =
pkgsel/install-language-support=3Dfalse vga=3Dnormal =
initrd=3D/ubuntu/x86/8.04/initrd.gz -- =0A=
 =0A=
 LABEL expert=0A=
-	kernel linux=0A=
-	append priority=3Dlow vga=3Dnormal initrd=3Dinitrd.gz -- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append priority=3Dlow vga=3Dnormal initrd=3D/ubuntu/x86/8.04/initrd.gz =
-- =0A=
 LABEL cli-expert=0A=
-	kernel linux=0A=
-	append tasks=3Dstandard pkgsel/language-pack-patterns=3D =
pkgsel/install-language-support=3Dfalse priority=3Dlow vga=3Dnormal =
initrd=3Dinitrd.gz -- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append tasks=3Dstandard pkgsel/language-pack-patterns=3D =
pkgsel/install-language-support=3Dfalse priority=3Dlow vga=3Dnormal =
initrd=3D/ubuntu/x86/8.04/initrd.gz -- =0A=
 =0A=
 LABEL rescue=0A=
-	kernel linux=0A=
-	append vga=3Dnormal initrd=3Dinitrd.gz rescue/enable=3Dtrue -- =0A=
+	kernel /ubuntu/x86/8.04/linux=0A=
+	append vga=3Dnormal initrd=3D/ubuntu/x86/8.04/initrd.gz =
rescue/enable=3Dtrue -- =0A=
 =0A=
 PROMPT 1=0A=
 TIMEOUT 0=0A=

------=_NextPart_000_25E0_01C8DF64.2D91C270--

