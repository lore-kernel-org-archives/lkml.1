Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYGSCNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYGSCNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYGSCN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:13:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59942 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbYGSCN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:13:28 -0400
X-Sasl-enc: vG5NjSJ312H3CQvqyFs5FsQgxTr+6x0wGrVK/u8tUtcp 1216433606
Subject: Re: [PATCH 5/7] autofs4 - fix direct mount pending expire race
From: Ian Kent <raven@themaw.net>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <x49bq0vc5wb.fsf@segfault.boston.devel.redhat.com>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	 <20080718023725.12802.74137.stgit@raven.themaw.net>
	 <x49bq0vc5wb.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 10:09:45 +0800
Message-Id: <1216433386.3210.16.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-18 at 16:08 -0400, Jeff Moyer wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > For direct and offset type mounts that are covered by another mount
> > we cannot check the AUTOFS_INF_EXPIRING flag during a path walk
> > which leads to lookups walking into an expiring mount while it is
> > being expired.
> >
> > For example, for the direct multi-mount map entry with a couple of
> > offsets:
> >
> > /race/mm1  /      <server1>:/<path1>
> >            /om1   <server2>:/<path2>
> >            /om2   <server1>:/<path3>
> >
> > an autofs trigger mount is mounted on /race/mm1 and when accessed
> > it is over mounted and trigger mounts made for /race/mm1/om1 and
> > /race/mm1/om2. So it isn't possible for path walks to see the
> > expiring flag at all and they happily walk into the file system
> > while it is expiring.
> >
> > When expiring these mounts follow_down() must stop at the autofs
> > mount and all processes must block in the ->follow_link() method
> > (except the daemon) until the expire is complete. This is done by
> > decrementing the d_mounted field of the autofs trigger mount root
> > dentry until the expire is completed. In ->follow_link() all
> > processes wait on the expire and the mount following is completed
> > for the daemon until the expire is complete.
> >
> > Signed-off-by: Ian Kent <raven@themaw.net>
> >
> > ---
> >
> >  fs/autofs4/autofs_i.h |    3 ++
> >  fs/autofs4/expire.c   |   16 +++++++++--
> >  fs/autofs4/root.c     |   72 +++++++++++++++++++++++++++++++++----------------
> >  3 files changed, 65 insertions(+), 26 deletions(-)
> >
> >
> > diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> > index 5d90ed3..4b40cbc 100644
> > --- a/fs/autofs4/autofs_i.h
> > +++ b/fs/autofs4/autofs_i.h
> > @@ -52,6 +52,8 @@ struct autofs_info {
> >  
> >  	int		flags;
> >  
> > +	struct completion expire_complete;
> > +
> >  	struct list_head active;
> >  	struct list_head expiring;
> >  
> > @@ -69,6 +71,7 @@ struct autofs_info {
> >  };
> >  
> >  #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
> > +#define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
> >  
> >  struct autofs_wait_queue {
> >  	wait_queue_head_t queue;
> > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > index 19f5bea..705b9f0 100644
> > --- a/fs/autofs4/expire.c
> > +++ b/fs/autofs4/expire.c
> > @@ -259,13 +259,15 @@ static struct dentry *autofs4_expire_direct(struct super_block *sb,
> >  	now = jiffies;
> >  	timeout = sbi->exp_timeout;
> >  
> > -	/* Lock the tree as we must expire as a whole */
> >  	spin_lock(&sbi->fs_lock);
> >  	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
> >  		struct autofs_info *ino = autofs4_dentry_ino(root);
> > -
> > -		/* Set this flag early to catch sys_chdir and the like */
> > +		if (d_mountpoint(root)) {
> > +			ino->flags |= AUTOFS_INF_MOUNTPOINT;
> > +			root->d_mounted--;
> > +		}
> 
> This makes me uneasy.  This should take d_mounted to zero.  Then, when
> the daemon actually does the unmount, won't the d_mounted drop below
> zero?  Following calls to d_mountpoint will return a negative value, but
> everyone treats it as a boolean, so it will evaluate to true for a brief
> time.  Or did I miss something?

Yes, I thought about doing exactly that.

But the thing that effects d_mounted is mounted on the dentry and so
d_mounted may be decremented during the expire. So if we set it
explicitly it would be incorrect at the end. While the
decrement/increment isn't always correct throughout the expire we need
to handle the mount following in ->follow_link() anyway and then the
decrement/increment ends up with the correct value once the expire is
complete.

One problem that has occurred to me is that user space could could
manually umount it just when we change it. So a follow up patch to add a
lock around the increment/decrement in fs/namespace.c and
fs/autofs4/expire.c is in order. I'm having a look at that now.

Ian


