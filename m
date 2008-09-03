Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYICONV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYICONV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYICONN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:13:13 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:48568 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbYICONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:13:12 -0400
Message-ID: <48BE9B74.7010600@fr.ibm.com>
Date: Wed, 03 Sep 2008 16:13:08 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 3/9] Introduce context structure needed during	checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1220439476-16465-2-git-send-email-major@openvz.org>	<1220439476-16465-3-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org>
In-Reply-To: <1220439476-16465-4-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +void context_release(struct cpt_context *ctx)
> +{
> +	ctx->ctx_state = CPT_CTX_ERROR;
> +
> +	if (ctx->file)
> +		fput(ctx->file);
> +	kfree(ctx);
> +}
> +
> +static void context_put(struct cpt_context *ctx)
> +{
> +	if (!--ctx->refcount)
> +		context_release(ctx);
> +}
> +
>  static int checkpoint(pid_t pid, int fd, unsigned long flags)
>  {
> -	return -ENOSYS; 
> +	struct file *file;
> +	struct cpt_context *ctx;
> +	int err;
> +
> +	err = -EBADF;
> +	file = fget(fd);
> +	if (!file)
> +		goto out;
> +
> +	err = -ENOMEM;
> +	ctx = context_alloc();
> +	if (!ctx)
> +		goto out_file;
> +
> +	ctx->file = file;
> +	ctx->ctx_state = CPT_CTX_DUMPING;
> +
> +	/* checkpoint */
> +	err = -ENOSYS;
> +
> +	context_put(ctx);
> +
> +out_file:
> +	fput(file);
> +out:
> +	return err; 
>  }

it looks like fput(file) is done twice in checkpoint() and context_release() ?

C.
