Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753038AbYLRTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbYLRTFG (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYLRTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:04:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYLRTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:04:53 -0500
Date: Thu, 18 Dec 2008 11:04:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com, tytso@mit.edu,
        sandeen@redhat.com
Subject: Re: [PATCH 01/24] GFS2: Support for FIEMAP ioctl
Message-Id: <20081218110414.ac421e1b.akpm@linux-foundation.org>
In-Reply-To: <1229596144.3538.1.camel@localhost.localdomain>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
	<1229513423-19105-2-git-send-email-swhiteho@redhat.com>
	<20081217172255.44700cb6.akpm@linux-foundation.org>
	<1229596144.3538.1.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 10:29:04 +0000
Steven Whitehouse <swhiteho@redhat.com> wrote:

> Hi,
> 
> On Wed, 2008-12-17 at 17:22 -0800, Andrew Morton wrote:
> > On Wed, 17 Dec 2008 11:30:00 +0000
> > swhiteho@redhat.com wrote:
> > 
> > > +static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > +		       u64 start, u64 len)
> > > +{
> > > +	struct gfs2_inode *ip = GFS2_I(inode);
> > > +	struct gfs2_holder gh;
> > > +	int ret;
> > > +
> > > +	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&inode->i_mutex);
> > > +
> > > +	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	if (gfs2_is_stuffed(ip)) {
> > > +		u64 phys = ip->i_no_addr << inode->i_blkbits;
> > > +		u64 size = i_size_read(inode);
> > 
> > It's actually safe to directly access i_size inside i_mutex.  Although
> > not terribly maintainable.
> > 
> > 
> I did wonder about that at the time, but I'm not quite sure if you are
> suggesting that I should change this now, or leave it as it is?

No strong opinion, really.  If it's a performance-sensitive path (it
isn't) then bypassing i_size_read() might be advantageous.  Leaving the
i_size_read() there provides some future-safety and sets a good
example.

It would be an easier decision if the SMP, 32-bit version of
i_size_read() wasn't inlined, and tremendously huge :(

