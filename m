Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZCFGQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZCFGQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZCFGQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:16:42 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:40932 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZCFGQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:16:42 -0500
Message-ID: <49B0BFBD.7060208@ahsoftware.de>
Date: Fri, 06 Mar 2009 07:16:29 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH] Re: Oops using 2.6.28.n after a lazy umount of a crypted
 loop-device
References: <49AFA565.6030902@ahsoftware.de> <49AFBE4A.1010605@redhat.com>
In-Reply-To: <49AFBE4A.1010605@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for the fast response and patch.

Milan Broz schrieb:
> Please Can you try attached patch if helps here?
> (Patch is not perfect, but should help, at least identify that
> it is the same problem I am fixing:-)

The patch works (I had to add an #include <linux/delay.h> /* msleep */).

I've tested it using 2.6.28.7 and the script below. With your patch the 
script was running over night looping about 400 times without any error. 
A crosscheck without the patch needed only 10 iterations to get an oops. 
So I assume you have fixed the problem I had. ;)

There stills seems to be another problem left, I've got 3 times the 
kernel-message

device-mapper: ioctl: unable to remove open device 
temporary-cryptsetup-21571

during cryptsetup luksOpen. I never realized that msg before, but I've 
found an old one in my logs too.

Anyway, this does not result in an oops, so I'm happy. Thanks a lot.

Kind regards,

Alexander Holler


----------- oopstest.exp -----------------------
!/usr/bin/expect
system modprobe dm-crypt
system modprobe loop
for { set i 0 } { $i < 1000 } {} {
   incr i
   send_user "Test $i\n"
   system losetup /dev/loop1 /Daten/Daten.crypt
   spawn cryptsetup luksOpen /dev/loop1 crypted
   expect passphrase:
   sleep 2
   send oopstest\r
   sleep 60
   send_user \n
   system fsck.ext3 /dev/mapper/crypted
   sleep 2
   system mount -t ext3 -o rw,user,exec,noatime /dev/mapper/crypted 
/Daten/crypted
   system dd if=/dev/urandom of=/Daten/crypted/random bs=1024 count=1024
   system umount -l /Daten/crypted
   system cryptsetup luksClose crypted
   system losetup -d /dev/loop1
}
----------- oopstest.exp -----------------------

