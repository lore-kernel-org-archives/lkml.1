Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZERCVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZERCVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZERCVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:21:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4738 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZERCVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:21:30 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
Date: Sun, 17 May 2009 19:21:08 -0700
Message-Id: <cover.1242609803.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly mechanical conversion of printk's

There is a change in drivers/ide/ide-cd_verbose.c that
cleans up a printk with pr_cont to use pr_err

Done via:

for file in $(find drivers/ide/ | grep -E "*\.[ch]$") ; do
    sed -i -r -e 's/\bprintk\s*\(\s*KERN_<foo>\s*/pr_<foo>\(/g' $file
done

and emacs indent and verification cleanup

_file=
git diff -U1 |
grep -E "^(\+\+\+|\@\@)" |
sed -e 's/^\+\+\+ b\//f:/g' |
sed -r -e 's/^\@\@ \-([0-9]+).*/l:\1/g' |
while read line ; do
    if [ $(echo $line | cut -f1 -d":") = "f" ] ; then
	_file=$(echo $line | cut -f2- -d":")
    else
	echo $_file:$(echo $line | cut -f2- -d":")
    fi
done |
while read line ; do
    emacs \
	+$(echo $line | cut -f2 -d":" | awk '{print($0 + 1)}') \
	$(echo $line | cut -f1 -d":") \
	-f set-mark-command \
	-f c-end-of-statement \
	-f c-indent-line-or-region \
	-f save-buffer
done

Joe Perches (6):
  drivers/ide: Convert printk(KERN_DEBUG to pr_debug(
  drivers/ide: Convert printk(KERN_INFO to pr_info(
  drivers/ide: Convert printk(KERN_ERR to pr_err(
  drivers/ide: Convert printk(KERN_WARNING to pr_warning(
  drivers/ide: Convert printk(KERN_CONT to pr_cont(
  drivers/ide: Convert printk(KERN_NOTICE to pr_notice(

 drivers/ide/aec62xx.c          |    4 +-
 drivers/ide/ali14xx.c          |   12 ++--
 drivers/ide/alim15x3.c         |    4 +-
 drivers/ide/amd74xx.c          |   12 ++--
 drivers/ide/au1xxx-ide.c       |   18 +++---
 drivers/ide/buddha.c           |    3 +-
 drivers/ide/cmd640.c           |   21 +++----
 drivers/ide/cs5520.c           |    7 +-
 drivers/ide/cs5530.c           |    4 +-
 drivers/ide/cs5536.c           |    4 +-
 drivers/ide/cy82c693.c         |   11 ++--
 drivers/ide/delkin_cb.c        |    4 +-
 drivers/ide/dtc2278.c          |    2 +-
 drivers/ide/falconide.c        |    6 +-
 drivers/ide/gayle.c            |    6 +-
 drivers/ide/hpt366.c           |   38 ++++++------
 drivers/ide/ht6560b.c          |    5 +-
 drivers/ide/ide-4drives.c      |    7 +-
 drivers/ide/ide-acpi.c         |   26 ++++-----
 drivers/ide/ide-atapi.c        |   66 ++++++++++-----------
 drivers/ide/ide-cd.c           |   71 ++++++++++------------
 drivers/ide/ide-cd_ioctl.c     |    3 +-
 drivers/ide/ide-cd_verbose.c   |   66 ++++++++++++---------
 drivers/ide/ide-cs.c           |   15 ++---
 drivers/ide/ide-disk.c         |   48 +++++++--------
 drivers/ide/ide-dma-sff.c      |    8 +-
 drivers/ide/ide-dma.c          |   27 ++++-----
 drivers/ide/ide-eh.c           |   26 ++++----
 drivers/ide/ide-floppy.c       |   61 +++++++++----------
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 drivers/ide/ide-gd.c           |   12 ++--
 drivers/ide/ide-generic.c      |   16 ++---
 drivers/ide/ide-h8300.c        |    4 +-
 drivers/ide/ide-io.c           |   15 ++---
 drivers/ide/ide-ioctls.c       |    4 +-
 drivers/ide/ide-iops.c         |   13 ++--
 drivers/ide/ide-legacy.c       |    8 +-
 drivers/ide/ide-lib.c          |   68 +++++++++++-----------
 drivers/ide/ide-pci-generic.c  |    4 +-
 drivers/ide/ide-pm.c           |    6 +-
 drivers/ide/ide-pnp.c          |   10 ++--
 drivers/ide/ide-probe.c        |   97 +++++++++++++++---------------
 drivers/ide/ide-proc.c         |   15 ++---
 drivers/ide/ide-scan-pci.c     |    4 +-
 drivers/ide/ide-tape.c         |  126 +++++++++++++++++-----------------------
 drivers/ide/ide-taskfile.c     |   26 ++++-----
 drivers/ide/ide-xfer-mode.c    |   12 ++--
 drivers/ide/ide.c              |   24 +++-----
 drivers/ide/it821x.c           |   19 +++---
 drivers/ide/macide.c           |    4 +-
 drivers/ide/opti621.c          |    2 +-
 drivers/ide/palm_bk3710.c      |   12 ++--
 drivers/ide/pdc202xx_new.c     |   25 ++++----
 drivers/ide/pdc202xx_old.c     |   21 +++----
 drivers/ide/piix.c             |    4 +-
 drivers/ide/pmac.c             |   71 +++++++++++-----------
 drivers/ide/q40ide.c           |    2 +-
 drivers/ide/qd65xx.c           |   40 ++++++------
 drivers/ide/rz1000.c           |    8 +-
 drivers/ide/scc_pata.c         |   20 +++---
 drivers/ide/serverworks.c      |    4 +-
 drivers/ide/setup-pci.c        |   86 +++++++++++++--------------
 drivers/ide/sgiioc4.c          |   70 +++++++++-------------
 drivers/ide/siimage.c          |   21 +++----
 drivers/ide/sis5513.c          |   10 ++--
 drivers/ide/sl82c105.c         |   10 ++--
 drivers/ide/tc86c001.c         |    6 +-
 drivers/ide/trm290.c           |   12 ++--
 drivers/ide/tx4939ide.c        |    4 +-
 drivers/ide/umc8672.c          |    6 +-
 drivers/ide/via82cxxx.c        |   13 ++--
 71 files changed, 722 insertions(+), 799 deletions(-)

