Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZHSK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZHSK63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZHSK62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:58:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZHSK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:58:27 -0400
Date: Wed, 19 Aug 2009 12:58:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Message-ID: <20090819105818.GB21150@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.980284148@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819092023.980284148@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Provide the ability to configure a counter to send its output to
> another (already existing) counter's output stream.
> 
> [ compile tested only ]

very nice!

two comments:

> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -216,6 +216,7 @@ struct perf_counter_attr {
>  #define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
>  #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
>  #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
> +#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)

Time to add a new sys_perf_counter_chattr() syscall and deprecate 
the ioctls?

> @@ -415,6 +416,9 @@ enum perf_callchain_context {
>  	PERF_CONTEXT_MAX		= (__u64)-4095,
>  };
>  
> +#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
> +#define PERF_FLAG_FD_OUTPUT	(1U << 1)

Why not extend the size of perf_counter_attr and add an output_fd 
parameter? Zero would mean no fd (and this is also backwards 
compatible behavior).

FD_NO_GROUP is a bit unclean API as it aliases group_fd to two 
purposes: the real group_fd and this new output_fd. I think we 
should move output_fd to the attribute structure.

That way one could also create a group counter which shares the 
output channel with another counter, in the same 
perf_counter_open() call.

	Ingo
