Return-Path: <linux-kernel-owner+w=401wt.eu-S934646AbYETWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbYETWdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765344AbYETWdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:33:33 -0400
Received: from ns2.suse.de ([195.135.220.15]:38895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYETWdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:33:32 -0400
Date: Tue, 20 May 2008 15:32:37 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes against 2.6.26-rc3
Message-ID: <20080520223237.GA12383@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches against your 2.6.26-rc3-git tree.

They fix a race condition when device_create is called.  At that point
in time sysfs files can be created automatically by the class or the
driver subsystem, and if those files are opened before the device
specific data is set, oopses can happen.  This was found and reported
for the bdi subsystem by Arthur Jones and he verified that these patches
fix the problem.

I then went and audited all users of the api and found other places
where this was also a problem.  This patch series fixes all of those
instances.

The API will be chaned in 2.6.27 so this can not happen in the future by
making device_create() look exactly like device_create_drvdata() but to
do that now would require a few hundred other changes through the tree.
I'll leave that for .27 and have patches queued up right now in -next
for this so it gets good testing.

These patches have been in -mm and -next.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

The patchs will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/base/core.c                    |   85 +++++++++++++++++++++++++++++--
 drivers/ide/ide-probe.c                |    5 +-
 drivers/infiniband/core/user_mad.c     |   14 ++---
 drivers/infiniband/core/uverbs_main.c  |   11 ++--
 drivers/leds/led-class.c               |    6 +--
 drivers/power/power_supply_core.c      |    6 +--
 drivers/s390/char/vmlogrdr.c           |    9 ++--
 drivers/scsi/ch.c                      |    7 +--
 drivers/scsi/osst.c                    |    3 +-
 drivers/scsi/sg.c                      |   11 ++--
 drivers/scsi/st.c                      |   12 +++--
 drivers/uio/uio.c                      |    7 +--
 drivers/usb/core/hcd.c                 |    6 +-
 drivers/usb/misc/phidgetkit.c          |    6 +-
 drivers/usb/misc/phidgetmotorcontrol.c |    7 +--
 drivers/usb/misc/phidgetservo.c        |    6 +-
 drivers/video/display/display-sysfs.c  |   10 +++-
 include/linux/device.h                 |   12 +++++
 mm/backing-dev.c                       |   12 +----
 sound/core/sound.c                     |    8 +--
 20 files changed, 157 insertions(+), 86 deletions(-)

---------------

Greg Kroah-Hartman (13):
      Driver core: add device_create_vargs and device_create_drvdata
      mm: bdi: fix race in bdi_class device creation
      fbdev: fix race in device_create
      ide: fix race in device_create
      IB: fix race in device_create
      LEDS: fix race in device_create
      Power Supply: fix race in device_create
      UIO: fix race in device_create
      SOUND: fix race in device_create
      s390: fix race in device_create
      USB: Phidget: fix race in device_create
      USB: Core: fix race in device_create
      SCSI: fix race in device_create

