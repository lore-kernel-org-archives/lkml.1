Return-Path: <linux-kernel-owner+w=401wt.eu-S1030614AbXCSVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614AbXCSVlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964944AbXCSVlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:55682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030611AbXCSVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:08 -0400
Date: Mon, 19 Mar 2007 14:39:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, olof@lixom.net,
       Trond.Myklebust@netapp.com, trond.myklebust@fys.uio.no
Subject: [patch 13/31] nfs: nfs_getattr() cant call nfs_sync_mapping_range() for non-regular files
Message-ID: <20070319213914.GO9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-nfs_getattr-can-t-call-nfs_sync_mapping_range-for-non-regular-files.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Trond Myklebust <trond.myklebust@fys.uio.no>

Looks like we need a check in nfs_getattr() for a regular file. It makes
no sense to call nfs_sync_mapping_range() on anything else. I think that
should fix your problem: it will stop the NFS client from interfering
with dirty pages on that inode's mapping.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -422,7 +422,8 @@ int nfs_getattr(struct vfsmount *mnt, st
 	int err;
 
 	/* Flush out writes to the server in order to update c/mtime */
-	nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 
 	/*
 	 * We may force a getattr if the user cares about atime.

-- 
