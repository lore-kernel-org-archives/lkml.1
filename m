Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYJTRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYJTRCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYJTRCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:02:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37457 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYJTRCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:02:40 -0400
Subject: Re: [PATCH 03/10] Introduce context structure needed during
	checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <1224285098-573-4-git-send-email-major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-2-git-send-email-major@openvz.org>
	 <1224285098-573-3-git-send-email-major@openvz.org>
	 <1224285098-573-4-git-send-email-major@openvz.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 10:02:24 -0700
Message-Id: <1224522144.1848.115.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 03:11 +0400, Andrey Mirkin wrote:
> +typedef struct cpt_context
> +{
> +	pid_t		pid;		/* should be changed to ctid later */
> +	int		ctx_id;		/* context id */
> +	struct list_head ctx_list;
> +	int		refcount;
> +	int		ctx_state;
> +	struct semaphore main_sem;

Does this really need to be a semaphore or is a mutex OK?

> +	int		errno;

Could you hold off on adding these things to the struct until the patch
where they're actually used?  It's hard to judge this without seeing
what you do with it.

> +	struct file	*file;
> +	loff_t		current_object;
> +
> +	struct list_head object_array[CPT_OBJ_MAX];
> +
> +	int		(*write)(const void *addr, size_t count, struct cpt_context *ctx);
> +	int		(*read)(void *addr, size_t count, struct cpt_context *ctx);
> +} cpt_context_t;

Man, this is hard to review.  I was going to try and make sure that your
refcounting was right and atomic, but there's no use of it in this patch
except for the initialization and accessor functions.  Darn.

> +extern int debug_level;

I'm going to go out on a limb here and say that "debug_level" is
probably a wee bit too generic of a variable name.

> +#define cpt_printk(lvl, fmt, args...)	do {	\
> +		if (lvl <= debug_level)		\
> +			printk(fmt, ##args);	\
> +	} while (0)

I think you can use pr_debug() here, too, just like Oren did.

> +struct cpt_context * context_alloc(void)
> +{
> +	struct cpt_context *ctx;
> +	int i;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return NULL;
> +
> +	init_MUTEX(&ctx->main_sem);
> +	ctx->refcount = 1;
> +
> +	ctx->current_object = -1;
> +	ctx->write = file_write;
> +	ctx->read = file_read;
> +	for (i = 0; i < CPT_OBJ_MAX; i++) {
> +		INIT_LIST_HEAD(&ctx->object_array[i]);
> +	}
> +
> +	return ctx;
> +}
> +
> +void context_release(struct cpt_context *ctx)
> +{
> +	ctx->ctx_state = CPT_CTX_ERROR;
> +
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

So, where is context_get()?  Is there only single-threaded access to the
refcount?  If so, why do we even need it?  We should probably just use
context_release() driectly.

If there is multithreaded access to context_put() or the refcount, then
they're unsafe without additional locking.

-- Dave

