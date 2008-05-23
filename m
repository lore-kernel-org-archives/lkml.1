Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYEWIN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYEWIN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbYEWINX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:13:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56877 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756121AbYEWINS (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:13:18 -0400
Date: Fri, 23 May 2008 18:13:10 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.26-rc4 (revised)
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080523081310.D0E1258C4C29@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_buf.c   |   24 ++++++++--
 fs/xfs/linux-2.6/xfs_buf.h   |   19 +++++++
 fs/xfs/linux-2.6/xfs_file.c  |   17 ++++--
 fs/xfs/linux-2.6/xfs_vnode.h |    8 ---
 fs/xfs/xfs_inode.c           |    9 ++--
 fs/xfs/xfs_vnodeops.c        |  112 ++++++++++++++++--------------------------
 fs/xfs/xfs_vnodeops.h        |    3 +-
 7 files changed, 98 insertions(+), 94 deletions(-)

through these commits:

commit 6ab455eeaff6893cd06da33843e840d888cdc04a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon May 19 16:34:42 2008 +1000

    [XFS] Fix memory corruption with small buffer reads
    
    When we have multiple buffers in a single page for a blocksize == pagesize
    filesystem we might overwrite the page contents if two callers hit it
    shortly after each other. To prevent that we need to keep the page locked
    until I/O is completed and the page marked uptodate.
    
    Thanks to Eric Sandeen for triaging this bug and finding a reproducible
    testcase and Dave Chinner for additional advice.
    
    This should fix kernel.org bz #10421.
    
    Tested-by: Eric Sandeen <sandeen@sandeen.net>
    
    SGI-PV: 981813
    SGI-Modid: xfs-linux-melb:xfs-kern:31173a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit c8f5f12e46f079a954d4f7163ba59dadee08ca26
Author: David Chinner <dgc@sgi.com>
Date:   Tue May 20 11:30:15 2008 +1000

    [XFS] Fix inode list allocation size in writeback.
    
    We only need to allocate space for the number of inodes in the cluster
    when writing back inodes, not every byte in the inode cluster. This
    reduces the amount of memory needing to be allocated to 256 bytes instead
    of 64k.
    
    SGI-PV: 981949
    SGI-Modid: xfs-linux-melb:xfs-kern:31182a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 49383b0e98ad1f69ff4c816eb1961f703df12318
Author: David Chinner <dgc@sgi.com>
Date:   Mon May 19 16:29:34 2008 +1000

    [XFS] Don't allow memory reclaim to wait on the filesystem in inode
    writeback
    
    If we allow memory reclaim to wait on the pages under writeback in inode
    cluster writeback we could deadlock because we are currently holding the
    ILOCK on the initial writeback inode which is needed in data I/O
    completion to change the file size or do unwritten extent conversion
    before the pages are taken out of writeback state.
    
    SGI-PV: 981091
    SGI-Modid: xfs-linux-melb:xfs-kern:31015a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 978b7237123d007b9fa983af6e0e2fa8f97f9934
Author: David Chinner <dgc@sgi.com>
Date:   Mon May 19 16:29:46 2008 +1000

    [XFS] Fix fsync() b0rkage.
    
    xfs_fsync() fails to wait for data I/O completion before checking if the
    inode is dirty or clean to decide whether to log the inode or not. This
    misses inode size updates when the data flushed by the fsync() is
    extending the file.
    
    Hence, like fdatasync(), we need to wait for I/o completion first, then
    check the inode for cleanliness. Doing so makes the behaviour of
    xfs_fsync() identical for fsync and fdatasync and we *always* use
    synchronous semantics if the inode is dirty. Therefore also kill the
    differences and remove the unused flags from the xfs_fsync function and
    callers.
    
    SGI-PV: 981296
    SGI-Modid: xfs-linux-melb:xfs-kern:31033a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
