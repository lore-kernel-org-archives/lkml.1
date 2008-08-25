Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYHYBou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYHYBou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 21:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYHYBok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 21:44:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYHYBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 21:44:39 -0400
Date: Mon, 25 Aug 2008 02:44:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080825014436.GT28946@ZenIV.linux.org.uk>
References: <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org> <20080824195908.GQ28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808241644330.3363@nehalem.linux-foundation.org> <20080825013316.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825013316.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PS: the part below was on top of patch from dwmw2; in the mainline the analog
of that sucker is in XFS.

> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 8291591..77ad3a5 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1832,6 +1832,7 @@ struct buffered_dirent {
>  struct readdir_data {
>  	char		*dirent;
>  	size_t		used;
> +	int		full;
>  };
>  
>  static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
> @@ -1842,8 +1843,10 @@ static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
>  	unsigned int reclen;
>  
>  	reclen = ALIGN(sizeof(struct buffered_dirent) + namlen, sizeof(u64));
> -	if (buf->used + reclen > PAGE_SIZE)
> +	if (buf->used + reclen > PAGE_SIZE) {
> +		buf->full = 1;
>  		return -EINVAL;
> +	}
>  
>  	de->namlen = namlen;
>  	de->offset = offset;
> @@ -1875,9 +1878,13 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
>  		unsigned int reclen;
>  
>  		buf.used = 0;
> +		buf.full = 0;
>  
>  		host_err = vfs_readdir(file, nfsd_buffered_filldir, &buf);
> -		if (host_err)
> +		if (buf.full)
> +			host_err = 0;
> +
> +		if (host_err < 0)
>  			break;
>  
>  		size = buf.used;
