Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZEaOeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZEaOeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZEaOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:33:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49478 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZEaOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=GAcU1JURIvPtotD/9MIG2en6B6XGW3PXiBOq8bFuM9TtUoPHtCXWDZiXtdz0h3dgCe
         7Nc2ZgnZkwp5Qh6+3wOAkv14ARqza7KrgfW6faGwvSBk3bzNpzdFY85wRlDS0XG/+HUr
         BJFXeALYr4ZKoAhaQZgcnvlSKSIlltKY/RT3g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Date: Sun, 31 May 2009 16:39:11 +0200
Message-Id: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/4] partitions/ide: improve Host Protected Area handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since from the perspective of most users of recent systems, disabling
Host Protected Area (HPA) can break vendor RAID formats, GPT partitions
and risks corrupting firmware or overwriting vendor system recovery tools
this patchset makes the IDE subsystem preserve HPA by default.

Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
disabling HPA and using full disk capacity) was introduced at the time
when the main use of HPA was to make the drive look small enough for the
BIOS to allow the system to boot with large capacity drives.

Thus to allow the maximum compatibility with the existing setups (using
HPA and partitioned with HPA disabled) we automatically disable HPA if
any partitions overlapping HPA are detected.  Additionally HPA can also
be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
to disable HPA on /dev/hda).

I tested it with artificially created HPA (using 'hdparm -N p', kudos to
Mark Lord for that) and it worked as expected:

	hda: Host Protected Area detected.
		current capacity is 117210000 sectors (60011 MB)
		native  capacity is 117210240 sectors (60011 MB)
	hda: 117210000 sectors (60011 MB) w/7884KiB Cache, CHS=16383/255/63
	hda: cache flushes supported
	 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
	hda: p6 size 44869482 exceeds device capacity, enabling native capacity
	hda: detected capacity change from 60011520000 to 60011642880


Thanks to Robert Hancock, Frans Pop and Andries E. Brouwer for input/ideas on
previous (now obsoleted) HPA patches.

[ Robert, it seems possible to use ->set_capacity block device method also in
  libata to improving HPA handling and fix previously discussed compatibility
  issue. ]


patches:
 #01: warn about the partition exceeding device capacity in rescan_partions()

 #02: add ->set_capacity method to struct block_device_operations and use it
      in rescan_partitions() to enable native device capacity if any partition
      exceeding device capacity is detected

 #03: implement ->set_capacity method in ide-gd device driver to handle HPA

 #04: change the original kernel behavior and preserve HPA by default

 For easier testing the combined patch against 2.6.30-rc7 is available here:

	http://www.kernel.org/pub/linux/kernel/people/bart/hpa-2.6.30-rc7.patch


diffstat:
 Documentation/ide/ide.txt           |    2 +
 Documentation/kernel-parameters.txt |    7 +-----
 drivers/ide/ide-disk.c              |   22 ++++++++++++++++++
 drivers/ide/ide-gd.c                |   14 ++++++++++++
 drivers/ide/ide.c                   |   10 ++++++++
 fs/partitions/check.c               |   42 +++++++++++++++++++++++++++---------
 include/linux/blkdev.h              |    2 +
 include/linux/genhd.h               |    1 
 include/linux/ide.h                 |    6 +++--
 9 files changed, 88 insertions(+), 18 deletions(-)
