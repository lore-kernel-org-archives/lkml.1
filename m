Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZFDSP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZFDSP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZFDSPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:15:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZFDSPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:15:10 -0400
Subject: Re: [PATCH] integrity: ima audit dentry_open failure
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       vibi sreenivasan <vibi_sreenivasan@cms.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1244137990-12678-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1244137990-12678-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 14:14:29 -0400
Message-Id: <1244139269.2822.3.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 13:53 -0400, Mimi Zohar wrote:
> Until we start appraising measurements, the ima_path_check()
> return code should always be 0.
> 
> - Update the ima_path_check() return code comment
> - Instead of the pr_info, audit the dentry_open failure
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

So I'm not a big fan of the needless stack variable declaration.  This
isn't the only spot you do it (and sometimes you do actually make use of
the variable like ima_add_template_entry) but I'm guessing the compiler
will clean it up, so

Acked-by: Eric Paris <eparis@redhat.com>

> 
> ---
>  security/integrity/ima/ima_main.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index a2eb233..6f61187 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -149,8 +149,8 @@ static void ima_update_counts(struct ima_iint_cache *iint, int mask)
>   *	- Opening a file for read when already open for write,
>   * 	  could result in a file measurement error.
>   *
> - * Return 0 on success, an error code on failure.
> - * (Based on the results of appraise_measurement().)
> + * Always return 0 and audit dentry_open failures.
> + * (Return code will be based upon measurement appraisal.)
>   */
>  int ima_path_check(struct path *path, int mask, int update_counts)
>  {
> @@ -189,8 +189,13 @@ int ima_path_check(struct path *path, int mask, int update_counts)
>  		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
>  				   current_cred());
>  		if (IS_ERR(file)) {
> -			pr_info("%s dentry_open failed\n", dentry->d_name.name);
> -			rc = PTR_ERR(file);
> +			int audit_info = 0;
> +
> +			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
> +					    dentry->d_name.name,
> +					    "add_measurement",
> +					    "dentry_open failed",
> +					    1, audit_info);
>  			file = NULL;
>  			goto out;
>  		}

