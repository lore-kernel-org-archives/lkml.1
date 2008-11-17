Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYKQVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYKQVNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYKQVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:12:36 -0500
Received: from tundra.namei.org ([65.99.196.166]:47985 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYKQVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:12:35 -0500
Date: Tue, 18 Nov 2008 08:12:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
Subject: Re: [PATCH -v2] capabilities: define get_vfs_caps_from_disk when
 file caps are not enabled
In-Reply-To: <1226702434.3353.83.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0811180811500.10839@tundra.namei.org>
References: <1226702434.3353.83.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Eric Paris wrote:

> When CONFIG_SECURITY_FILE_CAPABILITIES is not set the audit system may
> try to call into the capabilities function vfs_cap_from_file.  This
> patch defines that function so kernels can build and work.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

This needs to be a patch against the 'next' branch of the security-testing 
tree.

> 
> ---
> 
> james morris didn't like the fact I was clearing the cpu_caps struct.
> So this patch makes the error handling better so I don't need to.
> (actually I didn't need to fix the error handling since this audit
> function is only called when fcaps are enabled and we already got the
> xattr data once, but still, this is the right fix)
> 
>  kernel/auditsc.c     |   11 +++++++----
>  security/commoncap.c |    5 +++++
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index cef3423..90b0544 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2556,6 +2556,13 @@ void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_
>  	struct audit_context *context = current->audit_context;
>  	struct cpu_vfs_cap_data vcaps;
>  	struct dentry *dentry;
> +	int ret;
> +
> +	dentry = dget(bprm->file->f_dentry);
> +	ret = get_vfs_caps_from_disk(dentry, &vcaps);
> +	dput(dentry);
> +	if (ret)
> +		return;
>  
>  	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
>  	if (!ax)
> @@ -2565,10 +2572,6 @@ void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_
>  	ax->d.next = context->aux;
>  	context->aux = (void *)ax;
>  
> -	dentry = dget(bprm->file->f_dentry);
> -	get_vfs_caps_from_disk(dentry, &vcaps);
> -	dput(dentry);
> -
>  	ax->fcap.permitted = vcaps.permitted;
>  	ax->fcap.inheritable = vcaps.inheritable;
>  	ax->fcap.fE = !!(vcaps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 0b88160..22b9270 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -337,6 +337,11 @@ int cap_inode_killpriv(struct dentry *dentry)
>  	return 0;
>  }
>  
> +int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
> +{
> +	return -ENODATA;
> +}
> +
>  static inline int get_file_caps(struct linux_binprm *bprm)
>  {
>  	bprm_clear_caps(bprm);
> 
> 

-- 
James Morris
<jmorris@namei.org>
