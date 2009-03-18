Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZCRReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZCRReK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZCRRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:33:55 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51985 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZCRRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHFHqiy4dag7xYaAfvoNS5pb5qk9cMjTj2nWH8TdjigppWX5+FDD6RLz8jGsunlsET
         jWQmLhUMgKv4V464vH0tN6mnBwiAo+bJGxWuz4sBXnKVnTcEDdZiH01Qkiiy1wskEh32
         /siIOI9i6PB6woxgIL+nSQaZZy1cEotoxXL04=
Date: Wed, 18 Mar 2009 18:33:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range() (was: Re: [oops -tip]
	: x86 AMD 64)
Message-ID: <20090318173347.GD5981@nowhere>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <1237394936.3132.1.camel@localhost.localdomain> <20090318165611.GC5981@nowhere> <20090318172750.GA13584@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318172750.GA13584@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 06:27:50PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Mar 18, 2009 at 10:18:56PM +0530, Jaswinder Singh Rajput wrote:
> > > On Wed, 2009-03-18 at 17:35 +0100, Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > Good: f4c3c4cdb1de232
> > > > > Bad : 1e08816af0bc345
> > > > > 
> > > > > Config:
> > > > > http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> > > > > 
> > > > > oops:
> > > > > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> > > > > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> > > > > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> > > > > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> > > > > 
> > > > > <freeze>
> > > > 
> > > > Steve, Frederic - the crashes above are in:
> > > > 
> > > > 	tracepoint_update_probe_range()
> > > > 
> > > > in a modular kernel apparently.
> > > > 
> > > 
> > > This fixed the oops for me, Is this looks OK to you:
> > > 
> > > Subject: [PATCH] x86: tracepoint.c fix oops
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at (null)
> > > IP: [<ffffffff8107d4de>] tracepoint_update_probe_range+0x1f/0x9b
> > > PGD 13d5fb067 PUD 13d688067 PMD 0
> > > Oops: 0000 [#1] SMP
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  kernel/tracepoint.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > > index 7960274..80d1353 100644
> > > --- a/kernel/tracepoint.c
> > > +++ b/kernel/tracepoint.c
> > > @@ -280,6 +280,8 @@ void tracepoint_update_probe_range(struct tracepoint *begin,
> > >  
> > >  	mutex_lock(&tracepoints_mutex);
> > >  	for (iter = begin; iter < end; iter++) {
> > > +		if (!iter)
> > > +			goto out;
> > >  		mark_entry = get_tracepoint(iter->name);
> > >  		if (mark_entry) {
> > >  			set_tracepoint(&mark_entry, iter,
> > > @@ -288,6 +290,7 @@ void tracepoint_update_probe_range(struct tracepoint *begin,
> > >  			disable_tracepoint(iter);
> > >  		}
> > >  	}
> > > +out:
> > >  	mutex_unlock(&tracepoints_mutex);
> > >  }
> > 
> > 
> > Ok, it should fix the crash.
> > But I think the real problem remains: iter is not supposed to point to NULL,
> > this is a section range:
> > 
> > tracepoint_update_probe_range(__start___tracepoints,
> > 		__stop___tracepoints);
> > 
> > It seems to mean that the section is empty.
> 
> OK - so checking for !iter on entry and emitting a WARN_ONCE in that 
> case ought to change the crash for a warning, right?
> 
> 	Ingo


The real bug is elsewhere, Jaswinder has one user of tracepoints
which is blktrace.
So this section is not supposed to be empty.

But, I guess it is possible to raise via a randconfig by enabling
CONFIG_TRACEPOINTS without any user of it because when a module
is loaded, the section is checked without the !NULL safety.

Thus I think Jaswinder's patch could be picked without WARN or anything,
because this situation can happen in a normal randconfig case.

Concerning the real bug (there is blktrace here, so this NULL is weird)
I'm building Jaswinder's config, may be I will find something...

