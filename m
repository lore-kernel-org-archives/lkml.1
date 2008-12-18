Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752998AbYLRBYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYLRBYU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYLRBYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:24:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYLRBYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:24:04 -0500
Date: Wed, 17 Dec 2008 17:22:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: swhiteho@redhat.com
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        swhiteho@redhat.com, tytso@mit.edu, sandeen@redhat.com
Subject: Re: [PATCH 01/24] GFS2: Support for FIEMAP ioctl
Message-Id: <20081217172255.44700cb6.akpm@linux-foundation.org>
In-Reply-To: <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
	<1229513423-19105-2-git-send-email-swhiteho@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 11:30:00 +0000
swhiteho@redhat.com wrote:

> +static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> +		       u64 start, u64 len)
> +{
> +	struct gfs2_inode *ip = GFS2_I(inode);
> +	struct gfs2_holder gh;
> +	int ret;
> +
> +	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
> +	if (ret)
> +		goto out;
> +
> +	if (gfs2_is_stuffed(ip)) {
> +		u64 phys = ip->i_no_addr << inode->i_blkbits;
> +		u64 size = i_size_read(inode);

It's actually safe to directly access i_size inside i_mutex.  Although
not terribly maintainable.


> +		u32 flags = FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_NOT_ALIGNED|
> +			    FIEMAP_EXTENT_DATA_INLINE;
> +		phys += sizeof(struct gfs2_dinode);
> +		phys += start;
