Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXEBFzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXEBFzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030823AbXEBFzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:55:07 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:40713 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030818AbXEBFzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:55:04 -0400
Message-ID: <4638279A.9010105@cosmosbay.com>
Date: Wed, 02 May 2007 07:54:34 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davi Arnaut <davi@haxent.com.br>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br> <20070502053427.123392000@haxent.com.br>
In-Reply-To: <20070502053427.123392000@haxent.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 02 May 2007 07:54:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davi Arnaut a écrit :
> Asynchronously wait for FUTEX_WAKE operation on a futex if it still contains
> a given value. There can be only one futex wait per file descriptor. However,
> it can be rearmed (possibly at a different address) anytime.
> 
> The pollable futex approach is far superior (send and receive events from
> userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.
> 
> Building block for pollable semaphores and user-defined events.
> 
> Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
> 
> ---
>  fs/pollfs/Makefile |    1 
>  fs/pollfs/futex.c  |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  init/Kconfig       |    7 ++
>  3 files changed, 162 insertions(+)
> 
> Index: linux-2.6/fs/pollfs/Makefile
> ===================================================================
> --- linux-2.6.orig/fs/pollfs/Makefile
> +++ linux-2.6/fs/pollfs/Makefile
> @@ -3,3 +3,4 @@ pollfs-y := file.o
>  
>  pollfs-$(CONFIG_POLLFS_SIGNAL) += signal.o
>  pollfs-$(CONFIG_POLLFS_TIMER) += timer.o
> +pollfs-$(CONFIG_POLLFS_FUTEX) += futex.o
> Index: linux-2.6/fs/pollfs/futex.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/fs/pollfs/futex.c
> @@ -0,0 +1,154 @@
> +/*
> + * pollable futex
> + *
> + * Copyright (C) 2007 Davi E. M. Arnaut
> + *
> + * Licensed under the GNU GPL. See the file COPYING for details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/pollfs_fs.h>
> +#include <linux/futex.h>
> +
> +struct futex_event {
> +	union {
> +		void __user *addr;
> +		u64 padding;
> +	};
> +	int val;
> +};

Hum... Here we might have a problem with 64 bit futexes, or private futexes

So I believe this interface is not well defined and not expandable: in case of 
future additions to futexes, an old application compiled with an old pollable 
futex_event type might fail.



