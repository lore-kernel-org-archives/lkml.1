Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbZEONdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbZEONdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZEONd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:33:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZEONd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:33:27 -0400
Date: Fri, 15 May 2009 15:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 4/4] perf_counter: update perf-top to use the new freq
	interface
Message-ID: <20090515133319.GA1225@elte.hu>
References: <20090515131925.616419905@chello.nl> <20090515132018.707922166@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515132018.707922166@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Provide perf top -F as alternative to -c.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> ---
>  Documentation/perf_counter/builtin-top.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/Documentation/perf_counter/builtin-top.c
> ===================================================================
> --- linux-2.6.orig/Documentation/perf_counter/builtin-top.c
> +++ linux-2.6/Documentation/perf_counter/builtin-top.c
> @@ -98,6 +98,7 @@ static unsigned int		page_size;
>  static unsigned int		mmap_pages			=  16;
>  static int			use_mmap			= 0;
>  static int			use_munmap			= 0;
> +static int			freq				= 0;
>  
>  static char			*vmlinux;
>  
> @@ -846,9 +847,10 @@ static void process_options(int argc, ch
>  			{"stat",	no_argument,		NULL, 'S'},
>  			{"vmlinux",	required_argument,	NULL, 'x'},
>  			{"zero",	no_argument,		NULL, 'z'},
> +			{"freq",	required_argument,	NULL, 'F'},
>  			{NULL,		0,			NULL,  0 }
>  		};
> -		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMU",
> +		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMUF:",
>  				    long_options, &option_index);
>  		if (c == -1)
>  			break;
> @@ -889,6 +891,7 @@ static void process_options(int argc, ch
>  		case 'm': mmap_pages			=   atoi(optarg); break;
>  		case 'M': use_mmap			=              1; break;
>  		case 'U': use_munmap			=              1; break;
> +		case 'F': freq = 1; default_interval	=   atoi(optarg); break;
>  		default: error = 1; break;
>  		}
>  	}
> @@ -1075,6 +1078,7 @@ int cmd_top(int argc, char **argv, const
>  			hw_event.nmi		= nmi;
>  			hw_event.mmap		= use_mmap;
>  			hw_event.munmap		= use_munmap;
> +			hw_event.freq		= freq;
>  
>  			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
>  			if (fd[i][counter] < 0) {

this frequency-based profiling is nice. It's a lot more untuitive to 
users than rigid defaults of 'one IRQ per 100,000 cycles'.

So i think perf-top should be changed to have -F enabled by default, 
with a default 10 KHz frequency for all counters.

But for that we need another fix for this: currently the histogram 
is 'number of interrupts' based, which gets skewed with frequency 
based profiling.

A correct sorting key would be a normalized histogram, along 'number 
of hardware events', which could be measured as deltas between 
interrupts, like this:

	counter_val: 1200000       [ IRQ ] -> { 1200000, RIP-1 }
                 .
                 .
                 .
        counter_val: 1250000       [ IRQ ] -> { 1250000, RIP-2 }
                 .
                 .
                 .
        counter_val: 1260000       [ IRQ ] -> { 1260000, RIP-3 }

look at how the delta between the first and the second IRQ was 50000 
cycles, while the delta between the second and third IRQ was just 
10000 cycles - because the frequency adjustment code shortened the 
period.

So in the histogram, RIP-2 should get 50,000 cycles, and RIP-3 
should get 10,000 cycles.

With the current scheme both would get +1 event credited - which is 
wrong.

Agreed?

	Ingo
