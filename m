Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXBTRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXBTRu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXBTRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:50:26 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50802 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787AbXBTRuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:50:25 -0500
Date: Tue, 20 Feb 2007 11:50:22 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [RFC] [PATCH -mm] file caps: make on-disk capabilities future-proof
Message-ID: <20070220175021.GA26241@sergelap.austin.ibm.com>
References: <20070219170133.GB28412@sergelap.austin.ibm.com> <1171990508.14363.136.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171990508.14363.136.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Mon, 2007-02-19 at 11:01 -0600, Serge E. Hallyn wrote:
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Subject: [PATCH -mm] file caps: make on-disk capabilities future-proof
> > 
> > Stephen Smalley has pointed out that the current file capabilities
> > will eventually pose a problem.
> > 
> > As the capability set changes and distributions start tagging
> > binaries with capabilities, we would like for running an older
> > kernel to not necessarily make those binaries unusable.  To
> > that end,
> > 
> > 	1. If capabilities are specified which we don't know
> > 	   about, just ignore them, do not return -EPERM as we
> > 	   were doing before.
> 
> I didn't advocate that change - it is a separate issue from allowing the
> capability bitmaps to grow in size in a backward compatible manner.  In
> the one case, you have a binary that needs a capability that is unknown
> to the kernel, so running it could lead to unexpected failure.  In the
> other case, you simply have a binary labeled by newer userspace with a
> newer on-disk representation that supports larger bitmaps, but the
> binary might only have capabilities set that are known to the kernel.

So do you think we should fail with -EINVAL in the first case?

> > 	2. Specify a size with the on-disk capability implementation.
> > 	   In this implementation the size is the number of __u32's
> > 	   used for each of (eff,perm,inh).  For now, sz is 1.
> > 	   When we move to 64-bit capabilities, it becomes 2.
> 
> You could alternatively split them into separate xattrs, e.g.
> security.cap.eff, security.cap.perm, security.cap.inh, and determine the
> bitmap size from the xattr length rather than a separate field.

Clean, but slower... Not sure which way to go on that

> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index be86acb..dc8bf4f 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> 
> > @@ -148,50 +145,65 @@ static int set_file_caps(struct linux_bi
> >  {
> >  	struct dentry *dentry;
> >  	ssize_t rc;
> > -	struct vfs_cap_data_disk dcaps;
> > +	struct vfs_cap_data_disk *dcaps;
> >  	struct vfs_cap_data caps;
> >  	struct inode *inode;
> > -	int err;
> >  
> >  	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
> >  		return 0;
> >  
> >  	dentry = dget(bprm->file->f_dentry);
> >  	inode = dentry->d_inode;
> > -	if (!inode->i_op || !inode->i_op->getxattr) {
> > -		dput(dentry);
> > -		return 0;
> > +	rc = 0;
> > +	if (!inode->i_op || !inode->i_op->getxattr)
> > +		goto out;
> > +
> > +	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
> > +	if (rc == -ENODATA) {
> > +		rc = 0;
> > +		goto out;
> > +	}
> 
> I'd allocate an initial buffer with an expected size and try first to
> avoid always having to make the two ->getxattr calls in the common case.

I started to do that but decided that's just muck up the rfc.  Will put
it into a final version.

> > +	if (rc < 0)
> > +		goto out;
> > +	if (rc < sizeof(struct vfs_cap_data_disk)) {
> 
> You could make this a bit stricter, as you know that it will have at
> least three additional u32 values beyond the header.

true.

> > +		rc = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	dcaps = kmalloc(rc, GFP_KERNEL);
> > +	if (!dcaps) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
> > +						XATTR_CAPS_SZ);
> 
> I'm confused - you just asked for the actual length of the xattr and
> allocated a buffer for it, and then don't use the length in this second

Huh, I *did* send in rc, not sure what happened to that.  git mis-usage
maybe.

> call to ->getxattr.  And since you said you were organizing it as
> eff[0..sz-1],perm[0..sz-1],inh[0..sz-1], you do need to read the entire
> thing to get all three values even if you only use the lower 32 bits of
> each.  Or if you change the organization to avoid the need to read the
> entire thing, you don't need the first getxattr call at all, and you

Yes I had first organized it as eff[0],perm[0],inh[0], eff[1], etc...
But after I changed that I did put rc back in for the length...  I
thought.

> need to change how cap_from_disk extracts the values.

thanks Stephen,
-serge
