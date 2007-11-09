Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbXKISfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbXKISfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXKISfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:35:07 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:47562 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXKISfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:35:05 -0500
Message-ID: <4734A858.2010307@oracle.com>
Date: Fri, 09 Nov 2007 10:35:04 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-aio@kvack.org
Subject: Re: dio_get_page() lockdep complaints
References: <20070419073828.GB20928@kernel.dk>	<1194627742.6289.175.camel@twins>	<4734992C.7000408@oracle.com>	<1194630300.7459.65.camel@heimdal.trondhjem.org>	<47349D66.2040109@oracle.com> <20071109130156.4b05a652@think.oraclecorp.com>
In-Reply-To: <20071109130156.4b05a652@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Without getting into a huge patch, the best fix would just be switching
> to try lock.  If the tail doesn't get packed, the world doesn't end.

So, something like this?

---

reiserfs: trylock i_mutex in file release when packing

The mmap_sem is nested under the i_mutex.  reiserfs_file_release() wants
to acquire the i_mutex to pack the file but it can be called with the mmap_sem
held by munmap.  This has produced lockdep warnings in testing.

  http://lkml.org/lkml/2007/4/19/73

This acquires the i_mutex in reiserfs_file_release() with a trylock.  If the
i_mutex is already held it simply won't pack.  There are already a host of
conditions under which it won't pack.

Totally untested, but built.

 Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index a804903..40085f1 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -46,7 +46,13 @@ static int reiserfs_file_release(struct inode *inode, struct file *filp)
 		return 0;
 	}
 
-	mutex_lock(&inode->i_mutex);
+	/*
+	 * We can be called from munmap while holding mmap_sem, but mmap_sem
+	 * is nested inside i_mutex.  If we can't get i_mutex then we just
+	 * don't pack.
+	 */
+	if (mutex_trylock(&inode->i_mutex) == 0)
+		return 0;
 
 	mutex_lock(&(REISERFS_I(inode)->i_mmap));
 	if (REISERFS_I(inode)->i_flags & i_ever_mapped)

