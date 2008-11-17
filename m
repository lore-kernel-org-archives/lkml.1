Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYKQQ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYKQQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYKQQ7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:59:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:15563 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYKQQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=jL3ygo0JC2Zp2LWJnQ6XY5istJewfDuvxPO1Hi4VWuYpbMTkHreL9JS06x6nwIufKj
         om5wHRTgi4JN5bXSZhTuF5Z/2vbKOlrziDg/ulbVkIVwTpp8fcayXupcq9j70yOxlmUm
         nulYUBNsiedKDg7gbPYfU+15DLbx1jzCbR+3Q=
Message-ID: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
Date: Mon, 17 Nov 2008 11:59:11 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Robert Love" <rlove@rlove.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20081116232450.GA13547@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Sun, Nov 16, 2008 at 6:24 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi.
>
> This patch allows to send IO origin PID in inotify events (using cookie
> fields for all events except moving, where it is already used to track
> move from and move to parts) when its uid matches inotify owner uid or
> when inotify owner has admin (CAP_SYS_ADMIN) capabilities (Jeff
> Schroeder's idea).
>
> This is a resend of the previous patch, which was not commented by
> anyone. Does it mean no one objects? If so, please apply.

NAK.  If we are going to do this -- and I leave the security
discussions to others more knowlegeable on that score than me -- then
the API design should be better than this.  The current design is a
hack.  Why exclude rename events?  Why re-use the cookie field?  The
only answers I can guess at are that the current patch is less work to
write.  IMO, there are (much) better design possibilities, using
inotify1(), as I suggested earlier in this thread.

Thanks,

Michael

> Also removed John McCutchan's email, which bounces.
>
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
>
> diff --git a/fs/inotify.c b/fs/inotify.c
> index 690e725..835259d 100644
> --- a/fs/inotify.c
> +++ b/fs/inotify.c
> @@ -69,6 +69,9 @@ static atomic_t inotify_cookie;
>  * inotify_add_watch() to the final put_inotify_watch().
>  */
>
> +#define IH_FLAGS_ADMIN         (0x00000001)
> +/* handler owner has admin capabilities */
> +
>  /*
>  * struct inotify_handle - represents an inotify instance
>  *
> @@ -80,6 +83,8 @@ struct inotify_handle {
>        struct list_head        watches;        /* list of watches */
>        atomic_t                count;          /* reference count */
>        u32                     last_wd;        /* the last wd allocated */
> +       uid_t                   uid;            /* owner's uid */
> +       u32                     flags;          /* operation flags */
>        const struct inotify_operations *in_ops; /* inotify caller operations */
>  };
>
> @@ -292,6 +297,11 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
>                        mutex_lock(&ih->mutex);
>                        if (watch_mask & IN_ONESHOT)
>                                remove_watch_no_event(watch, ih);
> +
> +                       if (!cookie && ((ih->flags & IH_FLAGS_ADMIN) ||
> +                                       (current->uid == ih->uid)))
> +                               cookie = task_tgid_vnr(current);
> +
>                        ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
>                                                 name, n_inode);
>                        mutex_unlock(&ih->mutex);
> @@ -459,6 +469,10 @@ struct inotify_handle *inotify_init(const struct inotify_operations *ops)
>        mutex_init(&ih->mutex);
>        ih->last_wd = 0;
>        ih->in_ops = ops;
> +       ih->uid = current->user->uid;
> +       ih->flags = 0;
> +       if (capable(CAP_SYS_ADMIN))
> +               ih->flags |= IH_FLAGS_ADMIN;
>        atomic_set(&ih->count, 0);
>        get_inotify_handle(ih);
>
> --
>        Evgeniy Polyakov
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
