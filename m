Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXLaWDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXLaWDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXLaWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:03:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:42853 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbXLaWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:03:24 -0500
Date: Mon, 31 Dec 2007 14:03:04 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] configfs: dir.c fix possible recursive locking
Message-ID: <20071231220304.GA28151@mail.oracle.com>
Mail-Followup-To: Joonwoo Park <joonwpark81@gmail.com>,
	linux-kernel@vger.kernel.org
References: <003101c8476c$cd9a9840$47e7a8c0@jason>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003101c8476c$cd9a9840$47e7a8c0@jason>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 12:09:57PM +0900, Joonwoo Park wrote:
> configfs_register_subsystem() with default_groups triggers recursive locking.
> it seems that mutex_lock_nested is needed.

	Thanks for the work, I've added these to my tree.

Joel

> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.24-rc6 #141
> ---------------------------------------------
> swapper/1 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca76f>] configfs_attach_group+0x4f/0x190
> 
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca9d5>] configfs_register_subsystem+0x55/0x130
> 
> other info that might help us debug this:
> 1 lock held by swapper/1:
>  #0:  (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca9d5>] configfs_register_subsystem+0x55/0x130
> 
> stack backtrace:
> Pid: 1, comm: swapper Not tainted 2.6.24-rc6 #141
>  [<c40053ba>] show_trace_log_lvl+0x1a/0x30
>  [<c4005e82>] show_trace+0x12/0x20
>  [<c400687e>] dump_stack+0x6e/0x80
>  [<c404ec72>] __lock_acquire+0xe62/0x1120
>  [<c404efb2>] lock_acquire+0x82/0xa0
>  [<c43fdad8>] mutex_lock_nested+0x98/0x2e0
>  [<c40ca76f>] configfs_attach_group+0x4f/0x190
>  [<c40caa46>] configfs_register_subsystem+0xc6/0x130
>  [<c45c8186>] init_netconsole+0x2b6/0x300
>  [<c45a75f2>] kernel_init+0x142/0x320
>  [<c4004fb3>] kernel_thread_helper+0x7/0x14
>  =======================
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> ---
>  fs/configfs/dir.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 50ed691..a48dc7d 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -546,7 +546,7 @@ static int populate_groups(struct config_group *group)
>  		 * That said, taking our i_mutex is closer to mkdir
>  		 * emulation, and shouldn't hurt.
>  		 */
> -		mutex_lock(&dentry->d_inode->i_mutex);
> +		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
>  
>  		for (i = 0; group->default_groups[i]; i++) {
>  			new_group = group->default_groups[i];
> @@ -1405,7 +1405,8 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
>  	sd = configfs_sb->s_root->d_fsdata;
>  	link_group(to_config_group(sd->s_element), group);
>  
> -	mutex_lock(&configfs_sb->s_root->d_inode->i_mutex);
> +	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
> +			I_MUTEX_PARENT);
>  
>  	name.name = group->cg_item.ci_name;
>  	name.len = strlen(name.name);
> ---
> 
> Thanks.
> Joonwoo
> 

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
