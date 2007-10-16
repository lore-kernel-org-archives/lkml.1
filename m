Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbXJPSsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbXJPSsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXJPSsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:48:23 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:39566 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758130AbXJPSsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:48:21 -0400
X-YMail-OSG: .ryAsdoVM1nsEltMvAvZNo6u6Dq1T.SDTc2iV0j7VAhBDO.To_Axb3dlMZpw72yOQnBpNTFIPj8e9GAF2V3FLpIPc2dh7hVtjV_egmlP3qAdiNMeSh_A
Date: Tue, 16 Oct 2007 13:48:18 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       lkml <linux-kernel@vger.kernel.org>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071016184818.GA17755@vino.hallyn.com>
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

Yeah, I'm afraid so.

> And, of course, SELinux task_has_capability() will then need to deal
> with higher capabilities differently, most likely by mapping them to
> permissions in a new class and access vector.

I saw your other email about this so will watch that thread.

thanks,
-serge
