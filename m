Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYKKXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYKKXxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYKKXxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:53:40 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:55911 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYKKXxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:53:39 -0500
Message-ID: <491A1AF3.20609@cs.columbia.edu>
Date: Tue, 11 Nov 2008 18:53:23 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 05/13] Dump memory address space
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu> <20081111164517.GA15999@us.ibm.com>
In-Reply-To: <20081111164517.GA15999@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> +/**
>> + * cr_fill_fname - return pathname of a given file
>> + * @path: path name
>> + * @root: relative root
>> + * @buf: buffer for pathname
>> + * @n: buffer length (in) and pathname length (out)
>> + */
>> +static char *
>> +cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
>> +{
>> +	struct path tmp = *root;
>> +	char *fname;
>> +
>> +	BUG_ON(!buf);
>> +	fname = __d_path(path, &tmp, buf, *n);
>> +	if (!IS_ERR(fname))
>> +		*n = (buf + (*n) - fname);
>> +	/*
>> +	 * FIXME: if __d_path() changed these, it must have stepped out of
>> +	 * init's namespace. Since currently we require a unified namespace
>> +	 * within the container: simply fail.
>> +	 */
>> +	if (tmp.mnt != root->mnt || tmp.dentry != root->dentry)
>> +		fname = ERR_PTR(-EBADF);
> 
> ...
> 
>> +static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
>> +{
>> +	ctx->root_pid = pid;
>> +
>> +	/*
>> +	 * assume checkpointer is in container's root vfs
>> +	 * FIXME: this works for now, but will change with real containers
>> +	 */
>> +	ctx->vfsroot = &current->fs->root;
>> +	path_get(ctx->vfsroot);
> 
> Hi Oren,
> 
> Is there really any good reason to use current->fs->root rather
> than ctx->root_task->fs->root here?

Oops, that's a leftover from before supporting external checkpoint.
Will fix.

> 
> The way I'm testing, the checkpointer is in fact in a different
> container, so the root passed into cr_fill_fname() is different
> from the container's root, so cr_fill_fname() always returns me
> -EBADF.
> 

Thanks,

Oren.
