Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZHHBML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZHHBML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbZHHBMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:12:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbZHHBMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:12:09 -0400
Date: Fri, 7 Aug 2009 22:06:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/4] perf tools: callchain: Warn only once in empty
	node detection
Message-ID: <20090808010648.GL4339@ghostprotocols.net>
References: <1249690585-9145-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249690585-9145-1-git-send-email-fweisbec@gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 08, 2009 at 02:16:22AM +0200, Frederic Weisbecker escreveu:
> When we fill a new node that is found to be empty (sign of a bug),
> we print a message each time that happens. Sometimes we reach thousands
> of lines printed.
> 
> Just warn only once in that case (and use stderr instead of stdout).

Wouldn't this be better done with a macro so that the every message is
print once instead of any fprintf_once message?

I think it would even be nice to just use the same thing the kernel
uses... WARN_ON_ONCE, and also using asm/bug.h, etc, just add it to
tools/perf/util/include/asm, etc.

That way one can even forget that this is not kernel programming... :-)

- Arnaldo
 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  tools/perf/util/callchain.c |    3 ++-
>  tools/perf/util/util.h      |    3 +++
>  tools/perf/util/wrapper.c   |   16 ++++++++++++++++
>  3 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 98c5627..ce0c6d4 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -13,6 +13,7 @@
>  #include <stdio.h>
>  #include <stdbool.h>
>  #include <errno.h>
> +#include "util.h"
>  
>  #include "callchain.h"
>  
> @@ -203,7 +204,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
>  	}
>  	node->val_nr = chain->nr - start;
>  	if (!node->val_nr)
> -		printf("Warning: empty node in callchain tree\n");
> +		fprintf_once(stderr, "Warning: empty node in callchain tree\n");
>  }
>  
>  static void
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 68fe157..386ea40 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -148,6 +148,9 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
>  	return strncmp(str, prefix, len) ? NULL : str + len;
>  }
>  
> +extern int fprintf_once(FILE *fp, const char *fmt, ...)
> +	__attribute__((format (printf, 2, 3)));
> +
>  #if defined(NO_MMAP) || defined(USE_WIN32_MMAP)
>  
>  #ifndef PROT_READ
> diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
> index 4574ac2..026c87c 100644
> --- a/tools/perf/util/wrapper.c
> +++ b/tools/perf/util/wrapper.c
> @@ -205,3 +205,19 @@ int xmkstemp(char *template)
>  		die("Unable to create temporary file: %s", strerror(errno));
>  	return fd;
>  }
> +
> +int fprintf_once(FILE *fp, const char *fmt, ...)
> +{
> +	va_list args;
> +	int ret;
> +	static int once;
> +
> +	if (once++)
> +		return 1;
> +
> +	va_start(args, fmt);
> +	ret = vfprintf(fp, fmt, args);
> +	va_end(args);
> +
> +	return ret;
> +}
> -- 
> 1.6.2.3
