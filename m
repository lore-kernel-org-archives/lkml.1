Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYJGUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYJGUSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYJGUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:18:23 -0400
Received: from ns.suse.de ([195.135.220.2]:38473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYJGUSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:18:22 -0400
Date: Tue, 7 Oct 2008 13:18:20 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tao.ma@oracle.com
Subject: Re: [PATCH 10/39] ocfs2: Add helper function in uptodate.c for removing xattr clusters
Message-ID: <20081007201820.GC26373@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-11-git-send-email-mfasheh@suse.com> <20081001231156.c52c98b5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231156.c52c98b5.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:11:56PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:51 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +/* Called when we remove xattr clusters from an inode. */
> > +void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
> > +					    sector_t block,
> > +					    u32 c_len)
> > +{
> > +	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
> > +
> > +	for (i = 0; i < b_len; i++, block++)
> > +		ocfs2_remove_block_from_cache(inode, block);
> > +}
> 
> I really really hope that `i' and `b_len' didn't really need to be
> 64-bit here.

Yeah, there's no way currently that any of those variables should get even
close to that large. I made them unsigned ints with the patch below.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: use smaller counters in ocfs2_remove_xattr_clusters_from_cache

i and b_len don't really need to be u64's. Xattr extent lengths should be
limited by the VFS, and then the size of our on-disk length field.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/uptodate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 5235140..187b99f 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -562,7 +562,7 @@ void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
 					    sector_t block,
 					    u32 c_len)
 {
-	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
+	unsigned int i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
 
 	for (i = 0; i < b_len; i++, block++)
 		ocfs2_remove_block_from_cache(inode, block);
-- 
1.5.4.1

