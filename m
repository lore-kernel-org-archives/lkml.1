Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZHBUFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZHBUFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZHBUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:05:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZHBUFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:05:45 -0400
Date: Sun, 2 Aug 2009 22:05:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clark Williams <williams@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf report: Introduce -u/--unresolved-symbols
Message-ID: <20090802200533.GG24486@elte.hu>
References: <20090721201126.GH3091@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721201126.GH3091@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> So that we can concentrate on getting more symtabs or on figuring out
> which files we have to recompile with -g or ask proprietary vendors for
> graciously ship us rich symtabs.
> 
> For instance, shame on me:
> 
>  [acme@doppio ~]$ perf report -us comm,dso,symbol | head -7
>  # Samples: 22501
>  #
>  # Overhead       Command                           Shared Object        Symbol
>  # ........  ............  ............................................  ......
>  # 
>      82.53%  npviewer.bin  /usr/lib64/mozilla/plugins/libflashplayer.so  [.] 0x000000003820d7
>       6.34%         skype  /opt/skype_static-2.0.0.72/skype              [.] 0x00000000e1e0b1
> 
> ;-)
> 
> But the next cset should be rather nice, as I realized that doing:
> 
> yum install /usr/lib/debug/<DSO NAME WITH MISSING SYMTAB>.debug
> 
> Works!
> 
> Now think about a world where:
> 
> yum install /usr/lib/debug/<DSO NAME WITH MISSING SYMTAB>.symtab
> 
> Works, makes the internet a better place by not downloading whales,
> oops, debuginfo files full of crap we don't need.
> 
> Don't get me wrong, the aforementioned crap has its place in this world,
> just not for the perf tools, _so far_.
> 
> Ah, and replace 'yum' with zypper, apt-get (I tried!), smart, urpmi,
> whatever-is-your-still-non-standardized way to get needed pieces to do
> real work.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>,
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Documentation/perf-report.txt |    5 +++++
>  tools/perf/builtin-report.c              |   11 +++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index e72e931..86aec08 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -48,6 +48,11 @@ OPTIONS
>  	all occurances of this separator in symbol names (and other output)
>  	with a '.' character, that thus it's the only non valid separator.
>  
> +-u::
> +--unresolved-symbols
> +
> +	Consider only unresolved symbols.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1]
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index a118bc7..c30f4cd 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -52,6 +52,7 @@ static int		modules;
>  
>  static int		full_paths;
>  static int		show_nr_samples;
> +static int		show_only_unresolved_symbols;
>  
>  static unsigned long	page_size;
>  static unsigned long	mmap_window = 32;
> @@ -1556,8 +1557,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
>  		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
>  			return 0;
>  
> -		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
> -			return 0;
> +		if (sym) {
> +			if (show_only_unresolved_symbols)
> +				return 0;
> +			if (sym_list && !strlist__has_entry(sym_list, sym->name))
> +				return 0;
> +		}
>  
>  		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
>  			eprintf("problem incrementing symbol count, skipping event\n");
> @@ -2020,6 +2025,8 @@ static const struct option options[] = {
>  	OPT_STRING('t', "field-separator", &field_sep, "separator",
>  		   "separator for columns, no spaces will be added between "
>  		   "columns '.' is reserved."),
> +	OPT_BOOLEAN('u', "unresolved-symbols", &show_only_unresolved_symbols,
> +		    "Show only the symbols that were no resolved to names"),
>  	OPT_END()

Looks nice!

How about also adding an option to initiate the yum install (or 
apt-get, etc.) debuginfo package installation automatically? It 
would be a nice 'plug and play' touch.

	Ingo
