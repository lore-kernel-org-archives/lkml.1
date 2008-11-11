Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYKKQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYKKQpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYKKQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:45:35 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59055 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYKKQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:45:33 -0500
Date: Tue, 11 Nov 2008 10:45:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 05/13] Dump memory address space
Message-ID: <20081111164517.GA15999@us.ibm.com>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> +/**
> + * cr_fill_fname - return pathname of a given file
> + * @path: path name
> + * @root: relative root
> + * @buf: buffer for pathname
> + * @n: buffer length (in) and pathname length (out)
> + */
> +static char *
> +cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
> +{
> +	struct path tmp = *root;
> +	char *fname;
> +
> +	BUG_ON(!buf);
> +	fname = __d_path(path, &tmp, buf, *n);
> +	if (!IS_ERR(fname))
> +		*n = (buf + (*n) - fname);
> +	/*
> +	 * FIXME: if __d_path() changed these, it must have stepped out of
> +	 * init's namespace. Since currently we require a unified namespace
> +	 * within the container: simply fail.
> +	 */
> +	if (tmp.mnt != root->mnt || tmp.dentry != root->dentry)
> +		fname = ERR_PTR(-EBADF);

...

> +static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
> +{
> +	ctx->root_pid = pid;
> +
> +	/*
> +	 * assume checkpointer is in container's root vfs
> +	 * FIXME: this works for now, but will change with real containers
> +	 */
> +	ctx->vfsroot = &current->fs->root;
> +	path_get(ctx->vfsroot);

Hi Oren,

Is there really any good reason to use current->fs->root rather
than ctx->root_task->fs->root here?

The way I'm testing, the checkpointer is in fact in a different
container, so the root passed into cr_fill_fname() is different
from the container's root, so cr_fill_fname() always returns me
-EBADF.

thanks,
-serge
