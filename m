Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZHNMho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZHNMho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZHNMhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:37:42 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:60336 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZHNMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:37:41 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Greg Kroah-Hartman <greg@kroah.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
In-Reply-To: <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A84EF1D.8060408@schaufler-ca.com>
	 <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 14 Aug 2009 08:40:51 -0400
Message-Id: <1250253651.2422.183.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 08:20 -0400, Stephen Smalley wrote:
> On Thu, 2009-08-13 at 21:59 -0700, Casey Schaufler wrote:
> > From: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > This patch is in response to David P. Quigley's proposal from
> > July of this year. That patch provided special case handling of
> > LSM xattrs in the security name space.
> > 
> > This patch provides an in memory representation of general
> > xattrs. It currently only allows xattrs in the security namespace,
> > but that is only because the support of ACLs is beyond the
> > day's needs. The list of xattrs for a given file is created on
> > demand and a system that does not use xattrs should be pretty
> > well oblivious to the changes. On the down side, this requires
> > an unpleasant locking scheme. Improvements would of course be
> > welcome.
> > 
> > This scheme should generalize to any memory based file system,
> > although I have not attempted to create a generic implementation
> > here.
> 
> I don't understand the benefits of this scheme compared to David's patch
> - can you explain?  It seems worse in terms of locking, memory use, and
> is no more general than David's patch.  More specific comments below.
> 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > ---
> > 
> >  fs/sysfs/dir.c     |    4 
> >  fs/sysfs/inode.c   |  210 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/sysfs/symlink.c |   10 +-
> >  fs/sysfs/sysfs.h   |   16 +++
> >  4 files changed, 237 insertions(+), 3 deletions(-)
> 
> > diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/inode.c linux-0812/fs/sysfs/inode.c
> > --- linux-2.6/fs/sysfs/inode.c	2009-03-28 13:47:33.000000000 -0700
> > +++ linux-0812/fs/sysfs/inode.c	2009-08-12 11:08:28.000000000 -0700
> > @@ -104,6 +110,210 @@ int sysfs_setattr(struct dentry * dentry
> >  	return error;
> >  }
> >  
> > +/*
> > + * Extended attributes are stored on a list off of the dirent.
> > + * The list head itself is allocated when needed so that a file
> > + * with no xattrs does not have the overhead of a list head.
> > + * Unfortunately, to lock the xattr list for each dentry would
> > + * require a lock in each dentry, which would defeat the purpose
> > + * of allocating the list head. So one big sysfs xattr lock.
> > + *
> > + * A better solution would be welcome.
> 
> What was wrong with David's approach of wrapping the iattr with a
> containing structure that could also include the security attribute?
> 
> > + */
> > +static DEFINE_MUTEX(sysfs_xattr_lock);
> > +
> > +static struct sysfs_xattr *new_xattr(const char *name, const void *value,
> > +					size_t size)
> > +{
> > +	struct sysfs_xattr *nxattr;
> > +	void *nvalue;
> > +	char *nname;
> > +
> > +	nxattr = kzalloc(sizeof(*nxattr), GFP_KERNEL);
> > +	if (!nxattr)
> > +		return NULL;
> > +	nvalue = kzalloc(size, GFP_KERNEL);
> > +	if (!nvalue) {
> > +		kfree(nxattr);
> > +		return NULL;
> > +	}
> > +	nname = kzalloc(strlen(name) + 1, GFP_KERNEL);
> > +	if (!nname) {
> > +		kfree(nxattr);
> > +		kfree(nvalue);
> > +		return NULL;
> > +	}
> > +	memcpy(nvalue, value, size);
> > +	strcpy(nname, name);
> > +	nxattr->sx_name = nname;
> > +	nxattr->sx_value = nvalue;
> > +	nxattr->sx_size = size;
> 
> Storing the name/value pairs here is redundant - the security module
> already has to store the value in some form (potentially smaller, like a
> secid + struct in the SELinux case).  This wastes memory.

Sorry - to clarify, I understand that we have to store a representation
of the security attribute in the backing data structure so that it can
be restored later, but that representation should come from the security
module rather than being the original (name, value, size) triple.  Which
is what David's patch does - he obtains a secid from the security module
for storage in the wrapped iattr structure.

> 
> > +
> > +	return nxattr;
> > +}
> > +
> > +int sysfs_setxattr(struct dentry *dentry, const char *name,
> > +			const void *value, size_t size, int flags)
> > +{
> > +	struct sysfs_dirent *sd = dentry->d_fsdata;
> > +	struct list_head *xlist;
> > +	struct sysfs_xattr *nxattr;
> > +	void *nvalue;
> > +	int rc = 0;
> > +
> > +	/*
> > +	 * Only support the security namespace.
> > +	 * Only allow privileged processes to set them.
> > +	 * It has to be OK with the LSM, if any, as well.
> > +	 */
> > +	if (strncmp(name, XATTR_SECURITY_PREFIX,
> > +			sizeof XATTR_SECURITY_PREFIX - 1))
> > +		return -ENOTSUPP;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> 
> SELinux does not require CAP_SYS_ADMIN to set its attributes, so this
> breaks its security model.

And you don't need to apply any permission check here, as it gets
covered by the security_inode_setxattr() hook in vfs_setxattr() prior to
invoking i_op->setxattr.

-- 
Stephen Smalley
National Security Agency

