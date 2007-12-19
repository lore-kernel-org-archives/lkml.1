Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbXLSSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbXLSSXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXLSSXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:23:10 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36108 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752348AbXLSSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:23:09 -0500
X-YMail-OSG: kiWjCOUVM1m5YdZFnqEtL28yo9y0pvfjsBvhFe1NILNvh6Z2mXzCniMwt4cg6FF2PIdvRU6d7Q--
Date: Wed, 19 Dec 2007 12:14:17 -0600
From: Michael Halcrow <mike@halcrow.us>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ecryptfs: redo dget,mntget on dentry_open failure
Message-ID: <20071219181417.GP13486@halcrow.us>
Reply-To: Michael Halcrow <mike@halcrow.us>
References: <47695621.6040709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47695621.6040709@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:34:25AM -0600, Eric Sandeen wrote:
> Thanks to Jeff Moyer for pointing this out.
> 
> If the RDWR dentry_open() in ecryptfs_init_persistent_file fails,
> it will do a dput/mntput.  Need to re-take references if we
> retry as RDONLY.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>

> ---
> 
> Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/main.c
> @@ -138,11 +138,14 @@ int ecryptfs_init_persistent_file(struct
>  		inode_info->lower_file = dentry_open(lower_dentry,
>  						     lower_mnt,
>  						     (O_RDWR | O_LARGEFILE));
> -		if (IS_ERR(inode_info->lower_file))
> +		if (IS_ERR(inode_info->lower_file)) {
> +			dget(lower_dentry);
> +			mntget(lower_mnt);
>  			inode_info->lower_file = dentry_open(lower_dentry,
>  							     lower_mnt,
>  							     (O_RDONLY
>  							      | O_LARGEFILE));
> +		}
>  		if (IS_ERR(inode_info->lower_file)) {
>  			printk(KERN_ERR "Error opening lower persistent file "
>  			       "for lower_dentry [0x%p] and lower_mnt [0x%p]\n",
> 
