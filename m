Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYKHOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYKHOZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKHOZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:25:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:35853 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYKHOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=V2ZpQnHH0IBPPa77hGZP8CMCMvoA0pvxLqNG2rZOTB0Jfo+jWTSMrLDEajvSgI5VmS
         Z6mFDlB6IKoU3Ln8OV4Sh5SqoxFE5/zWoXRXaZcx03gkkhRAc+MjwcCkF64ig8qL7+N2
         RDKJD6G91NEUug1Mrr+fLlT1GqiItg6ymbv/Q=
Message-ID: <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
Date: Sat, 8 Nov 2008 09:25:16 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [1/1] Use pid in inotify events.
Cc: linux-kernel@vger.kernel.org, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org
In-Reply-To: <20081108114225.GA22674@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081108114225.GA22674@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=linux-api]

On Sat, Nov 8, 2008 at 6:42 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi.
>
> Attached patch puts pid into unused cookie field in inotify events.
> Cookie from move command were not changed.
>
> Having pid of the event origin is very useful for the notification
> daemons which have to differentiate 'local' and 'remote' users, i.e.
> those which have different policies. One of the examples is libionotify
> (an IO notiication library) and POHMELFS server.

Hi Evgeniy,

I've not looked closely at the patch, but a quick question.  The
ookied field is unused for _most_ events, but is used for rename
events.  Are you saying that with this patch, that the cookie will be
used as before for rename events, but for other events it will be the
PID of the triggering process?  If so, that seems a bit ugly -- why
wouldn't we also be intersted in the PID for rename events?

Cheers,

Michael

> Also fixed several whitespace issues.
>
> 1. libionotify
> http://www.ioremap.net/projects/libionotify
>
> 2. POHMELFS
> http://www.ioremap.net/projects/pohmelfs
>
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
>
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index d4b7c4a..4a10dff 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -55,7 +55,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
>
>        if (isdir)
>                isdir = IN_ISDIR;
> -       inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
> +       inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie, old_name,
>                                  source);
>        inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
>                                  source);
> @@ -79,7 +79,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
>        if (isdir)
>                isdir = IN_ISDIR;
>        dnotify_parent(dentry, DN_DELETE);
> -       inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
> +       inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir,
> +                       task_tgid_vnr(current), dentry->d_name.name);
>  }
>
>  /*
> @@ -87,7 +88,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
>  */
>  static inline void fsnotify_inoderemove(struct inode *inode)
>  {
> -       inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
> +       inotify_inode_queue_event(inode, IN_DELETE_SELF,
> +                       task_tgid_vnr(current), NULL, NULL);
>        inotify_inode_is_dead(inode);
>  }
>
> @@ -96,7 +98,8 @@ static inline void fsnotify_inoderemove(struct inode *inode)
>  */
>  static inline void fsnotify_link_count(struct inode *inode)
>  {
> -       inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
> +       inotify_inode_queue_event(inode, IN_ATTRIB,
> +                       task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -105,8 +108,8 @@ static inline void fsnotify_link_count(struct inode *inode)
>  static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
>  {
>        inode_dir_notify(inode, DN_CREATE);
> -       inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
> -                                 dentry->d_inode);
> +       inotify_inode_queue_event(inode, IN_CREATE, task_tgid_vnr(current),
> +                       dentry->d_name.name, dentry->d_inode);
>        audit_inode_child(dentry->d_name.name, dentry, inode);
>  }
>
> @@ -118,8 +121,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
>  static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
>  {
>        inode_dir_notify(dir, DN_CREATE);
> -       inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
> -                                 inode);
> +       inotify_inode_queue_event(dir, IN_CREATE, task_tgid_vnr(current),
> +                       new_dentry->d_name.name, inode);
>        fsnotify_link_count(inode);
>        audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
>  }
> @@ -130,8 +133,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
>  static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
>  {
>        inode_dir_notify(inode, DN_CREATE);
> -       inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0,
> -                                 dentry->d_name.name, dentry->d_inode);
> +       inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR,
> +               task_tgid_vnr(current), dentry->d_name.name, dentry->d_inode);
>        audit_inode_child(dentry->d_name.name, dentry, inode);
>  }
>
> @@ -147,8 +150,9 @@ static inline void fsnotify_access(struct dentry *dentry)
>                mask |= IN_ISDIR;
>
>        dnotify_parent(dentry, DN_ACCESS);
> -       inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
> -       inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +       inotify_dentry_parent_queue_event(dentry, mask,
> +                       task_tgid_vnr(current), dentry->d_name.name);
> +       inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -163,8 +167,9 @@ static inline void fsnotify_modify(struct dentry *dentry)
>                mask |= IN_ISDIR;
>
>        dnotify_parent(dentry, DN_MODIFY);
> -       inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
> -       inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +       inotify_dentry_parent_queue_event(dentry, mask,
> +                       task_tgid_vnr(current), dentry->d_name.name);
> +       inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -178,8 +183,10 @@ static inline void fsnotify_open(struct dentry *dentry)
>        if (S_ISDIR(inode->i_mode))
>                mask |= IN_ISDIR;
>
> -       inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
> -       inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +       inotify_dentry_parent_queue_event(dentry, mask,
> +               task_tgid_vnr(current), dentry->d_name.name);
> +       inotify_inode_queue_event(inode, mask,
> +               task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -196,8 +203,8 @@ static inline void fsnotify_close(struct file *file)
>        if (S_ISDIR(inode->i_mode))
>                mask |= IN_ISDIR;
>
> -       inotify_dentry_parent_queue_event(dentry, mask, 0, name);
> -       inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +       inotify_dentry_parent_queue_event(dentry, mask, task_tgid_vnr(current), name);
> +       inotify_inode_queue_event(inode, mask, task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -211,8 +218,10 @@ static inline void fsnotify_xattr(struct dentry *dentry)
>        if (S_ISDIR(inode->i_mode))
>                mask |= IN_ISDIR;
>
> -       inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
> -       inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +       inotify_dentry_parent_queue_event(dentry, mask,
> +                       task_tgid_vnr(current), dentry->d_name.name);
> +       inotify_inode_queue_event(inode, mask,
> +                       task_tgid_vnr(current), NULL, NULL);
>  }
>
>  /*
> @@ -259,9 +268,10 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
>        if (in_mask) {
>                if (S_ISDIR(inode->i_mode))
>                        in_mask |= IN_ISDIR;
> -               inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
> -               inotify_dentry_parent_queue_event(dentry, in_mask, 0,
> -                                                 dentry->d_name.name);
> +               inotify_inode_queue_event(inode, in_mask,
> +                               task_tgid_vnr(current), NULL, NULL);
> +               inotify_dentry_parent_queue_event(dentry, in_mask,
> +                               task_tgid_vnr(current), dentry->d_name.name);
>        }
>  }
>
>
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
