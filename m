Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXAWICq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXAWICq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbXAWICp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:02:45 -0500
Received: from smtp007.mail.ukl.yahoo.com ([217.12.11.96]:24485 "HELO
	smtp007.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932895AbXAWICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:02:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WEYbIiNncJLF1kODut0BoZGoEpEjt9kvS4qyslkpwBdtaXnGmLYbdmrsAe/O+8XkYDLKPe12d0jTYbR5/a29s3JaPagt9dOQ41xWpGW0/TYvM//L9zCTIXqY2ZPatQ3SmKMiIrNZsLF5vYvnqtXBhG31ggge1OgVLcO0yxZu90A=  ;
X-YMail-OSG: BtzK8C4VM1mYfMDkjg1VzuI0VC0P0gLFXCmv7Zpj2ADmc0QqlWhIS79v_jW7EOest8OKEJOhBJ2yUKuPM9a0n88KIlTomb99pRbJKQeBcibw3EFP9lWhzwZqF2zINjc.8WcAqEqxEPpW
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] [UML] fix mknod
Date: Tue, 23 Jan 2007 09:02:30 +0100
User-Agent: KMail/1.9.5
Cc: Johannes Stezenbach <js@linuxtv.org>, Jeff Dike <jdike@karaya.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070122201317.GA8594@linuxtv.org>
In-Reply-To: <20070122201317.GA8594@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701230902.30715.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 January 2007 21:13, Johannes Stezenbach wrote:
> Hi,
>
> I was playing with user-mode Linux and found that mknod creates
> devices node in hostfs with wrong major/minor numbers.
> The patch below fixes it for me.
>
> Johannes

Hmpf. Still having this bug on hostfs is quite bad. Thanks for reporting.

It should be hostfs_user.c to take major and minor and to combine them 
correctly - it can use libc's macros.

> Signed-off-by: Johannes Stezenbach <js@linuxtv.org>
>
>
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs.h
> linux-2.6.19/fs/hostfs/hostfs.h ---
> linux-2.6.19.orig/fs/hostfs/hostfs.h	2006-11-29 22:57:37.000000000 +0100
> +++ linux-2.6.19/fs/hostfs/hostfs.h	2007-01-22 20:53:23.000000000 +0100 @@
> -76,7 +76,17 @@ extern int make_symlink(const char *from
>  extern int unlink_file(const char *file);
>  extern int do_mkdir(const char *file, int mode);
>  extern int do_rmdir(const char *file);
> -extern int do_mknod(const char *file, int mode, int dev);
> +
> +/* gnu_dev_makedev from glibc's sys/sysmacros.h */
> +static inline unsigned long long makedev(unsigned int major, unsigned int
> minor) +{
> +	return ((minor & 0xff) | ((major & 0xfff) << 8)
> +		| (((unsigned long long int) (minor & ~0xff)) << 12)
> +		| (((unsigned long long int) (major & ~0xfff)) << 32));
> +
> +}
> +
> +extern int do_mknod(const char *file, int mode, unsigned long long dev);
>  extern int link_file(const char *from, const char *to);
>  extern int do_readlink(char *file, char *buf, int size);
>  extern int rename_file(char *from, char *to);
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_kern.c
> linux-2.6.19/fs/hostfs/hostfs_kern.c ---
> linux-2.6.19.orig/fs/hostfs/hostfs_kern.c	2006-11-29 22:57:37.000000000
> +0100 +++ linux-2.6.19/fs/hostfs/hostfs_kern.c	2007-01-22
> 20:57:58.000000000 +0100 @@ -740,6 +740,7 @@ int hostfs_mknod(struct inode
> *dir, stru
>  	struct inode *inode;
>  	char *name;
>  	int err = -ENOMEM;
> +	unsigned long long udev;
>
>  	inode = iget(dir->i_sb, 0);
>  	if(inode == NULL)
> @@ -755,7 +756,9 @@ int hostfs_mknod(struct inode *dir, stru
>  		goto out_put;
>
>  	init_special_inode(inode, mode, dev);
> -	err = do_mknod(name, mode, dev);
> +	/* userspace has different dev_t encoding than kernel... */
> +	udev = makedev(MAJOR(dev), MINOR(dev));
> +	err = do_mknod(name, mode, udev);
>  	if(err)
>  		goto out_free;
>
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_user.c
> linux-2.6.19/fs/hostfs/hostfs_user.c ---
> linux-2.6.19.orig/fs/hostfs/hostfs_user.c	2006-11-29 22:57:37.000000000
> +0100 +++ linux-2.6.19/fs/hostfs/hostfs_user.c	2007-01-22
> 20:54:37.000000000 +0100 @@ -295,7 +295,7 @@ int do_rmdir(const char *file)
>  	return(0);
>  }
>
> -int do_mknod(const char *file, int mode, int dev)
> +int do_mknod(const char *file, int mode, unsigned long long dev)
>  {
>  	int err;
>
>
> -------------------------------------------------------------------------
> Take Surveys. Earn Cash. Influence the Future of IT
> Join SourceForge.net's Techsay panel and you'll get the chance to share
> your opinions on IT & business topics through brief surveys - and earn cash
> http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
