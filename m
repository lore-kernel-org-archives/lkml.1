Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZC3QsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZC3QsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZC3Qrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:47:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:46562 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZC3Qrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:47:47 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, jens.axboe@oracle.com, nab@risingtidestorage.com,
       andi@firstfloor.org
Subject: [PATCH 00/12] DRBD: a block device for HA clusters
Date: Mon, 30 Mar 2009 18:47:08 +0200
Message-Id: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  This is a repost of DRBD, to keep you updated about the ongoing
  cleanups.

Description

  DRBD is a shared-nothing, synchronously replicated block device. It
  is designed to serve as a building block for high availability
  clusters and in this context, is a "drop-in" replacement for shared
  storage. Simplistically, you could see it as a network RAID 1.

  Each minor device has a role, which can be 'primary' or 'secondary'.
  On the node with the primary device the application is supposed to
  run and to access the device (/dev/drbdX). Every write is sent to
  the local 'lower level block device' and, across the network, to the
  node with the device in 'secondary' state.  The secondary device
  simply writes the data to its lower level block device.

  DRBD can also be used in dual-Primary mode (device writable on both
  nodes), which means it can exhibit shared disk semantics in a
  shared-nothing cluster.  Needless to say, on top of dual-Primary
  DRBD utilizing a cluster file system is necessary to maintain for
  cache coherency.

  This is one of the areas where DRBD differs notably from RAID1 (say
  md) stacked on top of NBD or iSCSI. DRBD solves the issue of
  concurrent writes to the same on disk location. That is an error of
  the layer above us -- it usually indicates a broken lock manager in
  a cluster file system --, but DRBD has to ensure that both sides
  agree on which write came last, and therefore overwrites the other
  write.

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

Changes since the last post from DRBD upstream

  * Updated to the final drbd-8.3.1 code
  * Optionally run-length encode bitmap transfers

Changes triggered by reviews

  * Using the latest proc_create() now
  * Moved the allocation of md_io_tmpp to attach/detach out of drbd_md_sync_page_io()
  * Removing the mode selection comments for emacs
  * Removed DRBD_ratelimit()

cheers,
  Phil
