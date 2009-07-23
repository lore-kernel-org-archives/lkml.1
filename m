Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZGWPXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZGWPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZGWPXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:23:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40351 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZGWPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:23:44 -0400
Date: Thu, 23 Jul 2009 09:47:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task
	other than ourself
Message-ID: <20090723144753.GA12416@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-23-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> +/* setup checkpoint-specific parts of ctx */
> +static int init_checkpoint_ctx(struct ckpt_ctx *ctx, pid_t pid)
> +{
> +	struct task_struct *task;
> +	struct nsproxy *nsproxy;
> +	int ret;
> +
> +	/*
> +	 * No need for explicit cleanup here, because if an error
> +	 * occurs then ckpt_ctx_free() is eventually called.
> +	 */
> +
> +	ctx->root_pid = pid;
> +
> +	/* root task */
> +	read_lock(&tasklist_lock);
> +	task = find_task_by_vpid(pid);
> +	if (task)
> +		get_task_struct(task);
> +	read_unlock(&tasklist_lock);
> +	if (!task)
> +		return -ESRCH;
> +	else
> +		ctx->root_task = task;
> +
> +	/* root nsproxy */
> +	rcu_read_lock();
> +	nsproxy = task_nsproxy(task);
> +	if (nsproxy)
> +		get_nsproxy(nsproxy);
> +	rcu_read_unlock();
> +	if (!nsproxy)
> +		return -ESRCH;
> +	else
> +		ctx->root_nsproxy = nsproxy;
> +
> +	/* root freezer */
> +	ctx->root_freezer = task;
> +	geT_task_struct(task);
> +
> +	ret = may_checkpoint_task(ctx, task);
> +	if (ret) {
> +		ckpt_write_err(ctx, NULL);
> +		put_task_struct(task);
> +		put_task_struct(task);
> +		put_nsproxy(nsproxy);

I don't think this is safe - the ckpt_ctx_free() will
free them a second time because you're not setting them
to NULL, right?

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +

-serge
