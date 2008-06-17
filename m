Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYFQRoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYFQRoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYFQRoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:44:04 -0400
Received: from tamago.serverit.net ([91.189.209.155]:52620 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752999AbYFQRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:44:01 -0400
X-Greylist: delayed 2679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 13:44:01 EDT
Date: Tue, 17 Jun 2008 19:59:15 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Miklos Szeredi <miklos@szeredi.hu>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ywang221@hotmail.com
Subject: Re: [2.6.26 patch] fuse: fix thinko in max I/O size calucation
In-Reply-To: <E1K8dgi-0005sl-El@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.62.0806171950350.23306@tamago.serverit.net>
References: <E1K8dgi-0005sl-El@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Jun 2008, Miklos Szeredi wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Use max not min to enforce a lower limit on the max I/O size.

Big write is ok now, thanks. NTFS-3G in-memory write performance seems to 
be 6x better on a T9300 and quick tests seem to show that it's at least as 
fast as ext3 in-memory writes (but this needs more testing, etc).

However the max write size seems to be limited to 128kB. Is this 
intentional? If yes then

Acked-by: Szabolcs Szakacsits <szaka@ntfs-3g.org>

	Szaka

> This bug was introduced by
> 
>    commit e5d9a0df07484d6d191756878c974e4307fb24ce
>    Author: Miklos Szeredi <mszeredi@suse.cz>
>    Date:   Wed Apr 30 00:54:44 2008 -0700
>    
>        fuse: fix max i/o size calculation
> 
> Thanks to Brian Wang for noticing.
> 
> Reported-by: Brian Wang <ywang221@hotmail.com>
> CC: Szabolcs Szakacsits <szaka@ntfs-3g.org>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/fuse/inode.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/fs/fuse/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/fuse/inode.c	2008-06-17 17:55:38.000000000 +0200
> +++ linux-2.6/fs/fuse/inode.c	2008-06-17 17:55:48.000000000 +0200
> @@ -591,7 +591,7 @@ static void process_init_reply(struct fu
>  		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
>  		fc->minor = arg->minor;
>  		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
> -		fc->max_write = min_t(unsigned, 4096, fc->max_write);
> +		fc->max_write = max_t(unsigned, 4096, fc->max_write);
>  		fc->conn_init = 1;
>  	}
>  	fuse_put_request(fc, req);
> @@ -667,7 +667,7 @@ static int fuse_fill_super(struct super_
>  	fc->flags = d.flags;
>  	fc->user_id = d.user_id;
>  	fc->group_id = d.group_id;
> -	fc->max_read = min_t(unsigned, 4096, d.max_read);
> +	fc->max_read = max_t(unsigned, 4096, d.max_read);
>  
>  	/* Used by get_root_inode() */
>  	sb->s_fs_info = fc;
> 

--
NTFS-3G:  http://ntfs-3g.org

