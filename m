Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXLLCy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXLLCy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbXLLCyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:54:50 -0500
Received: from pat.uio.no ([129.240.10.15]:57925 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXLLCyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:54:49 -0500
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <20071210185720.GA32466@bingen.suse.de>
References: <200712031623.58223.ak@suse.de> <200712081422.30815.ak@suse.de>
	 <1197243901.11792.1.camel@heimdal.trondhjem.org>
	 <20071210185720.GA32466@bingen.suse.de>
Content-Type: multipart/mixed; boundary="=-XMAP5Yl3GNondlnW9SOB"
Date: Tue, 11 Dec 2007 21:54:44 -0500
Message-Id: <1197428085.28126.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=5.0, autolearn=disabled, AWL=-0.355)
X-UiO-Scanned: 685C30BCBF8F31A1D0D6D22054B6EB48BC0BB976
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 133 total 5695633 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XMAP5Yl3GNondlnW9SOB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 2007-12-10 at 19:57 +0100, Andi Kleen wrote:
> > Hi Andi,
> > 
> > Does the attached patch fix the Oops?
> 
> Nope, got that a few hours after boot again:
> 
> -Andi

Hi Andi,

I appear to have misread d_find_alias(). It would seem that the only way
to ensure that a mountpoint won't be found is to remove it altogether
from the inode->i_dentry list. AFAICS that should be largely harmless
since the nfs sb->s_root is never visible to users, and is never part of
a dentry tree.

Cheers
  Trond


--=-XMAP5Yl3GNondlnW9SOB
Content-Disposition: inline; filename=linux-2.6.24-003-fix_oops_in_nfs_unmount.dif
Content-Type: message/rfc822; name=linux-2.6.24-003-fix_oops_in_nfs_unmount.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: 
Subject: NFS: Fix an Oops in NFS unmount
Message-Id: <1197428085.28126.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Ensure that the dummy 'root dentry' is invisible to d_find_alias(). If not,
then it may be spliced into the tree if a parent directory from the same
filesystem gets mounted at a later time.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/getroot.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 0ee4384..e6242cd 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -57,6 +57,17 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 		}
 		/* Circumvent igrab(): we know the inode is not being freed */
 		atomic_inc(&inode->i_count);
+		/*
+		 * Ensure that this dentry is invisible to d_find_alias().
+		 * Otherwise, it may be spliced into the tree by
+		 * d_materialise_unique if a parent directory from the same
+		 * filesystem gets mounted at a later time.
+		 * This again causes shrink_dcache_for_umount_subtree() to
+		 * Oops, since the test for IS_ROOT() will fail.
+		 */
+		spin_lock(&dcache_lock);
+		list_del_init(&sb->s_root->d_alias);
+		spin_unlock(&dcache_lock);
 	}
 	return 0;
 }

--=-XMAP5Yl3GNondlnW9SOB--

