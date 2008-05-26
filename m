Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYEZMU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYEZMU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYEZMUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:20:21 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48829 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbYEZMUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:20:20 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 2] UBIFS - new flash file system
Date: Mon, 26 May 2008 17:03:05 +0300
Message-Id: <1211810614-18636-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 26 May 2008 12:19:28.0701 (UTC) FILETIME=[BE94BED0:01C8BF2A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is the third round of UBIFS submission. If you are not aware what
UBIFS is about, please refer Jonathan Corbet's article:
http://lwn.net/Articles/276025/

Also, please refer the second and the first UBIFS submissions which
contain short UBIFS description and URLs.
second: http://marc.info/?l=linux-kernel&m=121006384211288&w=2
first: http://marc.info/?l=linux-kernel&m=120662475821992&w=2

We've addressed most of the requests from the second round:

* Requests from Christoph Hellwig's review (may be found here:
  http://marc.info/?l=linux-kernel&m=121093446502796&w=2). Few things
  related to the background thread were not done though. Here are
  explanations why: http://marc.info/?l=linux-kernel&m=121155640026661&w=2
  and http://marc.info/?l=linux-kernel&m=121119680522445&w=2 (see end
  of the mail).
  Also, we have not changed readdir() implementation so far, but just
  put a comment that we cannot support NFS at the moment. However, we
  have an idea how to fix this, but need some comments from the community.
  We'll send a separate mail describing the problem and the possible
  solution shortly. Nevertheless, this should not be a blocker.
* The 'generic_sync_sb_inodes()' was introduce as it was pointed to by
  Andrew Morton.
* Many build fixes spotted by Andrew Morton.
* Get rid of some dead code spotted by Marcin Slusarz.

Other news is that UBIFS has been sitting in -mm tree for a couple of
weeks already. And of course we have got more bug reports and fixed
more bugs since the last submission.

Christoph prefers tarballs - here it is:
http://www.infradead.org/~dedekind/ubifs/ubifs-08-05-26.tar.bz2

Changes between take 1 and take 2:
* Store milliseconds for [mca]time stamps in the inodes, not only seconds
  (requested by Andi Kleen)
* Documentation/filesystems/ubifs.txt has been added (requested by Josh Boyer)
* do_div() is not anymore used with 'unsigned long long' values
  (requested by Andrew Morton)
* The amount of debugging-related config options was lessened and module
  parameters were introduced instead (requested by Pekka Enberg and
  Christoph Hellwig)
* Many assertions were removed (requested by Pekka Enberg)
* Some debugging checks like custom memory leak and memory pressure checks
  were removed (requested by Pekka Enberg)

Thank you,
Adrian Hunter
Artem Bityutskiy

P.S. The patches are against v2.6.26-rc3.

git-diff --stat --summary -M v2.6.26-rc3
 Documentation/filesystems/ubifs.txt |  163 ++
 fs/Kconfig                          |    3 +
 fs/Makefile                         |    1 +
 fs/fs-writeback.c                   |   22 +-
 fs/ubifs/Kconfig                    |   71 +
 fs/ubifs/Makefile                   |    9 +
 fs/ubifs/budget.c                   |  859 +++++++++
 fs/ubifs/commit.c                   |  718 ++++++++
 fs/ubifs/compress.c                 |  253 +++
 fs/ubifs/debug.c                    | 1486 ++++++++++++++++
 fs/ubifs/debug.h                    |  392 ++++
 fs/ubifs/dir.c                      | 1016 +++++++++++
 fs/ubifs/file.c                     |  960 ++++++++++
 fs/ubifs/find.c                     |  956 ++++++++++
 fs/ubifs/gc.c                       |  761 ++++++++
 fs/ubifs/io.c                       |  921 ++++++++++
 fs/ubifs/ioctl.c                    |  212 +++
 fs/ubifs/journal.c                  | 1275 ++++++++++++++
 fs/ubifs/key.h                      |  532 ++++++
 fs/ubifs/log.c                      |  799 +++++++++
 fs/ubifs/lprops.c                   | 1353 ++++++++++++++
 fs/ubifs/lpt.c                      | 2241 +++++++++++++++++++++++
 fs/ubifs/lpt_commit.c               | 1631 +++++++++++++++++
 fs/ubifs/master.c                   |  387 ++++
 fs/ubifs/misc.h                     |  310 ++++
 fs/ubifs/orphan.c                   |  955 ++++++++++
 fs/ubifs/recovery.c                 | 1509 ++++++++++++++++
 fs/ubifs/replay.c                   | 1009 +++++++++++
 fs/ubifs/sb.c                       |  609 +++++++
 fs/ubifs/scan.c                     |  362 ++++
 fs/ubifs/shrinker.c                 |  322 ++++
 fs/ubifs/super.c                    | 1956 ++++++++++++++++++++
 fs/ubifs/tnc.c                      | 3330 +++++++++++++++++++++++++++++++++++
 fs/ubifs/tnc_commit.c               | 1105 ++++++++++++
 fs/ubifs/tnc_misc.c                 |  259 +++
 fs/ubifs/ubifs-media.h              |  725 ++++++++
 fs/ubifs/ubifs.h                    | 1576 +++++++++++++++++
 fs/ubifs/xattr.c                    |  582 ++++++
 include/linux/fs.h                  |    2 +
 init/do_mounts.c                    |    3 +-
 40 files changed, 31624 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/filesystems/ubifs.txt
 create mode 100644 fs/ubifs/Kconfig
 create mode 100644 fs/ubifs/Makefile
 create mode 100644 fs/ubifs/budget.c
 create mode 100644 fs/ubifs/commit.c
 create mode 100644 fs/ubifs/compress.c
 create mode 100644 fs/ubifs/debug.c
 create mode 100644 fs/ubifs/debug.h
 create mode 100644 fs/ubifs/dir.c
 create mode 100644 fs/ubifs/file.c
 create mode 100644 fs/ubifs/find.c
 create mode 100644 fs/ubifs/gc.c
 create mode 100644 fs/ubifs/io.c
 create mode 100644 fs/ubifs/ioctl.c
 create mode 100644 fs/ubifs/journal.c
 create mode 100644 fs/ubifs/key.h
 create mode 100644 fs/ubifs/log.c
 create mode 100644 fs/ubifs/lprops.c
 create mode 100644 fs/ubifs/lpt.c
 create mode 100644 fs/ubifs/lpt_commit.c
 create mode 100644 fs/ubifs/master.c
 create mode 100644 fs/ubifs/misc.h
 create mode 100644 fs/ubifs/orphan.c
 create mode 100644 fs/ubifs/recovery.c
 create mode 100644 fs/ubifs/replay.c
 create mode 100644 fs/ubifs/sb.c
 create mode 100644 fs/ubifs/scan.c
 create mode 100644 fs/ubifs/shrinker.c
 create mode 100644 fs/ubifs/super.c
 create mode 100644 fs/ubifs/tnc.c
 create mode 100644 fs/ubifs/tnc_commit.c
 create mode 100644 fs/ubifs/tnc_misc.c
 create mode 100644 fs/ubifs/ubifs-media.h
 create mode 100644 fs/ubifs/ubifs.h
 create mode 100644 fs/ubifs/xattr.c
