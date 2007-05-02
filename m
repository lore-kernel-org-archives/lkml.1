Return-Path: <linux-kernel-owner+w=401wt.eu-S1766818AbXEBRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766818AbXEBRK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766802AbXEBRK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:10:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:63138 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766818AbXEBRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oo937zM2OAq7Leh657V0VcAMmi6qyZZmSzIiLgYhNWaY0qm0o2eVvVkS6BLsyoqgUaD5UKVSytlvObnEETfmRu6Okd/uNxZLiDtiXnjTvGcNr55zeNwsginrLqVk3WBWK8OxRLq2hWqOgK0nhqpfx5f0HHyLkQBbPthW4Fdr9Ds=
Message-ID: <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
Date: Wed, 2 May 2007 10:10:22 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4638C37D.7050503@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
> thread A:
>     int fd = plfutex(addr, 0);
>     do
>         poll(fdset+fd);
>         process network events
>         queue obj to thread B
>         if fd:
>             job processed
>
> thread B:
>     wait_job();
>     process_job();
>     raise_event(addr);

This is not the model you can implement with your changes.  Because
every single waiter is woken you need one thread listening for the
jobs and then distribute the work.  Otherwise you have thundering
herds of threads and only one gets to do some work.


> It simple as is, there is no need to overdesign.

There is no reason to go with a limited, too-simple minded design if
we've already identified a much better design.  The fact that poll is
used today does not excuse piling on more and more code which makes
additional functions which don't fit into the poll framework barely
work.  Plus, poll/epoll itself is a problem.

And you cannot talk about little changes and no "overdesign".  You
have 22 patches for all this.  It's not just limited to futexes, it's
the whole thing which IMO is unnecessary ballast going forward.
