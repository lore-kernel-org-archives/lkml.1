Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYFNAPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYFNAPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbYFNAMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:34152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460AbYFNAMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:49 -0400
Date: Fri, 13 Jun 2008 17:10:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mhalcrow@us.ibm.com, viro@ZenIV.linux.org.uk,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/47] eCryptfs: protect crypt_stat->flags in
	ecryptfs_open()
Message-ID: <20080614001036.GI24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Halcrow <mhalcrow@us.ibm.com>

upstream commit: 2f9b12a31fcb738ea8c9eb0d4ddf906c6f1d696c

Make sure crypt_stat->flags is protected with a lock in ecryptfs_open().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ecryptfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -195,7 +195,9 @@ static int ecryptfs_open(struct inode *i
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
+		mutex_lock(&crypt_stat->cs_mutex);
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = 0;
 		goto out;
 	}

-- 
