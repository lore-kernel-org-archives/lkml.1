Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZELWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZELWIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZELWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:07:51 -0400
Received: from web23602.mail.ird.yahoo.com ([87.248.115.45]:23261 "HELO
	web23602.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754301AbZELWHu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:07:50 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 18:07:50 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SQ1z+suAlNlOqvhTlP/6jgXh6cVJqjR3V1cwUATR7tQLbzFo/ib93u8SPt3uQQt4fOEMBeeEL0duFc29iLkeyRMKBdCoPI66bv93qaIpfajrUK58DgyFWNHez/xb6/1iG5JZE6KgltwOyaGDwbbUoImKk/b13JKvD2AVaZrxbag=;
Message-ID: <26299.12218.qm@web23602.mail.ird.yahoo.com>
X-YMail-OSG: AbRmOKoVM1nsusuV00bLj5O4WcWycdD1Wr2T28A66H8JiSuLTWUw1SKk.NmuxRlmSPhZBM5kdPv1wHsVnSgtmHk0y_gswDP8Uqi053OuYOXB._uC5v_gInAxFY4766T7GkhZy7.XdY6Z7lJbo_Yic4C6XwKnJJCChTnu_aVkvft4QJhDHtL0unGGkSFP1eEj._WSPbX75mNx7tfgxlyB15xD_bM2dTyg1EhC0SnDY_t8Evt5Ch42HzoRuVSVjTGjcVzMiVMybzPtLq0kb6aP9Lmh9Qh2eHBE09iyA_5J.kGnW0lAZXcYO.Tyxae0LTSsBmqIfrpLhHfx3IrM
X-Mailer: YahooMailWebService/0.7.289.1
Date: Tue, 12 May 2009 22:01:08 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Reply-To: etienne_lorrain@yahoo.fr
Subject: [ANNOUNCE] Gujin GPL bootloader version 2.6
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a new version v2.6 of Gujin at http://gujin.sf.net with 

bugfixes and improvement, like: 

  - Better PCI BIOS to detect IDE interfaces (SATA CDROM at non

  conventional address)

  - Better EDID BIOS support (screen definition detection)

  - Fix modification of *.iso images, fix ELF32/64 handling by

  tiny images.

  - works with GCC-4.4, works with every distribution-provided

  compiler I tested.

  - Align by default the clusters of FAT16/32 filesystems even if

  the start of the partition isn't aligned, generate FAT32 useable

  by Windows.

  - Completely remove the support for zImage and for locating

  the ELF in the Linux kernel, now only the official way to boot a

  bzImage Linux kernel is possible, and *.kgz files have to be

  compressed ELF32/64 files.

  - Gives few examples of ELF32 and ELF64 bootable kgz files,

  with and without memory relocation by using ld option --emit-relocs:

  see hello*.kgz in Makefile.

  - Generate a "gujin" executable, which is "instboot + few embedded

  boot images" for either 32 or 64 bits Linux, to use like (as root):



    -> to install the way GRUB or LILO installs themselves:

./gujin /boot/gujin.ebios

    -> to remove (and re-install previous bootloader)

./gujin --remove=/dev/sda && rm /boot/gujin.ebios

    -> to initialise a "superfloppy" FAT filesystem on a USB drive:

umount /dev/sdz*      # device /dev/sdz will be ERASED

./gujin --disk=BIOS:0x0,auto /dev/sdz

    -> to  transform a bootable ISO file and write it to a USB stick:

umount /dev/sdz*      # device /dev/sdz will be ERASED

./gujin eeebuntu-2.0-standard.iso \\

        && cat eeebuntu-2.0-standard.iso > /dev/sdz && sync

    -> for more example, use gujin without parameters,

        or with --help parameter.

 



 The simplest bootable "hello world" kgz file is:

/*  To be compiled by:

$ gcc -m32 -Wall -O2 -s -static -nostartfiles -nodefaultlibs \

   -Wl,-Ttext=0x110000 hello.c -o hello.elf

$ gzip -9 hello.elf -c > hello.kgz

*/

const char msg1[] = "Hello protected-mode text world! please reboot ...";

#define STACKSIZE 64 * 1024

static unsigned stack[STACKSIZE / 4] __attribute__ ((aligned(32)));

void _start (void)

{

    /* We are flat non-paged memory and interrupt disabled */

    asm (" mov %0,%%esp " : : "i" (&stack[STACKSIZE / 4]));

    /* This work only in text modes (assumed mode 3), video

    memory at real mode address 0xB800:0000. At this address,

    we shall write two bytes per char, one  containing the foreground

    and background color, the other containing the letter: */

    volatile unsigned short *video_array
         = (volatile unsigned short *)0xB8000;

    unsigned cpt1;



    video_array += 10 * 80;  /* few empty lines */

    /* We want blue background color and lightgray foreground: */

    for (cpt1 = 0; cpt1 < sizeof(msg1) - 1; cpt1++)

            video_array[cpt1] = 0x1700 + msg1[cpt1];

    while (1)

        continue;

}



 Downloads at:

http://sourceforge.net/project/showfiles.php?group_id=15465



  Have fun,

  Etienne.



      
