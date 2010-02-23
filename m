Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0BWBEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:04:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36314 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0BWBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:04:19 -0500
Date: Mon, 22 Feb 2010 19:04:13 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
Message-ID: <20100223010413.GA31046@us.ibm.com>
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
 <20100222161714.de1a7fca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222161714.de1a7fca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Sat, 20 Feb 2010 04:27:38 -0800 john.johansen@canonical.com wrote:
> 
> > From: John Johansen <john.johansen@canonical.com>
> > 
> > When __d_path() hits a lazily unmounted mount point, it tries to prepend
> > the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> > and also overwrites the slash that separates the name from the following
> > pathname component. This patch fixes that; if a process was in directory
> > /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> > missing slash), while the new result with this patch is ``/foo/bar''.
> > 
> > Signed-off-by: John Johansen <john.johansen@canonical.com>
> > ---
> >  fs/dcache.c |   27 +++++++++++++++++++++++----
> >  1 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 953173a..df49666 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1922,11 +1922,9 @@ char *__d_path(const struct path *path, struct path *root,
> >  	retval = end-1;
> >  	*retval = '/';
> >  
> > -	for (;;) {
> > +	while(dentry != root->dentry || vfsmnt != root->mnt) {
> 
> Please put a space between the `while' and the `('.
> 
> >  		struct dentry * parent;
> >  
> > -		if (dentry == root->dentry && vfsmnt == root->mnt)
> > -			break;
> >  		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
> >  			/* Global root? */
> >  			if (vfsmnt->mnt_parent == vfsmnt) {
> > @@ -1950,9 +1948,30 @@ out:
> >  	return retval;
> >  
> >  global_root:
> > -	retval += 1;	/* hit the slash */
> > +	/*
> > +	 * We went past the (vfsmount, dentry) we were looking for and have
> > +	 * either hit a root dentry, a lazily unmounted dentry, an
> > +	 * unconnected dentry, or the file is on a pseudo filesystem.
> > +	 */
> > +	if ((dentry->d_sb->s_flags & MS_NOUSER) ||
> > +	    (dentry->d_name.len = 1 && *dentry->d_name.name == '/')) {
> 
> Did you really mean to assign 1 to dentry->d_name.len here?  Was `=='
> intended?  I hope so, because modifying the dentry in d_path() would be odd.
> 
> If this was a mistake then why did the patch pass testing?

Jinkeys!  Well I guess it must've passed testing bc that will only be
done for MS_NOUSER filesystems, and we won't later be doing any 'ls'
so the d_name.len isn't really used?

> > +		/*
> > +		 * Historically, we also glue together the root dentry and
> > +		 * remaining name for pseudo filesystems like pipefs, which
> > +		 * have the MS_NOUSER flag set. This results in pathnames
> > +		 * like "pipe:[439336]".
> > +		 */
> > +		retval += 1;	/* overwrite the slash */
> > +		buflen++;
> > +	}
> >  	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
> >  		goto Elong;
> > +
> > +	/* connect lazily unmounted mount point */
> > +	if (*retval != '/' && !(dentry->d_sb->s_flags & MS_NOUSER) &&
> > +	    prepend(&retval, &buflen, "/", 1) != 0)
> > +		goto Elong;
> > +
> >  	root->mnt = vfsmnt;
> >  	root->dentry = dentry;
> >  	goto out;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
