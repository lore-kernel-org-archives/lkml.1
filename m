Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZHGS6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZHGS6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932892AbZHGS6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:58:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZHGS6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:58:02 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 0/4] vfs: change sb->s_maxbytes to loff_t
Date: Fri,  7 Aug 2009 14:57:37 -0400
Message-Id: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, I spent a day or so tracking down a long-standing problem with
CIFS and sendfile(). The problem turned out to be that CIFS was setting
s_maxbytes to a value that, when cast to a signed value, became
negative.  This broke the offset checks in do_sendfile().

While I fixed this in CIFS, it turns out that this problem is actually a
little more widespread. Since setting s_maxbytes to a value larger than
MAX_LFS_FILESIZE breaks things, I believe it makes sense to turn
s_maxbytes into an loff_t. Most of the places that compare values to
s_maxbytes are comparing it against signed loff_t values, so this change
should help reduce the amount of implicit casting that's done in the
code.

I've looked at most of the places that use s_maxbytes and have tried to
fix areas that look like they might have problems with this change. It's
quite possible though that I've missed some, so a careful eye for that
when reviewing this would be a good thing.

This set is only lightly tested, but it's fairly straightforward.

Jeff Layton (4):
  vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to
    signed
  vfs: explicitly cast s_maxbytes in fiemap_check_ranges
  vfs: change sb->s_maxbytes to a loff_t
  vfs: remove redundant checks in do_sendfile

 fs/ioctl.c         |    9 +++++----
 fs/libfs.c         |    2 +-
 fs/read_write.c    |   11 -----------
 fs/super.c         |   10 ++++++++++
 include/linux/fs.h |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

