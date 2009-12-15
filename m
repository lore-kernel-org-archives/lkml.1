Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbZLON7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbZLON7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbZLON7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:59:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22794 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760237AbZLON7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:59:02 -0500
Date: Tue, 15 Dec 2009 14:58:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf_event: fix getting point
Message-ID: <20091215135855.GA5833@nowhere>
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2770FA.7090803@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 07:20:26PM +0800, Xiao Guangrong wrote:
> The point that got by raw_field_ptr() is point to @data offset not
> tracepoint saved.
> 
> Introduce raw_field_arry() to get arry data is tracepoint save
> arry to it.


Could you please rename it into raw_field_array()?
I feel like...a kind of loss there :)



> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/builtin-sched.c          |    3 +--
>  tools/perf/util/trace-event-parse.c |   25 ++++++++++++++++++++++---
>  tools/perf/util/trace-event.h       |    3 +++
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index d67f274..8df982e 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -630,8 +630,7 @@ static void test_calibrations(void)
>  
>  #define FILL_ARRAY(ptr, array, event, data)			\
>  do {								\
> -	void *__array = raw_field_ptr(event, #array, data);	\
> -	memcpy(ptr.array, __array, sizeof(ptr.array));	\
> +	raw_field_arry(event, #array, data, ptr.array, sizeof(ptr.array));\
>  } while(0)
>  
>  #define FILL_COMMON_FIELDS(ptr, event, data)			\
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index c5c32be..b0ee64f 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -840,7 +840,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
>  			field->flags |= FIELD_IS_ARRAY;
>  
>  			type = read_token(&token);
> -		        while (strcmp(token, "]") != 0) {
> +			while (strcmp(token, "]") != 0) {
>  				if (last_type == EVENT_ITEM &&
>  				    type == EVENT_ITEM)
>  					len = 2;
> @@ -1919,13 +1919,32 @@ raw_field_value(struct event *event, const char *name, void *data)
>  
>  void *raw_field_ptr(struct event *event, const char *name, void *data)
>  {
> +	void *ptr;
> +	unsigned long long value;
> +
> +	value = raw_field_value(event, name, data);
> +
> +	if (!value)
> +		return NULL;
> +
> +	memcpy(&ptr, &value, sizeof(ptr));



Could you perhaps just do

ptr = (void *)value; ?

This memcpy suggest we are dereferencing some field while
actually just copy a pointer.

Thanks!

