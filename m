Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbZKDVty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbZKDVty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbZKDVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:49:53 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58999 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbZKDVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:49:52 -0500
Date: Wed, 4 Nov 2009 15:49:38 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
Message-ID: <20091104214938.GA21033@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-12-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-12-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> By teaching sysfs_revalidate to hide a dentry for
> a sysfs_dirent if the sysfs_dirent has been renamed,
> and by teaching sysfs_lookup to return the original
> dentry if the sysfs dirent has been renamed.  I can
> show the results of renames correctly without having to
> update the dcache during the directory rename.
> 
> This massively simplifies the rename logic allowing a lot
> of weird sysfs special cases to be removed along with
> a lot of now unnecesary helper code.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Patch looks *great*, except:

...

> @@ -315,6 +274,14 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>  	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>  		goto out_bad;
> 
> +	/* The sysfs dirent has been moved? */
> +	if (dentry->d_parent->d_fsdata != sd->s_parent)
> +		goto out_bad;
> +
> +	/* The sysfs dirent has been renamed */
> +	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
> +		goto out_bad;
> +
>  	mutex_unlock(&sysfs_mutex);
>  out_valid:
>  	return 1;
> @@ -322,6 +289,12 @@ out_bad:
>  	/* Remove the dentry from the dcache hashes.
>  	 * If this is a deleted dentry we use d_drop instead of d_delete
>  	 * so sysfs doesn't need to cope with negative dentries.
> +	 *
> +	 * If this is a dentry that has simply been renamed we
> +	 * use d_drop to remove it from the dcache lookup on its
> +	 * old parent.  If this dentry persists later when a lookup
> +	 * is performed at its new name the dentry will be readded
> +	 * to the dcache hashes.
>  	 */
>  	is_dir = (sysfs_type(sd) == SYSFS_DIR);
>  	mutex_unlock(&sysfs_mutex);

After this, if (is_dir) and (have_submounts(dentry)) then you'll
still goto out_valid and return 1.  Is that what you want?

-serge
