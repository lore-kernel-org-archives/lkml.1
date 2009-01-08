Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZAHORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZAHORe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZAHORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:17:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZAHORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:17:24 -0500
Date: Thu, 8 Jan 2009 09:17:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: akpm@linux-foundation.org
cc: mm-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + kernel-trace-ring_bufferc-use-div_round_up.patch added to -mm
 tree
In-Reply-To: <200901080529.n085TM7t015825@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901080916080.22642@gandalf.stny.rr.com>
References: <200901080529.n085TM7t015825@imap1.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ------------------------------------------------------
> Subject: kernel/trace/ring_buffer.c: use DIV_ROUND_UP
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Instead of open-coding it.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/trace/ring_buffer.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up kernel/trace/ring_buffer.c
> --- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up
> +++ a/kernel/trace/ring_buffer.c
> @@ -123,8 +123,7 @@ void ring_buffer_normalize_time_stamp(in
>  EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
>  
>  #define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
> -#define RB_ALIGNMENT_SHIFT	2
> -#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
> +#define RB_ALIGNMENT		4U
>  #define RB_MAX_SMALL_DATA	28
>  
>  enum {
> @@ -151,7 +150,7 @@ rb_event_length(struct ring_buffer_event
>  
>  	case RINGBUF_TYPE_DATA:
>  		if (event->len)
> -			length = event->len << RB_ALIGNMENT_SHIFT;
> +			length = event->len / RB_ALIGNMENT;

uh, shouldn't that be a * and not a / ?

-- Steve

>  		else
>  			length = event->array[0];
>  		return length + RB_EVNT_HDR_SIZE;
> @@ -931,15 +930,11 @@ rb_update_event(struct ring_buffer_event
>  		break;
>  
>  	case RINGBUF_TYPE_TIME_EXTEND:
> -		event->len =
> -			(RB_LEN_TIME_EXTEND + (RB_ALIGNMENT-1))
> -			>> RB_ALIGNMENT_SHIFT;
> +		event->len = DIV_ROUND_UP(RB_LEN_TIME_EXTEND, RB_ALIGNMENT);
>  		break;
>  
>  	case RINGBUF_TYPE_TIME_STAMP:
> -		event->len =
> -			(RB_LEN_TIME_STAMP + (RB_ALIGNMENT-1))
> -			>> RB_ALIGNMENT_SHIFT;
> +		event->len = DIV_ROUND_UP(RB_LEN_TIME_STAMP, RB_ALIGNMENT);
>  		break;
>  
>  	case RINGBUF_TYPE_DATA:
> @@ -948,9 +943,7 @@ rb_update_event(struct ring_buffer_event
>  			event->len = 0;
>  			event->array[0] = length;
>  		} else
> -			event->len =
> -				(length + (RB_ALIGNMENT-1))
> -				>> RB_ALIGNMENT_SHIFT;
> +			event->len = DIV_ROUND_UP(length, RB_ALIGNMENT);
>  		break;
>  	default:
>  		BUG();
> _
