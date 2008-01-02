Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbYABU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbYABU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYABU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:56:20 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:29290 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbYABU4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:56:19 -0500
Date: Wed, 2 Jan 2008 23:55:52 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Jean-Marc Saffroy <jean-marc.saffroy@orange-ftgroup.com>
Cc: daniel.pirkl@email.cz, linux-kernel@vger.kernel.org
Subject: Re: fsx failure on ufs2
Message-ID: <20080102205552.GA16481@rain>
Mail-Followup-To: Jean-Marc Saffroy <jean-marc.saffroy@orange-ftgroup.com>,
	daniel.pirkl@email.cz, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.61.0712141649230.10387@brutus.ri.silicomp.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712141649230.10387@brutus.ri.silicomp.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, sorry for delay.

On Fri, Dec 14, 2007 at 05:21:31PM +0100, Jean-Marc Saffroy wrote:
> For an embedded system, I'm currently evaluating the robustness of ufs2 
> write support on Linux, and my very first test, with fsx, shows serious 
> problems.
>
> My test bed is a single CPU PC with a single IDE disk, that boots FreeBSD 
> 6.2 and Ubuntu 7.10. The kernel on Ubuntu is a vanilla 2.6.23.9 with UFS2 
> write support. fsx is from the freebsd cvs (with a small patch to build on 
> Linux, see after my sig):
>   http://www.freebsd.org/cgi/cvsweb.cgi/src/tools/regression/fsx/
>

Can you try this patch (see attachment)?

-- 
/Evgeniy

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ufs_truncate_zero_fix.patch"

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index f63a09c..572b145 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -404,6 +404,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 		if (tmp) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
 			unlock_super(sb);
+			*err = 0;
 			return 0;
 		}
 	}
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 4320782..34ce4fb 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -273,6 +273,8 @@ repeat:
 		tmp = ufs_new_fragments(inode, p, fragment - blockoff,
 					goal, uspi->s_fpb, err,
 					phys != NULL ? locked_page : NULL);
+		if (!tmp && ufs_data_ptr_to_cpu(sb, p))
+			goto repeat;
 	}
 	if (!tmp) {
 		if ((!blockoff && ufs_data_ptr_to_cpu(sb, p)) ||
@@ -423,10 +425,13 @@ int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head
 	u64 phys64 = 0;
 	
 	if (!create) {
-		phys64 = ufs_frag_map(inode, fragment);
-		UFSD("phys64 = %llu\n", (unsigned long long)phys64);
-		if (phys64)
-			map_bh(bh_result, sb, phys64);
+		if (fragment < UFS_I(inode)->i_lastfrag) {		      
+			phys64 = ufs_frag_map(inode, fragment);
+			if (phys64)
+				map_bh(bh_result, sb, phys64);
+		}
+		UFSD("fragment %llu, phys64 = %llu\n",
+		     (unsigned long long)fragment, (unsigned long long)phys64);
 		return 0;
 	}
 
@@ -502,6 +507,7 @@ out:
 	map_bh(bh_result, sb, phys);
 abort:
 	unlock_kernel();
+	UFSD("EXIT: err %d, new %d\n", err, new);
 	return err;
 
 abort_negative:
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index 311ded3..ef09426 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -390,6 +390,7 @@ static int ufs_alloc_lastblock(struct inode *inode)
 	u64 phys64;
 
 	lastfrag = (i_size_read(inode) + uspi->s_fsize - 1) >> uspi->s_fshift;
+	UFSD("BEGIN lastfrag %llu\n", (unsigned long long)lastfrag);
 
 	if (!lastfrag)
 		goto out;
@@ -418,13 +419,13 @@ static int ufs_alloc_lastblock(struct inode *inode)
 	       clear_buffer_new(bh);
 	       unmap_underlying_metadata(bh->b_bdev,
 					 bh->b_blocknr);
-	       /*
-		* we do not zeroize fragment, because of
-		* if it maped to hole, it already contains zeroes
-		*/
-	       set_buffer_uptodate(bh);
-	       mark_buffer_dirty(bh);
-	       set_page_dirty(lastpage);
+	       if (!buffer_dirty(bh)) {
+		       zero_user_page(lastpage, end * sb->s_blocksize,
+				      sb->s_blocksize, KM_USER0);
+		       set_buffer_uptodate(bh);
+		       mark_buffer_dirty(bh);
+		       set_page_dirty(lastpage);
+	       }	       
        }
 
        if (lastfrag >= UFS_IND_FRAGMENT) {

--9jxsPFA5p3P2qPhR--

