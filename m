Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYLZCal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYLZCal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYLZCaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:30:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYLZCaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:30:07 -0500
Date: Thu, 25 Dec 2008 18:29:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       joel.becker@oracle.com, jack@suse.cz
Subject: Re: [PATCH 23/56] ocfs2: Implementation of local and global quota
 file handling
Message-Id: <20081225182941.7fdadc83.akpm@linux-foundation.org>
In-Reply-To: <20081225002923.GA17410@wotan.suse.de>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-24-git-send-email-mfasheh@suse.com>
	<20081222161138.779cbffa.akpm@linux-foundation.org>
	<20081225002923.GA17410@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 16:29:23 -0800 Mark Fasheh <mfasheh@suse.com> wrote:

> > 
> > put_bh() is more efficient and modern, in the case where bh is known to
> > not be NULL.
> 
> How about __brelse()? Won't we lose the ref counting check if we go straight
> to put_bh()?
> 

That would work, if you value the debug check.

>
> ...
>
> > > +/* Write to quotafile (we know the transaction is already started and has
> > > + * enough credits) */
> > > +ssize_t ocfs2_quota_write(struct super_block *sb, int type,
> > > +			  const char *data, size_t len, loff_t off)
> > > +{
> > > +	struct mem_dqinfo *info = sb_dqinfo(sb, type);
> > > +	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
> > > +	struct inode *gqinode = oinfo->dqi_gqinode;
> > > +	int offset = off & (sb->s_blocksize - 1);
> > > +	sector_t blk = off >> sb->s_blocksize_bits;
> > 
> > does ocfs2 attempt to support CONFIG_LBD=n?
> 
> It should... What's the problem here?

Idle curiosity.  I noticed that the above expression could result in
truncation when writing a 64-bit value into a 32-bit one, which makes
one wonder whether this all works and is tested, etc.
