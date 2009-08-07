Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZHGGcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZHGGcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbZHGGcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:32:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZHGGcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:32:32 -0400
Date: Fri, 7 Aug 2009 08:32:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
Message-ID: <20090807063226.GA29532@elte.hu>
References: <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7B68C3.7040706@inria.fr>
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


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Ingo Molnar wrote:
> > It would be nice to add this as some "perf report -s/--stats" flag, 
> > to not have to go via -D (which is a 'print debug output' kind of 
> > ad-hoc thing and subject to format changes in the future).
> >
> > Would you be interested in sending a patch that adds that flag 
> > to 'perf report', to print out these statistics entries (if 
> > any), in a tabular form suitable for your purposes? Below is a 
> > past patch to builtin-report.c that shows how to add new 
> > options.
> 
> Here's a quick'n'dirty first try. Read events are copied in the 
> show_stat_event array during process_read_event. And __cmd_report 
> sorts the array by tid before displaying it.
> 
> perf report -S now shows the following after the existing output: (-s is
> already used for something else).
> It shows things like
> # Per-thread statistics:
> # PID    TID       Event          Count
>   16709   16709   cache-misses   82727
>   16709   16709   cache-references   41238768
>   16709   16710   cache-misses   6462
>   16709   16710   cache-references   76119375
> or
> # Per-thread statistics:
> # PID    TID       Event          Count
>   6268   6268   raw 0x1000001e0   494628
>   6268   6268   raw 0x1000002e0   209113
>   6268   6268   raw 0x1000004e0   307215
>   6268   6268   raw 0x1000008e0   9203221
>   6268   6269   raw 0x1000001e0   9210788
>   6268   6269   raw 0x1000002e0   302344
>   6268   6269   raw 0x1000004e0   198705
>   6268   6269   raw 0x1000008e0   473471
> 
> Obviously, there's some a lot of nice pretty printing to do, but 
> you'll be able to tell whether the general idea is ok or not.

Yeah, the general idea looks OK to me.

I think it would be nice to share the pretty-printing code with 
'perf stat' (builtin-stat.c).

Plus, to make it easier for your scripting needs, we could add a 
--pretty=raw type of flag to both perf stat and perf report, which 
would emit the data in a raw way - to be used in gnuplot almost 
straight away, etc.

But for the typical interactive use it would be nice to do the 2D 
tabular form that 'perf stat' does. (btw: feel free to enhance that 
output as well, where it seems appropriate)

here's a few mostly stylistic comments:

>  static int		full_paths;
>  static int		show_nr_samples;
> +static int		show_stat;
> +static int		show_stat_events;
> +static int		show_stat_event_max;
> +static struct read_event	*show_stat_event;

> @@ -126,6 +132,8 @@
>  	struct read_event		read;
>  } event_t;
>  
> +static struct perf_counter_attr *perf_header__find_attr(u64 id);

Small cleanliness detail: could this function be moved to this spot? 
That way we could avoid this prototype declaration.

> +static int compar_read_event_by_tid(const void *e1, const void *e2)
> +{
> +	const struct read_event *event1 = e1;
> +	const struct read_event *event2 = e2;
> +	return event1->tid - event2->tid;
> +}

another small detail: i'd suggest s/compar/compare, and please put a 
newline after local variables, i.e. something like:

static int compare_read_event_by_tid(const void *e1, const void *e2)
{
	const struct read_event *event1 = e1;
	const struct read_event *event2 = e2;

	return event1->tid - event2->tid;
}

> @@ -1430,6 +1445,21 @@
>  	}
>  	fprintf(fp, "\n");
>  
> +	if (show_stat && show_stat_events) {
> +		int i;

[please add a newline here too]

> +		qsort(&show_stat_event[0], show_stat_events, sizeof(struct read_event), compar_read_event_by_tid);
> +		fprintf(fp, "# Per-thread statistics:\n");
> +		fprintf(fp, "# PID    TID       Event          Count\n");
> +		for(i=0; i<show_stat_events; i++) {

We write loops a tiny bit differently in the kernel - there's an 
easy way to check such details: run your patch through 
scripts/checkpatch.pl.

> +			struct read_event *event = &show_stat_event[i];
> +			struct perf_counter_attr *attr = perf_header__find_attr(event->id);

[please add a newline here too]

> +			printf("  %d   %d   %s   %Lu\n",
> +			       event->pid, event->tid,
> +			       attr ? __event_name(attr->type, attr->config) : "unknown",
> +			       event->value);
> +		}
> +	}

i'd also suggest to put this function into a helper inline function, 
which can start with:

	if (!show_stat || !show_stat_events)
		return;

That way it looks a (tiny) bit more structured and we win an 
indentation level.

> +	if (show_stat) {
> +		if (!show_stat_event) {
> +			show_stat_events = 0;
> +			show_stat_event_max = 16;
> +			show_stat_event = malloc(show_stat_event_max * sizeof(*show_stat_event));
> +			if (!show_stat_event)
> +				die("cannot allocate show_stat_event array");
> +		}
> +		if (show_stat_events == show_stat_event_max) {
> +			show_stat_event_max *= 2;
> +			show_stat_event = realloc(show_stat_event, show_stat_event_max * sizeof(*show_stat_event));
> +			if (!show_stat_event)
> +				die("cannot enlarge show_stat_event array");
> +		}
> +		memcpy(&show_stat_event[show_stat_events], &event->read, sizeof(struct read_event));
> +		show_stat_events++;
> +	}

this too could move into a helper inline function.

> @@ -1998,6 +2046,8 @@
>  		    "Show a column with the number of samples"),
>  	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
>  		   "sort by key(s): pid, comm, dso, symbol, parent"),
> +	OPT_BOOLEAN('S', "stat", &show_stat,
> +		    "show per-thread event counters"),

Ok, there's indeed a flag clash with -s/--sort as you noticed.

-S looks good to me, how about going one step further and changing 
perf record to use -S/--stat as well, to make the flag consistent 
across all tools?

In any case, this patch moves into the right direction - this kind 
of functionality is exactly what we need.

	Ingo
