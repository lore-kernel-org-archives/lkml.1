Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZHOBVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZHOBVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 21:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZHOBVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 21:21:08 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:35613 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754614AbZHOBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 21:21:07 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: Y4C5iV0VM1nTa2Glmmi7At1nbwGaJNo7pT03z9CJByDHhoSvo46WTBgc6KgiWIt407D0E_4T2iJWIRXWeRCtdEGg1Z1n_XLHAE6JA4MwW.pSPBSEJN8Esy7A6UwdjkaIRcUtfhH1xU2zqYJVxY2vL1HUYPcSCHvZ2INdZgNy8Kdd.uICQLxQO4vn6mAowLwRtRior_Su5j996OCYjMAJHtsoWx0nRiggvfVb6lOawTKUNUH6rbt9IVQ4IbrcCU5mY51aukG0onPfA_9qnavFn1L_8dCTKhOhtVKqrfnJyaWaSox3jiMpzMMCOccvf1NMc3uEx5wvqOLWQxoBERnHBRyp41HQIUPGvn4-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A860D0F.7020205@schaufler-ca.com>
Date: Fri, 14 Aug 2009 18:19:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Greg Kroah-Hartman <greg@kroah.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A84EF1D.8060408@schaufler-ca.com> <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil>
In-Reply-To: <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Thu, 2009-08-13 at 21:59 -0700, Casey Schaufler wrote:
>   
>> From: Casey Schaufler <casey@schaufler-ca.com>
>>
>> This patch is in response to David P. Quigley's proposal from
>> July of this year. That patch provided special case handling of
>> LSM xattrs in the security name space.
>>
>> This patch provides an in memory representation of general
>> xattrs. It currently only allows xattrs in the security namespace,
>> but that is only because the support of ACLs is beyond the
>> day's needs. The list of xattrs for a given file is created on
>> demand and a system that does not use xattrs should be pretty
>> well oblivious to the changes. On the down side, this requires
>> an unpleasant locking scheme. Improvements would of course be
>> welcome.
>>
>> This scheme should generalize to any memory based file system,
>> although I have not attempted to create a generic implementation
>> here.
>>     
>
> I don't understand the benefits of this scheme compared to David's patch
> - can you explain?

Sure, you bet. David's scheme requires as LSM and is only capable
of supporting security namespace attributes. It is further not a
reasonable model for other memory based filesystems. If all you
ever want to support is SELinux, it would be fine, but an LSM
that uses multiple xattrs (Smack only uses multiple xattrs on
sockets, but it does use them) would be hard pressed to work off
of a secid. This is a swag at real xattr support, which is the
right thing to do for any filesystem. Special purpose interfaces
to solve a single instance of a problem are for squares.

>   It seems worse in terms of locking,

I'll buy that, and happily incorporate improvements. The
crude locking is an artifact of keeping memory usage down.

>  memory use,

There are less than 12,000 entries in /sys on my machine.
Is that really an issue?

>  and
> is no more general than David's patch.

Except that one could (fix the locking and) port this code to
other memory based file systems, such as smackfs or selinuxfs
without much bother. You'd have to implement new LSM hooks for
each file system you ported the other approach for. It
can be used without an LSM, it could support multiple security
xattrs and it can support other namespaces.

