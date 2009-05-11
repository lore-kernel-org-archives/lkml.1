Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbZEKXSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbZEKXSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbZEKXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:18:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43427 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760424AbZEKXSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:18:13 -0400
Subject: Re: [PATCH 2/3] IMA: Handle dentry_open failures
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
In-Reply-To: <20090511175916.7719.34187.stgit@dhcp231-142.rdu.redhat.com>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
	 <20090511175916.7719.34187.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 19:18:12 -0400
Message-Id: <1242083892.4131.4.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 13:59 -0400, Eric Paris wrote:
> Currently IMA does not handle failures from dentry_open().  This means that we
> leave a pointer set to ERR_PTR(errno) and then try to use it just a few lines
> later in fput().  Oops.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
> 
>  security/integrity/ima/ima_main.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index cdae13c..1987424 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -116,10 +116,6 @@ static int get_path_measurement(struct ima_iint_cache *iint, struct file *file,
>  {
>  	int rc = 0;
> 
> -	if (IS_ERR(file)) {
> -		pr_info("%s dentry_open failed\n", filename);
> -		return rc;
> -	}
>  	iint->opencount++;
>  	iint->readcount++;
> 
> @@ -185,6 +181,12 @@ int ima_path_check(struct path *path, int mask)
>  		struct vfsmount *mnt = mntget(path->mnt);
> 
>  		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
> +		if (IS_ERR(file)) {
> +			pr_info("%s dentry_open failed\n", dentry->d_name.name);
> +			rc = PTR_ERR(file);
> +			file = NULL;
> +			goto out;
> +		}
>  		rc = get_path_measurement(iint, file, dentry->d_name.name);
>  	}
>  out:
> 

