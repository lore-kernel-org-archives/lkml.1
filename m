Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZIPOiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZIPOiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIPOiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:38:04 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:64689 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZIPOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:38:02 -0400
Date: Wed, 16 Sep 2009 10:37:56 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] Ext3: data=guarded mode
Message-ID: <20090916143756.GC2641@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
 <1252422595-4554-3-git-send-email-chris.mason@oracle.com>
 <20090915172924.GI12169@duck.suse.cz>
 <20090915183906.GE23965@think>
 <20090916140913.GN26030@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916140913.GN26030@duck.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AB0F845.0217:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 04:09:13PM +0200, Jan Kara wrote:
> On Tue 15-09-09 14:39:06, Chris Mason wrote:

[ ... ]

> > >   The code here still looks suspicious.
> > > 1) Inodes can be on orphan list with i_nlink > 0 when a write failed for
> > >    some reason and we have to truncate blocks instantiated beyond i_size.
> > >    Those places (similarly as truncate) expect that while they hold i_mutex
> > >    they are safe doing what they want with the orphan list. This code would
> > >    happily remove the inode from orphan list...
> > 
> > The only risky place for this is the work thread doing the ordered
> > writes.  Truncate gets around it by waiting for the ordered completions.
> > I'll add the wait to the error handlers as well.
>   You probably mean guarded writes. I agree.

Sorry, guarded in ext3 is ordered in btrfs and I'm easily confused.

> 
> > > 2) Cannot it happen that:
> > >      CPU1
> > > orphan_del()
> > >   if (inode->i_nlink && list_empty(ordered_list)) {
> > > 	ext3_ordered_unlock(inode);
> > > 	lock_super(inode->i_sb);
> > > 	smp_mb();
> > > 	if (inode->i_nlink == 0 || !list_empty(ordered_list)) {
> > > 
> > >      CPU2
> > > journal_dirty_data_guarded_fn()
> > >   ret = ext3_add_ordered_extent(inode, offset, bh);
> > >   if (ret == 0 && buffer_dataguarded(bh) &&
> > >       list_empty(&EXT3_I(inode)->i_orphan) &&
> > >       !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) - list isn't
> > > empty yet so we don't add inode to orphan list, but on CPU1, we go ahead
> > > and remove inode from the orphan list...
> > 
> > This used to have a check after the orphan_del to re-add the orphan if
> > we raced with the end_io handlers.  I removed it because I thought it
> > was over-paranoid, but I see that you're right.  So, I'll put that one
> > back in.
>   Hmm, that will probably work but it's ugly :(. The ugliness is localized
> in the guarded mode code so probably we can bear it for a while but I'll
> certainly try to look into what we can do to get rid of it :).

;)

> 
> > > > diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
> > > > index ca1bfe9..a6cf26d 100644
> > > > --- a/include/linux/ext3_fs_i.h
> > > > +++ b/include/linux/ext3_fs_i.h
> > > > @@ -137,6 +180,8 @@ struct ext3_inode_info {
> > > >  	 * by other means, so we have truncate_mutex.
> > > >  	 */
> > > >  	struct mutex truncate_mutex;
> > > > +
> > > > +	struct ext3_ordered_buffers ordered_buffers;
> > > >  	struct inode vfs_inode;
> > > >  };
> > >   Hmm, how hard would it be to hide especially this behind
> > > CONFIG_EXT3_GUARDED_DATA so that we can avoid increasing inode size for
> > > users which are not interested in the new guarded mode?
> > 
> > I'm not too picky, but it would litter the code with #ifdefs around the
> > guarded functions.  I'd rather not.
>   Looking into the code, it needn't be too bad if we define a a few
> functions as empty in !guarded case. I'll have a look at it for the next
> version of your patch.

Fair enough, I plan on hammering out the next version today or tomorrow.

-chris

