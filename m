Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZBWINN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZBWINN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZBWIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:12:57 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZBWIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:12:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kia3K3Par4jGiYbYxvEb/RudYX7Z49st+6PPfEu1SOSJ9jVA1ITAABLeyXFW7ku/2
	VB7fi7FCw117veVI5+vpQ==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net>
Date: Mon, 23 Feb 2009 00:12:51 -0800
Message-ID: <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in 
	kernel/cgroup.c
From: Paul Menage <menage@google.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 2:05 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> Here's a small patch for kernel/cgroup.c
>
> Removes a few pointless tests of pointer == 0 before kfree() in
> kernel/cgroup.c.
> If the pointer we hand to kfree() is 0, then kfree() is a noop, so there
> is no need to test.
>
> Reduces object file size a bit :
>
> Before:
> $ size kernel/cgroup.o
>   text    data     bss     dec     hex filename
>  21593    7804    4924   34321    8611 kernel/cgroup.o
> After:
> $ size kernel/cgroup.o
>   text    data     bss     dec     hex filename
>  21537    7744    4924   34205    859d kernel/cgroup.o

Thanks. I'm a bit surprised that it also shrunk the data segment size
(and in fact, by more than the text segment size). Any idea how that
came about?

>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Paul Menage <menage@google.com>

Paul

> ---
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 9edb5c4..1c0a9b5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -865,8 +865,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>        if (opts.release_agent)
>                strcpy(root->release_agent_path, opts.release_agent);
>  out_unlock:
> -       if (opts.release_agent)
> -               kfree(opts.release_agent);
> +       kfree(opts.release_agent);
>        mutex_unlock(&cgroup_mutex);
>        mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
>        return ret;
> @@ -969,15 +968,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>        /* First find the desired set of subsystems */
>        ret = parse_cgroupfs_options(data, &opts);
>        if (ret) {
> -               if (opts.release_agent)
> -                       kfree(opts.release_agent);
> +               kfree(opts.release_agent);
>                return ret;
>        }
>
>        root = kzalloc(sizeof(*root), GFP_KERNEL);
>        if (!root) {
> -               if (opts.release_agent)
> -                       kfree(opts.release_agent);
> +               kfree(opts.release_agent);
>                return -ENOMEM;
>        }
>
>
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>
>
