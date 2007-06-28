Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbXF1BeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbXF1BeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 21:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXF1BeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 21:34:09 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39106 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbXF1BeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 21:34:08 -0400
Message-ID: <46830FDE.7060502@ak.jp.nec.com>
Date: Thu, 28 Jun 2007 10:33:18 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: introduce cap_setfcap
References: <20070627171506.GA16764@sergelap.austin.ibm.com>
In-Reply-To: <20070627171506.GA16764@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Here's the first patch (of several or many to come) to address some of
> Andrew's comments.
> 
> Kaigai, IIUC cap_names.h will eventually be automatically updated?  (I
> had to manually tweak it for testing as the new kernel sources were not
> located on the test system)

The origin of cap_names.h is "/usr/include/linux/capability.h".
Some scripts kicked by Makefile convert it, then cap_names.h will
be generated.

I don't know whether we can expect the kernel headers are always
deployed under "/usr/include/linux", or not.
In Fedora system, the kernel-headers package deploys all headers
there, so cap_names.h will eventually be automatically updated.

Thanks,

> thanks,
> -serge
> 
>>From fefcd341e478bd9e490d34abe9efd3c3c4f0b8a0 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 27 Jun 2007 13:09:20 -0400
> Subject: [PATCH 1/1] file capabilities: introduce cap_setfcap
> 
> Setting file capabilities previously required the
> cap_sys_admin capability, since they are stored as
> extended attributes in the security.* namespace.
> 
> Introduce CAP_SETFCAP (to mirror CAP_SETPCAP), and
> require it for setting file capabilities instead of
> CAP_SYS_ADMIN.
> 
> Quoting Andrew Morgan,
> 
> "CAP_SYS_ADMIN is way too overloaded and this
> functionality is special."
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  include/linux/capability.h |    4 +++-
>  security/commoncap.c       |   12 ++++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 89125df..cdfaa10 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -324,7 +324,9 @@ typedef __u32 kernel_cap_t;
>  
>  #define CAP_AUDIT_CONTROL    30
>  
> -#define CAP_NUMCAPS	     31
> +#define CAP_SETFCAP	     31
> +
> +#define CAP_NUMCAPS	     32
>  
>  #ifdef __KERNEL__
>  /* 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 4e9ff02..24de4fa 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -290,7 +290,11 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
>  int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
>  		       size_t size, int flags)
>  {
> -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> +	if (!strcmp(name, XATTR_NAME_CAPS)) {
> +		if (!capable(CAP_SETFCAP))
> +			return -EPERM;
> +		return 0;
> +	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
>  		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
>  	    !capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -299,7 +303,11 @@ int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
>  
>  int cap_inode_removexattr(struct dentry *dentry, char *name)
>  {
> -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> +	if (!strcmp(name, XATTR_NAME_CAPS)) {
> +		if (!capable(CAP_SETFCAP))
> +			return -EPERM;
> +		return 0;
> +	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
>  		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
>  	    !capable(CAP_SYS_ADMIN))
>  		return -EPERM;


-- 
Open Source Software Promotion Center, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
