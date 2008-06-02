Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYFBPxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYFBPxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYFBPxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:53:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44694 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYFBPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:53:03 -0400
Date: Mon, 2 Jun 2008 17:53:01 +0200
From: Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Message-ID: <20080602155301.GG6746@atrey.karlin.mff.cuni.cz>
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com> <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 2, 2008 at 8:31 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > Hi,
> >
> > 2.6.26-rc4 seems to exhibit the following (new since at least 2.6.24)
> > warning when running find /proc/1:
> >
> > find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> > in your filesystem driver.  Automatically turning on find's -noleaf
> > option.  Earlier results may have failed to include directories that
> > should have been searched.
> 
> My prime suspect is
> 
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
> 
>     [NET]: Make /proc/net a symlink on /proc/self/net (v3)
> 
> 
> as this patch introduces a new directory entry without bumping the nlink count.
> 
> Will this do? (Untested)
> 
> Vegard
> 
> 
> >From a43ef05a8c1f8d45ca88e00fdd31c00ddfdba1b8 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 2 Jun 2008 08:57:45 +0200
> Subject: [PATCH] proc: fix /proc/<pid> link count
> 
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
> 
>     [NET]: Make /proc/net a symlink on /proc/self/net (v3)
> 
> introduced /proc/net without bumping the link count on /proc/self.
  Looks fine to me :).

								Honza
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  fs/proc/base.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c447e07..10ee4a2 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2589,6 +2589,9 @@ static struct dentry
> *proc_pid_instantiate(struct inode *dir,
>  #ifdef CONFIG_SECURITY
>  	inode->i_nlink += 1;
>  #endif
> +#ifdef CONFIG_NET
> +	inode->i_nlink += 1;
> +#endif
> 
>  	dentry->d_op = &pid_dentry_operations;
> 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
