Return-Path: <linux-kernel-owner+w=401wt.eu-S935982AbXJPVmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935982AbXJPVmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934271AbXJPVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:42:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32966 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbXJPVmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:42:00 -0400
Date: Tue, 16 Oct 2007 16:41:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       lkml <linux-kernel@vger.kernel.org>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071016214159.GB13294@sergelap.austin.ibm.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Mon, 2007-10-15 at 21:31 -0500, Serge E. Hallyn wrote:
> > >From 7dd503c612afcb86b3165602ab264e2e9493b4bf Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Mon, 15 Oct 2007 20:57:52 -0400
> > Subject: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
> > 
> > We are out of capabilities in the 32-bit capability fields, and
> > several users could make use of additional capabilities.
> > Convert the capabilities to 64-bits, change the capability
> > version number accordingly, and convert the file capability
> > code to handle both 32-bit and 64-bit file capability xattrs.
> > 
> > It might seem desirable to also implement back-compatibility
> > to read 32-bit caps from userspace, but that becomes
> > problematic with capget, as capget could return valid info
> > for processes not using high bits, but would have to return
> > -EINVAL for those which were.
> > 
> > So with this patch, libcap would need to be updated to make
> > use of capset/capget.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  fs/proc/array.c            |    6 +++---
> >  include/linux/capability.h |   29 ++++++++++++++++++++---------
> >  security/commoncap.c       |   37 +++++++++++++++++++++++++++++--------
> >  3 files changed, 52 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > index 3f4d824..c8ea46d 100644
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -288,9 +288,9 @@ static inline char *task_sig(struct task_struct *p, char *buffer)
> >  
> >  static inline char *task_cap(struct task_struct *p, char *buffer)
> >  {
> > -    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
> > -			    "CapPrm:\t%016x\n"
> > -			    "CapEff:\t%016x\n",
> > +    return buffer + sprintf(buffer, "CapInh:\t%016lx\n"
> > +			    "CapPrm:\t%016lx\n"
> > +			    "CapEff:\t%016lx\n",
> >  			    cap_t(p->cap_inheritable),
> >  			    cap_t(p->cap_permitted),
> >  			    cap_t(p->cap_effective));
> > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > index bb017ed..a3da4b9 100644
> > --- a/include/linux/capability.h
> > +++ b/include/linux/capability.h
> > @@ -29,7 +29,7 @@ struct task_struct;
> >     library since the draft standard requires the use of malloc/free
> >     etc.. */
> >  
> > -#define _LINUX_CAPABILITY_VERSION  0x19980330
> > +#define _LINUX_CAPABILITY_VERSION  0x20071015
> >  
> >  typedef struct __user_cap_header_struct {
> >  	__u32 version;
> > @@ -37,29 +37,40 @@ typedef struct __user_cap_header_struct {
> >  } __user *cap_user_header_t;
> >  
> >  typedef struct __user_cap_data_struct {
> > -        __u32 effective;
> > -        __u32 permitted;
> > -        __u32 inheritable;
> > +        __u64 effective;
> > +        __u64 permitted;
> > +        __u64 inheritable;
> >  } __user *cap_user_data_t;
> >  
> >  #define XATTR_CAPS_SUFFIX "capability"
> >  #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> >  
> > -#define XATTR_CAPS_SZ (3*sizeof(__le32))
> > +#define XATTR_CAPS_SZ_1 (3*sizeof(__le32))
> > +#define XATTR_CAPS_SZ_2 (2*sizeof(__le64) + sizeof(__le32))
> >  #define VFS_CAP_REVISION_MASK	0xFF000000
> >  #define VFS_CAP_REVISION_1	0x01000000
> > +#define VFS_CAP_REVISION_2	0x02000000
> >  
> > -#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
> > +#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
> > +#define XATTR_CAPS_SZ		XATTR_CAPS_SZ_2
> >  
> >  #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
> >  #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
> >  
> > -struct vfs_cap_data {
> > +struct vfs_cap_data_v1 {
> >  	__u32 magic_etc;  /* Little endian */
> >  	__u32 permitted;    /* Little endian */
> >  	__u32 inheritable;  /* Little endian */
> >  };
> >  
> > +struct vfs_cap_data_v2 {
> > +	__u32 magic_etc;  /* Little endian */
> > +	__u64 permitted;    /* Little endian */
> > +	__u64 inheritable;  /* Little endian */
> > +};
> > +
> > +typedef struct vfs_cap_data_v2 vfs_cap_data;
> > +
> >  #ifdef __KERNEL__
> >  
> >  /* #define STRICT_CAP_T_TYPECHECKS */
> > @@ -67,12 +78,12 @@ struct vfs_cap_data {
> >  #ifdef STRICT_CAP_T_TYPECHECKS
> >  
> >  typedef struct kernel_cap_struct {
> > -	__u32 cap;
> > +	__u64 cap;
> >  } kernel_cap_t;
> >  
> >  #else
> >  
> > -typedef __u32 kernel_cap_t;
> > +typedef __u64 kernel_cap_t;
> >  
> >  #endif
> 
> Don't you need to update CAP_TO_MASK() too?

Thanks for catching that.

New patch appended - I'll leave the selinux patch out until there is
more comment on the selinux list?

To properly test this the libcap code will need to be updated first,
which I'm looking at now...

thanks,
-serge


>From 276a6f84f10a627832c067d8e039aafffaca67a1 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 15 Oct 2007 20:57:52 -0400
Subject: [PATCH 2/2] capabilities: implement 64-bit capabilities

We are out of capabilities in the 32-bit capability fields, and
several users could make use of additional capabilities.
Convert the capabilities to 64-bits, change the capability
version number accordingly, and convert the file capability
code to handle both 32-bit and 64-bit file capability xattrs.

It might seem desirable to also implement back-compatibility
to read 32-bit caps from userspace, but that becomes
problematic with capget, as capget could return valid info
for processes not using high bits, but would have to return
-EINVAL for those which were.

Changelog:
	Oct 16: fix the CAP_TO_MASK definition

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/proc/array.c            |    6 +++---
 include/linux/capability.h |   31 +++++++++++++++++++++----------
 security/commoncap.c       |   37 +++++++++++++++++++++++++++++--------
 3 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 3f4d824..c8ea46d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -288,9 +288,9 @@ static inline char *task_sig(struct task_struct *p, char *buffer)
 
 static inline char *task_cap(struct task_struct *p, char *buffer)
 {
-    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
-			    "CapPrm:\t%016x\n"
-			    "CapEff:\t%016x\n",
+    return buffer + sprintf(buffer, "CapInh:\t%016lx\n"
+			    "CapPrm:\t%016lx\n"
+			    "CapEff:\t%016lx\n",
 			    cap_t(p->cap_inheritable),
 			    cap_t(p->cap_permitted),
 			    cap_t(p->cap_effective));
diff --git a/include/linux/capability.h b/include/linux/capability.h
index bb017ed..316c4c3 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -29,7 +29,7 @@ struct task_struct;
    library since the draft standard requires the use of malloc/free
    etc.. */
 
-#define _LINUX_CAPABILITY_VERSION  0x19980330
+#define _LINUX_CAPABILITY_VERSION  0x20071015
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -37,29 +37,40 @@ typedef struct __user_cap_header_struct {
 } __user *cap_user_header_t;
 
 typedef struct __user_cap_data_struct {
-        __u32 effective;
-        __u32 permitted;
-        __u32 inheritable;
+        __u64 effective;
+        __u64 permitted;
+        __u64 inheritable;
 } __user *cap_user_data_t;
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
-#define XATTR_CAPS_SZ (3*sizeof(__le32))
+#define XATTR_CAPS_SZ_1 (3*sizeof(__le32))
+#define XATTR_CAPS_SZ_2 (2*sizeof(__le64) + sizeof(__le32))
 #define VFS_CAP_REVISION_MASK	0xFF000000
 #define VFS_CAP_REVISION_1	0x01000000
+#define VFS_CAP_REVISION_2	0x02000000
 
-#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
+#define XATTR_CAPS_SZ		XATTR_CAPS_SZ_2
 
 #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
 #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
-struct vfs_cap_data {
+struct vfs_cap_data_v1 {
 	__u32 magic_etc;  /* Little endian */
 	__u32 permitted;    /* Little endian */
 	__u32 inheritable;  /* Little endian */
 };
 
+struct vfs_cap_data_v2 {
+	__u32 magic_etc;  /* Little endian */
+	__u64 permitted;    /* Little endian */
+	__u64 inheritable;  /* Little endian */
+};
+
+typedef struct vfs_cap_data_v2 vfs_cap_data;
+
 #ifdef __KERNEL__
 
 /* #define STRICT_CAP_T_TYPECHECKS */
@@ -67,12 +78,12 @@ struct vfs_cap_data {
 #ifdef STRICT_CAP_T_TYPECHECKS
 
 typedef struct kernel_cap_struct {
-	__u32 cap;
+	__u64 cap;
 } kernel_cap_t;
 
 #else
 
-typedef __u32 kernel_cap_t;
+typedef __u64 kernel_cap_t;
 
 #endif
 
@@ -330,7 +341,7 @@ typedef __u32 kernel_cap_t;
 #define CAP_INIT_EFF_SET    to_cap_t(~0 & ~CAP_TO_MASK(CAP_SETPCAP))
 #define CAP_INIT_INH_SET    to_cap_t(0)
 
-#define CAP_TO_MASK(x) (1 << (x))
+#define CAP_TO_MASK(x) (1ULL << (x))
 #define cap_raise(c, flag)   (cap_t(c) |=  CAP_TO_MASK(flag))
 #define cap_lower(c, flag)   (cap_t(c) &= ~CAP_TO_MASK(flag))
 #define cap_raised(c, flag)  (cap_t(c) & CAP_TO_MASK(flag))
diff --git a/security/commoncap.c b/security/commoncap.c
index 542bbe9..2cca843 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -190,25 +190,46 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(struct vfs_cap_data *caps,
+union vfs_cap_union {
+	struct vfs_cap_data_v1 v1;
+	struct vfs_cap_data_v2 v2;
+};
+
+static inline int cap_from_disk(union vfs_cap_union *caps,
 				struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
 
-	if (size != XATTR_CAPS_SZ)
+	if (size != XATTR_CAPS_SZ_1 && size != XATTR_CAPS_SZ_2)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps->magic_etc);
+	magic_etc = le32_to_cpu(caps->v1.magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
-	case VFS_CAP_REVISION:
+	case VFS_CAP_REVISION_1:
+		if (size != XATTR_CAPS_SZ_1)
+			return -EINVAL;
+		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+			bprm->cap_effective = true;
+		else
+			bprm->cap_effective = false;
+		bprm->cap_permitted = to_cap_t(
+			(__u64) le32_to_cpu(caps->v1.permitted) );
+		bprm->cap_inheritable = to_cap_t(
+			(__u64) le32_to_cpu(caps->v1.inheritable) );
+		return 0;
+	case VFS_CAP_REVISION_2:
+		if (size != XATTR_CAPS_SZ_2)
+			return -EINVAL;
 		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );
+		bprm->cap_permitted = to_cap_t(
+			le64_to_cpu(caps->v2.permitted) );
+		bprm->cap_inheritable = to_cap_t(
+			le64_to_cpu(caps->v2.inheritable) );
 		return 0;
 	default:
 		return -EINVAL;
@@ -220,7 +241,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
 	int rc = 0;
-	struct vfs_cap_data incaps;
+	union vfs_cap_union incaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -235,7 +256,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 
 	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
 	if (rc > 0) {
-		if (rc == XATTR_CAPS_SZ)
+		if (rc == XATTR_CAPS_SZ_2 || rc == XATTR_CAPS_SZ_1)
 			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
 						&incaps, XATTR_CAPS_SZ);
 		else
-- 
1.5.1.1.GIT

