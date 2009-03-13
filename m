Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZCMTC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZCMTC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZCMTCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:02:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:43737 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZCMTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=pNZh2hJSW3Y+YlagLMIePaW75itNkH6ydc4KolXaGfjSHzS9swYXrhE++4iH/LsxFv
         2G/yMru3eJ0/OgZiN9sQUb+q/Y5Wc8NYkInzdwjxvvNfpDLozXN/HAXyJprJX/NZdNqc
         tMWmLOtzDhv4ytdfe7GKPXDhhbMD7UtaG0s1g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: IDE subsystem status report
Date: Fri, 13 Mar 2009 20:02:41 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903132002.41599.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since there hasn't been an update on the current status of the development in
a rather (too) long time and there are some misunderstandings w.r.t. old/new
design of the subsystem I decided to prepare this short document.

Questions, comments and suggestions are welcomed.

Thanks,
Bart
--


IDE Subsystem Status Report
===========================


1. Introduction

  I've noticed that besides the usual summaries given in the pull requests and
few LKML specific discussions there haven't been much updates on the status of
IDE subsystem (CONFIG_IDE, not to be mistaken with CONFIG_ATA).  Reasons for
that are that there was a lot of overdue work to take care of first and as we
were getting through it new things kept popping out, also since the code was
in a flux making a summary would be difficult.  As things are becoming more
peaceful I thought that it would be a good moment to briefly describe what has
been achieved during the last two years (2.6.20-rc6 to 2.6.29-rc6 time-frame).


2. Outline

  The intention of this document is to give the reader an overview of changes
done to IDE subsystem and future development directions.  I tried to not go
too much into IDE specific technical details so it should be also parseable
for people who are not familiar with IDE subsystem internals or ATA hardware
specifics (if you would like to know more you are always encouraged to hang at
linux-ide@vger.kernel.org and/or read commit logs).

  Lets start with trying to measure the total amount of changes to drivers/ide/
directory during 2.6.20-rc6 to 2.6.29-rc6 period:

$ git diff v2.6.20-rc6..v2.6.29-rc6 drivers/ide/ | diffstat
...
 158 files changed, 36251 insertions(+), 45315 deletions(-)

and then comparing it to the current size of drivers/ide/:

