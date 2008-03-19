Return-Path: <linux-kernel-owner+w=401wt.eu-S937021AbYCSVYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937021AbYCSVYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYCSUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbYCSUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:05 -0400
Date: Wed, 19 Mar 2008 11:56:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] vfs: optimization to /proc/<pid>/mountinfo patch
Message-ID: <20080319115640.GL10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212738.474842471@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313212738.474842471@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:26:46PM +0100, Miklos Szeredi wrote:
> +static int prepend(char **buffer, int *buflen, const char *str,
> +			  int namelen)

inline, please.

> @@ -1911,10 +1902,9 @@ char *dentry_path(struct dentry *dentry,
>  
>  	spin_lock(&dcache_lock);
>  	prepend(&end, &buflen, "\0", 1);
> -	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
> -		if (prepend(&end, &buflen, "//deleted", 9))
> +	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
> +		(prepend(&end, &buflen, " (deleted)", 10) != 0))
>  			goto Elong;

That's a bad idea:
	* we bloody well might want to use it outside of procfs
	* //deleted is _better_; you can't have an empty path component,
but you can have a pathname ending on " (deleted)".

> +#ifdef CONFIG_PROC_FS
>  /*
>   * returns the path of the 'dentry' from the root of its filesystem.
>   */
> @@ -411,7 +412,7 @@ int seq_dentry(struct seq_file *m, struc
>  	m->count = m->size;
>  	return -1;
>  }
> -EXPORT_SYMBOL(seq_dentry);
> +#endif /* CONFIG_PROC_FS */

Same comment; you don't need procfs to use seq_file.
