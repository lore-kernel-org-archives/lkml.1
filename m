Return-Path: <linux-kernel-owner+w=401wt.eu-S1764628AbZLQM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764628AbZLQM5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764315AbZLQM5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:57:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764286AbZLQM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:57:09 -0500
Subject: Re: linux-next: fsnotify tree build failure
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20091217144506.d73902de.sfr@canb.auug.org.au>
References: <20091217144506.d73902de.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 07:57:03 -0500
Message-Id: <1261054623.2788.146.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 14:45 +1100, Stephen Rothwell wrote:
> Hi Eric,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> fs/notify/fanotify/fanotify_user.c: In function 'create_fd':
> fs/notify/fanotify/fanotify_user.c:76: error: 'IMA_COUNT_UPDATE' undeclared (first use in this function)
> fs/notify/fanotify/fanotify_user.c:76: error: too many arguments to function 'ima_path_check'
> 
> Caused by commit df8f58f5e75be6fa3fb7e5bd55f3ab5b8970b16b ("fanotify:
> send events using read") from the fsnotify tree interacting with commit
> 1429b3eca23818f87f9fa569a15d9816de81f698 ("Untangling ima mess, part 3:
> kill dead code in ima") from Linus' tree.
> 
> I applied the following merge fix (I *think* it is correct but may easily
> require something more - Al?) for today (and can carry it for a while):

Actually it requires less!  All of the IMA stuff needs to be dropped in
light of my/Al's IMA rework.  I'll take care of it today.

-Eric

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 17 Dec 2009 14:40:11 +1100
> Subject: [PATCH] fsnotify: fixup for ima_path_check API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/notify/fanotify/fanotify_user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 98c5c44..da79856 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -73,7 +73,7 @@ static int create_fd(struct fsnotify_group *group, struct fsnotify_event *event)
>  	/* it's possible this event was an overflow event.  in that case dentry and mnt
>  	 * are NULL;  That's fine, just don't call dentry open */
>  	if (dentry && mnt) {
> -		err = ima_path_check(&event->path, MAY_READ, IMA_COUNT_UPDATE);
> +		err = ima_path_check(&event->path, MAY_READ);
>  		if (err)
>  			new_file = ERR_PTR(err);
>  		else
> -- 
> 1.6.5.4
> 


