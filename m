Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbZAHVXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbZAHVXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbZAHVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:23:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:59068 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760613AbZAHVXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=li5SBS2tlatUadDCayhDX6LTCNQweNjrtdFiZCG/HsVsBOyRyqPXRDF6h/NtATInrn
         ypVfTdlIp/Jb3KwSPeNEvu174DrAwujsSZJBgjiYfRawkkkxHSrRL9AfBT7ywhNHK+qB
         FAVIaUPkw64HMmdSq3AHdW4fWN5N/GV18GZvE=
Message-ID: <49666EB2.3090800@gmail.com>
Date: Thu, 08 Jan 2009 13:22:58 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: torvalds@linux-foundation.org, Pekka Paalanen <pq@iki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	<20090108221753.78648cd6@daedalus.pq.iki.fi> <20090108125317.648397d2@infradead.org>
In-Reply-To: <20090108125317.648397d2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>> Additional async_synchronize_full() helps and box boot to the end.
>>>       
>
> Hi Linus,
>
> can you add the patch below to your tree? This makes the
> async_synchronize_full() a real absolute async barrier, rather than
> just synchronizing the work scheduled upto the starting point.
> It's a bit too much for some cases (so later on I might introduce the
> softer synchronization again) but it solves some real problems
> for people so this should go into -rc1 please...
>
> >From ca1827b142e41b54c612026b3c0b5d239f21a715 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 8 Jan 2009 12:35:11 -0800
> Subject: [PATCH] async: make async_synchronize_full() more serializing
>
> turns out that there are real problems with allowing async
> tasks that are scheduled from async tasks to run after
> the async_synchronize_full() returns.
>
> This patch makes the _full more strict and a complete
> synchronization. Later I might need to add back a lighter
> form of synchronization for other uses.. but not right now.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/async.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 9737338..64cc916 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -206,7 +206,9 @@ EXPORT_SYMBOL_GPL(async_schedule_special);
>  
>  void async_synchronize_full(void)
>  {
> -	async_synchronize_cookie(next_cookie);
> +	do {
> +		async_synchronize_cookie(next_cookie);
> +	} while (!list_empty(&async_running) || !list_empty(&async_pending));
>  }
>  EXPORT_SYMBOL_GPL(async_synchronize_full);
>  
>   
I'm getting this as well,
happens three to two times in a row,
then I'll get a good bootup.
going to try and see if I can grab a log
with ohci1394

regards;

Justin P. Mattock

