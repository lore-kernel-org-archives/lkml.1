Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZBDXui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZBDXui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759056AbZBDXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:49:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45302 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025AbZBDXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:49:07 -0500
Date: Wed, 4 Feb 2009 17:49:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       sukadev@us.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 1/5] Unroll essentials of do_remount_sb() into
	devpts
Message-ID: <20090204234905.GB17354@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043640.GA26202@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043640.GA26202@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Tue, 27 Jan 2009 22:58:18 -0800
> Subject: [v2][PATCH 1/5] Unroll essentials of do_remount_sb() into devpts
> 
> On remount, devpts fs only needs to parse the mount options. Users cannot
> directly create/dirty files in /dev/pts so the MS_RDONLY flag and
> shrinking the dcache does not really apply to devpts.
> 
> So effectively on remount, devpts only parses the mount options and updates
> these options in its super block. As such, we could replace do_remount_sb()
> call with a direct parse_mount_options().
> 
> Doing so enables subsequent patches to avoid parsing the mount options twice
> and simplify the code.

You've dropped the update_ptmx_mode() which you used to do
inside devpts_remount().  Is that also on purpose?

> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  fs/devpts/inode.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index ad186b4..de15e73 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -442,6 +442,8 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
>  		void *data, struct vfsmount *mnt)
>  {
>  	struct super_block *s;
> +	struct pts_mount_opts *opts;
> +	struct pts_fs_info *fsi;
>  	int error;
> 
>  	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
> @@ -458,7 +460,10 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
>  		}
>  		s->s_flags |= MS_ACTIVE;
>  	}
> -	do_remount_sb(s, flags, data, 0);
> +	fsi = DEVPTS_SB(s);
> +	opts = &fsi->mount_opts;
> +	parse_mount_options(data, PARSE_REMOUNT, opts);
> +
>  	simple_set_mnt(mnt, s);
>  	return 0;
>  }
> -- 
> 1.5.2.5
