Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYIJSkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYIJSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYIJSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:40:26 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:32980 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYIJSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:40:25 -0400
Message-ID: <48C813A0.2020404@cs.columbia.edu>
Date: Wed, 10 Sep 2008 14:36:16 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: MinChan Kim <minchan.kim@gmail.com>
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v4][PATCH 2/9] General infrastructure for checkpoint restart
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-3-git-send-email-orenl@cs.columbia.edu> <28c262360809092310x244c0c8dvca8a6022c7d0d225@mail.gmail.com>
In-Reply-To: <28c262360809092310x244c0c8dvca8a6022c7d0d225@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



MinChan Kim wrote:
> On Tue, Sep 9, 2008 at 4:42 PM, Oren Laadan <orenl@cs.columbia.edu> wrote:

[...]

>> +struct cr_ctx *cr_ctx_alloc(pid_t pid, int fd, unsigned long flags)
>> +{
>> +       struct cr_ctx *ctx;
>> +
>> +       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +       if (!ctx)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       ctx->file = fget(fd);
>> +       if (!ctx->file) {
>> +               cr_ctx_free(ctx);
>> +               return ERR_PTR(-EBADF);
>> +       }
>> +       get_file(ctx->file);
> 
> Why do you need get_file?
> You already called fget.
> Am I missing something ?

This was meant for when we will restart multiple processes, each would
have access to the checkpoint-context, such that the checkpoint-context
may outlives the task that created it and initiated the restart. Thus
the file-pointer will need to stay around longer than that task.

Of course, restart of multiple processes _can_ be coded such that this
first task will always terminate last - either after restart completes
successfully, or after all the other tasks aborted and won't use the
checkpoint-context anymore.

Because that code is not part of the this patch-set, I considered it
safer to grab a reference of the file pointer, making it less likely
that we forget about it later.

> 
>> +       ctx->hbuf = (void *) __get_free_pages(GFP_KERNEL, CR_HBUF_ORDER);
>> +       if (!ctx->hbuf) {
>> +               cr_ctx_free(ctx);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       ctx->pid = pid;
>> +       ctx->flags = flags;
>> +
>> +       ctx->crid = atomic_inc_return(&cr_ctx_count);
>> +
>> +       return ctx;
>> +}

Oren.

