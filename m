Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbZFQB0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbZFQB0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZFQB0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:26:17 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:47765 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFQB0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FoPfzvm1QJv20JqommoxvfjmZMzdAIrR+CkKrsZ4t60+80aA93GneMn9d5o/qwhXBY
         Z1+HzQoSmCQS4XT87QTHRYgo5dwFcA7NWrqXb+u2jhGeQahaLEyDFEiHkE9w32jghS6F
         ZLYQq5GDEXrW7MQYVnwC3I8XLs1a1ZibhNceI=
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 19:26:18 -0600
Message-ID: <9b1675090906161826q12db9dd3wdde22e603a395ee6@mail.gmail.com>
Subject: BUG??? Incorrect metadata area header checksum
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I have had problems several times, where my LVM metadata gets
completely messed up.  I have no idea how it's happening.  When I look
at /var/log/messages, I am not finding any IO errors of any kind.  Not
previously, and not this time.  I'm starting to think there is a small
bug in the kernel somewhere regarding this, that causes it to loose
it's marbles regarding the LVM metadata.

A couple of weeks ago, I had to recover my system from the LVM backups
at the start of the disk.  At first, I had no idea what I was doing,
but after using pvck, I quickly noticed that it had offsets to the
metadata backups on the disk.  I was then able to recover from that.
All I had done is a routine move of my physical extents over to
another disk.  I rebooted, it worked, I rebooted again, and it quit
working.

I had this problem again yesterday/today.  This time it was a backup
drive, not my primary, so it was easy to restore from the backups kept
in /etc/lvm/backup/

As you can see, with the example below, there is no disk corruption at
all, it simply lost it's metadata marbles, and a simple vgcfgrestore
fixes the problem.  So, what I want to know, is what could possibly
cause this?  FYI, I had just finished adding a whole bunch more data
(overnight last night) to the drive when I noticed today that it was
corrupted.  I reboot, and sure enough, I could not load up the volume
group or volumes.  So, I'm wondering if somehow there is an erroneous
overlap in storage area of the disk, mixed up between files, and
metadata, that could cause this?  After all, it was as simple as
adding more data to the volume.  The actual LVM info has not changed
in a couple of weeks, so there is no good reason for LVM to change
it's metadata without my approval.

tdamac ~ # vgchange -ay
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Volume group "bak" inconsistent
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  WARNING: Inconsistent metadata found for VG bak - updating to use version 23
  Incorrect metadata area header checksum
  Automatic metadata correction failed
  Incorrect metadata area header checksum
  4 logical volume(s) in volume group "s" now active

tdamac ~ # pvcreate -ff -u 0dNrQJ-torK-1wmT-TxIY-1jMY-QWA4-BHIrKe
--restorefile /etc/lvm/backup/bak /dev/sdb1
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  WARNING: Volume group bak is not consistent
Really INITIALIZE physical volume "/dev/sdb1" of volume group "bak" [y/n]? y
  WARNING: Forcing physical volume creation on /dev/sdb1 of volume group "bak"
  Physical volume "/dev/sdb1" successfully created
tdamac ~ # vgcfgrestore -f /etc/lvm/backup/bak -v bak
  Restored volume group bak
tdamac ~ # vgchange -ay
  1 logical volume(s) in volume group "bak" now active
tdamac ~ # e2fsck -f /dev/bak/safe
e2fsck 1.41.3 (12-Oct-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/bak/safe: 2234755/91578368 files (0.4% non-contiguous),
197843954/366283776 blocks
