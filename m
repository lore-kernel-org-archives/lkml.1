Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZF1ShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZF1ShQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZF1ShF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:37:05 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:41823 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbZF1ShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:37:04 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jun 2009 14:37:03 EDT
Date: Sun, 28 Jun 2009 20:26:09 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: linux-kernel@vger.kernel.org
cc: hirofumi@mail.parknet.co.jp
Subject: vfat creates multiple files with the same filename
Message-ID: <Pine.LNX.4.64.0906281935490.20945@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-2024526967-1246213569=:20945"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-2024526967-1246213569=:20945
Content-Type: TEXT/PLAIN; charset=ISO8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,=20

If I use vfat with the utf8 mount option, and create a file with an=20
invalid utf-8 character in it's name, then the invalid charater gets=20
removed from the filename silently. That's probably the expected way of=20
operation but the problem is, that this automatic filename sanitization=20
can be used to create multiple files with the same filename. Here's an=20
example how to do it:

mkdir /mnt/fatfs
FILENAME=3D`echo -ne "invalidutf8char_\\0341_endofchar"`
echo "Using filename: $FILENAME"
dd if=3D/dev/zero of=3Dfatfs bs=3D512 count=3D128
mkdosfs -F 32 fatfs
mount -o loop,utf8 fatfs /mnt/fatfs
touch "/mnt/fatfs/$FILENAME"
umount /mnt/fatfs
mount -o loop,utf8 fatfs /mnt/fatfs
touch "/mnt/fatfs/$FILENAME"
ls -l /mnt/fatfs
umount /mnt/fatfs

----  And the output is:

Using filename: invalidutf8char_=E1_endofchar
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.000388118 s, 169 MB/s
mkdosfs 2.11 (12 Mar 2005)
total 0
-rwxr-xr-x 1 root root 0 Jun 28 19:46 invalidutf8char__endofchar
-rwxr-xr-x 1 root root 0 Jun 28 19:46 invalidutf8char__endofchar

I don't know if removing the invalid characters silently instead of=20
returning EINVAL is a good practice, but allowing two files with identical=
=20
filenames is definitely wrong.=20

Could someone please have a look at the problem? Unfortunately I am not=20
qualified enough to track it down...

I've run the testcase on both 2.6.30 and 2.6.31-rc1 kernels, but this bug=
=20
is probably not very new, since I remember having it also in 2.6.27.

Regards,
  Marton
---943463948-2024526967-1246213569=:20945--
