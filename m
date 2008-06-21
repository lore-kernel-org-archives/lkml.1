Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYFUPsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYFUPsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYFUPrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:47:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48598 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYFUPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:47:27 -0400
Message-Id: <20080621154607.154640724@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jun 2008 17:46:07 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: [rfc patch 0/4] splice: cleanups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Wang reported some problems with NFS export of fuse filesystems,
which turned out to be bad interaction between splice (used by nfsd)
and page cache invalidation.

I looked at the splice code, and found quite a bit of dead code,
duplication, and unnecessary complication.  This patchset attempts to
resolve those, in addition to fixing the invalidation issues.  Some
optimizations are lost in the process like the gang page lookup for
the fully cached case, and I can't really tell if these are important
enough to warrant the extra complexity.

I did minimal testing to verify that splice(2) on regular files still
works.  And since generic_file_splice_read() now shares most of its
code with generic_file_aio_read(), there's not much to go wrong in
there.  That said, it needs more testing...

Comments?

Thanks,
Miklos
--

 drivers/block/loop.c      |    5 
 fs/nfsd/vfs.c             |    9 -
 fs/pipe.c                 |   58 -------
 fs/splice.c               |  371 +++++-----------------------------------------
 include/linux/fs.h        |    2 
 include/linux/pipe_fs_i.h |   36 ----
 kernel/relay.c            |    2 
 mm/filemap.c              |    2 
 net/core/skbuff.c         |    9 -
 9 files changed, 47 insertions(+), 447 deletions(-)
