Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbYBLLj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbYBLLj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbYBLLjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:39:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:40540 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761689AbYBLLjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:39:19 -0500
Date: Tue, 12 Feb 2008 12:39:17 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: udf regression: broken directory handling
Message-ID: <20080212113916.GA13425@duck.suse.cz>
References: <20080210104754.GH6737@joi> <20080211110910.GB9622@duck.suse.cz> <20080211191313.GA12375@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211191313.GA12375@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-02-08 20:13:20, Marcin Slusarz wrote:
> On Mon, Feb 11, 2008 at 12:09:10PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> > On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> > > Current mainline has a problem with reading file list.
> > > Simple ls prints only 2 out of 8 files on my testing DVD.
> > > Reverting your patch "udf: cleanup directory offset handling"
> > > (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
> >   Thanks for testing! Do you have a way to create such UDF filesystem? For
> > the filesystems I've created it seems to work just fine...
> 
> with patch applied:
  <snip testing>

  Argh, I've submitted an old version of the patch missing changes in
dir.c. Below is the missing hunk. Does UDF work for you with it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Patch cleaning up UDF directory offset handling missed modifications in dir.c
(because I've submitted an old version :(). Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 4b44e23..8d8643a 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -43,13 +43,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	int block, iblock;
-	loff_t nf_pos = filp->f_pos - 1;
+	loff_t nf_pos = (filp->f_pos - 1) << 2;
 	int flen;
 	char fname[UDF_NAME_LEN];
 	char *nameptr;
 	uint16_t liu;
 	uint8_t lfi;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	struct buffer_head *tmp, *bha[16];
 	kernel_lb_addr eloc;
 	uint32_t elen;
@@ -63,13 +63,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		return 0;
 
 	if (nf_pos == 0)
-		nf_pos = (udf_ext0_offset(dir) >> 2);
+		nf_pos = udf_ext0_offset(dir);
 
-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset = nf_pos & (dir->i_sb->s_blocksize - 1);
 	iinfo = UDF_I(dir);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	} else if (inode_bmap(dir, nf_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
@@ -111,7 +111,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	}
 
 	while (nf_pos < size) {
-		filp->f_pos = nf_pos + 1;
+		filp->f_pos = (nf_pos >> 2) + 1;
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
@@ -178,7 +178,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		}
 	} /* end while */
 
-	filp->f_pos = nf_pos + 1;
+	filp->f_pos = (nf_pos >> 2) + 1;
 
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
