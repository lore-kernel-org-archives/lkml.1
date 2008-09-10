Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYIJWy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYIJWy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYIJWyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:54:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35135 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYIJWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R+TLCHVdQeBs6h2/se7T3HpEExPucSe2/zwRY3FCHGXjrTTmo266Dy/MqMI+vXQerZ
         zTJniGnRNTpK3aUqJf4hFjVccpfQdEGr+0o4A4FtK/g6DT2CAKp6+aSIX3ozropEre4U
         /ZGjIZOsF9C+FsA5jUhhyn/FYmRp7TdX1V4LQ=
Message-ID: <28c262360809101554l1faab2a9na6b9066a07747554@mail.gmail.com>
Date: Thu, 11 Sep 2008 07:54:16 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Oren Laadan" <orenl@cs.columbia.edu>
Subject: Re: [RFC v4][PATCH 2/9] General infrastructure for checkpoint restart
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <48C813A0.2020404@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-3-git-send-email-orenl@cs.columbia.edu>
	 <28c262360809092310x244c0c8dvca8a6022c7d0d225@mail.gmail.com>
	 <48C813A0.2020404@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oren.

On Thu, Sep 11, 2008 at 3:36 AM, Oren Laadan <orenl@cs.columbia.edu> wrote:
>
>
> MinChan Kim wrote:
>> On Tue, Sep 9, 2008 at 4:42 PM, Oren Laadan <orenl@cs.columbia.edu> wrote:
>
> [...]
>
>>> +struct cr_ctx *cr_ctx_alloc(pid_t pid, int fd, unsigned long flags)
>>> +{
>>> +       struct cr_ctx *ctx;
>>> +
>>> +       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>>> +       if (!ctx)
>>> +               return ERR_PTR(-ENOMEM);
>>> +
>>> +       ctx->file = fget(fd);
>>> +       if (!ctx->file) {
>>> +               cr_ctx_free(ctx);
>>> +               return ERR_PTR(-EBADF);
>>> +       }
>>> +       get_file(ctx->file);
>>
>> Why do you need get_file?
>> You already called fget.
>> Am I missing something ?
>
> This was meant for when we will restart multiple processes, each would
> have access to the checkpoint-context, such that the checkpoint-context
> may outlives the task that created it and initiated the restart. Thus
> the file-pointer will need to stay around longer than that task.

OK. Thanks for your explanation.
You should have inserted above annotation.

> Of course, restart of multiple processes _can_ be coded such that this
> first task will always terminate last - either after restart completes
> successfully, or after all the other tasks aborted and won't use the
> checkpoint-context anymore.
>
> Because that code is not part of the this patch-set, I considered it
> safer to grab a reference of the file pointer, making it less likely
> that we forget about it later.

What do you mean by that ? Isn't it a your part of your code?
When the last checkpoint-context is ended, who free file ?
I mean how it match pair(fget/fput and get_file) ?

>>
>>> +       ctx->hbuf = (void *) __get_free_pages(GFP_KERNEL, CR_HBUF_ORDER);
>>> +       if (!ctx->hbuf) {
>>> +               cr_ctx_free(ctx);
>>> +               return ERR_PTR(-ENOMEM);
>>> +       }
>>> +
>>> +       ctx->pid = pid;
>>> +       ctx->flags = flags;
>>> +
>>> +       ctx->crid = atomic_inc_return(&cr_ctx_count);
>>> +
>>> +       return ctx;
>>> +}
>
> Oren.
>
>



-- 
Kinds regards,
MinChan Kim
