Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZIUIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZIUIKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZIUIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:10:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56142 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZIUIKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:10:53 -0400
Date: Mon, 21 Sep 2009 09:10:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] VFS: document what MAY_ACCESS means
Message-ID: <20090921081047.GA20006@shareable.org>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> The vfs MAY_ACCESS flag really means that we might not use the object
> immediately (consider chdir which might not actually use the new dir).
> Thus permissions must be checked rather than relying on checkes during
> later access of the object in question.  This patch just adds some
> documentation so the meaning of the flag is clear.  I would rename the flag,
> but it's already visable (although useless) to userspace.

As it's intended to clarify the meaning, I must admit that I didn't
find the comment clear at all!  I had to grep the code for MAY_ACCESS
to understand what your comment meant.

Especially what was meant by "chdir which might not actually use the
new dir".

Suggest: MAY_ACCESS means we are calling from access() or chdir() and
won't do the actual read/write/exec/appene/open, so ->permission()
must fully check the permission and not assume it can optimise away checks.

(Btw, side issue: I was very surprised to find fchdir() to an open
directory can fail on NFS due to change of permissions, so the pattern
dir = open("."); chdir("foo"); fchdir(dir) can fail to restore the
current directory).

-- Jamie


> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  include/linux/fs.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 215b708..f683b29 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -51,6 +51,13 @@ struct inodes_stat_t {
>  #define MAY_WRITE 2
>  #define MAY_READ 4
>  #define MAY_APPEND 8
> +/*
> + * The vfs MAY_ACCESS flag really means that we might not use the object
> + * immediately (consider chdir which might not actually use the new dir).
> + * Thus permissions must be checked mmediately rather than relying on later
> + * checks during the actual user of the object in question.  This is an
> + * internal flag and should not come from userspace.
> + */
>  #define MAY_ACCESS 16
>  #define MAY_OPEN 32
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
