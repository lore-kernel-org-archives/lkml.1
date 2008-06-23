Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbYFWU1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbYFWU1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYFWU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:27:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57297 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYFWU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:27:40 -0400
Date: Mon, 23 Jun 2008 16:27:35 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] don't export linux/nfsd/stats.h to userspace
Message-ID: <20080623202735.GA28784@fieldses.org>
References: <20080623174854.GI4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174854.GI4756@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:48:54PM +0300, Adrian Bunk wrote:
> The main contents is struct nfsd_stats which changes depending on a 
> CONFIG_ variable.
> 
> This would not work in userspace.

Makes sense, but could we just get this out of include/linux entirely,
and into fs/nfsd/?

	$ git grep -l '^#include <linux/nfsd/stats.h>'
	fs/nfsd/nfssvc.c
	fs/nfsd/stats.c
	include/linux/nfsd/nfsd.h

So the only user outside of fs/nfsd/ is nfsd.h.  I doubt it really needs
it.  And nfsd.h is included a lot of places it needn't be too:

	$ git grep -l '^#include <linux/nfsd/nfsd.h>'
	arch/parisc/kernel/sys_parisc32.c
	arch/s390/kernel/compat_linux.c
	arch/s390/kernel/compat_linux.h
	arch/sparc64/kernel/sys_sparc32.c

Those includes are unnecessary.

	fs/compat.c

That too, I think.

	fs/lockd/svc4proc.c
	fs/lockd/svcproc.c

Those might need it (though they shouldn't also need stats.h).  Etc.

	fs/nfsctl.c
	fs/nfsd/auth.c
	fs/nfsd/export.c
	fs/nfsd/lockd.c
	fs/nfsd/nfs2acl.c
	fs/nfsd/nfs3acl.c
	fs/nfsd/nfs3proc.c
	fs/nfsd/nfs3xdr.c
	fs/nfsd/nfs4callback.c
	fs/nfsd/nfs4proc.c
	fs/nfsd/nfs4recover.c
	fs/nfsd/nfs4state.c
	fs/nfsd/nfs4xdr.c
	fs/nfsd/nfscache.c
	fs/nfsd/nfsctl.c
	fs/nfsd/nfsfh.c
	fs/nfsd/nfsproc.c
	fs/nfsd/nfssvc.c
	fs/nfsd/nfsxdr.c
	fs/nfsd/stats.c
	fs/nfsd/vfs.c

--b.

> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  include/linux/nfsd/Kbuild  |    1 -
>  include/linux/nfsd/stats.h |    3 ---
>  2 files changed, 4 deletions(-)
> 
> 9b6014db4d4182cf4cb342b97f9018c5d1090afa diff --git a/include/linux/nfsd/Kbuild b/include/linux/nfsd/Kbuild
> index fc97204..698e9ec 100644
> --- a/include/linux/nfsd/Kbuild
> +++ b/include/linux/nfsd/Kbuild
> @@ -2,5 +2,4 @@ unifdef-y += const.h
>  unifdef-y += debug.h
>  unifdef-y += export.h
>  unifdef-y += nfsfh.h
> -unifdef-y += stats.h
>  unifdef-y += syscall.h
> diff --git a/include/linux/nfsd/stats.h b/include/linux/nfsd/stats.h
> index 7678cfb..d949590 100644
> --- a/include/linux/nfsd/stats.h
> +++ b/include/linux/nfsd/stats.h
> @@ -38,13 +38,10 @@ struct nfsd_stats {
>  /* thread usage wraps very million seconds (approx one fortnight) */
>  #define	NFSD_USAGE_WRAP	(HZ*1000000)
>  
> -#ifdef __KERNEL__
> -
>  extern struct nfsd_stats	nfsdstats;
>  extern struct svc_stat		nfsd_svcstats;
>  
>  void	nfsd_stat_init(void);
>  void	nfsd_stat_shutdown(void);
>  
> -#endif /* __KERNEL__ */
>  #endif /* LINUX_NFSD_STATS_H */
> 
