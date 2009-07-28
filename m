Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZG1DKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZG1DKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZG1DKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:10:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57558 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZG1DKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DtIIzZI1p4yEC4Fw6PB2x0051FmQRqY8RCqSt5yBhdLbo0CETHmd4SgZQ2jNKJww0E
         GdEo4ev6oqClQ3R2x0noCs/F/OK1UUosSPL3tEVzi3ReS718GkzTCVmOgzk2aUaxKy/i
         xMCnrQQ+qR9E83P0d7lfRHyury+5bHCF6Nxbk=
Date: Tue, 28 Jul 2009 05:10:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clark Williams <williams@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf report: Introduce -u/--unresolved-symbols
Message-ID: <20090728031049.GG5147@nowhere>
References: <20090721201126.GH3091@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721201126.GH3091@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 05:11:26PM -0300, Arnaldo Carvalho de Melo wrote:
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



Looks pretty useful :-)

Thanks!
Frederic.



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
>  };
>  
> -- 
> 1.6.2.5
> 

