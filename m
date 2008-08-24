Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYHXGDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYHXGDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 02:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYHXGDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 02:03:08 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:40751 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHXGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 02:03:07 -0400
Message-ID: <48B0F88C.2090403@cs.columbia.edu>
Date: Sun, 24 Aug 2008 01:58:36 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 2/9] General infrastructure for checkpoint	restart
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202303460.17436@takamine.ncl.cs.columbia.edu> <20080821093529.GG581@hawkmoon.kerlabs.com>
In-Reply-To: <20080821093529.GG581@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Wed, Aug 20, 2008 at 11:04:13PM -0400, Oren Laadan wrote:
>> Add those interfaces, as well as helpers needed to easily manage the
>> file format. The code is roughly broken out as follows:
>>
>> ckpt/sys.c - user/kernel data transfer, as well as setup of the
>> checkpoint/restart context (a per-checkpoint data structure for
>> housekeeping)
>>
>> ckpt/checkpoint.c - output wrappers and basic checkpoint handling
>>
>> ckpt/restart.c - input wrappers and basic restart handling
>>
>> Patches to add the per-architecture support as well as the actual
>> work to do the memory checkpoint follow in subsequent patches.
>>
> 
> [...]
> 
>> diff --git a/checkpoint/sys.c b/checkpoint/sys.c
>> new file mode 100644
>> index 0000000..2891c48
>> --- /dev/null
>> +++ b/checkpoint/sys.c
> 
> [...]
> 
>> +/*
>> + * helpers to manage CR contexts: allocated for each checkpoint and/or
>> + * restart operation, and persists until the operation is completed.
>> + */
>> +
>> +static atomic_t cr_ctx_count;	/* unique checkpoint identifier */
> 
> I thought we agreed that this counter should be per-container. Perhaps add a
> TODO here?

True.

> 
>> +
>> +void cr_ctx_free(struct cr_ctx *ctx)
>> +{
>> +
>> +	if (ctx->file)
>> +		fput(ctx->file);
>> +	if (ctx->vfsroot)
>> +		path_put(ctx->vfsroot);
>> +
>> +	free_pages((unsigned long) ctx->tbuf, CR_TBUF_ORDER);
>> +	free_pages((unsigned long) ctx->hbuf, CR_HBUF_ORDER);
>> +
>> +	kfree(ctx);
>> +}
>> +
>> +struct cr_ctx *cr_ctx_alloc(pid_t pid, struct file *file, unsigned long flags)
>> +{
>> +	struct cr_ctx *ctx;
>> +
>> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +	if (!ctx)
>> +		return NULL;
>> +
>> +	ctx->tbuf = (void *) __get_free_pages(GFP_KERNEL, CR_TBUF_ORDER);
>> +	ctx->hbuf = (void *) __get_free_pages(GFP_KERNEL, CR_HBUF_ORDER);
>> +	if (!ctx->tbuf || !ctx->hbuf)
>> +		goto nomem;
>> +
>> +	ctx->pid = pid;
>> +	ctx->flags = flags;
>> +
>> +	ctx->file = file;
>> +	get_file(file);
>> +
>> +	/* assume checkpointer is in container's root vfs */
> 
> I'm a bit puzzled by this assumption. I would say: either this is a
> self-checkpoint (only current process), or this is a container checkpoint. In
> the latter case, I expect that in the general case the checkpointer lives
> outside the container (and the interface of sys_checkpoint() below confirms
> this), so it's root fs is probably not the container's one.
> 
> Does it differ from what you're planning?

You are correct. We lack infrastructure for what I'd call "container-object",
and the patchset does not yet tackle a container and multiple tasks, so this
is an interim solution. Will add a FIXME comment.

Thanks,

Oren.