$ wc -l drivers/ide/*.c
...
  42046 total

it shows us that the total subsystem code shrank by ~18% (in reality even more
than that but I was too lazy to account IDE changes outside main directory,
i.e. removal of arch specific IDE hooks) which is not a such bad result given
that we kept on adding new features and hardware support.  While diffstat
output is a bit blurred by the fact that the superfluous drivers/ide/
sub-directories have been removed it seems that we've almost completely
rewrote the subsystem so that it now barely resembles the old 2.4.x design
(just before I took over IDE in 2.5.7x days most of 2.5.x changes have been
dropped and subsystem has been reverted to 2.4.x).   The main reason behind
such large-scale changes is that without doing this work it was practically
impossible to maintain/debug the old code-base (some people showed concern
about amount of changes or/and their scope but I hope that we proved over time
that such large-scale changes can be done without breaking things too much).
  As many of you know, IDE subsystem is not the only way to drive ATA devices
in Linux.  The other one (ATA-to-SCSI driver) lives in drivers/ata directory
and also supports modern SATA hardware (while IDE supports only some first
generation SATA controllers).  Many distros have switched to using libata also
for PATA and probably more will go in this direction.  However, currently,
libata is not a full replacement for IDE (especially for embedded appliances
and non-x86 hardware) so keeping IDE maintainable and not leaving users in the
cold makes much sense IMO.


3. Changes history.

  Next three subpoints describe in more detail changes done to the core code,
host drivers and device drivers.

3.1. Core code

Core code changes include but are not limited to:

* Redesigning  the monolithic architecture to a more flexible/maintainable
  one in which we have mandatory core parts and optional features (thanks to
  Kconfig language they are automatically selectable by the code that needs
  them so user don't have to even know about them) like IDE SFF DMA support
  (CONFIG_BLK_DEV_IDEDMA_SFF), IDE timings library (CONFIG_IDE_TIMINGS) or
  ATAPI support (CONFIG_IDE_ATAPI)

* Using all available features (like DMA support) by default if available
  (safe fallback is provided by the new kernel parameters interface when
  necessary) and removing redundant config options (i.e. CONFIG_IDEDMA_AUTO,
  CONFIG_IDEDMA_IVB, CONFIG_IDEPCI_SHARE_IRQ, CONFIG_IDE_MAX_HWIFS).

* Untangling of PIO/DMA tuning from host drivers, fixing/enhancing core code
  PIO/DMA tuning support and adding sane host driver interfaces for setting
  timings (with a great deal of work and help from Sergei Shtylyov).

* Adding interface for reading/writing IDE settings which allowed closing many
  races (from Elias Oltmanns).

* Adding IDE ACPI support (from Hannes Reinecke).

* Adding disk head parking support (from Elias Oltmanns).

* Adding warm-plug support using a simple sysfs interface.

* Adding generic IDE DMA layer independent from PCI BMDMA specifics and then
  converting all DMA capable host drivers to use it.

* Dynamic allocation of port/device data structures and support for fully
  modular host drivers (preserving the legacy ordering of /dev/hd* devices).

* Sanitizing taskfile based interface for processing commands and switching
  all commands (fs requests ones, special commands and the ones generated by
  HDIO_DRIVE_{CMD,TASK,TASKFILE} ioctls) over it.

* Improving/simplifying support for serialized interfaces by adding struct
  ide_host and using bit-locking instead of per ide_hwgroup_t locking.

* Scalability improvements: global ide_lock spinlock was replaced by per-port
  ones, this in turn allowed introducing per-device request queues and greatly
  simplifying the code choosing the next device to be serviced.

* Removing no longer needed "hwgroup" support (ide_hwgroup_t & friends).

* Reworking the request handling code to not process the next command in the
  IRQ-context after finishing the previous one (instead just let block layer
  to call into the subsystem again).

* Switching all MMIO hosts drivers over to generic MMIO support.

* Abstracting code responsible for legacy /proc/ide/ support and making the
  interface optional (CONFIG_IDE_PROC_FS).

* Moving legacy hd driver to drivers/block/ (from Adrian Bunk).

* There were also countless bugfixes and cleanups...

3.2. Host drivers

* Most host drivers have been rewritten alongside the core code rewrite.

* New hardware support (not counting simple PCI IDs additions etc.):

- Delkin/ASKA/Workbit Cardbus IDE (from Mark Lord)

- Platform IDE (from Anton Vorontsov)

- AMD CS5536 IDE (based on older driver by Martin K. Petersen)

- IT8172 IDE (from Shane McDonald)

- IT8213 IDE (from Jack Lee)

- Toshiba TC86C001 IDE (from Sergei Shtylyov)

- Toshiba's Cell IDE (from Kou Ishizaki)

- TX4938 IDE (from Atsushi Nemoto)

- TX4939 IDE (ditto)

- Palmchip bk3710 IDE (Anton Salnikov)

* Removed hardware support:

- MPC8xx IDE [platform support removed from the kernel]

- HPT34x IDE [broken, proper support now present in the kernel]

- CRIS IDE [broken, to be reintroduced if needed]

* Not to mention the countless bugfixes and cleanups...

3.3. Device drivers

* All device drivers have been completely rewritten (with a lot of work on
  sanitizing ide-cd, ide-floppy and ide-tape from Borislav Petkov).

* Code for ATAPI support present in ide-{cd,floppy,tape,scsi} drivers has
  been unified and moved to the core code (with a lot of help from Borislav).

* Later ide-disk and ide-floppy drivers have been merged into ide-gd driver
  (generic ATA/ATAPI disk driver) and deprecated ide-scsi driver has been
  finally removed.

* Lets not forget about countless bugfixes and cleanups...


4. Reporting problems

  There were some changes in this area.  Namely all bug-reports should go
through linux-ide@vger.kernel.org mailing list (kernel bugzilla has been
configured in such way that all bugs against IDE component are assigned to
linux-ide ML initially).  Please also keep in mind that project is based on
a voluntary work so while we try to treat regression reports with the utmost
urgency the old bugs are dealt with in the best effort manner.


5. Future plans

  The subsystem is in good shape now so I think that no more radical changes
like the ones that happened recently will be needed.  We will just concentrate
on keeping things working till better solutions take over.


6. Thanks

  I would like to thank all contributors (special thanks to Sergei Shtylyov
and Borislav Petkov) and users (even if it sometimes seems like there is no
apparent action we are always taking notes and using the feedback), also many
thanks to libata developers since some of changes were either inspired by
libata changes or ported over.
