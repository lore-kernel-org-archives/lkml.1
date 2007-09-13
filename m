Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbXIMXph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbXIMXph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbXIMXov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:44:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57142 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760875AbXIMXou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:44:50 -0400
Date: Thu, 13 Sep 2007 16:37:51 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Some driver core and kobject minor patches
Message-ID: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay pointed out to me the other day that we are dragging around 20 bytes
in every struct kobject and in every struct device to contain a name
string that can be dynamically allocated instead.  For small device
names (the majority), this savings can add up, especially with a lot of
individual devices.

So, I started out by getting rid of the static array in the kobject
structure, as we already were dynamically allocating space if it was
needed.

Of course, this required a number of other minor cleanups through the
code tree to handle places where we were incorrectly directly accessing
the kobject name instead of using the "proper" function.  I also got
sidetracked by a few driver core and kobject.h cleanups of macros that
are no longer needed, or functions that no longer need to be global
(they were never exported, so we don't have to worry about that mess...)

And I added a change to trigger a warning if we add an attribute to
sysfs that we have already had created, to help the SCSI developers out
with their driver model reworks.

So, here's a series of 11 patches that I've added to my tree, and will
send to Linus when 2.6.24 is opened up.

Any review comments are appreciated.  The full diffstat is below showing
that overall, we did get rid of more code than was added.

thanks,

greg k-h

 block/bsg.c                         |    5 --
 block/elevator.c                    |    2 
 block/ll_rw_blk.c                   |    2 
 drivers/acpi/bus.c                  |    2 
 drivers/base/base.h                 |    2 
 drivers/base/bus.c                  |   60 ++++++++++++++--------------
 drivers/base/class.c                |    6 +-
 drivers/base/sys.c                  |    2 
 drivers/char/raw.c                  |    5 --
 drivers/cpufreq/cpufreq.c           |    2 
 drivers/edac/edac_mc_sysfs.c        |    3 -
 drivers/md/md.c                     |    3 -
 drivers/media/dvb/dvb-core/dvbdev.c |    5 --
 drivers/usb/core/devio.c            |    6 --
 fs/dlm/lockspace.c                  |    2 
 fs/gfs2/locking/dlm/sysfs.c         |    2 
 fs/gfs2/sys.c                       |    2 
 fs/ocfs2/cluster/masklog.c          |    3 -
 fs/partitions/check.c               |   12 +++--
 fs/sysfs/dir.c                      |    6 ++
 include/linux/kobject.h             |   46 +---------------------
 lib/kobject.c                       |   75 ++++++++++++++++--------------------
 net/bridge/br_sysfs_br.c            |    2 
 23 files changed, 102 insertions(+), 153 deletions(-)

