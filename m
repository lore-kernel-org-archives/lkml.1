Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZHHBKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZHHBKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZHHBKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:10:13 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:33952 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZHHBKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fkVaMTyRVjoig/S41BcUcktNDyhkj9Qu7VFXlRWnSWaqoNhcl7+l6FyKyQZbO3NyX+
         NJcJICSbNw23n7/xXrr1ka8qCtGo9CQFfEevxffCyc91zZr/vX/TRaS7tL3ROMXdRKnS
         Ygf8fQbjM/wa/kiUTvnYQx+kzn+vIOVtn2ueE=
Date: Sat, 8 Aug 2009 03:10:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/4] perf tools: callchain: Warn only once in empty
	node detection
Message-ID: <20090808011007.GO4999@nowhere>
References: <1249690585-9145-1-git-send-email-fweisbec@gmail.com> <20090808010648.GL4339@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808010648.GL4339@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:06:48PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Aug 08, 2009 at 02:16:22AM +0200, Frederic Weisbecker escreveu:
> > When we fill a new node that is found to be empty (sign of a bug),
> > we print a message each time that happens. Sometimes we reach thousands
> > of lines printed.
> > 
> > Just warn only once in that case (and use stderr instead of stdout).
> 
> Wouldn't this be better done with a macro so that the every message is
> print once instead of any fprintf_once message?



Doh! You're right...
/me slaps his face.


 
> I think it would even be nice to just use the same thing the kernel
> uses... WARN_ON_ONCE, and also using asm/bug.h, etc, just add it to
> tools/perf/util/include/asm, etc.
> 


Ok, I'll try that.



> That way one can even forget that this is not kernel programming... :-)

Hehe :)


> - Arnaldo
>  
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > ---
> >  tools/perf/util/callchain.c |    3 ++-
> >  tools/perf/util/util.h      |    3 +++
> >  tools/perf/util/wrapper.c   |   16 ++++++++++++++++
> >  3 files changed, 21 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> > index 98c5627..ce0c6d4 100644
> > --- a/tools/perf/util/callchain.c
> > +++ b/tools/perf/util/callchain.c
> > @@ -13,6 +13,7 @@
> >  #include <stdio.h>
> >  #include <stdbool.h>
> >  #include <errno.h>
> > +#include "util.h"
> >  
> >  #include "callchain.h"
> >  
> > @@ -203,7 +204,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
> >  	}
> >  	node->val_nr = chain->nr - start;
> >  	if (!node->val_nr)
> > -		printf("Warning: empty node in callchain tree\n");
> > +		fprintf_once(stderr, "Warning: empty node in callchain tree\n");
> >  }
> >  
> >  static void
> > diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> > index 68fe157..386ea40 100644
> > --- a/tools/perf/util/util.h
> > +++ b/tools/perf/util/util.h
> > @@ -148,6 +148,9 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
> >  	return strncmp(str, prefix, len) ? NULL : str + len;
> >  }
> >  
> > +extern int fprintf_once(FILE *fp, const char *fmt, ...)
> > +	__attribute__((format (printf, 2, 3)));
> > +
> >  #if defined(NO_MMAP) || defined(USE_WIN32_MMAP)
> >  
> >  #ifndef PROT_READ
> > diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
> > index 4574ac2..026c87c 100644
> > --- a/tools/perf/util/wrapper.c
> > +++ b/tools/perf/util/wrapper.c
> > @@ -205,3 +205,19 @@ int xmkstemp(char *template)
> >  		die("Unable to create temporary file: %s", strerror(errno));
> >  	return fd;
> >  }
> > +
> > +int fprintf_once(FILE *fp, const char *fmt, ...)
> > +{
> > +	va_list args;
> > +	int ret;
> > +	static int once;
> > +
> > +	if (once++)
> > +		return 1;
> > +
> > +	va_start(args, fmt);
> > +	ret = vfprintf(fp, fmt, args);
> > +	va_end(args);
> > +
> > +	return ret;
> > +}
> > -- 
> > 1.6.2.3

