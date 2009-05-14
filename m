Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZENNLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZENNLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZENNLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:11:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40323 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZENNLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:11:33 -0400
Subject: Re: [PATCH] IMA: remove read permissions on the ima policy file
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
In-Reply-To: <20090512191355.6874.31248.stgit@dhcp231-142.rdu.redhat.com>
References: <20090512191355.6874.31248.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 09:11:19 -0400
Message-Id: <1242306679.4647.5.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:13 -0400, Eric Paris wrote:
> The IMA policy file does not implement read.  Trying to just open/read/close
> the file will load a blank policy and you cannot then change the policy
> without a reboot.  This removes the read permission from the file so one must
> at least be attempting to write...
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
> 
>  security/integrity/ima/ima_fs.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 510186f..2a829da 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -15,6 +15,7 @@
>   *	implemenents security file system for reporting
>   *	current measurement list and IMA statistics
>   */
> +#include <linux/fcntl.h>
>  #include <linux/module.h>
>  #include <linux/seq_file.h>
>  #include <linux/rculist.h>
> @@ -283,6 +284,9 @@ static atomic_t policy_opencount = ATOMIC_INIT(1);
>   */
>  int ima_open_policy(struct inode * inode, struct file * filp)
>  {
> +	/* No point in being allowed to open it if you aren't going to write */
> +	if (!(filp->f_flags & O_WRONLY))
> +		return -EACCES;
>  	if (atomic_dec_and_test(&policy_opencount))
>  		return 0;
>  	return -EBUSY;
> @@ -349,7 +353,7 @@ int ima_fs_init(void)
>  		goto out;
> 
>  	ima_policy = securityfs_create_file("policy",
> -					    S_IRUSR | S_IRGRP | S_IWUSR,
> +					    S_IWUSR,
>  					    ima_dir, NULL,
>  					    &ima_measure_policy_ops);
>  	if (IS_ERR(ima_policy))
> 

