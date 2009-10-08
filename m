Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZJHUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZJHUeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZJHUeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:34:21 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:64204 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZJHUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tqiEMrt+toWpEpUYiuX9zoMzf6ua7lOZsujqmLv8Ehd++d1YcBDAJUUMRIMB145sPC
         eEuFbddqQZV8HvVUBFjB2kUuFf1DphV3C7V6o2aL8lD+K3TCsj3KHB4u9/00fiTl4Lux
         zi9f631gErb3JOUDs4gCoi6KgQ4GWSD0dLdzk=
Date: Thu, 8 Oct 2009 22:28:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Provide backward compatibility with
	previous perf.data version
Message-ID: <20091008202828.GF5073@nowhere>
References: <1255032449-12022-1-git-send-email-fweisbec@gmail.com> <20091008201222.GB30594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008201222.GB30594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 10:12:22PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > We have merged the trace.info file into perf.data by adding one 
> > section in the perf headers. This makes it incompatible with previous 
> > version: the new perf tools can't read the older perf.data.
> > 
> > To support the previous format, we check the headers size. If they 
> > have the same size than in the previous format, then ignore the trace 
> > info section that doesn't exist.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > ---
> >  tools/perf/util/header.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index 212fade..9aae360 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -287,10 +287,16 @@ struct perf_header *perf_header__read(int fd)
> >  	do_read(fd, &f_header, sizeof(f_header));
> >  
> >  	if (f_header.magic	!= PERF_MAGIC		||
> > -	    f_header.size	!= sizeof(f_header)	||
> >  	    f_header.attr_size	!= sizeof(f_attr))
> >  		die("incompatible file format");
> >  
> > +	if (f_header.size != sizeof(f_header)) {
> > +		/* Support the previous format */
> > +		if (f_header.size == offsetof(typeof(f_header), trace_info))
> > +			f_header.trace_info.size = 0;
> > +		else
> > +			die("incompatible file format");
> > +	}
> >  	nr_attrs = f_header.attrs.size / sizeof(f_attr);
> >  	lseek(fd, f_header.attrs.offset, SEEK_SET);
> 
> Perfect - thanks Frederic!
> 
> This should handle most of the (non-trace) perf.data's out there. 


Yeah, hopefully. I've only tested in a simple old perf.data but
that should do the trick for all of the non-trace files.


> trace.info is not something we really want to be backwards compatible 
> about, if we can avoid it.
> 
> 	Ingo


Yeah, that said, it's still possible and wouldn't require too much changes.
May be let's wait for complaints and, if any, I can provide this backward
support too.

Thanks.

