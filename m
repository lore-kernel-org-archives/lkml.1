Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZHFTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZHFTBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZHFTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:01:47 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:31645 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbZHFTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:01:46 -0400
X-IronPort-AV: E=Sophos;i="4.43,335,1246831200"; 
   d="scan'208";a="34112538"
Message-ID: <4A7B28A5.2010605@inria.fr>
Date: Thu, 06 Aug 2009 21:01:57 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>	 <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr>	 <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr>	 <20090629192913.GA29295@elte.hu>  <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop>
In-Reply-To: <1249580428.4975.14.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

This one and the next patch made the trick.



Peter Zijlstra wrote:
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 8cb58d6..c053fd8 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -112,7 +112,9 @@ struct read_event {
>  	struct perf_event_header header;
>  	u32 pid,tid;
>  	u64 value;
> -	u64 format[3];
> +	u64 time_enabled;
> +	u64 time_running;
> +	u64 id;
>  };
>  
>  typedef union event_union {
> @@ -1690,14 +1692,37 @@ static void trace_event(event_t *event)
>  	dprintf(".\n");
>  }
>  
> +static struct perf_header	*header;
> +
> +static struct perf_counter_attr *perf_header__find_attr(u64 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < header->attrs; i++) {
> +		struct perf_header_attr *attr = header->attr[i];
> +		int j;
> +
> +		for (j = 0; j < attr->ids; j++) {
> +			if (attr->id[j] == id)
> +				return &attr->attr;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>  static int
>  process_read_event(event_t *event, unsigned long offset, unsigned long head)
>  {
> -	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %Lu\n",
> +	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
> +
> +	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
>  			(void *)(offset + head),
>  			(void *)(long)(event->header.size),
>  			event->read.pid,
>  			event->read.tid,
> +			attr ? __event_name(attr->type, attr->config)
> +			     : "FAIL",
>  			event->read.value);
>  
>  	return 0;
> @@ -1743,8 +1768,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
>  	return 0;
>  }
>  
> -static struct perf_header	*header;
> -
>  static u64 perf_header__sample_type(void)
>  {
>  	u64 sample_type = 0;
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 7bdad8d..4858d83 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -223,9 +239,15 @@ char *event_name(int counter)
>  {
>  	u64 config = attrs[counter].config;
>  	int type = attrs[counter].type;
> +
> +	return __event_name(type, config);
> +}
> +
> +char *__event_name(int type, u64 config)
> +{
>  	static char buf[32];
>  
> -	if (attrs[counter].type == PERF_TYPE_RAW) {
> +	if (type == PERF_TYPE_RAW) {
>  		sprintf(buf, "raw 0x%llx", config);
>  		return buf;
>  	}
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 1ea5d09..192a962 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -10,6 +10,7 @@ extern int			nr_counters;
>  extern struct perf_counter_attr attrs[MAX_COUNTERS];
>  
>  extern char *event_name(int ctr);
> +extern char *__event_name(int type, u64 config);
>  
>  extern int parse_events(const struct option *opt, const char *str, int unset);
>  
>
>
>   

