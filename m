Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXGBPVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXGBPVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXGBPVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:21:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52201 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbXGBPVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:21:39 -0400
Date: Mon, 2 Jul 2007 10:21:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file caps: update selinux xattr hooks
Message-ID: <20070702152136.GB3243@sergelap.austin.ibm.com>
References: <20070628182255.GA13144@sergelap.austin.ibm.com> <1183387015.12218.25.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183387015.12218.25.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Thu, 2007-06-28 at 13:22 -0500, Serge E. Hallyn wrote:
> > This fixes a shortcoming of the cap_setfcap patch I sent earlier,
> > pointed out by Stephen Smalley.
> > 
> > Seems to compile and boot on my little systems.
> > 
> > thanks,
> > -serge
> > 
> > >From d729000b922a2877a48ce2b5a03a9366d8c65d04 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Thu, 28 Jun 2007 11:57:19 -0400
> > Subject: [PATCH 1/1] file caps: update selinux xattr hooks
> > 
> > SELinux does not call out to it's secondary module for setxattr
> > or removexattr mediation, as the secondary module would
> > incorrectly prevent writing of selinux xattrs.  This means
> > that when selinux and capability are both loaded, admins will
> > be able to write file capabilities with CAP_SYS_ADMIN as before,
> > not with CAP_SETFCAP.
> > 
> > Update the selinux hooks to hardcode logic for the special
> > consideration for file caps.
> > 
> > I changed the flow of the removexattr hook to reduce the amount
> > of indentation I was getting.  It was probably written the way
> > it was for a reason, and if it was, I apologize and will
> > rewrite :)  If it wasn't, hopefully this way is ok.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/selinux/hooks.c |   75 +++++++++++++++++++++++++++++----------------
> >  1 files changed, 48 insertions(+), 27 deletions(-)
> > 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index af42820..db0a4ed 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2289,6 +2289,30 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
> >  	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
> >  }
> >  
> > +/* called by selinux_inode_setxattr to mediate setting
> > + * of non-selinux xattrs */
> > +static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
> > +{
> > +	if (strncmp(name, XATTR_SECURITY_PREFIX,
> > +		     sizeof XATTR_SECURITY_PREFIX - 1))
> > +		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
> > +
> > +	/* a file capability requires cap_setfcap */
> > +	if (!strcmp(name, XATTR_NAME_CAPS)) {
> > +		if (!capable(CAP_SETFCAP))
> > +			return -EPERM;
> > +		else
> > +			return 0;
> > +	}
> > +
> > +	/* A different attribute in the security namespace.
> > +	   Restrict to administrator. */
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	return 0;
> > +}
> 
> In reworking the flow of this code, you've changed the behavior (more so
> than you intended) - your checking above only applies the FILE__SETATTR
> check if dealing with a non-security attribute, whereas the original

Crud.  I *thought* I had a clue what I was doing.

Will give it another try.

thanks,
-serge

> logic (below) applied that check to all non-selinux attributes.  So with
> your new logic, we don't get any process-to-object check for
> security.cap or security.<other>, and thus lose the domain-to-type check
> or the level-to-level check.
> 
> > @@ -2299,19 +2323,8 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
> >  	u32 newsid;
> >  	int rc = 0;
> >  
> > -	if (strcmp(name, XATTR_NAME_SELINUX)) {
> > -		if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > -			     sizeof XATTR_SECURITY_PREFIX - 1) &&
> > -		    !capable(CAP_SYS_ADMIN)) {
> > -			/* A different attribute in the security namespace.
> > -			   Restrict to administrator. */
> > -			return -EPERM;
> > -		}
> 
> Note that if setting a security.<non-selinux> attribute, we first check
> the capability but then fall through on success to the FILE__SETATTR
> check below.
> 
> > -
> > -		/* Not an attribute we recognize, so just check the
> > -		   ordinary setattr permission. */
> > -		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
> > -	}
> > +	if (strcmp(name, XATTR_NAME_SELINUX))
> > +		return selinux_inode_setotherxattr(dentry, name);
> >  
> >  	sbsec = inode->i_sb->s_security;
> >  	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
> > @@ -2385,24 +2398,32 @@ static int selinux_inode_listxattr (struct dentry *dentry)
> >  
> >  static int selinux_inode_removexattr (struct dentry *dentry, char *name)
> >  {
> > -	if (strcmp(name, XATTR_NAME_SELINUX)) {
> > -		if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > -			     sizeof XATTR_SECURITY_PREFIX - 1) &&
> > -		    !capable(CAP_SYS_ADMIN)) {
> > -			/* A different attribute in the security namespace.
> > -			   Restrict to administrator. */
> > -			return -EPERM;
> > -		}
> > +	/* No one is allowed to remove a SELinux security label.
> > +	   You can change the label, but all data must be labeled. */
> > +	if (!strcmp(name, XATTR_NAME_SELINUX))
> > +		return -EACCES;
> >  
> > -		/* Not an attribute we recognize, so just check the
> > -		   ordinary setattr permission. Might want a separate
> > -		   permission for removexattr. */
> > +	/* Not an attribute we recognize, so just check the
> > +	   ordinary setattr permission. Might want a separate
> > +	   permission for removexattr. */
> > +	if (strncmp(name, XATTR_SECURITY_PREFIX,
> > +		     sizeof XATTR_SECURITY_PREFIX - 1))
> >  		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
> 
> Same problem here - when you changed the flow, you unintentionally
> changed the behavior.
> 
> > +
> > +	/* a file capability requires cap_setfcap */
> > +	if (!strcmp(name, XATTR_NAME_CAPS)) {
> > +		if (!capable(CAP_SETFCAP))
> > +			return -EPERM;
> > +		else
> > +			return 0;
> >  	}
> >  
> > -	/* No one is allowed to remove a SELinux security label.
> > -	   You can change the label, but all data must be labeled. */
> > -	return -EACCES;
> > +	/* A different attribute in the security namespace.
> > +	   Restrict to administrator. */
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	return 0;
> >  }
> >  
> >  static const char *selinux_inode_xattr_getsuffix(void)
> -- 
> Stephen Smalley
> National Security Agency
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
