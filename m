Return-Path: <linux-kernel-owner+w=401wt.eu-S965727AbXCGXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727AbXCGXYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965726AbXCGXYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:24:16 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:29449 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965738AbXCGXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=SbyMyO0sZeZnyIWL0/y8hjfkAG6nX6f78ASzjlCmu0vh7vifyP65giOh4VpgrSog+YtjWE97G48FSH6h2I3123ol2Lx3a3RDNkLAmWslRXgAEiFNmaK9AxvOqvOSqKLtzyrla5pxdUmpOTTUPLDgB9mkg4NZf345pjFBnwKo2KY=
Message-ID: <2a12af650703071524q222f9229m1d276995c577097d@mail.gmail.com>
Date: Thu, 8 Mar 2007 01:24:11 +0200
From: "Marti Raudsepp" <marti@juffo.org>
To: "Kernel hackers" <linux-kernel@vger.kernel.org>
Subject: PROBLEM: 'bio too big device' after moving to a USB disk
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 2a6838b042665749
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML,

PROBLEM: 'bio too big device' after moving to a USB disk

I. Summary

After lvmove'ing an LVM volume from a SATA disk to a USB disk, reiserfs starts
spewing I/O errors with "bio too big device dm-1 (256 > 240)" in dmesg; fsck
reports no corruptions, and problems only occur at certain lengths in
different files, such as 112k, 240k, 368k, and only with files that existed
before, and not newly written files.  When copying the partition back to its
original disk, everything works again.

II. Further description

Recently, I got a new USB disk, and as I was starting to run out of space on
my primary disk, I plugged it in and decided to lvmove a volume to it. While
the migration process went without apparent problems, the file system started
giving out I/O errors during reads, with the message "bio too big device dm-1
(256 > 240)" appearing in dmesg each time. However, none of newly written
files trigger this behavior, even after unmount-remount. To make the matters
more confusing, I'm also using dm-crypt in addition to LVM on this volume.
The file system is ReiserFS; A reiserfsck --check on the disk reported no
problems.

Initial suspects include:
* ReiserFS
* dm-crypto
* LVM
* Generic block device code
* usb-storage driver

As I had already allocated some of the space on the old disk, restoring the
old volume was not an option; my bellyfeel told me that this was simply a
software bug in the read code, so instead, I reorganized existing partitions
on the older SATA disk to make enough space, and duplicated the whole volume.
Everything worked perfectly again. Since then, I have only mounted each of the
partitions read-only, and 'cmp' reports that the contents are equal.

III. Problem inspection

Some inspection with dd revealed that a large part of files that are big
enough, fail exactly at 114688 bytes; many others fail at 245760, at 376832,
etc. It is always the same set of files and they fail exactly at the same
point, regardless of how much the skip= parameter is set to as long as it's
smaller than the failure point. However, after some playing around with the
skip= argument, these failure points start to "shift" forward:

% dd if=FILENAME of=/dev/null bs=1 seek=0
114688 bytes (115 kB) copied, 0.246294 s, 466 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=114688
0 bytes (0 B) copied, 0.000157 s, 0.0 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=114790
118682 bytes (119 kB) copied, 0.258896 s, 458 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=0
233472 bytes (233 kB) copied, 0.436577 s, 535 kB/s
# echo 3 > /proc/sys/vm/drop_caches
% dd if=FILENAME of=/dev/null bs=1 skip=0
114688 bytes (115 kB) copied, 0.21658 s, 530 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=114689
0 bytes (0 B) copied, 0.000976 s, 0.0 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=114690
0 bytes (0 B) copied, 0.000976 s, 0.0 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=233473
0 bytes (0 B) copied, 0.000976 s, 0.0 kB/s
# echo 3 > /proc/sys/vm/drop_caches
% dd if=FILENAME of=/dev/null bs=1 skip=233473
145460 bytes (145 kB) copied, 0.624043 s, 233 kB/s
% dd if=FILENAME of=/dev/null bs=1 skip=0
378933 bytes (379 kB) copied, 0.796276 s, 476 kB/s
(the file is 378933 bytes long, so it hit EOF)

I verified that these files weren't picking up garbage, but actual data that
the file should contain. However, the skip trick doesn't seem to work for
every file, or with every seek value, but it is important to skip beyond the
failure points.

IV. System information

Here are some details of the system:
* Kernel 2.6.19-gentoo-r6
* Arch x86_64
* USB disk 120GB Western Digital, model 00UE-00KVT0 (according to udev),
* Serial DEF10CD7F64C,
* Older SATA disk 200GB Seagate 7200.7, model ST3200822AS
* Motherboard Asus A8N5X, nForce4 chipset
* Offending file system: reiserfs v3.6, mounted with noatime,barrier=flush
* dm-crypt using aes-256 with cbc-essiv:sha256; using assembly-optimized AES
  (CONFIG_CRYPTO_AES_X86_64)
* implementation (CONFIG_CRYPTO_AES_X86_64)
* The partition is (exactly) 108GiB, 6912 LE * 16MiB
* LVM utilities version: 2.02.17 (2006-12-14)
* LVM library version: 1.02.12 (2006-10-13)
* LVM driver version: 4.10.0

I still have both disk images intact and can provide more details as
necessary. I have not yet attempted to reproduce it on a test partition. Any
extra information requests are welcome.

I'm not subscribed to the list, so please keep me in Cc:. Excuse me if some
parts of this e-mail don't make sense, I'm almost falling asleep here.

Regards,
Marti Raudsepp
