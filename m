Return-Path: <linux-kernel-owner+w=401wt.eu-S965774AbXCPRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774AbXCPRgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965777AbXCPRgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:36:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:51049 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965756AbXCPRge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:36:34 -0400
Date: Fri, 16 Mar 2007 20:40:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch added to -mm tree
Message-ID: <20070316174028.GA233@tv-sign.ru>
References: <20070316171023.GA218@tv-sign.ru> <200703161823.57858.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703161823.57858.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Eric Dumazet wrote:
>
> On Friday 16 March 2007 18:10, Oleg Nesterov wrote:
> > Eric Dumazet wrote:
> > > @@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
> > >  			r->ru_nivcsw = p->signal->cnivcsw;
> > >  			r->ru_minflt = p->signal->cmin_flt;
> > >  			r->ru_majflt = p->signal->cmaj_flt;
> > > +			r->ru_inblock = task_io_get_inblock(p);
> > > +			r->ru_oublock = task_io_get_oublock(p);
> > >
> > >  			if (who == RUSAGE_CHILDREN)
> > >  				break;
> > > @@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
> > >  			r->ru_nivcsw += p->signal->nivcsw;
> > >  			r->ru_minflt += p->signal->min_flt;
> > >  			r->ru_majflt += p->signal->maj_flt;
> > > +			r->ru_inblock += task_io_get_inblock(p);
> > > +			r->ru_oublock += task_io_get_oublock(p);
> > >  			t = p;
> > >  			do {
> > >  				utime = cputime_add(utime, t->utime);
> > > @@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
> > >  				r->ru_nivcsw += t->nivcsw;
> > >  				r->ru_minflt += t->min_flt;
> > >  				r->ru_majflt += t->maj_flt;
> > > +				r->ru_inblock += task_io_get_inblock(t);
> > > +				r->ru_oublock += task_io_get_oublock(t);
> >
> > I can't understand this. Consider k_getrusage(RUSAGE_BOTH). The end result
> > is that r->ru_inblock == 3 * task_io_get_inblock(p).
> >
> > No?
> 
> Yes :)
> 
> Very good point, you found a bug in k_getrusage().

No, no, please check the code.

> So not only ru_inblock/ru_oublock are multiplied by 3 : others fields as well 
> are wrong.
> 
> Also the definition of RUSAGE_CHILDREN is not conformant to standard
> 
> http://www.opengroup.org/onlinepubs/009695399/functions/getrusage.html
> 
> 	"If the value of the who argument is RUSAGE_CHILDREN, information shall be 
> 	"returned about resources used by the terminated and waited-for children of 
> 	"the current process

This exactly happens. We are reading ->signal->*, see wait_task_zombie().

> We currently do a sum of rusage stats of still alive children.. thats totally 
> wrong...

I hope not :)

Oleg.

