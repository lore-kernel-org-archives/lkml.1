Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZHOBfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZHOBfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 21:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZHOBfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 21:35:11 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:36688 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755279AbZHOBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 21:35:10 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: noJMRXYVM1lcbEYDGIILSYeoVwyfSO7c_iYYlMMzvgtdDupRob2K91t_A.6AgrUB2q4acFEKX2EAycQYP7PXttaDorx3mxlqi_AZyYyghb0jCvjCz4n9fuzFsnKif.r2dgd08YzPcZADxLBvwV094C32uY9zwVRcwTmH2GXExT67ivqDzC7z0sKQKwGsb2P8S5vILy3dGGSYs3FT1.d0T9KFJ.2HBUYC.S54USPIno.0phu78r.wrITTdWzJ_wTtk9CZKEz4N_En3pgTvUXitG0DIw2e.kRrApbHyhtgKuhRyfK6j6dZe0.qohDU9Xne5zcA
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A86105C.4070806@schaufler-ca.com>
Date: Fri, 14 Aug 2009 18:33:16 -0700
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
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A84EF1D.8060408@schaufler-ca.com>	 <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil> <1250253651.2422.183.camel@moss-pluto.epoch.ncsc.mil>
In-Reply-To: <1250253651.2422.183.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Fri, 2009-08-14 at 08:20 -0400, Stephen Smalley wrote:
>   
>> ...
>>> + */
>>> +static DEFINE_MUTEX(sysfs_xattr_lock);
>>> +
>>> +static struct sysfs_xattr *new_xattr(const char *name, const void *value,
>>> +					size_t size)
>>> +{
>>> +	struct sysfs_xattr *nxattr;
>>> +	void *nvalue;
>>> +	char *nname;
>>> +
>>> +	nxattr = kzalloc(sizeof(*nxattr), GFP_KERNEL);
>>> +	if (!nxattr)
>>> +		return NULL;
>>> +	nvalue = kzalloc(size, GFP_KERNEL);
>>> +	if (!nvalue) {
>>> +		kfree(nxattr);
>>> +		return NULL;
>>> +	}
>>> +	nname = kzalloc(strlen(name) + 1, GFP_KERNEL);
>>> +	if (!nname) {
>>> +		kfree(nxattr);
>>> +		kfree(nvalue);
>>> +		return NULL;
>>> +	}
>>> +	memcpy(nvalue, value, size);
>>> +	strcpy(nname, name);
>>> +	nxattr->sx_name = nname;
>>> +	nxattr->sx_value = nvalue;
>>> +	nxattr->sx_size = size;
>>>       
>> Storing the name/value pairs here is redundant - the security module
>> already has to store the value in some form (potentially smaller, like a
>> secid + struct in the SELinux case).  This wastes memory.
>>     
>
> Sorry - to clarify, I understand that we have to store a representation
> of the security attribute in the backing data structure so that it can
> be restored later, but that representation should come from the security
> module rather than being the original (name, value, size) triple.  Which
> is what David's patch does - he obtains a secid from the security module
> for storage in the wrapped iattr structure.
>   

Sorry, but I disagree with your assertion. An LSM can do what
it likes with the xattr, but the value sent from userland is
what should be stored.

>>> +
>>> +	return nxattr;
>>> +}
>>> +
>>> +int sysfs_setxattr(struct dentry *dentry, const char *name,
>>> +			const void *value, size_t size, int flags)
>>> +{
>>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>>> +	struct list_head *xlist;
>>> +	struct sysfs_xattr *nxattr;
>>> +	void *nvalue;
>>> +	int rc = 0;
>>> +
>>> +	/*
>>> +	 * Only support the security namespace.
>>> +	 * Only allow privileged processes to set them.
>>> +	 * It has to be OK with the LSM, if any, as well.
>>> +	 */
>>> +	if (strncmp(name, XATTR_SECURITY_PREFIX,
>>> +			sizeof XATTR_SECURITY_PREFIX - 1))
>>> +		return -ENOTSUPP;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EPERM;
>>>       
>> SELinux does not require CAP_SYS_ADMIN to set its attributes, so this
>> breaks its security model.
>>     
>
> And you don't need to apply any permission check here, as it gets
> covered by the security_inode_setxattr() hook in vfs_setxattr() prior to
> invoking i_op->setxattr.
>   

David seemed to think it necessary in an earlier review. I will
have another look.


