Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYFWCFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYFWCFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYFWCFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:05:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:53049 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYFWCFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KehTDwFbdrfA8VX5QutkJ/yD9ipU4aDiWWrQFDAFjPF/O+qmuV2b8p4Q6x+Ipkaz9T
         QlXTPaZY0iA93ly5CPGsQONfLTBjr8h+wyLO0TOK7jcEK20tynF34ARlfe8+3u2TQgiW
         o7dk+D5NKOl8vEn6Wr7YHRU8kc3b2AgCCaXZI=
Message-ID: <485F04E1.70204@gmail.com>
Date: Mon, 23 Jun 2008 11:05:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.002784342@theryb.frec.bull.fr>
In-Reply-To: <20080618170731.002784342@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Index: linux-mm/fs/sysfs/file.c
> ===================================================================
> --- linux-mm.orig/fs/sysfs/file.c
> +++ linux-mm/fs/sysfs/file.c
> @@ -460,9 +460,9 @@ void sysfs_notify(struct kobject *k, cha
>  	mutex_lock(&sysfs_mutex);
>  
>  	if (sd && dir)
> -		sd = sysfs_find_dirent(sd, dir);
> +		sd = sysfs_find_dirent(sd, NULL, dir);
>  	if (sd && attr)
> -		sd = sysfs_find_dirent(sd, attr);
> +		sd = sysfs_find_dirent(sd, NULL, attr);
>  	if (sd) {
>  		struct sysfs_open_dirent *od;
>  

As only directories can be tagged, I suppose handling tags explicitly
isn't necessary here, right?  Can we please add a comment explaning
that?

> Index: linux-mm/fs/sysfs/inode.c
> ===================================================================
> --- linux-mm.orig/fs/sysfs/inode.c
> +++ linux-mm/fs/sysfs/inode.c
> @@ -217,17 +217,20 @@ struct inode * sysfs_get_inode(struct sy
>  	return inode;
>  }
>  
> -int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
> +int sysfs_hash_and_remove(struct kobject *kobj, struct sysfs_dirent *dir_sd,
> +			  const char *name)
>  {
>  	struct sysfs_addrm_cxt acxt;
>  	struct sysfs_dirent *sd;
> +	const void *tag;
>  
>  	if (!dir_sd)
>  		return -ENOENT;
>  
>  	sysfs_addrm_start(&acxt, dir_sd);
> +	tag = sysfs_removal_tag(kobj, dir_sd);
>  
> -	sd = sysfs_find_dirent(dir_sd, name);
> +	sd = sysfs_find_dirent(dir_sd, tag, name);
>  	if (sd)
>  		sysfs_remove_one(&acxt, sd);

Taking both @kobj and @dir_sd is ugly but it isn't your fault.  I'll
clean things up later.

> Index: linux-mm/include/linux/sysfs.h
> ===================================================================
> --- linux-mm.orig/include/linux/sysfs.h
> +++ linux-mm/include/linux/sysfs.h
> @@ -80,6 +80,14 @@ struct sysfs_ops {
>  	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
>  };
>  
> +struct sysfs_tag_info {
> +};
> +
> +struct sysfs_tagged_dir_operations {
> +	const void *(*sb_tag)(struct sysfs_tag_info *info);
> +	const void *(*kobject_tag)(struct kobject *kobj);
> +};

As before, I can't bring myself to like this interface.  Is computing
tags dynamically really necessary?  Can't we do the followings?

tag = sysfs_allocate_tag(s);
sysfs_enable_tag(kobj (or sd), tag);
sysfs_sb_show_tag(sb, tag);

Where tags are allocated using ida and each sb has bitmap of enabled
tags so that sysfs ops can simply use something like the following to
test whether it's enabled.

bool sysfs_tag_enabled(sb, tag)
{
	return sysfs_info(sb)->tag_map & (1 << tag);
}

Tags which can change dynamically seems too confusing to me and it
makes things difficult to verify as it's unclear how those tags are
gonna to change.

Thanks.

-- 
tejun
