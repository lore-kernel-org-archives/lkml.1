Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZGQFPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZGQFPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbZGQFPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:15:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:41245 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZGQFPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UQz8iwHax8poLkrKLmDfSLgrRGtqXAtVM6wclYls/BVBi58lqjFevFUJWIm6zUvidM
         /UQHvWO9aKc1gT0ylITPH9QDS4qXckw7HW56lfKE61vLUnJSrnFMAdce6n6/klgL6QLo
         YxPnAuFCAsBCsYKM9ksk9aTTo30wzxDqnvEyw=
Date: Fri, 17 Jul 2009 01:14:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] tracing/events: record the size of dynamic arrays
Message-ID: <20090717051357.GE4977@nowhere>
References: <4A5E9604.2030103@cn.fujitsu.com> <4A5E964A.9000403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5E964A.9000403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:54:02AM +0800, Li Zefan wrote:
> When a dynamic array is defined, we add __data_loc_foo in
> trace_entry to record the offset of the array, but the
> size of the array is not recorded, which causes 2 problems:
> 
> - the event filter just compares the first 2 chars of the strings.
> 
> - parsers can't parse dynamic arrays.
> 
> So we encode the size of each dynamic array in the higher 16 bits
> of __data_loc_foo, while the offset is in lower 16 bits.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/ftrace.h             |   14 ++++++++------
>  kernel/trace/trace_events_filter.c |    6 ++++--
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index cc78943..3cbb96e 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -25,7 +25,7 @@
>  #define __array(type, item, len)	type	item[len];
>  
>  #undef __dynamic_array
> -#define __dynamic_array(type, item, len) unsigned short __data_loc_##item;
> +#define __dynamic_array(type, item, len) u32 __data_loc_##item;
>  
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
> @@ -51,13 +51,14 @@
>   * Include the following:
>   *
>   * struct ftrace_data_offsets_<call> {
> - *	int				<item1>;
> - *	int				<item2>;
> + *	u32				<item1>;
> + *	u32				<item2>;
>   *	[...]
>   * };
>   *
> - * The __dynamic_array() macro will create each int <item>, this is
> + * The __dynamic_array() macro will create each u32 <item>, this is
>   * to keep the offset of each array from the beginning of the event.
> + * The size of an array is also encoded, in the higher 16 bits of <item>.
>   */
>  
>  #undef __field
> @@ -67,7 +68,7 @@
>  #define __array(type, item, len)
>  
>  #undef __dynamic_array
> -#define __dynamic_array(type, item, len)	int item;
> +#define __dynamic_array(type, item, len)	u32 item;
>  
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
> @@ -207,7 +208,7 @@ ftrace_format_##call(struct trace_seq *s)				\
>  
>  #undef __get_dynamic_array
>  #define __get_dynamic_array(field)	\
> -		((void *)__entry + __entry->__data_loc_##field)
> +		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
>  
>  #undef __get_str
>  #define __get_str(field) (char *)__get_dynamic_array(field)
> @@ -325,6 +326,7 @@ ftrace_define_fields_##call(void)					\
>  #define __dynamic_array(type, item, len)				\
>  	__data_offsets->item = __data_size +				\
>  			       offsetof(typeof(*entry), __data);	\
> +	__data_offsets->item |= (len * sizeof(type)) << 16;		\
>  	__data_size += (len) * sizeof(type);
>  
>  #undef __string
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index b9aae72..1c80ef7 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -176,11 +176,13 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
>  static int filter_pred_strloc(struct filter_pred *pred, void *event,
>  			      int val1, int val2)
>  {
> -	unsigned short str_loc = *(unsigned short *)(event + pred->offset);
> +	u32 str_item = *(u32 *)(event + pred->offset);
> +	int str_loc = str_item & 0xffff;
> +	int str_len = str_item >> 16;
>  	char *addr = (char *)(event + str_loc);
>  	int cmp, match;
>  
> -	cmp = strncmp(addr, pred->str_val, pred->str_len);
> +	cmp = strncmp(addr, pred->str_val, str_len);
>  
>  	match = (!cmp) ^ pred->not;
>  
> -- 1.6.3 


Looks good.
Like the previous one, I prefer to wait for an Ack from Steve though.

