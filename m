Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYHHDxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYHHDxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYHHDwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:52:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50300 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbYHHDww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:52:52 -0400
X-Sasl-enc: fsPaqX6KSfHf8ADY5L7ozBa9U+h1dOS3u4pr9fRaD7+g 1218167570
Subject: Re: [PATCH 2/4] autofs4 - track uid and gid of last mount requester
From: Ian Kent <raven@themaw.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <20080807221242.GA27032@us.ibm.com>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	 <20080807114012.4142.83607.stgit@web.messagingengine.com>
	 <20080807134650.a6a51f7d.akpm@linux-foundation.org>
	 <20080807221242.GA27032@us.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 11:48:33 +0800
Message-Id: <1218167314.17093.79.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-07 at 17:12 -0500, Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Thu, 07 Aug 2008 19:40:14 +0800
> > Ian Kent <raven@themaw.net> wrote:
> > 
> > > Patch to track the uid and gid of the last process to request a mount
> > > for on an autofs dentry.
> > 
> > pet peeve: changelog should not tell the reader that this is a "patch".
> > Because when someone is reading the changelog in the git repository,
> > they hopefully already know that.
> > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > 
> > > ---
> > > 
> > >  fs/autofs4/autofs_i.h |    3 +++
> > >  fs/autofs4/inode.c    |    2 ++
> > >  fs/autofs4/waitq.c    |   34 ++++++++++++++++++++++++++++++++++
> > >  3 files changed, 39 insertions(+), 0 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> > > index ea024d8..fa76d18 100644
> > > --- a/fs/autofs4/autofs_i.h
> > > +++ b/fs/autofs4/autofs_i.h
> > > @@ -63,6 +63,9 @@ struct autofs_info {
> > >  	unsigned long last_used;
> > >  	atomic_t count;
> > >  
> > > +	uid_t uid;
> > > +	gid_t gid;
> > > +
> > >  	mode_t	mode;
> > >  	size_t	size;
> > >  
> > > diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
> > > index 9ca2d07..9408507 100644
> > > --- a/fs/autofs4/inode.c
> > > +++ b/fs/autofs4/inode.c
> > > @@ -53,6 +53,8 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
> > >  		atomic_set(&ino->count, 0);
> > >  	}
> > >  
> > > +	ino->uid = 0;
> > > +	ino->gid = 0;
> > >  	ino->mode = mode;
> > >  	ino->last_used = jiffies;
> > >  
> > > diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> > > index 6d87bb1..7c60c0b 100644
> > > --- a/fs/autofs4/waitq.c
> > > +++ b/fs/autofs4/waitq.c
> > > @@ -457,6 +457,40 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
> > >  
> > >  	status = wq->status;
> > >  
> > > +	/*
> > > +	 * For direct and offset mounts we need to track the requestrer
> > 
> > typo which I'll fix.
> > 
> > > +	 * uid and gid in the dentry info struct. This is so it can be
> > > +	 * supplied, on request, by the misc device ioctl interface.
> > > +	 * This is needed during daemon resatart when reconnecting
> > > +	 * to existing, active, autofs mounts. The uid and gid (and
> > > +	 * related string values) may be used for macro substitution
> > > +	 * in autofs mount maps.
> > > +	 */
> > > +	if (!status) {
> > > +		struct autofs_info *ino;
> > > +		struct dentry *de = NULL;
> > > +
> > > +		/* direct mount or browsable map */
> > > +		ino = autofs4_dentry_ino(dentry);
> > > +		if (!ino) {
> > > +			/* If not lookup actual dentry used */
> > > +			de = d_lookup(dentry->d_parent, &dentry->d_name);
> > > +			if (de)
> > > +				ino = autofs4_dentry_ino(de);
> > > +		}
> > > +
> > > +		/* Set mount requester */
> > > +		if (ino) {
> > > +			spin_lock(&sbi->fs_lock);
> > > +			ino->uid = wq->uid;
> > > +			ino->gid = wq->gid;
> > > +			spin_unlock(&sbi->fs_lock);
> > > +		}
> > > +
> > > +		if (de)
> > > +			dput(de);
> > > +	}
> > > +
> > 
> > Please remind me again why autofs's use of current->uid and
> > current->gid is not busted in the presence of PID namespaces, where
> > these things are no longer system-wide unique?
> 
> I actually don't see what the autofs4_waitq->pid is used for.  It's
> copied from current into wq->pid at autofs4_wait, and into a packet to
> send to userspace (I assume) at autofs4_notify_daemon.
> 
> So as long as a daemon can serve multiple pid namespaces (which
> doubtless it can), the pid could be confusing (or erroneous) for the
> daemon.

Your point is well taken.

The pid is used purely for logging purposes to aid in debugging in user
space. I'm not sure it is worth worrying about it too much as the daemon
has no business interfering with user space processes it is not the
owner of.

> 
> If I'm remotely right about how the pid is being used, then the thing to
> do would be to 
> 	1. store the daemon's pid namespace  (would that belong in
> 	the autofs_sb_info?)
 
Yep.

> 	2. store the task_pid(current) in the waitqueue
> 	3. retrieve the pid_t for the waiting task in the daemon's
> 	pid namespace, and put that into the packet at
> 	autofs4_notify_daemon.
> 
> I realize this patch was about the *uids*, but the pids seem more
> urgent.

OK, I get it.
I'll have a go at doing this for completeness.

Ian


