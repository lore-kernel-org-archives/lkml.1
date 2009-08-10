Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZHJON3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZHJON3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZHJON2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:13:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:39568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZHJON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:13:27 -0400
Subject: Re: [PATCH 6/3] perfcounter: Substract the buffer size field from
 the event record size
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090810141129.GA5124@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
	 <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
	 <1249896447.17467.74.camel@twins> <20090810125731.GA5124@nowhere>
	 <1249909585.17467.135.camel@twins>  <20090810141129.GA5124@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 16:13:05 +0200
Message-Id: <1249913585.17467.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 16:11 +0200, Frederic Weisbecker wrote:

> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 10 Aug 2009 15:56:46 +0200
> Subject: [PATCH 6/3] perfcounter: Substract the buffer size field from the event record size
> 
> We compute the perf raw sample size by aligning the raw ftrace event
> size plus the buffer size field itself. We do that instead of aligning
> only the perf raw sample size, so that we might economize some in some
> cases.
> 
> But this buffer size field is not stored in the perf raw sample, we
> must then substract its size from the buffer once we computed the
> alignment unless we may get a useless u32 field in the buffer.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!

> ---
>  include/trace/ftrace.h      |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 4dc1a60..f98ff56 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -639,7 +639,12 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>   *	pc = preempt_count();
>   *
>   *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
> - *	__entry_size = __data_size + sizeof(*entry);
> + *
> + *	// Below we want to get the aligned size by taking into account
> + *	// the u32 field that will later store the buffer size
> + *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
> + *			     sizeof(u64));
> + *	__entry_size -= sizeof(u32);
>   *
>   *	do {
>   *		char raw_data[__entry_size]; <- allocate our sample in the stack
> @@ -689,6 +694,7 @@ static void ftrace_profile_##call(proto)				\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
>  			     sizeof(u64));				\
> +	__entry_size -= sizeof(u32);					\
>  									\
>  	do {								\
>  		char raw_data[__entry_size];				\
