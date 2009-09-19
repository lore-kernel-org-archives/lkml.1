Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZISJbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZISJbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZISJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:31:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZISJbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:31:40 -0400
Date: Sat, 19 Sep 2009 11:31:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org
Subject: Re: [PATCH 2/8] perf: Store trace event name/id pairs in perf.data
Message-ID: <20090919093137.GA456@elte.hu>
References: <20090912130306.5d0086ea@infradead.org> <20090912130405.6960d099@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912130405.6960d099@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From c9d9dfc617df7a6a6029feb486f2433b7d825ef4 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 12 Sep 2009 07:52:51 +0200
> Subject: [PATCH] perf: Store trace event name/id pairs in perf.data
> 
> The trace event name<->id mapping is dynamic for each kernel compile.
> In order for perf.data to be useable outside the actual system, we thus
> need to store a table of this mapping for later use.
> 
> This patch adds this table to perf.data, and provides helper functions
> for lookup up fields from this table.
> 
> To avoid mistakes, lookup-from-table is kept completely seprate from
> lookup-from-local-debugfs.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  tools/perf/util/header.c       |   59 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/header.h       |    6 ++++
>  tools/perf/util/parse-events.c |   25 +++++++++++++++++
>  3 files changed, 90 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index ec4d4c2..ef91145 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -86,6 +86,44 @@ void perf_header__add_attr(struct perf_header *self,
>  	self->attr[pos] = attr;
>  }
>  
> +struct perf_trace_event_type {
> +	u64	event_id;
> +	char	name[64];
> +};
> +
> +static int event_count;
> +static struct perf_trace_event_type *events;
> +
> +void perf_header__push_event(u64 id, const char *name)
> +{
> +	if (strlen(name) > 64)
> +		printf("Event %s will be truncated\n", name);
> +
> +	if (!events) {
> +		events = malloc(sizeof(struct perf_trace_event_type));
> +		if (!events)
> +			die("nomem");
> +	} else {
> +		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
> +		if (!events)
> +			die("nomem");
> +	}
> +	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
> +	events[event_count].event_id = id;
> +	strncpy(events[event_count].name, name, 63);
> +	event_count++;

This has the string length limit '64' embedded in 3 open-coded forms...

	Ingo
