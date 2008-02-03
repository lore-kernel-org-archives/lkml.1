Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYBCUz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYBCUz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYBCUzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:55:20 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:48131 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752035AbYBCUzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:55:18 -0500
Subject: data corruption with dmcrypt/LUKS
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 03 Feb 2008 15:50:37 +0100
Message-Id: <1202050237.3200.33.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I think I've found a bug somewhere in dm-crypt...

First of all the system that I use:
Debian (sid) with kernel 2.26.24 on AMD64 (intel core2 duo), 2GB RAM

For several days now I try to fully encrypt that system (that is, all
partitions are encrypted an I boot from an USB stick)
There are two errors that appear always and always again but first of
all an explanation how I setup everything:
/dev/sda1 is my unencrypted debian installation
/dev/sda2 is the partition that will hold the encrypted root
/dev/sda3 is swap

I boot from an USB stick (with the same debian sid/2.6.24 kernel as
on /dev/sda1) which is /dev/sdb(1).
The key itself is on /dev/sdc (also an USB stick)

How I've made the key:
dd if=/dev/random of=/tmp/KEY count=32 bs=1

How I've formatted sda2:
cryptsetup --verbose --cipher aes-cbc-essiv:sha256 --key-size 256
--iter-time 10000 luksFormat /dev/sda2 /tmp/KEY
cryptsetup --key-file /tmp/KEY luksOpen /dev/sda2 sda2
mkfs.ext3 /dev/mapper/sda2
cryptsetup luksClose sda2

<reboot>
<create mappings and mount everything again>

cp -a /mnt/unencrypted /mnt/encrypted/

<when I diff -q -r /mnt/unencrypted /mnt/encrypted/ here, everything is
ok but this is just, because those files are still cached in RAM>
<unmount + close mapping + reboot>
<create mappings and mount everything again>

Here's the first problem:
1) When I now diff the two versions again (the unencrypted and the one
from the encrypted partition) I get differences...
I'm quite sure that this is not due to damaged RAM or harddisk (checked
several times with memtest and badblocks) and the corruption is always
the same, although not fully reproducibly.
The filesystem tree itself seems to be the same on both discs (but I'm
not sure if the permissions and owners are copied correctly), but there
are differences in some (though not all) files.
The difference is always the same, that for one or more bytes of the
affected files, the hexcode is reduced by 0x10
That is:
If the file contains a byte "T" (0x74) on the unencrypted partition it
will have a "D" (0x64) on the encrypted.

I've first recognized this bug some weeks ago, when I used a 2.6.18
kernel on my boot+copy USB-stick (/dev/sdb) but I thought this might be
a bug in that pretty old version...
But now it even happens with 2.6.24...

2) The second bug happens only rarely and leads to a panic.
Unfortunately it's difficult to reproduce, but it always happened when I
mkfs.ext3 on the /dev/mapper/sda2.
There's a stack-trace printed which clearly involves some dmcrypt
lines...


Unfortunately this bug makes dm-crypt completely unusable for me (and
everybody who needs correctness for his data ;-) )

I'd ask you to run your own (massive) copying tests and report here if
you can reproduce that error.

Best wishes,
Chris.

btw: are there any other currently known bugs in dmcrypt? Or is it
considered as "production stable"?


