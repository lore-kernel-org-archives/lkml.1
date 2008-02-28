Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYB1GiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYB1GiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYB1Ghy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:37:54 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbYB1Ghx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:37:53 -0500
Date: Wed, 27 Feb 2008 22:37:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
Message-Id: <20080227223734.caab0165.akpm@linux-foundation.org>
In-Reply-To: <1204179747.3501.21.camel@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	<20080227204546.72e16e8d.akpm@linux-foundation.org>
	<1204179747.3501.21.camel@raven.themaw.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:22:27 +0900 Ian Kent <raven@themaw.net> wrote:

> 
> > > +++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-20 13:10:23.000000000 +0900
> > > @@ -363,6 +363,38 @@ int autofs4_wait(struct autofs_sb_info *
> > >  
> > >  	status = wq->status;
> > >  
> > > +	/*
> > > +	 * For direct and offset mounts we need to track the requestor
> > > +	 * uid and gid in the dentry info struct. This is so it can be
> > > +	 * supplied, on request, by the misc device ioctl interface.
> > > +	 * This is needed during daemon resatart when reconnecting
> > > +	 * to existing, active, autofs mounts. The uid and gid (and
> > > +	 * related string values) may be used for macro substitution
> > > +	 * in autofs mount maps.
> > > +	 */
> > > +	if (!status) {
> > > +		struct dentry *de = NULL;
> > > +
> > > +		/* direct mount or browsable map */
> > > +		ino = autofs4_dentry_ino(dentry);
> > > +		if (!ino) {
> > > +			/* If not lookup actual dentry used */
> > > +			de = d_lookup(dentry->d_parent, &dentry->d_name);
> > > +			ino = autofs4_dentry_ino(de);
> > > +		}
> > > +
> > > +		/* Set mount requestor */
> > > +		if (ino) {
> > > +			if (ino) {
> > > +				ino->uid = wq->uid;
> > > +				ino->gid = wq->gid;
> > > +			}
> > > +		}
> > > +
> > > +		if (de)
> > > +			dput(de);
> > > +	}
> > > +
> > 
> > But uids and gids are no longer system-wide-unique.  Two different users
> > can have the same identifiers in different namespaces.  What happens then?
> 
> That's a tricky question.
> 
> Presumably, the process requesting the mount has the user space daemon
> running in the namespace within which the uid and gid are to be looked
> up, by the daemon.
> 
> Am I missing something?
> 

err, you assume more knowledge at this end about what you're trying to do
than actually exists :)

You seem to imply that if a machine is running 100 user namespaces then it
needs to run 100 mount daemons.  Doesn't seem good.

What problem are you actually trying to solve here?
