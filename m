Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZCDGA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZCDGA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZCDGAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:00:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:10733 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZCDGAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=b+fC7XFk4gwGezs9D26DRZpu6kYAkiG35F8VZW3PT/zOsffMLNCLUmF6gqQ2UtPPg8
         6rzgBhDDPuMamhfnqsZkulwV7qDBuSA+uZ4FoVQz+scRbPYcpGpmNf7djaHZ3uc1usRO
         rD1A3kXwkT75PjTiggnBuo+y85/9+xJ0faUzg=
MIME-Version: 1.0
Date: Wed, 4 Mar 2009 15:00:45 +0900
Message-ID: <79a3cd740903032200g5c0af4cbr12e03355c9c614b0@mail.gmail.com>
Subject: Question regarding direntry read error in fat filesystem when a 
	device is removed
From: YS Kim <historic59@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question about too many error messages from FAT when
unexpected device removal occurs.
I got the following error messages when I unplugged a USB
drive(formatted as FAT) during direntry reading.

sd 0:0:0:0: rejecting I/O to device being removed
FAT: Directory bread(block 1478192) failed
sd 0:0:0:0: rejecting I/O to device being removed
FAT: Directory bread(block 1478193) failed
sd 0:0:0:0: rejecting I/O to device being removed
FAT: Directory bread(block 1478194) failed
sd 0:0:0:0: rejecting I/O to device being removed
FAT: Directory bread(block 1478195) failed
...

>From the code of fat__get_entry in dir.c, I found that it continues to
read the next device block
even if the block reading has been failed. Because of this continuous
read, a lot of error messages
come up if the device itself is removed during reading fairly many
files, and it causes the malfunction
of my embedded system.

I think this code is to make the filesystem available to read the next
block when a storage contains
bad blocks, so that a user can backup remainings in case that some
portion of a storage are dead.

However, if the storage is a NAND flash memory, the flash driver is
supposed to perform bad block
management (because of the NAND charateristics) before the filesystem
encounters the bad block.

Thus, if I modify the code to just return error when fat__get_entry
fails to read blocks, could it be
cause any side effects? Except the purpose of backup/recovery, is
there any other reason for
the continuous block read?
