Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZF2Uez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZF2Uez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZF2Ues
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:34:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZF2Uer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:34:47 -0400
Date: Mon, 29 Jun 2009 22:34:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf_counter: tools: Make :u and :k exclude
	hypervisor
Message-ID: <20090629203443.GH31577@elte.hu>
References: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> At present, appending ":u" to an event sets the exclude_kernel 
> bit, and ":k" sets the exclude_user bit.  There is no way to set 
> the exclude_hv bit, which means that on systems with a hypervisor 
> (e.g. IBM pSeries systems), we get counts from hypervisor mode for 
> an event such as 0:1:u.
> 
> This fixes the problem by setting all three exclude bits when we 
> see the second ':' and the clearing the exclude bits corresponding 
> to the modes we want to count.  This also adds a ":h" modifier to 
> allow the user to ask for counts in hypervisor mode.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  tools/perf/util/parse-events.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 4d042f1..f2ffe2c 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -277,10 +277,15 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
>  		sep = strchr(pstr, ':');
>  		if (sep) {
>  			pstr = sep + 1;
> +			attr->exclude_user = 1;
> +			attr->exclude_kernel = 1;
> +			attr->exclude_hv = 1;
>  			if (strchr(pstr, 'k'))
> -				attr->exclude_user = 1;
> +				attr->exclude_kernel = 0;
>  			if (strchr(pstr, 'u'))
> -				attr->exclude_kernel = 1;
> +				attr->exclude_user = 0;
> +			if (strchr(pstr, 'h'))
> +				attr->exclude_hv = 0;
>  		}

Hm, mind fixing the full range of problems with these flags please?

One problem is that things like:

	--event cycles:u

dont work as expected - the u/k/h flags only work in numeric events 
which is a pity. Also, it would be nice to have an 'general' option 
to specify the context mask for all events, in some straightforward 
format like this:

	--event-mask +u+k-h

Things like that. This bit is really not well developed right now.

	Ingo
