Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZLCBXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZLCBXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZLCBXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZLCBXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:23:44 -0500
Date: Wed, 2 Dec 2009 20:23:22 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on
 FS_REVAL_DOT filesystems
Message-ID: <20091202202322.58e651d1@tlielax.poochiereds.net>
In-Reply-To: <m1ljhlq614.fsf@fess.ebiederm.org>
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<m1ljhlq614.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 16:01:59 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > In the case of a bind mounted file, the path walking code will assume
> > that the cached dentry that was bind mounted is valid. This is a problem
> > problem for NFSv4 in a way that's similar to LAST_BIND symlinks.
> >
> > Fix this by revalidating the dentry if FS_FOLLOW_DOT is set and
> > __follow_mount returns true.
> >
> > Note that in the non-open codepath, we cannot return an error to the
> > lookup if the revalidation fails. Doing so will leave a bind mount in
> > a state such that we can't unmount it. In that case we'll just have to
> > settle for d_invalidating it (which should mostly turn out to be a
> > d_drop in this case) and returning success.
> 
> Looks reasonable to me.  I wonder a little if we care about follow_mount
> as well as __follow_mount.
> 

Good question.

It does sort of seem like it. There's also follow_down too...

OTOH, we have a reproducible testcases that the two patches in this
series fix. I'm not aware of anything that's technically "broken" by
the lack of revalidations in the other codepaths so I'm hesitant to add
them in unless and until we do.

> This seems reasonable to me.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> >
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/namei.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 339789e..0d55b6f 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -851,7 +851,13 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
> >  done:
> >  	path->mnt = mnt;
> >  	path->dentry = dentry;
> > -	__follow_mount(path);
> > +
> > +	/*
> > +	 * cannot return the error returned by force_reval_path as that can
> > +	 * make it impossible to unmount a bind mounted dentry if it's stale.
> > +	 */
> > +	if (__follow_mount(path))
> > +		force_reval_path(path, nd);
> >  	return 0;
> >  
> >  need_lookup:
> > @@ -1840,6 +1846,9 @@ do_last:
> >  		error = -ELOOP;
> >  		if (flag & O_NOFOLLOW)
> >  			goto exit_dput;
> > +		error = force_reval_path(&path, &nd);
> > +		if (error)
> > +			goto exit_dput;
> >  	}
> >  
> >  	error = -ENOENT;
> > -- 
> > 1.5.5.6


-- 
Jeff Layton <jlayton@redhat.com>