>   More specific comments below.
>
>   
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> ---
>>
>>  fs/sysfs/dir.c     |    4 
>>  fs/sysfs/inode.c   |  210 +++++++++++++++++++++++++++++++++++++++++++
>>  fs/sysfs/symlink.c |   10 +-
>>  fs/sysfs/sysfs.h   |   16 +++
>>  4 files changed, 237 insertions(+), 3 deletions(-)
>>     
>
>   
>> diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/inode.c linux-0812/fs/sysfs/inode.c
>> --- linux-2.6/fs/sysfs/inode.c	2009-03-28 13:47:33.000000000 -0700
>> +++ linux-0812/fs/sysfs/inode.c	2009-08-12 11:08:28.000000000 -0700
>> @@ -104,6 +110,210 @@ int sysfs_setattr(struct dentry * dentry
>>  	return error;
>>  }
>>  
>> +/*
>> + * Extended attributes are stored on a list off of the dirent.
>> + * The list head itself is allocated when needed so that a file
>> + * with no xattrs does not have the overhead of a list head.
>> + * Unfortunately, to lock the xattr list for each dentry would
>> + * require a lock in each dentry, which would defeat the purpose
>> + * of allocating the list head. So one big sysfs xattr lock.
>> + *
>> + * A better solution would be welcome.
>>     
>
> What was wrong with David's approach of wrapping the iattr with a
> containing structure that could also include the security attribute?
>   

Nothing really. Once I abandoned the notion of starting from David's
code I didn't look back at it.


>> + */
>> +static DEFINE_MUTEX(sysfs_xattr_lock);
>> +
>> +static struct sysfs_xattr *new_xattr(const char *name, const void *value,
>> +					size_t size)
>> +{
>> +	struct sysfs_xattr *nxattr;
>> +	void *nvalue;
>> +	char *nname;
>> +
>> +	nxattr = kzalloc(sizeof(*nxattr), GFP_KERNEL);
>> +	if (!nxattr)
>> +		return NULL;
>> +	nvalue = kzalloc(size, GFP_KERNEL);
>> +	if (!nvalue) {
>> +		kfree(nxattr);
>> +		return NULL;
>> +	}
>> +	nname = kzalloc(strlen(name) + 1, GFP_KERNEL);
>> +	if (!nname) {
>> +		kfree(nxattr);
>> +		kfree(nvalue);
>> +		return NULL;
>> +	}
>> +	memcpy(nvalue, value, size);
>> +	strcpy(nname, name);
>> +	nxattr->sx_name = nname;
>> +	nxattr->sx_value = nvalue;
>> +	nxattr->sx_size = size;
>>     
>
> Storing the name/value pairs here is redundant - the security module
> already has to store the value in some form (potentially smaller, like a
> secid + struct in the SELinux case).  This wastes memory.
>   

Only in the case where you have an LSM and the attribute you're
dealing with is the attribute that the LSM presents when you ask
the inode for the secid. I realize that that is the case that
SELinux finds compelling. That. David's code optimizes that case
like nobody's business at the expense of supporting any other case.

Again, this is xattr support. SELinux and Smack are LSMs that use
xattrs, but they are not the only use for xattrs.

>> +
>> +	return nxattr;
>> +}
>> +
>> +int sysfs_setxattr(struct dentry *dentry, const char *name,
>> +			const void *value, size_t size, int flags)
>> +{
>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>> +	struct list_head *xlist;
>> +	struct sysfs_xattr *nxattr;
>> +	void *nvalue;
>> +	int rc = 0;
>> +
>> +	/*
>> +	 * Only support the security namespace.
>> +	 * Only allow privileged processes to set them.
>> +	 * It has to be OK with the LSM, if any, as well.
>> +	 */
>> +	if (strncmp(name, XATTR_SECURITY_PREFIX,
>> +			sizeof XATTR_SECURITY_PREFIX - 1))
>> +		return -ENOTSUPP;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>>     
>
> SELinux does not require CAP_SYS_ADMIN to set its attributes, so this
> breaks its security model.
>   

That'll have to get fixed then.

>> +
>> +	mutex_lock(&sysfs_xattr_lock);
>> +
>> +	if (!sd->s_xattr) {
>> +		sd->s_xattr = kzalloc(sizeof(*xlist), GFP_KERNEL);
>> +		if (!sd->s_xattr) {
>> +			rc = -ENOMEM;
>> +			goto unlock_out;
>> +		}
>> +		INIT_LIST_HEAD(sd->s_xattr);
>> +	}
>> +	xlist = sd->s_xattr;
>> +
>> +	list_for_each_entry(nxattr, xlist, list) {
>> +		if (!strcmp(nxattr->sx_name, name)) {
>> +			if (flags & XATTR_CREATE) {
>> +				rc = -EEXIST;
>> +				goto unlock_out;
>> +			}
>> +			nvalue = kzalloc(size, GFP_KERNEL);
>> +			if (!nvalue) {
>> +				rc = -ENOMEM;
>> +				goto unlock_out;
>> +			}
>> +			memcpy(nvalue, value, size);
>> +			kfree(nxattr->sx_value);
>> +			nxattr->sx_value = nvalue;
>> +			nxattr->sx_size = size;
>> +			rc = 0;
>> +			goto unlock_out;
>> +		}
>> +	}
>> +	if (flags & XATTR_REPLACE) {
>> +		rc = -ENOENT;
>> +		goto unlock_out;
>> +	}
>> +	nxattr = new_xattr(name, value, size);
>> +	list_add_tail(&nxattr->list, xlist);
>> +
>> +unlock_out:
>> +	mutex_unlock(&sysfs_xattr_lock);
>> +	return rc;
>> +}
>> +
>> +ssize_t sysfs_getxattr(struct dentry *dentry, const char *name,
>> +			void *value, size_t size)
>> +{
>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>> +	struct list_head *xlist = sd->s_xattr;
>> +	struct sysfs_xattr *nxattr;
>> +	int rc = -ENODATA;
>> +
>> +	if (!xlist)
>> +		return -ENODATA;
>> +
>> +	mutex_lock(&sysfs_xattr_lock);
>> +
>> +	list_for_each_entry(nxattr, xlist, list) {
>> +		if (!strcmp(nxattr->sx_name, name)) {
>> +			if (size <= 0) {
>> +				rc = nxattr->sx_size;
>> +				goto unlock_out;
>> +			}
>> +			if (nxattr->sx_size > size) {
>> +				rc = -ERANGE;
>> +				goto unlock_out;
>> +			}
>> +			memcpy(value, nxattr->sx_value, nxattr->sx_size);
>> +			rc = nxattr->sx_size;
>> +			goto unlock_out;
>> +		}
>> +	}
>> +
>> +unlock_out:
>> +	mutex_unlock(&sysfs_xattr_lock);
>> +	return rc;
>> +}
>> +
>> +ssize_t sysfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>> +{
>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>> +	struct list_head *xlist = sd->s_xattr;
>> +	struct sysfs_xattr *nxattr;
>> +	ssize_t total = 0;
>> +	char *cp = buffer;
>> +
>> +	if (!xlist)
>> +		return 0;
>> +
>> +	mutex_lock(&sysfs_xattr_lock);
>> +
>> +	list_for_each_entry(nxattr, xlist, list)
>> +		total += strlen(nxattr->sx_name) + 1;
>> +
>> +	if (total > size) {
>> +		total = -ERANGE;
>> +		goto unlock_out;
>> +	}
>> +
>> +	list_for_each_entry(nxattr, xlist, list) {
>> +		strcpy(cp, nxattr->sx_name);
>> +		cp += strlen(nxattr->sx_name) + 1;
>> +	}
>> +
>> +unlock_out:
>> +	mutex_unlock(&sysfs_xattr_lock);
>> +	return total;
>> +}
>>     
>
> You are duplicating a lot of machinery that is already supported via the
> vfs fallback behavior for the security namespace.  We can already
> support getxattr, listxattr, setxattr of security atttributes on in
> memory filesystems via those fallbacks.  The only thing we lack is the
> ability to preserve attributes when an inode is evicted from memory,
> which is only an issue when the inodes are not pinned (as in the sysfs
> case).  

