Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZHHCap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZHHCap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZHHCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:30:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41457 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZHHCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OlMIxPRmne2eG9dGnLSEWW73Fej46Xj0lm8aizGd0tC1yclt/W96SVcJ90f6z3JtHa
         U8o/ECgA4HAOZA5rUUb2TYJNzc0JyIArF2OUsYs6AVm+1dsMyh5HP//a6oo43iy5r/Z0
         8itPLq8wC4lDifq65/7odd8/y/UsR4MsZd2Xk=
Date: Sat, 8 Aug 2009 04:30:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] perfcounter: Initialize tracepoint record before
	any use
Message-ID: <20090808023038.GA5366@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com> <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 04:26:35AM +0200, Frederic Weisbecker wrote:
> Despite that the tracepoint record is always present when the
> PERF_SAMPLE_TP_RECORD flag is set, gcc whines, thinking it might not
> be initialized:
> 
> kernel/perf_counter.c: In function ‘perf_counter_output’:
> kernel/perf_counter.c:2650: warning: ‘tp’ may be used uninitialized in this function
> 
> Then, initialize it to NULL and always check if it's not NULL before
> dereference it.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> ---


Hmm, sorry I've resent the perf tools series by mistake. Please
ignore the [PATCH */4] "perf tools: *" series that has already been
sent.

The only ones are [PATCH */3] perfcounter: *

Thanks.


>  kernel/perf_counter.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 142ae5a..a6963e2 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -2647,7 +2647,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>  		u64 counter;
>  	} group_entry;
>  	struct perf_callchain_entry *callchain = NULL;
> -	struct perf_tracepoint_record *tp;
> +	struct perf_tracepoint_record *tp = NULL;
>  	int callchain_size = 0;
>  	u64 time;
>  	struct {
> @@ -2718,7 +2718,8 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>  
>  	if (sample_type & PERF_SAMPLE_TP_RECORD) {
>  		tp = data->private;
> -		header.size += tp->size;
> +		if (tp)
> +			header.size += tp->size;
>  	}
>  
>  	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
> @@ -2784,7 +2785,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>  		}
>  	}
>  
> -	if (sample_type & PERF_SAMPLE_TP_RECORD)
> +	if ((sample_type & PERF_SAMPLE_TP_RECORD) && tp)
>  		perf_output_copy(&handle, tp->record, tp->size);
>  
>  	perf_output_end(&handle);
> -- 
> 1.6.2.3
> 

