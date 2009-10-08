Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZJHUXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZJHUXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZJHUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:23:08 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42007 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbZJHUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzkR2PClu6bzW0pqtoBFnXWyM357lh+5wzjYOs1IpCQSrGRch8A/VI8CHm+Q6A2UtK
         jo/3EumowMgP21t/BQM90taHpXtx0pZqYAyraF5nm7+YLnV9gF7Uupst27swx/73vIEc
         uN17t/1ytVbCsXdKse35MSL+df02h5OKSDkcg=
Date: Thu, 8 Oct 2009 22:22:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Provide backward compatibility with
	previous perf.data version
Message-ID: <20091008202226.GE5073@nowhere>
References: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 10:07:29PM +0200, Frederic Weisbecker wrote:
> We have merged the trace.info file into perf.data by adding one section
> in the perf headers. This makes it incompatible with previous version:
> the new perf tools can't read the older perf.data.
> 
> To support the previous format, we check the headers size. If they
> have the same size than in the previous format, then ignore the trace
> info section that doesn't exist.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  tools/perf/util/header.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 212fade..9aae360 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -287,10 +287,16 @@ struct perf_header *perf_header__read(int fd)
>  	do_read(fd, &f_header, sizeof(f_header));
>  
>  	if (f_header.magic	!= PERF_MAGIC		||
> -	    f_header.size	!= sizeof(f_header)	||



Few notes about this.
I can send a separate fix for .32 that would just consist in the above line,
or more likely I can replace it by:

	f_header.size < sizeof(f_header)     ||

and then we'll get a minimal forward compatibility from the older
tools (can be Cc'ed to stable for .31).

Another thing. We may feel the need to add yet another sections
in the future.

So just a suggestion: we could turn this trace_info section into a
more generic one in which we could add as much subsections as we want
in the future while always ensuring backward compatibility. That could
be managed through a versioning of this generic section.

Of course I don't wish too much format modifications
will happen in the future, because it means difficults interaction
between several perf tools versions.

That said, it could still happen if important new needs arise and
I guess we don't want to be blocked by the header size.

The other solution is to continue like I did in this patch: guess the
version of this file format against its size.

Thanks.

