Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXHBN6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXHBN6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXHBN5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:57:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51700 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbXHBN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:57:53 -0400
Date: Thu, 2 Aug 2007 08:56:43 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, moriai.satoshi@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc1] eCryptfs: fix error handling in ecryptfs_init
Message-ID: <20070802135642.GH30416@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <200708021306.AA00225@paprika.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708021306.AA00225@paprika.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 10:06:19PM +0900, Ryusuke Konishi wrote:
> ecryptfs_init() exits without doing any cleanup jobs if
> ecryptfs_init_messaging() fails.  In that case, eCryptfs leaves
> sysfs entries, leaks memory, and causes an invalid page fault.
> This patch fixes the problem.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
>  fs/ecryptfs/main.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index e557a67..a984972 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -813,6 +813,15 @@ out:
>  	return rc;
>  }
> 
> +static void do_sysfs_unregistration(void)
> +{
> +	sysfs_remove_file(&ecryptfs_subsys.kobj,
> +			  &sysfs_attr_version.attr);
> +	sysfs_remove_file(&ecryptfs_subsys.kobj,
> +			  &sysfs_attr_version_str.attr);
> +	subsystem_unregister(&ecryptfs_subsys);
> +}
> +
>  static int __init ecryptfs_init(void)
>  {
>  	int rc;
> @@ -851,6 +860,9 @@ static int __init ecryptfs_init(void)
>  	if (rc) {
>  		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
>  				"initialize the eCryptfs netlink socket\n");
> +		do_sysfs_unregistration();
> +		unregister_filesystem(&ecryptfs_fs_type);
> +		ecryptfs_free_kmem_caches();
>  	}
>  out:
>  	return rc;
> @@ -858,11 +870,7 @@ out:
> 
>  static void __exit ecryptfs_exit(void)
>  {
> -	sysfs_remove_file(&ecryptfs_subsys.kobj,
> -			  &sysfs_attr_version.attr);
> -	sysfs_remove_file(&ecryptfs_subsys.kobj,
> -			  &sysfs_attr_version_str.attr);
> -	subsystem_unregister(&ecryptfs_subsys);
> +	do_sysfs_unregistration();
>  	ecryptfs_release_messaging(ecryptfs_transport);
>  	unregister_filesystem(&ecryptfs_fs_type);
>  	ecryptfs_free_kmem_caches();
