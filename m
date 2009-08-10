Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZHJMSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZHJMSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZHJMS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:18:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZHJMS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:18:28 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 0/3] vfs: change sb->s_maxbytes to loff_t (try #2)
Date: Mon, 10 Aug 2009 08:17:40 -0400
Message-Id: <1249906663-7572-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second attempt at a set to convert s_maxbytes to loff_t. The
first set had a patch for fiemap that doesn't seem to actually be needed
and removed a check from do_sendfile that does seem to be needed. This
set should fix those problems and also cleans up the warning in
vfs_kern_mount a bit.

Recently, I spent a day or so tracking down a long-standing problem with
CIFS and sendfile(). The problem turned out to be that CIFS was setting
s_maxbytes to a value that, when cast to a signed value, became
negative. This broke the offset checks in do_sendfile().

While I fixed this in CIFS, it turns out that this problem is actually a
little more widespread. Since setting s_maxbytes to a value larger than
MAX_LFS_FILESIZE breaks things, I believe it makes sense to turn
s_maxbytes into an loff_t. Most of the places that compare values to
s_maxbytes are comparing it against signed loff_t values, so this change
should help reduce the amount of implicit conversion that needs to be
done.

I've looked at the places that use s_maxbytes and didn't see any that
would immediately break with this change. That said, some of the
calculations that filesystems use to set s_maxbytes are convoluted, so
it's possible that I missed some. A critical eye toward that when
reviewing would be good.

This set is only lightly tested, but it's fairly straightforward. Many
thanks to those that have reviewed this so far.

Jeff Layton (3):
  vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to
    signed
  vfs: remove redundant position check in do_sendfile
  vfs: change sb->s_maxbytes to a loff_t

 fs/libfs.c         |    2 +-
 fs/read_write.c    |    3 ---
 fs/super.c         |   10 ++++++++++
 include/linux/fs.h |    2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

