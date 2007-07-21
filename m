Return-Path: <linux-kernel-owner+w=401wt.eu-S1764573AbXGUU6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764573AbXGUU6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXGUU6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:58:17 -0400
Received: from aug.linbit.com ([212.69.162.22]:37750 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752801AbXGUU6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:58:15 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2007 16:58:15 EDT
Date: Sat, 21 Jul 2007 22:38:19 +0200
From: Lars Ellenberg <lars@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: drbd-user@linbit.com
Subject: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070721203819.GA10706@mail.linbit.com>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
	drbd-user@lists.linbit.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	DRBD wants to go mainline.
	please have a look at the "for-linus" branch of
	git://git.drbd.org/home/git/linux-drbd.git.

Longer story:

Hi there,

for lkml readers who don't know about DRBD yet:
DRBD is the distributed replicated block device,
a stacked block device driver as developed mainly
by Lars Ellenberg and Philipp Reisner
both employed at Linbit.

We implement shared-disk semantics in a shared-nothing cluster.

yes, we even support cluster file systems (OCFS2, GFS2)
[support for this is somewhat clumsy, still,
mainly userland/setup/convenience issues.
but that will improve.]

to actually use it you will need some userland tools
(drbdadm, drbdmeta, drbdsetup).

most unfortunate current limitations:
we support only 2 nodes directly;
but we are working on that, too :)

I'm going to give a presentation/BoF about it
at linux-conf.eu in September.

Currently we are at "stable version 8.0.y" (y == 4 right now,
8.0.5 to be released within a few days.

we have a project home page http://www.drbd.org
we have some mention on the linux-HA project http://www.linux-ha.org/DRBD
(both are slightly out-dated, unfortunately...)
our subversion repository (yeah, sorry, there has been no git back then)
is at http://svn.drbd.org/drbd/branches/drbd-8.0

and, we have a user base...
[drbd-user readers who are in a position to do so:
please help us get this into mainline! ]

Now, finally, we have a git repository of the kernel module part, too:
 git://git.drbd.org/home/git/linux-drbd.git

it has two branches currently,
 master, which tracks ...torvalds/linux-2.6.git, and 
 for-linus, which tracks the cleaned up patch meant for inclusin in
mainline.
so if interessted please do
 git fetch git://git.drbd.org/home/git/linux-drbd.git +for-linus:drbd-8.0
to get a local branch named drbd-8.0 where you can inspect it.
see below for a diffstat of master..for-linus.

Jens, Andrew, anyone: please review,
and give me advice how to proceed from here.

technically, would you prefer
frequent rebase of the "for-linus" branch,
or rather merges back and forth?

Cheers,

	Lars




The only not drbd specific files touched
are listed explicitly here:

=====================
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a4a3119..76f84bc 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -272,6 +272,8 @@ config BLK_DEV_CRYPTOLOOP
 	  instead, which can be configured to be on-disk compatible with the
 	  cryptoloop device.
 
+source "drivers/block/drbd/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 819c829..b27e16a 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_LGUEST_GUEST)	+= lguest_blk.o
+obj-$(CONFIG_BLK_DEV_DRBD)	+= drbd/
diff --git a/include/linux/major.h b/include/linux/major.h
index 0cb9805..2dbd7c1 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -145,6 +145,8 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
+
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
=====================

(yes, block major 147 is assigned by LANANA,
 as documented in Documentation/devices.txt already)

git-diff master..for-linus | diffstat
 drivers/block/Kconfig              |    2 
 drivers/block/Makefile             |    1 
 drivers/block/drbd/Kconfig         |   32 
 drivers/block/drbd/Makefile        |    7 
 drivers/block/drbd/drbd_actlog.c   | 1456 ++++++++++++++++
 drivers/block/drbd/drbd_bitmap.c   | 1184 +++++++++++++
 drivers/block/drbd/drbd_buildtag.c |    6 
 drivers/block/drbd/drbd_int.h      | 1894 ++++++++++++++++++++
 drivers/block/drbd/drbd_main.c     | 3249 +++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_nl.c       | 1847 ++++++++++++++++++++
 drivers/block/drbd/drbd_proc.c     |  267 ++
 drivers/block/drbd/drbd_receiver.c | 3356 +++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_req.c      | 1169 ++++++++++++
 drivers/block/drbd/drbd_req.h      |  320 +++
 drivers/block/drbd/drbd_strings.c  |  106 +
 drivers/block/drbd/drbd_worker.c   | 1046 +++++++++++
 drivers/block/drbd/drbd_wrappers.h |  144 +
 drivers/block/drbd/lru_cache.c     |  370 ++++
 drivers/block/drbd/lru_cache.h     |  147 +
 include/linux/drbd.h               |  284 +++
 include/linux/drbd_config.h        |   55 
 include/linux/drbd_limits.h        |  124 +
 include/linux/drbd_nl.h            |  105 +
 include/linux/drbd_tag_magic.h     |   78 
 include/linux/major.h              |    2 
 25 files changed, 17251 insertions(+)

 

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
