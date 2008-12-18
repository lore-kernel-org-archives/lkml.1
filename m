Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752532AbYLRK3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYLRK3W (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYLRK3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:29:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYLRK3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:29:09 -0500
Subject: Re: [PATCH 01/24] GFS2: Support for FIEMAP ioctl
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com, tytso@mit.edu,
        sandeen@redhat.com
In-Reply-To: <20081217172255.44700cb6.akpm@linux-foundation.org>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
	 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
	 <20081217172255.44700cb6.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 18 Dec 2008 10:29:04 +0000
Message-Id: <1229596144.3538.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-12-17 at 17:22 -0800, Andrew Morton wrote:
> On Wed, 17 Dec 2008 11:30:00 +0000
> swhiteho@redhat.com wrote:
> 
> > +static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > +		       u64 start, u64 len)
> > +{
> > +	struct gfs2_inode *ip = GFS2_I(inode);
> > +	struct gfs2_holder gh;
> > +	int ret;
> > +
> > +	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&inode->i_mutex);
> > +
> > +	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
> > +	if (ret)
> > +		goto out;
> > +
> > +	if (gfs2_is_stuffed(ip)) {
> > +		u64 phys = ip->i_no_addr << inode->i_blkbits;
> > +		u64 size = i_size_read(inode);
> 
> It's actually safe to directly access i_size inside i_mutex.  Although
> not terribly maintainable.
> 
> 
I did wonder about that at the time, but I'm not quite sure if you are
suggesting that I should change this now, or leave it as it is?

Steve.

> > +		u32 flags = FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_NOT_ALIGNED|
> > +			    FIEMAP_EXTENT_DATA_INLINE;
> > +		phys += sizeof(struct gfs2_dinode);
> > +		phys += start;

