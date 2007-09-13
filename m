Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbXIMNCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbXIMNCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXIMNCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:02:37 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:62553 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752458AbXIMNCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:02:35 -0400
Subject: Re: [RFC]selinux: Improving SELinux read/write performance
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Yuichi Nakamura <ynakam@hitachisoft.jp>
Cc: selinux@tycho.nsa.gov, busybox@kaigai.gr.jp,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       kaigai@ak.jp.nec.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070912174759.1B94.YNAKAM@hitachisoft.jp>
References: <20070910102250.FF41.YNAKAM@hitachisoft.jp>
	 <1189429354.11972.8.camel@moss-spartans.epoch.ncsc.mil>
	 <20070912174759.1B94.YNAKAM@hitachisoft.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 13 Sep 2007 08:58:32 -0400
Message-Id: <1189688312.18713.17.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 17:51 +0900, Yuichi Nakamura wrote:
> Hi. 
> 
> Stephen Smalley pointed out possibility of race condition
> in off-list discussion.
> Stephen Smalley said:
> > One other observation about the patch:  it presently leaves open a
> > (small) race window in which the file could get relabeled or policy gets
> > reloaded between the time of the normal permission check (from
> > selinux_inode_permission) and the time you copy the inode SID and policy
> > seqno to the file security struct.  In which case you might end up never
> > revalidating access upon read/write even though conditions changed since
> > the open-time permission check.  Not sure how to cleanly fix in a
> > lock-free manner, and adding locks here will only make matters worse.
> 
> To fix that, permission has to be checked in selinux_dentry_open.
> Therefore, in open, number of permission checks increased.
> As shown in benchmark result below, it does not affect open/close 
> performance so much.
> 
> Following is benchmark result.
> * Benchmark
> lmbench simple read,write,open/close.
> 
> * Before tuning
> 1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
>                 Base  SELinux  Overhead(%)
> Simple read     1.10  1.24     12.3
> Simple write    1.02  1.14     14.0
> open/close      5.97  7.45     24.9
> * Base: kernel compiled without SELinux support
> 
> 2) Result for SH(SH4, SH7751R), kernel 2.6.22
>                 Base    SELinux   Overhead(%)
> Simple read     2.39    5.49      130.5
> Simple write    2.07    5.10      146.6
> open/close      32.6    62.8      93.0
> 
> * After tuning
> 1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
>                 Base  SELinux  Overhead(%)
> Simple read     1.10  1.13     2.3(Before 12.3)
> Simple write    1.02  1.024    0.6(Before 14.0)
> open/close      5.97  7.48     25.3(Before 24.9)
> * Base: kernel compiled without SELinux support
> 
> 2) Result for SH(SH4, SH7751R), kernel 2.6.22
>                 Base    SELinux   Overhead(%)
> Simple read     2.39    2.63      10.4(Before 130.5)
> Simple write    2.07    2.34      13.1(Before 146.6)
> open/close      32.6    58.7      80.2(before 93.0)
> 
> Next is a patch.

Thanks, a few comments below.

> 
> * Description of patch
> This patch improves performance of read/write in SELinux.
> It improves performance by skipping permission check in 
> selinux_file_permission. Permission is only checked when 
> sid change or policy load is detected after file open.
> To detect sid change, new LSM hook securiy_dentry_open is added.

I think I'd reword this a little, e.g.

It reduces the selinux overhead on read/write by only revalidating
permissions in selinux_file_permission if the task or inode labels have
changed or the policy has changed since the open-time check.  A new LSM
hook, security_dentry_open, is added to capture the necessary state at
open time to allow this optimization.

> 
> Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
> ---
>  fs/open.c                         |    5 ++++
>  include/linux/security.h          |   16 ++++++++++++++
>  security/dummy.c                  |    6 +++++
>  security/selinux/avc.c            |    5 ++++
>  security/selinux/hooks.c          |   43 +++++++++++++++++++++++++++++++++++++-
>  security/selinux/include/avc.h    |    2 +
>  security/selinux/include/objsec.h |    2 +
>  7 files changed, 78 insertions(+), 1 deletion(-)
<snip>
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/hooks.c linux-2.6.22/security/selinux/hooks.c
> --- linux-2.6.22.orig/security/selinux/hooks.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/hooks.c	2007-09-12 08:42:49.000000000 +0900
> @@ -80,6 +82,7 @@
>  
>  #define XATTR_SELINUX_SUFFIX "selinux"
>  #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
> +#define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])

Leftover from prior version of the patch, no longer needed.

<snip>
> @@ -2715,6 +2737,23 @@ static int selinux_file_receive(struct f
>  	return file_has_perm(current, file, file_to_av(file));
>  }
>  
> +static int selinux_dentry_open(struct file *file)
> +{
> +	struct file_security_struct *fsec;
> +	struct inode *inode;
> +	struct inode_security_struct *isec;
> +	inode = file->f_path.dentry->d_inode;
> +	fsec = file->f_security;
> +	isec = inode->i_security;

I'd add a comment here, e.g.
	  /* 
	   * Save inode label and policy sequence number
	   * at open-time so that selinux_file_permission
	   * can determine whether revalidation is necessary.
	   * Task label is already saved in the file security
           * struct as its SID.
	   */

> +	fsec->isid = isec->sid;
> +	fsec->pseqno = avc_policy_seqno();
> +
> +	/*Permission has to be rechecked here.
> +	  Policy load of inode sid can happen between
> +	  may_open and selinux_dentry_open.*/

Typo in the comment (s/of/or/), coding style isn't right for a
multi-line comment, and likely needs clarification, e.g.
	/*
	 * Since the inode label or policy seqno may have changed
	 * between the selinux_inode_permission check and the saving
	 * of state above, recheck that access is still permitted.
	 * Otherwise, access might never be revalidated against the
	 * new inode label or new policy.
	 * This check is not redundant - do not remove. 
	 */

> +	return inode_has_perm(current, inode, file_to_av(file), NULL);
> +}
> +
>  /* task security operations */
>  
>  static int selinux_task_create(unsigned long clone_flags)

> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/fs/open.c linux-2.6.22/fs/open.c
> --- linux-2.6.22.orig/fs/open.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/fs/open.c	2007-09-12 08:31:24.000000000 +0900
> @@ -696,8 +696,13 @@ static struct file *__dentry_open(struct
>  	f->f_op = fops_get(inode->i_fop);
>  	file_move(f, &inode->i_sb->s_files);
>  
> +	error = security_dentry_open(f);
> +	if (error)
> +		goto cleanup_all;
> +
>  	if (!open && f->f_op)
>  		open = f->f_op->open;
> +

Extraneous whitespace leftover from prior version of the patch.

>  	if (open) {
>  		error = open(inode, f);
>  		if (error)
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
> --- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/include/linux/security.h	2007-09-12 08:30:16.000000000 +0900
> @@ -503,6 +503,11 @@ struct request_sock;
>   *	@file contains the file structure being received.
>   *	Return 0 if permission is granted.
>   *
> + * Security hook for dentry
> + *
> + * @dentry_open
> + *   Check permission or get additional information before opening dentry.
> + *

More precisely, "Save open-time permission checking state for later use
upon file_permission, and recheck access if anything has changed since
inode_permission."
  
-- 
Stephen Smalley
National Security Agency

