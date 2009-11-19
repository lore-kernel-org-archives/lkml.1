Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZKSRHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZKSRHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZKSRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:07:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56883 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZKSRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:07:15 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal" symlinks
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 09:07:16 -0800
In-Reply-To: <1258638251-20034-1-git-send-email-jlayton@redhat.com> (Jeff Layton's message of "Thu\, 19 Nov 2009 08\:44\:11 -0500")
Message-ID: <m14ooq5tq3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This is broken.  If the referenced file is in a different mount namespace
the path returned could point to a completely different path in your
own mount namespace.  Even in your own mount namespace this makes the
proc symlinks racy and not guaranteed to return the file of interest.

I don't see any hope of this approach ever working.

Eric


Jeff Layton <jlayton@redhat.com> writes:

> -static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)
> -{
> -	int error = -EACCES;
> -	struct inode *inode = dentry->d_inode;
> +	struct page *page = NULL;
>  	struct path path;
> +	int error;
>  
>  	/* Are we allowed to snoop on the tasks file descriptors? */
> -	if (!proc_fd_access_allowed(inode))
> +	if (!proc_fd_access_allowed(inode)) {
> +		pathname = ERR_PTR(-EACCES);
>  		goto out;
> +	}
>  
>  	error = PROC_I(inode)->op.proc_get_link(inode, &path);
> -	if (error)
> +	if (error) {
> +		pathname = ERR_PTR(error);
>  		goto out;
> +	}
> +
> +	page = alloc_page(GFP_HIGHUSER);
> +	if (!page) {
> +		pathname = ERR_PTR(-ENOMEM);
> +		goto out_path_put;
> +	}
> +
> +	pathname = kmap(page);
> +	pathname = d_path(&path, pathname, PAGE_SIZE);

This is just nonsense.


> +	if (IS_ERR(pathname)) {
> +		kunmap(page);
> +		__free_page(page);
> +		page = NULL;
> +	}
>  
> -	error = do_proc_readlink(&path, buffer, buflen);
> +out_path_put:
>  	path_put(&path);
>  out:
> -	return error;
> +	nd_set_link(nd, pathname);
> +	return page;
> +}
