Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXHHJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXHHJf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbXHHJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:35:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:10890 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXHHJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QF1sYm0QV7uyqttar0xFWGS1wgRVtG1bNUscTStybtftwDkhMJ7iVgeRkq63QoVDTK8orMmbCq8bvrp7c3qbq9lMeiaT5qVhwqVLf95Ly8NHTZcyQwoZY229akVaXfnpO7BtZuZiyttGAx4F5QLT28KbOCfk/gI4yBiUbaIeJtE=
Date: Wed, 8 Aug 2007 18:35:05 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 20/25] sysfs: Rename Support multiple superblocks
Message-ID: <20070808093505.GL13674@htj.dyndns.org>
References: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com> <m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com> <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com> <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com> <m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 07, 2007 at 03:31:18PM -0600, Eric W. Biederman wrote:
> This patch modifies the sysfs_rename_dir and sysfs_move_dir
> to support multiple sysfs dentry trees rooted in different
> sysfs superblocks.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

> +struct sysfs_rename_struct {
> +	struct list_head list;
> +	struct dentry *old_dentry;
> +	struct dentry *new_dentry;
> +	struct dentry *old_parent;
> +	struct dentry *new_parent;
> +};

Please rename to sysfs_rename_cxt to it consistent with
sysfs_addrm_cxt.

> +static void post_rename(struct list_head *head)

Please rename to sysfs_post_rename() and add comment.

> +{
> +	struct sysfs_rename_struct *srs;
> +	while (!list_empty(head)) {
> +		srs = list_entry(head->next, struct sysfs_rename_struct, list);
> +		dput(srs->old_dentry);
> +		dput(srs->new_dentry);
> +		dput(srs->old_parent);
> +		dput(srs->new_parent);
> +		list_del(&srs->list);
> +		kfree(srs);
> +	}
> +}
> +
> +static int prep_rename(struct list_head *head,
> +	struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
> +	const char *name)

Ditto.

> +{
> +	struct sysfs_rename_struct *srs;
> +	struct super_block *sb;
> +	struct dentry *dentry;
> +	int error;
> +
> +	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
> +		dentry = sysfs_get_dentry(sb, sd);
> +		if (!dentry)
> +			continue;

sysfs_get_dentry() return ERR_PTR() value.  Oops, sysfs_get_dentry()
implementation is wrong too.  Also, please move
sysfs_grab/release_supers() near this patch and add (a lot of)
comments there.

Other than that, I think this is as clean as this can be.  Great.

-- 
tejun
