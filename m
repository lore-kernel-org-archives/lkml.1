Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZHJHXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZHJHXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZHJHXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:23:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZHJHXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:23:13 -0400
Subject: Re: [PATCH 3/3] perfcounter: Align ftrace events raw samples to 8
 bytes
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
	 <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 09:13:57 +0200
Message-Id: <1249888437.17467.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 04:26 +0200, Frederic Weisbecker wrote:
> Align the ftrace events raw samples to 8 bytes so that they meet the
> perf output event alignements requirements.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 80e5f6c..7b0834c 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -687,7 +687,7 @@ static void ftrace_profile_##call(proto)				\
>  	pc = preempt_count();						\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> -	__entry_size = __data_size + sizeof(*entry);			\
> +	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
>  									\
>  	do {								\
>  		char raw_data[__entry_size];				\

Make sure to clear the trailing few bytes, otherwise we've got a stack
data leak here.

Also, tracepoints using __string() could still easily overflow the stack
here and cause great havoc, esp since the tracepoint could already be
deep into a call-chain.


