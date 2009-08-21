Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbZHURYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbZHURYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbZHURYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:24:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbZHURYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:07 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/17] Make O_SYNC handling use standard syncing path (Version 2)
Date: Fri, 21 Aug 2009 19:23:50 +0200
Message-Id: <1250875447-15622-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

  first, sorry for a few patches sent before this one - I forgot to give
--compose to git send-email and there was a bug in the third patch.
  This is the second version of my patch set improving O_SYNC implementation.
The changes against previous version are small. Most notably
generic_file_aio_write() now triggers fsync() even when it returns EIOCBQUEUED
so that we behave the same way as generic_file_direct_write() did. I've
added patch renaming generic_file_aio_write_nolock() to device_aio_write()
(since it's used by fs/block_dev.c and drivers/char/raw.c). And finally
I've optimized XFS syncing as Christoph has suggested.
  Any comments welcome and BTW I'd be happy if affected fs maintainers
had a look at those patches so that I can add their ack.
									Honza
---
  Here's some rationale for the patch set:
The patch set unifines O_SYNC handling with standard fsync() path.  After this,
we have just one place forcing a single file to disk so filesystems like ext3 /
ext4 don't have to force a transaction commit in ext?_file_write for O_SYNC
files / IS_SYNC inodes.  The code is also cleaner this way (actually about 150
lines shorter), we don't sync the inode several times as it happened previously
etc.

