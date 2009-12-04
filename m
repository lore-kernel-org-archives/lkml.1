Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZLDHJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZLDHJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZLDHJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:09:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48248 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZLDHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:09:51 -0500
To: Eric Paris <eparis@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
In-reply-to: <20091203195917.8925.84203.stgit@paris.rdu.redhat.com> (message
	from Eric Paris on Thu, 03 Dec 2009 14:59:17 -0500)
Subject: Re: [RFC PATCH 4/6] networking: rework socket to fd mapping using
	alloc-file
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> <20091203195917.8925.84203.stgit@paris.rdu.redhat.com>
Message-Id: <E1NGSIQ-0004nz-Lo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Dec 2009 08:09:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric Paris wrote:
> @@ -391,32 +383,37 @@ static int sock_attach_fd(struct socket *sock, struct file *file, int flags)
>  	dentry->d_flags &= ~DCACHE_UNHASHED;
>  	d_instantiate(dentry, SOCK_INODE(sock));
>  
> +	file = alloc_file(sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
> +			  &socket_file_ops);
> +	if (unlikely(!file)) {
> +		rc = -ENFILE;
> +		goto out_err;
> +	}
> +
>  	sock->file = file;
> -	init_file(file, sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
> -		  &socket_file_ops);
>  	SOCK_INODE(sock)->i_fop = &socket_file_ops;
>  	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
> -	file->f_pos = 0;
>  	file->private_data = sock;
>  
> -	return 0;
> +	return fd;
> +out_err:
> +	if (fd >= 0)
> +		put_unused_fd(fd);
> +	if (dentry)
> +		dput(dentry);

Could you please use separate labels intead of conditionals here?

Thanks,
Miklos
