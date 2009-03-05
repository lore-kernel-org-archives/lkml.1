Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZCEK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZCEK5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZCEK5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:57:18 -0500
Received: from alcalazamora.dti2.net ([81.24.162.8]:1830 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZCEK5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:57:17 -0500
X-Spam-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 11:57:12 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0209.49AFB007.0119,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49AFAFD9.9050805@dti2.net>
Date: Thu, 05 Mar 2009 11:56:25 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: npiggin@suse.de
CC: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de>
In-Reply-To: <20090305094623.GA17815@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 11:57:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin escribió:
> On Thu, Mar 05, 2009 at 10:19:46AM +0100, Jorge Boncompte [DTI2] wrote:
>> Nick Piggin escribió:
>>>> ------------
>>>> mount -no remount,ro /dev/ram0
>>>> dd if=/dev/ram0 of=config.bin bs=1k count=1000
>>>> mount -no remount,rw /dev/ram0
>>>> md5sum config.bin
>>>> dd if=config.bin of=/dev/hda1
>>>> echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
>>>> ------------
>>>>
>>>> on system boot
>>>>
>>>> ------------
>>>> CHECK MD5SUM
>>>> dd if=/dev/hda1 of=/dev/ram0 bs=1k count=1000
>>>> fsck.minix -a /dev/ram0
>>>> mount -nt minix /dev/ram0 /etc -o rw
>>>> ------------
>>>>
>>>> 	I have never seen a MD5 failure on boot, just sometimes the 
>>>> 	filesystem is corrupted. Kernel config attached.
>>> >From your description, it suggests that the corrupted image is being
>>> read from /dev/ram0 (becuase the md5sum passes).
>> 	No, it is read from /dev/hda1.
> 
> No I mean when it is first read from /dev/ram0 when you create the
> image. Can you put some fsx.minix checks on the image file to try
> to narrow down when exactly it is getting corrupted?

Ok. I have modified the script to do...
------------
mount -no remount,ro /dev/ram0
dd if=/dev/ram0 of=/tmp/config.bin bs=1k count=1000
fsck.minix -fv /tmp/config.bin
if [ $? != 0 ]; then
	echo "FATAL: Filesystem is corrupted"
	exit 2
fi
mount -no remount,rw /dev/ram0
md5sum config.bin
dd if=config.bin of=/dev/hda1
echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
------------
... after some cycles of modifying files on the filesystem and trying to 
save it to disk...
------------------
fsck.minix: BusyBox v1.8.2 (2008-12-03 14:24:56 CET)
Forcing filesystem check on /tmp/config.bin
Unused inode 198 is marked as 'used' in the bitmap.
Zone 393 is marked 'in use', but no file uses it.
Zone 394 is marked 'in use', but no file uses it.

    198 inodes used (58%)
    395 zones used (39%)

    163 regular files
     24 directories
      0 character device files
      0 block device files
      0 links
     10 symbolic links
------
    197 files
FATAL: Filesystem is corrupted
-------------------

-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

