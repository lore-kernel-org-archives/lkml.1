Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbXJPObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbXJPObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbXJPObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:31:12 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:40443 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932132AbXJPObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:31:09 -0400
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       lkml <linux-kernel@vger.kernel.org>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20071016023100.GA10698@sergelap.austin.ibm.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com>
	 <20071016023100.GA10698@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 16 Oct 2007 10:18:19 -0400
Message-Id: <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 21:31 -0500, Serge E. Hallyn wrote:
> >From 7dd503c612afcb86b3165602ab264e2e9493b4bf Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 15 Oct 2007 20:57:52 -0400
> Subject: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
> 
> We are out of capabilities in the 32-bit capability fields, and
> several users could make use of additional capabilities.
> Convert the capabilities to 64-bits, change the capability
> version number accordingly, and convert the file capability
> code to handle both 32-bit and 64-bit file capability xattrs.
> 
> It might seem desirable to also implement back-compatibility
> to read 32-bit caps from userspace, but that becomes
> problematic with capget, as capget could return valid info
> for processes not using high bits, but would have to return
> -EINVAL for those which were.
> 
> So with this patch, libcap would need to be updated to make
> use of capset/capget.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  fs/proc/array.c            |    6 +++---
>  include/linux/capability.h |   29 ++++++++++++++++++++---------
>  security/commoncap.c       |   37 +++++++++++++++++++++++++++++--------
>  3 files changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 3f4d824..c8ea46d 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -288,9 +288,9 @@ static inline char *task_sig(struct task_struct *p, char *buffer)
>  
>  static inline char *task_cap(struct task_struct *p, char *buffer)
>  {
> -    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
> -			    "CapPrm:\t%016x\n"
> -			    "CapEff:\t%016x\n",
> +    return buffer + sprintf(buffer, "CapInh:\t%016lx\n"
> +			    "CapPrm:\t%016lx\n"
> +			    "CapEff:\t%016lx\n",
>  			    cap_t(p->cap_inheritable),
>  			    cap_t(p->cap_permitted),
>  			    cap_t(p->cap_effective));
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index bb017ed..a3da4b9 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -29,7 +29,7 @@ struct task_struct;
>     library since the draft standard requires the use of malloc/free
>     etc.. */
>  
> -#define _LINUX_CAPABILITY_VERSION  0x19980330
> +#define _LINUX_CAPABILITY_VERSION  0x20071015
>  
>  typedef struct __user_cap_header_struct {
>  	__u32 version;
> @@ -37,29 +37,40 @@ typedef struct __user_cap_header_struct {
>  } __user *cap_user_header_t;
>  
>  typedef struct __user_cap_data_struct {
> -        __u32 effective;
> -        __u32 permitted;
> -        __u32 inheritable;
> +        __u64 effective;
> +        __u64 permitted;
> +        __u64 inheritable;
>  } __user *cap_user_data_t;
>  
>  #define XATTR_CAPS_SUFFIX "capability"
>  #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
>  
> -#define XATTR_CAPS_SZ (3*sizeof(__le32))
> +#define XATTR_CAPS_SZ_1 (3*sizeof(__le32))
> +#define XATTR_CAPS_SZ_2 (2*sizeof(__le64) + sizeof(__le32))
>  #define VFS_CAP_REVISION_MASK	0xFF000000
>  #define VFS_CAP_REVISION_1	0x01000000
> +#define VFS_CAP_REVISION_2	0x02000000
>  
> -#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
> +#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
> +#define XATTR_CAPS_SZ		XATTR_CAPS_SZ_2
>  
>  #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
>  #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
>  
> -struct vfs_cap_data {
> +struct vfs_cap_data_v1 {
>  	__u32 magic_etc;  /* Little endian */
>  	__u32 permitted;    /* Little endian */
>  	__u32 inheritable;  /* Little endian */
>  };
>  
> +struct vfs_cap_data_v2 {
> +	__u32 magic_etc;  /* Little endian */
> +	__u64 permitted;    /* Little endian */
> +	__u64 inheritable;  /* Little endian */
> +};
> +
> +typedef struct vfs_cap_data_v2 vfs_cap_data;
> +
>  #ifdef __KERNEL__
>  
>  /* #define STRICT_CAP_T_TYPECHECKS */
> @@ -67,12 +78,12 @@ struct vfs_cap_data {
>  #ifdef STRICT_CAP_T_TYPECHECKS
>  
>  typedef struct kernel_cap_struct {
> -	__u32 cap;
> +	__u64 cap;
>  } kernel_cap_t;
>  
>  #else
>  
> -typedef __u32 kernel_cap_t;
> +typedef __u64 kernel_cap_t;
>  
>  #endif

Don't you need to update CAP_TO_MASK() too?
And, of course, SELinux task_has_capability() will then need to deal
with higher capabilities differently, most likely by mapping them to
permissions in a new class and access vector.

> diff --git a/security/commoncap.c b/security/commoncap.c
> index 542bbe9..2cca843 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -190,25 +190,46 @@ int cap_inode_killpriv(struct dentry *dentry)
>  	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
>  }
>  
> -static inline int cap_from_disk(struct vfs_cap_data *caps,
> +union vfs_cap_union {
> +	struct vfs_cap_data_v1 v1;
> +	struct vfs_cap_data_v2 v2;
> +};
> +
> +static inline int cap_from_disk(union vfs_cap_union *caps,
>  				struct linux_binprm *bprm,
>  				int size)
>  {
>  	__u32 magic_etc;
>  
> -	if (size != XATTR_CAPS_SZ)
> +	if (size != XATTR_CAPS_SZ_1 && size != XATTR_CAPS_SZ_2)
>  		return -EINVAL;
>  
> -	magic_etc = le32_to_cpu(caps->magic_etc);
> +	magic_etc = le32_to_cpu(caps->v1.magic_etc);
>  
>  	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
> -	case VFS_CAP_REVISION:
> +	case VFS_CAP_REVISION_1:
> +		if (size != XATTR_CAPS_SZ_1)
> +			return -EINVAL;
> +		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
> +			bprm->cap_effective = true;
> +		else
> +			bprm->cap_effective = false;
> +		bprm->cap_permitted = to_cap_t(
> +			(__u64) le32_to_cpu(caps->v1.permitted) );
> +		bprm->cap_inheritable = to_cap_t(
> +			(__u64) le32_to_cpu(caps->v1.inheritable) );
> +		return 0;
> +	case VFS_CAP_REVISION_2:
> +		if (size != XATTR_CAPS_SZ_2)
> +			return -EINVAL;
>  		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
>  			bprm->cap_effective = true;
>  		else
>  			bprm->cap_effective = false;
> -		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );
> -		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );
> +		bprm->cap_permitted = to_cap_t(
> +			le64_to_cpu(caps->v2.permitted) );
> +		bprm->cap_inheritable = to_cap_t(
> +			le64_to_cpu(caps->v2.inheritable) );
>  		return 0;
>  	default:
>  		return -EINVAL;
> @@ -220,7 +241,7 @@ static int get_file_caps(struct linux_binprm *bprm)
>  {
>  	struct dentry *dentry;
>  	int rc = 0;
> -	struct vfs_cap_data incaps;
> +	union vfs_cap_union incaps;
>  	struct inode *inode;
>  
>  	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
> @@ -235,7 +256,7 @@ static int get_file_caps(struct linux_binprm *bprm)
>  
>  	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
>  	if (rc > 0) {
> -		if (rc == XATTR_CAPS_SZ)
> +		if (rc == XATTR_CAPS_SZ_2 || rc == XATTR_CAPS_SZ_1)
>  			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
>  						&incaps, XATTR_CAPS_SZ);
>  		else
-- 
Stephen Smalley
National Security Agency

