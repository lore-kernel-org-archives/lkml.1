Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266Ab0ATNmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0ATNmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646Ab0ATNmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:42:06 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63282 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0ATNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YNGzlkNPmDVGt5rs9926C+H8DWPBC9LpiYGrgpG7j0aoJnC425zPQ4Nn5HCNMBXXUZ
         ZECb4+9+6jEPStNxH4MAD17dm5xp1QccbPCmSx51ORO2noohI5SCnryATytREVL75ave
         6axHdpehNbTiFdYEcZF3Nlt5hghZBfHWvn13s=
Date: Wed, 20 Jan 2010 14:41:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: fix write_event()
Message-ID: <20100120134155.GA7281@nowhere>
References: <4B570657.5090105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B570657.5090105@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 09:34:15PM +0800, Xiao Guangrong wrote:
> We parse the event while it's read from mmap buffer in
> write_event(), but sometimes the event will straddles the
> mmap boundary, we should handle this case
> 
> And if we record events(such as perf kmem/sched) for long
> times, Ctrl + C can't interrupt it just for this reason
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>




I've seen this bug recently, perf record was hanging because of
events of size 0. Must be the same bug. Thanks!



> ---
>  tools/perf/builtin-record.c |   62 +++++++++++++++++++++++++++++++++---------
>  1 files changed, 48 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 7bb9ca1..97573b7 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -111,28 +111,62 @@ static void write_output(void *buf, size_t size)
>  	}
>  }
>  
> -static void write_event(event_t *buf, size_t size)
> +static void write_event(void *buf, size_t size)
>  {
> -	size_t processed_size = buf->header.size;
> -	event_t *ev = buf;
> +	event_t *ev;
> +	struct mmap_event mmap_ev;
> +	static void *rec_buf;
> +	static unsigned long rec_len;
>  
> -	do {
> -		/*
> -		* Add it to the list of DSOs, so that when we finish this
> -		 * record session we can pick the available build-ids.
> -		 */
> +	write_output(buf, size);
> +
> +	while (size > 0) {
> +		if (rec_buf) {
> +			int len;
> +
> +			memcpy(&mmap_ev, rec_buf, rec_len);
> +			len = sizeof(mmap_ev.header) - rec_len;
> +			if (len > 0) {
> +				memcpy(&mmap_ev + rec_len, buf, len);
> +				buf += len;
> +				size -= len;
> +				rec_len = sizeof((mmap_ev.header));
> +			}
> +
> +			len = mmap_ev.header.size - rec_len;
> +			if (mmap_ev.header.type == PERF_RECORD_MMAP)
> +				memcpy(&mmap_ev + rec_len, buf, len);
> +
> +			buf += len;
> +			size -= len;
> +
> +			rec_buf = NULL;
> +			rec_len = 0;
> +
> +			ev = (event_t *)&mmap_ev;
> +			goto handle_mmap;
> +		}
> +
> +		ev = (event_t *)buf;
> +		if (size < sizeof(struct perf_event_header) ||
> +		    ev->header.size > size) {
> +			rec_buf = buf;
> +			rec_len = size;
> +			break;
> +		}
> +
> +		buf += ev->header.size;
> +		size -= ev->header.size;
> +
> +handle_mmap:
>  		if (ev->header.type == PERF_RECORD_MMAP) {
>  			struct list_head *head = &dsos__user;
>  			if (ev->header.misc == 1)
>  				head = &dsos__kernel;
>  			__dsos__findnew(head, ev->mmap.filename);
>  		}
> +	}
>  
> -		ev = ((void *)ev) + ev->header.size;
> -		processed_size += ev->header.size;
> -	} while (processed_size < size);
> -
> -	write_output(buf, size);
>  }
>  
>  static int process_synthesized_event(event_t *event,
> -- 
> 1.6.1.2
> 

