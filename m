Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYI3HmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYI3HmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYI3Hlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:41:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58877 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYI3Hlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:46 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: What is in ubifs-2.6.git
Date: Tue, 30 Sep 2008 12:18:56 +0300
Message-Id: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0397 (UTC) FILETIME=[F7934BD0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the stuff we have scheduled for 2.6.28. The patches
contains various small fixes and cleanups, but there is something
interesting as well.

The first interesting thing is new "bulk read" functionality. The
idea is that many NAND flashes support "bulk read" in some form.
For example, OneNAND has "read while load" feature, which allows
reading consecutive NAND pages faster than reading them one-by-one.

So we've made UBIFS benefit from this feature and introduced new
"bulk_read" mount option. With this option enabled UBIFS reads files
a little ahead if the file data sits in consecutive physical
addresses. For example, if user-space asks to read page zero of a
file, and page 0-4 are in consecutive flash addressed, UBIFS reads
pages 0-4 and populates them to the Page Cache.

Note, this is disabled by default and UBIFS has to be explicitly
mounted mounted with "bulk_read" option. The reason for this is
that we consider this feature as experimental so far.

Note, UBIFS does not use VFS read-ahead and actually explicitly
disables it. This is because MTD is synchronous and all I/O is
done synchronously, so read-ahead actually slows things down for
UBIFS, instead of improving them. So the "bulk read" feature is
basically internal UBIFS read-ahead implementation.

We are able to gain 4-5MiB/s of read speed on OneNAND with bulk
read enabled.

The second interesting thing is new "no_chk_data_crc" mount option
which disables data CRC32 checking.

UBIFS always checks CRC of everything it reads from flash by default.
On ARM platform this results in ~30% of total CPU usage in profiles,
which is quite high. But many modern flashes are very reliable
(e.g., OneNAND), and one does not need that level of protection.
So now it is possible to disable CRC checking for _data_. However:

* internal indexing information CRC is always checked;
* when replaying the journal, data CRC is always checked;
* on write, CRC is always calculated.

With this mount option we are able to gain another 4-5MiB/s of read
speed on OneNAND. And together with bulk-read, the read speed becomes
~10MiB/s faster.

Adrian Hunter (11):
      UBIFS: add bulk-read facility
      UBIFS: add no_chk_data_crc mount option
      UBIFS: improve znode splitting rules
      UBIFS: correct key comparison
      UBIFS: ensure data read beyond i_size is zeroed out correctly
      UBIFS: allow for sync_fs when read-only
      UBIFS: improve garbage collection
      UBIFS: fix bulk-read handling uptodate pages
      UBIFS: add more debugging messages for LPT
      UBIFS: correct condition to eliminate unecessary assignment
      UBIFS: check buffer length when scanning for LPT nodes

Artem Bityutskiy (9):
      UBIFS: add a print, fix comments and more minor stuff
      UBIFS: inline one-line functions
      UBIFS: check data CRC when in error state
      UBIFS: use bit-fields when possible
      UBIFS: fix races in bit-fields
      UBIFS: fix commentary
      UBIFS: update dbg_dump_inode
      UBIFS: correct comment for commit_on_unmount
      UBIFS: commit on sync_fs

Hirofumi Nakagawa (1):
      UBIFS: remove unneeded unlikely()

Julien Brunel (1):
      UBIFS: use an IS_ERR test rather than a NULL test

 Documentation/filesystems/ubifs.txt |    9 +
 fs/ubifs/budget.c                   |   26 ++--
 fs/ubifs/debug.c                    |   79 +++++++--
 fs/ubifs/debug.h                    |    6 +
 fs/ubifs/file.c                     |  260 ++++++++++++++++++++++++++
 fs/ubifs/find.c                     |    4 +-
 fs/ubifs/gc.c                       |   90 ++++++++--
 fs/ubifs/io.c                       |   12 +-
 fs/ubifs/key.h                      |   22 ++-
 fs/ubifs/lprops.c                   |   34 +----
 fs/ubifs/lpt.c                      |    3 +-
 fs/ubifs/lpt_commit.c               |  187 ++++++++++++++++++-
 fs/ubifs/misc.h                     |   27 +++
 fs/ubifs/scan.c                     |    2 +-
 fs/ubifs/super.c                    |  109 +++++++++--
 fs/ubifs/tnc.c                      |  345 ++++++++++++++++++++++++++++++++---
 fs/ubifs/tnc_misc.c                 |    4 +-
 fs/ubifs/ubifs-media.h              |    1 -
 fs/ubifs/ubifs.h                    |   85 +++++++--
 fs/ubifs/xattr.c                    |    2 +-
 20 files changed, 1149 insertions(+), 158 deletions(-)

--
Best regards,
Artem Bityutskiy (Битюцкий Артём)
