Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbYDURai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbYDURai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYDURaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:30:01 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:49340 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYDURaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kjgfx9zFI8ksXLr5Wubd6QSDur94Ug1sxKh6EWeqT9FPhJWLhhcwMDbMSa/vxZTaLP401ErBoTx5Wd56r00QSd3cUfaACR8rooqc19PGPEj31AcOKolg05bCZhbfcLn/PlfrS1ERk4wkkWx/Js1uoSlqrF01j455sbc3TNkpc7k=
Subject: Re: [PATCH] Force remount read-only of jffs2 when the garbage
	collector dies
From: Josh Boyer <jwboyer@gmail.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <831534.91220.qm@web26206.mail.ukl.yahoo.com>
References: <831534.91220.qm@web26206.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 12:29:54 -0500
Message-Id: <1208798994.6654.37.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 16:31 +0000, Michael Trimarchi wrote:
> [PATCH] Force remount read-only of jffs2 when the garbage collector
> dies
> 
> Signed-off-by: Michael Trimarchi <michael@evidence.eu.com>

Why would you do this?  The garbage collect thread is an optimization,
not a requirement.  Garbage collection will occur as-needed on behalf of
whichever process forces the requirement.

josh

> 
> ---
>  fs/jffs2/background.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
> index 8adebd3..669b35e 100644
> --- a/fs/jffs2/background.c
> +++ b/fs/jffs2/background.c
> @@ -70,6 +70,7 @@ void jffs2_stop_garbage_collect_thread(struct
> jffs2_sb_info *c)
>  static int jffs2_garbage_collect_thread(void *_c)
>  {
>         struct jffs2_sb_info *c = _c;
> +       struct super_block *sb;
>  
>         daemonize("jffs2_gcd_mtd%d", c->mtd->index);
>         allow_signal(SIGKILL);
> @@ -145,5 +146,25 @@ static int jffs2_garbage_collect_thread(void *_c)
>         spin_lock(&c->erase_completion_lock);
>         c->gc_task = NULL;
>         spin_unlock(&c->erase_completion_lock);
> +
> +       sb = c->os_priv;
> +       BUG_ON(sb == NULL);
> +
> +       /* The garbage collect is died. Try to remount the fs
> +        * read-only
> +        */
> +       down_read(&sb->s_umount);
> +       if (sb->s_root && sb->s_mtd && !(sb->s_flags & MS_RDONLY)) {
> +               /*
> +                * ->remount_fs needs lock_kernel().
> +                *
> +                * What lock protects sb->s_flags??
> +                */
> +               lock_kernel();
> +               do_remount_sb(sb, MS_RDONLY, NULL, 1);
> +               unlock_kernel();
> +       }
> +       drop_super(sb);
> +
>         complete_and_exit(&c->gc_thread_exit, 0);
>  }
> -- 
> 1.5.3.6
> 
> 

