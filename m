Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbXAWWdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbXAWWdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXAWWdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:33:38 -0500
Received: from smtp005.mail.ukl.yahoo.com ([217.12.11.36]:47026 "HELO
	smtp005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933135AbXAWWdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:33:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Jd0a1x1LIwY7L3okIyZlQlPYjMz1qyW3Gu8fdfrF0kOgm9CAFcsYZr5ihI6PrFCco5+dkPTgWsDNtxC90tn2wvBddQis0+HYVq8JSjucxxCeI/vpIBzir63w1IsfeqPDhtpTveHaNKBY/cUJE5SgOk8SI2JajRe5U6bpIvzBFA8=  ;
X-YMail-OSG: O.3A8SsVM1ma2V16aJR9q38BBnmYxekAyKRPrpU8czls1aJwzDOVzsL3Ayff.yVBa5_rp9WhXu5bulqkReN.LZJrKbPozO9lj5GOwSWXLxUv7j.xoIOsRgiiMbMK5SIpzYEnkEjPhQV_
From: Blaisorblade <blaisorblade@yahoo.it>
To: Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [uml-devel] [PATCH] [UML] fix mknod
Date: Tue, 23 Jan 2007 23:33:29 +0100
User-Agent: KMail/1.9.5
Cc: user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@karaya.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070122201317.GA8594@linuxtv.org> <200701230902.30715.blaisorblade@yahoo.it> <20070123131730.GA9286@linuxtv.org>
In-Reply-To: <20070123131730.GA9286@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701232333.29655.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 14:17, Johannes Stezenbach wrote:
> On Tue, Jan 23, 2007 at 09:02:30AM +0100, Blaisorblade wrote:
> > On Monday 22 January 2007 21:13, Johannes Stezenbach wrote:
> > > I was playing with user-mode Linux and found that mknod creates
> > > devices node in hostfs with wrong major/minor numbers.
> > > The patch below fixes it for me.
> >
> > Hmpf. Still having this bug on hostfs is quite bad. Thanks for reporting.

I've now seen - we never fixed this one, we fixed the analogous problem 
on 'ls' output and friends (in init_inode, which is used in many places).

> > It should be hostfs_user.c to take major and minor and to combine them
> > correctly - it can use libc's macros.
>
> Right, below is a better patch.

Exactly what I meant, thanks!
I'd say:
Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
This can go to 2.6.20, and possibly even to -stable (after either me or Jeff 
tests it once).

> ---
> Fix UML hostfs mknod(): userspace has differernt
> dev_t size and encoding than kernel, so extract major/minor
> and reencode using glibc makedev() macro.
>
> Signed-off-by: Johannes Stezenbach <js@linuxtv.org>
>
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs.h
> linux-2.6.19/fs/hostfs/hostfs.h ---
> linux-2.6.19.orig/fs/hostfs/hostfs.h	2006-11-29 22:57:37.000000000 +0100
> +++ linux-2.6.19/fs/hostfs/hostfs.h	2007-01-23 14:11:03.000000000 +0100 @@
> -76,7 +76,7 @@ extern int make_symlink(const char *from
>  extern int unlink_file(const char *file);
>  extern int do_mkdir(const char *file, int mode);
>  extern int do_rmdir(const char *file);
> -extern int do_mknod(const char *file, int mode, int dev);
> +extern int do_mknod(const char *file, int mode, unsigned int major,
> unsigned int minor);
> extern int link_file(const char *from, const char 
> *to);
>  extern int do_readlink(char *file, char *buf, int size);
>  extern int rename_file(char *from, char *to);
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_kern.c
> linux-2.6.19/fs/hostfs/hostfs_kern.c ---
> linux-2.6.19.orig/fs/hostfs/hostfs_kern.c	2006-11-29 22:57:37.000000000
> +0100 +++ linux-2.6.19/fs/hostfs/hostfs_kern.c	2007-01-23
> 14:11:20.000000000 +0100 @@ -755,7 +755,7 @@ int hostfs_mknod(struct inode
> *dir, stru
>  		goto out_put;
>
>  	init_special_inode(inode, mode, dev);
> -	err = do_mknod(name, mode, dev);
> +	err = do_mknod(name, mode, MAJOR(dev), MINOR(dev));
>  	if(err)
>  		goto out_free;
>
> diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_user.c
> linux-2.6.19/fs/hostfs/hostfs_user.c ---
> linux-2.6.19.orig/fs/hostfs/hostfs_user.c	2006-11-29 22:57:37.000000000
> +0100 +++ linux-2.6.19/fs/hostfs/hostfs_user.c	2007-01-23
> 14:11:39.000000000 +0100 @@ -295,11 +295,11 @@ int do_rmdir(const char
> *file)
>  	return(0);
>  }
>
> -int do_mknod(const char *file, int mode, int dev)
> +int do_mknod(const char *file, int mode, unsigned int major, unsigned int
> minor) {
>  	int err;
>
> -	err = mknod(file, mode, dev);
> +	err = mknod(file, mode, makedev(major, minor));
>  	if(err) return(-errno);
>  	return(0);
>  }

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