Wouldn't be the first time I ripped out code at your suggestion.

> And there all we need is support for saving the attribute in the
> backing data structure, which is precisely what David's patch is about.
>
>   

Once again, you are assuming the presence of an LSM and the desire
to support exactly one xattr in the security namespace.

>> +int sysfs_removexattr(struct dentry *dentry, const char *name)
>> +{
>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>> +	struct list_head *xlist = sd->s_xattr;
>> +	struct sysfs_xattr *nxattr;
>> +	int rc = -ENODATA;
>> +
>> +	if (!xlist)
>> +		return -ENODATA;
>> +
>> +	mutex_lock(&sysfs_xattr_lock);
>> +
>> +	list_for_each_entry(nxattr, xlist, list) {
>> +		if (!strcmp(nxattr->sx_name, name)) {
>> +			list_del(&nxattr->list);
>> +			if (list_empty(xlist)) {
>> +				kfree(xlist);
>> +				sd->s_xattr = NULL;
>> +			}
>> +			kfree(nxattr->sx_name);
>> +			kfree(nxattr->sx_value);
>> +			kfree(nxattr);
>> +			rc = 0;
>> +			goto unlock_out;
>> +		}
>> +	}
>> +
>> +unlock_out:
>> +	mutex_unlock(&sysfs_xattr_lock);
>> +	return rc;
>> +}
>> +
>> +
>>  static inline void set_default_inode_attr(struct inode * inode, mode_t mode)
>>  {
>>  	inode->i_mode = mode

Thank you for the kind suggestions. The next version should be
much cleaner.


