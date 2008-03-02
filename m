Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYCBX3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYCBX3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYCBX3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:29:25 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:7312 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYCBX3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:29:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jjurtjuKDXMrod4AoC4yundTQbiRHXtYlgVLHNV494D4RbWwyb68IwBvEwEpyNE0lr5JUlZKDUs8R0OCBeLfy1D1UdICkwZTpLa/J8FE0QhK/E49xub/higPe+RgM82mx+dh6q3C8RtWLJmPsNwWX3akSJ9n756VUZh6CgaisIQ=
Message-ID: <9a8748490803021529m695f91egcc9e4dba13a5c911@mail.gmail.com>
Date: Mon, 3 Mar 2008 00:29:19 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] leak less memory in failure paths of alloc_rt_sched_group()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1204499992.6240.109.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0803030002520.4939@dragon.funnycrock.com>
	 <1204499992.6240.109.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2008, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  On Mon, 2008-03-03 at 00:09 +0100, Jesper Juhl wrote:
>  > In kernel/sched.c b/kernel/sched.c::alloc_rt_sched_group() we currently do
>  > some paired memory allocations, and if one fails we bail out without
>  > freeing the previous one.
>  >
>  > If we fail inside the loop we should proably roll the whole thing back.
>  > This patch does not do that, it simply frees the first member of the
>  > paired alloc if the second fails. This is not perfect, but it's a simple
>  > change that will, at least, result in us leaking a little less than we
>  > currently do when an allocation fails.
>  >
>  > So, not perfect, but better than what we currently have.
>  > Please consider applying.
>
>
> Doesn't the following handle that:
>
>  sched_create_group()
>  {
>  ...
>         if (!alloc_rt_sched_group())
>                 goto err;
>  ...
>
>  err:
>         free_sched_group();
>  }
>
>
>  free_sched_group()
>  {
>  ...
>         free_rt_sched_group();
>  ...
>  }
>
>  free_rt_sched_group()
>  {
>         free all relevant stuff
>  }
>

Hmmm, it might. I must admit I only looked at alloc_rt_sched_group()
isolated, and what I saw looked like leaks. It seems I need to do a
more thorough reading of the code to be dead sure.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
