Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZJHUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZJHUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZJHUc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:32:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZJHUcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:32:25 -0400
Date: Thu, 8 Oct 2009 22:31:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Provide backward compatibility with
	previous perf.data version
Message-ID: <20091008203137.GA17527@elte.hu>
References: <1255032449-12022-1-git-send-email-fweisbec@gmail.com> <20091008201222.GB30594@elte.hu> <20091008202828.GF5073@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008202828.GF5073@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Oct 08, 2009 at 10:12:22PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > We have merged the trace.info file into perf.data by adding one 
> > > section in the perf headers. This makes it incompatible with previous 
> > > version: the new perf tools can't read the older perf.data.
> > > 
> > > To support the previous format, we check the headers size. If they 
> > > have the same size than in the previous format, then ignore the trace 
> > > info section that doesn't exist.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > ---
> > >  tools/perf/util/header.c |    8 +++++++-
> > >  1 files changed, 7 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > > index 212fade..9aae360 100644
> > > --- a/tools/perf/util/header.c
> > > +++ b/tools/perf/util/header.c
> > > @@ -287,10 +287,16 @@ struct perf_header *perf_header__read(int fd)
> > >  	do_read(fd, &f_header, sizeof(f_header));
> > >  
> > >  	if (f_header.magic	!= PERF_MAGIC		||
> > > -	    f_header.size	!= sizeof(f_header)	||
> > >  	    f_header.attr_size	!= sizeof(f_attr))
> > >  		die("incompatible file format");
> > >  
> > > +	if (f_header.size != sizeof(f_header)) {
> > > +		/* Support the previous format */
> > > +		if (f_header.size == offsetof(typeof(f_header), trace_info))
> > > +			f_header.trace_info.size = 0;
> > > +		else
> > > +			die("incompatible file format");
> > > +	}
> > >  	nr_attrs = f_header.attrs.size / sizeof(f_attr);
> > >  	lseek(fd, f_header.attrs.offset, SEEK_SET);
> > 
> > Perfect - thanks Frederic!
> > 
> > This should handle most of the (non-trace) perf.data's out there. 
> 
> 
> Yeah, hopefully. I've only tested in a simple old perf.data but that 
> should do the trick for all of the non-trace files.

yeah, i tested it on an old perf.data too, and it worked.

> > trace.info is not something we really want to be backwards compatible 
> > about, if we can avoid it.
> > 
> > 	Ingo
> 
> 
> Yeah, that said, it's still possible and wouldn't require too much 
> changes. May be let's wait for complaints and, if any, I can provide 
> this backward support too.

ok.

	Ingo
