Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYB1GZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYB1GZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYB1GZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:25:37 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50041 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYB1GZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:25:37 -0500
X-Sasl-enc: WS63GE04wcLx6bL3K6U6961TUXlIei5/1TOvWwgQw8G/ 1204179934
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080227204546.72e16e8d.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	 <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	 <20080227204546.72e16e8d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 15:22:27 +0900
Message-Id: <1204179747.3501.21.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 20:45 -0800, Andrew Morton wrote:
> On Tue, 26 Feb 2008 12:23:20 +0900 (WST) Ian Kent <raven@themaw.net> wrote:
> 
> > Hi Andrew,
> > 
> > Patch to track the uid and gid of the last process to request
> > a mount for on an autofs dentry.
> > 
> > Signed-off-by: Ian Kent < raven@themaw.net>
> > 
> > Ian
> > 
> > ---
> > diff -up linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/inode.c
> > --- linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.track-last-mount-ids	2008-02-20 13:11:28.000000000 +0900
> > +++ linux-2.6.25-rc2-mm1/fs/autofs4/inode.c	2008-02-20 13:12:23.000000000 +0900
> > @@ -43,6 +43,8 @@ struct autofs_info *autofs4_init_ino(str
> >  
> >  	ino->flags = 0;
> >  	ino->mode = mode;
> > +	ino->uid = 0;
> > +	ino->gid = 0;
> >  	ino->inode = NULL;
> >  	ino->dentry = NULL;
> >  	ino->size = 0;
> > diff -up linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h
> > --- linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.track-last-mount-ids	2008-02-20 13:14:03.000000000 +0900
> > +++ linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h	2008-02-20 13:14:34.000000000 +0900
> > @@ -58,6 +58,9 @@ struct autofs_info {
> >  	unsigned long last_used;
> >  	atomic_t count;
> >  
> > +	uid_t uid;
> > +	gid_t gid;
> > +
> >  	mode_t	mode;
> >  	size_t	size;
> >  
> > diff -up linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c
> > --- linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids	2008-02-20 13:06:20.000000000 +0900
> > +++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-20 13:10:23.000000000 +0900
> > @@ -363,6 +363,38 @@ int autofs4_wait(struct autofs_sb_info *
> >  
> >  	status = wq->status;
> >  
> > +	/*
> > +	 * For direct and offset mounts we need to track the requestor
> > +	 * uid and gid in the dentry info struct. This is so it can be
> > +	 * supplied, on request, by the misc device ioctl interface.
> > +	 * This is needed during daemon resatart when reconnecting
> > +	 * to existing, active, autofs mounts. The uid and gid (and
> > +	 * related string values) may be used for macro substitution
> > +	 * in autofs mount maps.
> > +	 */
> > +	if (!status) {
> > +		struct dentry *de = NULL;
> > +
> > +		/* direct mount or browsable map */
> > +		ino = autofs4_dentry_ino(dentry);
> > +		if (!ino) {
> > +			/* If not lookup actual dentry used */
> > +			de = d_lookup(dentry->d_parent, &dentry->d_name);
> > +			ino = autofs4_dentry_ino(de);
> > +		}
> > +
> > +		/* Set mount requestor */
> > +		if (ino) {
> > +			if (ino) {
> > +				ino->uid = wq->uid;
> > +				ino->gid = wq->gid;
> > +			}
> > +		}
> > +
> > +		if (de)
> > +			dput(de);
> > +	}
> > +
> 
> But uids and gids are no longer system-wide-unique.  Two different users
> can have the same identifiers in different namespaces.  What happens then?

That's a tricky question.

Presumably, the process requesting the mount has the user space daemon
running in the namespace within which the uid and gid are to be looked
up, by the daemon.

Am I missing something?

Ian


