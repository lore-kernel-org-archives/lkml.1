Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZEACon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZEACon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZEACo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47259 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZEACo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vM7u3rrrzWPuy8t8FdF0A7EG5wLb4LQYkYLfmVptny8o7KIDW2dYuA+YOIW9Sg/4Sn
         DnEwJex1uJ3fEg7SAJlP+IN5+Q0+Qhy+5JyLr8ULV/T1tDtX5DLCH/9ML0qPNnMsRdrs
         dwCzHy8rhE3SVG3G55A/tkGv6nzpkhD+QkfAs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements, faster than Bkl based scheme
Date: Fri,  1 May 2009 04:44:16 +0200
Message-Id: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This reiserfs patchset applies against latest tip:core/kill-the-BKL
It adds various explicit write lock releases on specific sleeping sections.

A performance test with dbench on UP with 100 processus during 100 seconds
gives the following results:

Locking		  Throughput 

Bkl:              11.2587 MB/s
Write lock/Mutex: 12.5713 MB/s

So the new locking scheme makes it 11% faster than with the bkl.

It's not possible to compare it on the kill-the-BKL tree because the Bkl
is not anymore a Bkl inside but a plain Mutex.

Instead, you can apply the following equivalent patch against -rc3 to test it:
http://www.kernel.org/pub/linux/kernel/people/frederic/reiserfs-kill-the-bkl-full.patch

Of course it might eat your data, make you cows produce black milk, bring coffee
to your children at 3:00 am, turn the teletubbies song in your mind for
seven years long and so...

Frederic.

The following changes since commit a3a2b793d18bc068b79508e96eba33ae2326f759:
  Alessio Igor Bogani (1):
        remove the BKL: remove "BKL auto-drop" assumption from ext3_remount()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git bkl

Frederic Weisbecker (6):
      kill-the-BKL/reiserfs: release write lock on fs_changed()
      kill-the-BKL/reiserfs: release the write lock before rescheduling on do_journal_end()
      kill-the-BKL/reiserfs: release write lock while rescheduling on prepare_for_delete_or_cut()
      kill-the-BKL/reiserfs: release the write lock inside get_neighbors()
      kill-the-BKL/reiserfs: release the write lock inside reiserfs_read_bitmap_block()
      kill-the-BKL/reiserfs: release the write lock on flush_commit_list()

 fs/reiserfs/bitmap.c        |    2 ++
 fs/reiserfs/fix_node.c      |    4 ++++
 fs/reiserfs/journal.c       |    9 +++++++--
 fs/reiserfs/stree.c         |    2 ++
 include/linux/reiserfs_fs.h |    8 +++++++-
 5 files changed, 22 insertions(+), 3 deletions(-)
