Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZCRSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZCRSAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbZCRSAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:00:16 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34180 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455AbZCRSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YIzvS6e84A8m8hsMKZyiZxbk3FmdjJOJpvR2ycj2ZYgZMGQgdW76/ELxBB8FfDiSN3
         CuxuRfTaT+w7gHsT98rInChOVuaye3VSZagjowVruqI+ebEjrchsRYyXN9rt79lyssii
         rincyZC9j1ioRlVydWLyOcaKNekWlAUrUqmks=
Date: Wed, 18 Mar 2009 19:00:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] tracing: fix oops in
	tracepoint_update_probe_range()
Message-ID: <20090318180007.GE5981@nowhere>
References: <1237394936.3132.1.camel@localhost.localdomain> <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org> <1237398997.22438.10.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237398997.22438.10.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 11:26:37PM +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-03-18 at 17:51 +0000, Jaswinder Singh Rajput wrote:
> > Commit-ID:  966a6fdf6210e3ac8ce00b61cd1107cdf97ce744
> > Gitweb:     http://git.kernel.org/tip/966a6fdf6210e3ac8ce00b61cd1107cdf97ce744
> > Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> > AuthorDate: Wed, 18 Mar 2009 22:18:56 +0530
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 18 Mar 2009 18:48:43 +0100
> > 
> > tracing: fix oops in tracepoint_update_probe_range()
> > 
> > Change this crash:
> > 
> >  BUG: unable to handle kernel NULL pointer dereference at (null)
> >  IP: [<ffffffff8107d4de>] tracepoint_update_probe_range+0x1f/0x9b
> >  PGD 13d5fb067 PUD 13d688067 PMD 0
> >  Oops: 0000 [#1] SMP
> > 
> > To a more debuggable WARN_ONCE().
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > LKML-Reference: <1237394936.3132.1.camel@localhost.localdomain>
> > [ moved the check outside the lock and added a WARN_ON(). ]
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  kernel/tracepoint.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 7960274..dd15df9 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -272,12 +272,17 @@ static void disable_tracepoint(struct tracepoint *elem)
> >   *
> >   * Updates the probe callback corresponding to a range of tracepoints.
> >   */
> > -void tracepoint_update_probe_range(struct tracepoint *begin,
> > -	struct tracepoint *end)
> > +void
> > +tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
> >  {
> >  	struct tracepoint *iter;
> >  	struct tracepoint_entry *mark_entry;
> >  
> > +	if (!iter) {
> > +		WARN_ON_ONCE(1);
> > +		return;
> > +	}
> > +
> >  	mutex_lock(&tracepoints_mutex);
> >  	for (iter = begin; iter < end; iter++) {
> >  		mark_entry = get_tracepoint(iter->name);
> 
> my original patch was correct.
> 
> --
> JSR
> 
> 

Jaswinder, It's hard for me to reproduce it via your config.
May be it's because I had to update it to match latest -tip tree and
then I inserted some noise inside.

Could you please send me your bad vmlinux, so that I can have a first look at
your elf sections and see if there is something helpful inside.

Thanks.

