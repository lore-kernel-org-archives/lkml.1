Return-Path: <linux-kernel-owner+w=401wt.eu-S1762634AbXJXQot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634AbXJXQot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbXJXQ0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60985 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760071AbXJXQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:57 -0400
Date: Wed, 24 Oct 2007 18:26:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Hellwig <hch@lst.de>, swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: gfs2_fh_to_parent() array overflow
Message-ID: <20071024162626.GJ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following array overflow caused by
commit 34c0d154243dd913c5690ae6ceb9557017429b9c:


include/linux/exportfs.h contains:

<--  snip  -->

...
struct fid {
...
                __u32 raw[6];
        };
};

<--  snip  -->


fs/gfs2/ops_export.c contains:

<--  snip  -->

...
static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
                int fh_len, int fh_type)
{
        struct gfs2_inum_host parent;
        __be32 *fh = (__force __be32 *)fid->raw;  <------------

        switch (fh_type) {
        case GFS2_LARGE_FH_SIZE:
        case GFS2_OLD_FH_SIZE:
                parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
                parent.no_formal_ino |= be32_to_cpu(fh[5]);
                parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
                                                   ^^^^^
                parent.no_addr |= be32_to_cpu(fh[7]);
...                                           ^^^^^

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

