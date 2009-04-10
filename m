Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbZDJMNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbZDJMNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZDJMMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:12:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39886 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZDJMMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:12:48 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 00/14] DRBD: a block device for HA clusters
Date: Fri, 10 Apr 2009 14:12:11 +0200
Message-Id: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  This is a repost of DRBD, to keep you updated about the ongoing
  cleanups and improvements.

  Patch set attached. Git tree available:
  git pull git://git.drbd.org/linux-2.6-drbd.git drbd

Description

  DRBD is a shared-nothing, synchronously replicated block device. It
  is designed to serve as a building block for high availability
  clusters and in this context, is a "drop-in" replacement for shared
  storage. Simplistically, you could see it as a network RAID 1.

  Although I use the "RAID1+NBD" metaphor myself, recent discussion
  unveiled that one needs to understand the differences as well.
  Here are just two examples of that:

   1) Think of a two node HA cluster. Node A is active ('primary' in DRBD
    speak) has the filesystem mounted and the application running. Node B is
    in standby mode ('secondary' in DRBD speak).

    We loose network connectivity, the primary node continues to run, the
    secondary no longer gets updates.

    Then we have a complete power failure, both nodes are down. Then they
    power up the data center again, but at first the get only the power
    circuit of node B up and running again.

    Should node B offer the service right now ?
      ( DRBD has configurable policies for that )

    Later on they manage to get node A up and running again, now lets assume
    node B was chosen to be the new primary node. What needs to be done ?

    Modifications on B since it became primary needs to be resynced to A.
    Modifications on A sind it lost contact to B needs to be taken out.

    DRBD does that.

    How do you fit that into a RAID1+NBD model ? NBD is just a block
    transport, it does not offer the ability to exchange dirty bitmaps or
    data generation identifiers, nor does the RAID1 code has a concept of
    that.

   2) When using DRBD over small bandwidth links, one has to run a resync,
    DRBD offers the option to do a "checksum based resync". Similar to rsync
    it at first only exchanges a checksum, and transmits the whole data
    block only if the checksums differ.

    That again is something that does not fit into the concepts of NBD or RAID1.

  DRBD can also be used in dual-Primary mode (device writable on both
  nodes), which means it can exhibit shared disk semantics in a
  shared-nothing cluster.  Needless to say, on top of dual-Primary
  DRBD utilizing a cluster file system is necessary to maintain for
  cache coherency.

  More background on this can be found in this paper:
    http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf

  Beyond that, DRBD addresses various issues of cluster partitioning,
  which the MD/NBD stack, to the best of our knowledge, does not
  solve. The above-mentioned paper goes into some detail about that as
  well.

  DRBD can operate in synchronous mode, or in asynchronous mode. I want
  to point out that we guarantee not to violate a single possible write
  after write dependency when writing on the standby node. More on that
  can be found in this paper:
    http://www.drbd.org/fileadmin/drbd/publications/drbd_lk9.pdf

  Last not least DRBD offers background resynchronisation and keeps
  a on disk representation of the dirty bitmap up-to-date. A reasonable
  tradeoff between number of updates, and resyncing more than needed
  is implemented with the activity log.
  More on that:
    http://www.drbd.org/fileadmin/drbd/publications/drbd-activity-logging_v6.pdf

Changes since the post on 2009-03-30, all triggered by reviews

  * Improvements to Makefile and Kconfig
  * Simplified definitions of bm_flags' bitnumbers
  * Removed debugging aid

Changes since the post on 2009-03-23, from drbd-mainline

  * Updated to the final drbd-8.3.1 code
  * Optionally run-length encode bitmap transfers

Changes since the post on 2009-03-23, triggered by reviews

  * Using the latest proc_create() now
  * Moved the allocation of md_io_tmpp to attach/detach out of drbd_md_sync_page_io()
  * Removing the mode selection comments for emacs
  * Removed DRBD_ratelimit()

cheers,
  Phil
