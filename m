Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXHHJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXHHJit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXHHJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:38:39 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:50418 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXHHJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nrK3CIxaYlZF1xZzuSxqitSAOGpStUQZa+0oxIG1k/DtZlm8ok+ZqI2WGC5dUuY9HsLhswJF8U9o1QgHsYaOprSEXbzdSvyZnx+7fJDu6nrhEPrkyErNkcKAgmTdADnl+GNIB1WqC4wXUr4jVGQjxTx7ElSaKMh64ng3iJLFVmI=
Date: Wed, 8 Aug 2007 18:38:30 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 21/25] sysfs: sysfs_chmod_file handle multiple superblocks
Message-ID: <20070808093830.GM13674@htj.dyndns.org>
References: <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com> <m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com> <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com> <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com> <m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com> <m1myx3ghdt.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1myx3ghdt.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:32:46PM -0600, Eric W. Biederman wrote:
> 
> Teach sysfs_chmod_file how to handle multiple sysfs
> superblocks.  We need to iterate over each superblock
> so that we give all of the appropriate filesystem modification
> notifications.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/sysfs/file.c |   41 +++++++++++++++++++++++++----------------
>  1 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index f954b9f..cff054f 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -501,7 +501,8 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
>  int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
>  {
>  	struct sysfs_dirent *victim_sd = NULL;
> -	struct dentry *victim = NULL;
> +	struct super_block *sb;
> +	struct dentry *victim;
>  	struct inode * inode;
>  	struct iattr newattrs;
>  	int rc;
> @@ -512,22 +513,30 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
>  		goto out;
>  
>  	mutex_lock(&sysfs_rename_mutex);
> -	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
> -	mutex_unlock(&sysfs_rename_mutex);
> -	if (IS_ERR(victim)) {
> -		rc = PTR_ERR(victim);
> -		victim = NULL;
> -		goto out;
> +	sysfs_grab_supers();
> +	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
> +		victim = sysfs_get_dentry(sb, victim_sd);
> +		if (!victim)
> +			continue;
> +		if (IS_ERR(victim)) {
> +			rc = PTR_ERR(victim);
> +			victim = NULL;
> +			goto out_unlock;

Hmmm... Please fix sysfs_get_dentry() and make it return either NULL
or PTR_ERR() values.  Returning both is pretty confusing.  Also, it
would be nice if we can use the rename_prep stuff for this too but it
might just be a wishful thinking.

Thanks.

-- 
tejun
