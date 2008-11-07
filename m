Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYKGPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYKGPj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYKGPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:39:49 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:50981 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKGPjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:39:48 -0500
Subject: Re: [PATCH -v3 4/4] SELinux: use new cap_noaudit interface
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, jmorris@nameil.org,
       serue@us.ibm.com, morgan@kernel.org, casey@schaufler-ca.com,
       esandeen@redhat.com
In-Reply-To: <20081107152343.10328.60753.stgit@paris.rdu.redhat.com>
References: <20081107152326.10328.44330.stgit@paris.rdu.redhat.com>
	 <20081107152343.10328.60753.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 07 Nov 2008 10:38:10 -0500
Message-Id: <1226072290.16320.60.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 10:23 -0500, Eric Paris wrote:
> Currently SELinux jumps through some ugly hoops to not audit a capbility
> check when determining if a process has additional powers to override
> memory limits or when trying to read/write illegal file labels.  Use
> the new noaudit call instead.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
> 
>  security/selinux/hooks.c |   19 ++-----------------
>  1 files changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 0d4ee8c..d3fd051 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1978,16 +1978,8 @@ static int selinux_syslog(int type)
>  static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
>  {
>  	int rc, cap_sys_admin = 0;
> -	struct task_security_struct *tsec = current->security;
> -
> -	rc = secondary_ops->capable(current, CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT);
> -	if (rc == 0)
> -		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
> -					  SECCLASS_CAPABILITY,
> -					  CAP_TO_MASK(CAP_SYS_ADMIN),
> -					  0,
> -					  NULL);
>  
> +	rc = selinux_capable(current, CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT);
>  	if (rc == 0)
>  		cap_sys_admin = 1;
>  
> @@ -2812,7 +2804,6 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
>  	u32 size;
>  	int error;
>  	char *context = NULL;
> -	struct task_security_struct *tsec = current->security;
>  	struct inode_security_struct *isec = inode->i_security;
>  
>  	if (strcmp(name, XATTR_SELINUX_SUFFIX))
> @@ -2827,13 +2818,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
>  	 * and lack of permission just means that we fall back to the
>  	 * in-core context value, not a denial.
>  	 */
> -	error = secondary_ops->capable(current, CAP_MAC_ADMIN, SECURITY_CAP_NOAUDIT);
> -	if (!error)
> -		error = avc_has_perm_noaudit(tsec->sid, tsec->sid,
> -					     SECCLASS_CAPABILITY2,
> -					     CAPABILITY2__MAC_ADMIN,
> -					     0,
> -					     NULL);
> +	error = selinux_capable(current, CAP_MAC_ADMIN, SECURITY_CAP_NOAUDIT);
>  	if (!error)
>  		error = security_sid_to_context_force(isec->sid, &context,
>  						      &size);
-- 
Stephen Smalley
National Security Agency

