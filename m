Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZHJOM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZHJOM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZHJOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:12:55 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:42749 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZHJOMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <20090809215941.26204.52486.stgit@paris.rdu.redhat.com>
References: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
	 <20090809215941.26204.52486.stgit@paris.rdu.redhat.com>
Date: Mon, 10 Aug 2009 10:12:55 -0400
Message-ID: <7e0fb38c0908100712h4dbd6c98y3807af36824ade41@mail.gmail.com>
Subject: Re: [PATCH 2/5] inotify: use ZERO_PAGE instead of private static 
	declaration
From: Eric Paris <eparis@parisplace.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 9, 2009 at 5:59 PM, Eric Paris<eparis@redhat.com> wrote:
> inotify needs to pad filenames to an inotify event length.  Currently this
> is done by copying 0s from an event declared globally.  This patch doesn't
> waste global address space just to have some 0s and instead uses
> clear_user()
>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Crap, the subject of this message is wrong.  I'll fix the subject when
I commit, the summary and patch are correct.

-Eric

> ---
>
>  fs/notify/inotify/inotify_user.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index c17d5a3..c3086b0 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -47,9 +47,6 @@
>
>  static struct vfsmount *inotify_mnt __read_mostly;
>
> -/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
> -static struct inotify_event nul_inotify_event;
> -
>  /* these are configurable via /proc/sys/fs/inotify/ */
>  static int inotify_max_user_instances __read_mostly;
>  static int inotify_max_queued_events __read_mostly;
> @@ -215,7 +212,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>        /*
>         * fsnotify only stores the pathname, so here we have to send the pathname
>         * and then pad that pathname out to a multiple of sizeof(inotify_event)
> -        * with zeros.  I get my zeros from the nul_inotify_event.
> +        * with zeros.
>         */
>        if (name_len) {
>                unsigned int len_to_zero = name_len - event->name_len;
> @@ -224,8 +221,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>                        return -EFAULT;
>                buf += event->name_len;
>
> -               /* fill userspace with 0's from nul_inotify_event */
> -               if (copy_to_user(buf, &nul_inotify_event, len_to_zero))
> +               /* fill userspace with 0's */
> +               if (clear_user(buf, len_to_zero))
>                        return -EFAULT;
>                buf += len_to_zero;
>                event_size += name_len;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
