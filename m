Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZKROfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZKROfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZKROfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:35:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbZKROf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:35:29 -0500
Subject: Re: [PATCH] perf_events: fix default watermark calculation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
In-Reply-To: <1256302576-6169-1-git-send-email-eranian@gmail.com>
References: <>  <1256302576-6169-1-git-send-email-eranian@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 15:35:25 +0100
Message-ID: <1258554925.3918.504.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 14:56 +0200, Stephane Eranian wrote:
> 	This patch fixes the default watermark value for
> 	the sampling buffer. With the existing calculation
> 	(watermark = max(PAGE_SIZE, max_size / 2)), no
> 	notification was ever received when the buffer was
> 	exactly 1 page. This was because you would never
> 	cross the threshold (there is no partial samples).

Right, silly thinko, thanks for catching this.

> 	In certain configuration, there was no possibilty
> 	detecting the problem because there was not enough
> 	space left to store the LOST record.In fact, there
> 	may be a more generic problem here. The kernel should
> 	ensure that there is alaways enough space to store
> 	one LOST record.

It tries to prepend LOST records for each new event (when there is data
lost), so as soon as it manages to write a new event, it will include a
LOST record when appropriate.

> 	This patch sets the default watermark to half the
> 	buffer size. With such limit, we are guaranteed to
> 	get a notification even with a single page buffer
> 	assuming no sample is bigger than a page.
> 	
> 	Signed-off-by: Stephane Eranian <eranian@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/perf_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a69d4ed..e8ec4b7 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -2315,7 +2315,7 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
>  	}
>  
>  	if (!data->watermark)
> -		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
> +		data->watermark = max_size / 2;
>  
> 
>  	rcu_assign_pointer(event->data, data);


