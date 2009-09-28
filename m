Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZI1OCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZI1OCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZI1OCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:02:01 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48703 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZI1OCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HocXfzqkDbBo2SAjpKAAdg/SSKTk7cws0Q1XmsKkxOzPf82CoPSIkQm/YlCTMTM06t
         Xxu8AP1D8qjMu25gdFKsNE+Av7sDs8Gnt5wpAPsYQsTACyPexh90aMD5cULSBF7asSFe
         lcwcX5n3gzNcf4pziz26WjvTZMjrZTWSTGws8=
Date: Mon, 28 Sep 2009 16:02:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] Put common histogram functions for perf in their own
	file
Message-ID: <20090928140158.GA6178@nowhere>
References: <alpine.LFD.2.00.0909281457530.8316@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909281457530.8316@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:05:29PM +0200, John Kacur wrote:
> From d187ab3a62526ffbdff91911f4b2da813ccf037f Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Mon, 28 Sep 2009 14:53:08 +0200
> Subject: [PATCH] Move histogram related functions into their own files (hist.c and hist.h)
>  and make use of them in builtin-annotate.c and builtin-report.c



I guess a part of the title should be in the changelog, and the title
should be a compressed version :)


 
> Signed-off-by: John Kacur <jkacur@redhat.com>
>  static int
>  process_sample_event(event_t *event, unsigned long offset, unsigned long head)
>  {
> @@ -861,7 +713,7 @@ more:
>  		dsos__fprintf(stdout);
>  
>  	collapse__resort();
> -	output__resort();
> +	output__resort(total);



Now I wonder if we actually ever need to sort the entries
in perf annotate. The only thing we need is to count the
hits per ip.


>  
>  	find_annotations();
>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 7b43504..ff6de9e 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -28,6 +28,7 @@
>  
>  #include "util/thread.h"
>  #include "util/sort.h"
> +#include "util/hist.h"
>  
>  static char		const *input_name = "perf.data";
>  
> @@ -55,8 +56,6 @@ static int		exclude_other = 1;
>  
>  static char		callchain_default_opt[] = "fractal,0.5";
>  
> -static int		callchain;
> -
>  static char		__cwd[PATH_MAX];
>  static char		*cwd = __cwd;
>  static int		cwdlen;
> @@ -66,50 +65,8 @@ static struct thread	*last_match;
>  
>  static struct perf_header *header;
>  
> -static
> -struct callchain_param	callchain_param = {
> -	.mode	= CHAIN_GRAPH_REL,
> -	.min_percent = 0.5
> -};



At least for now, this part is only used by report. May be better
keep it in report?

Concerning the whole, that looks nice. Especially annotate doesn't
even seem to need any sort.

So we could eventually keep the hist sorting only in report.
But that said, it's nice to make all these sorting and histogram
features in a separate file for general purpose. We can bet that will
be reused soon or later. If not this is still good to split it, to clear
a bit builtin-report.c

But the callchain bits should perhaps stay in report. If that needs
to be used elsewhere, it would need a kind of cleanup before.

