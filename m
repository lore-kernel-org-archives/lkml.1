Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbXCPRX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbXCPRX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCPRX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:23:59 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:58058 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965755AbXCPRX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:23:58 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: + getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch added to -mm tree
Date: Fri, 16 Mar 2007 18:23:57 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070316171023.GA218@tv-sign.ru>
In-Reply-To: <20070316171023.GA218@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161823.57858.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 18:10, Oleg Nesterov wrote:
> Eric Dumazet wrote:
> > @@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
> >  			r->ru_nivcsw = p->signal->cnivcsw;
> >  			r->ru_minflt = p->signal->cmin_flt;
> >  			r->ru_majflt = p->signal->cmaj_flt;
> > +			r->ru_inblock = task_io_get_inblock(p);
> > +			r->ru_oublock = task_io_get_oublock(p);
> >
> >  			if (who == RUSAGE_CHILDREN)
> >  				break;
> > @@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
> >  			r->ru_nivcsw += p->signal->nivcsw;
> >  			r->ru_minflt += p->signal->min_flt;
> >  			r->ru_majflt += p->signal->maj_flt;
> > +			r->ru_inblock += task_io_get_inblock(p);
> > +			r->ru_oublock += task_io_get_oublock(p);
> >  			t = p;
> >  			do {
> >  				utime = cputime_add(utime, t->utime);
> > @@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
> >  				r->ru_nivcsw += t->nivcsw;
> >  				r->ru_minflt += t->min_flt;
> >  				r->ru_majflt += t->maj_flt;
> > +				r->ru_inblock += task_io_get_inblock(t);
> > +				r->ru_oublock += task_io_get_oublock(t);
>
> I can't understand this. Consider k_getrusage(RUSAGE_BOTH). The end result
> is that r->ru_inblock == 3 * task_io_get_inblock(p).
>
> No?

Yes :)

Very good point, you found a bug in k_getrusage().

I just followed the existing logic, but it seems this logic is bad.

So not only ru_inblock/ru_oublock are multiplied by 3 : others fields as well 
are wrong.

Also the definition of RUSAGE_CHILDREN is not conformant to standard

http://www.opengroup.org/onlinepubs/009695399/functions/getrusage.html

	"If the value of the who argument is RUSAGE_CHILDREN, information shall be 
	"returned about resources used by the terminated and waited-for children of 
	"the current process

We currently do a sum of rusage stats of still alive children.. thats totally 
wrong...

Eric
