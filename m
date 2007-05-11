Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXEKXh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXEKXh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXEKXhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:37:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXEKXhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:37:17 -0400
Date: Sat, 12 May 2007 01:37:01 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Use boot based time for process start time and boot
	time in /proc
Message-ID: <20070511233701.GA13437@redhat.com>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz> <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz> <20070510164047.263a9524.akpm@linux-foundation.org> <20070511084531.GA31854@redhat.com> <20070511125132.93a4abdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511125132.93a4abdd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 11, 2007 at 12:51:32PM -0700, Andrew Morton wrote:
> On Fri, 11 May 2007 10:45:31 +0200
> Tomas Janousek <tjanouse@redhat.com> wrote:
> 
> > Hello,
> > 
> > On Thu, May 10, 2007 at 04:40:47PM -0700, Andrew Morton wrote:
> > > Tomas Janousek <tjanouse@redhat.com> wrote:
> > > > @@ -445,12 +445,14 @@ static int show_stat(struct seq_file *p, void *v)
> > > >  	unsigned long jif;
> > > >  	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
> > > >  	u64 sum = 0;
> > > > +	struct timespec boottime;
> > > >  
> > > >  	user = nice = system = idle = iowait =
> > > >  		irq = softirq = steal = cputime64_zero;
> > > > -	jif = - wall_to_monotonic.tv_sec;
> > > > -	if (wall_to_monotonic.tv_nsec)
> > > > -		--jif;
> > > > +	getboottime(&boottime);
> > > > +	jif = boottime.tv_sec;
> > > > +	if (boottime.tv_nsec)
> > > > +		++jif;
> > > >
> > > 

> >  	getboottime(&boottime);
> >  	jif = boottime.tv_sec;
> > -	if (boottime.tv_nsec)
> > -		++jif;
> >  

> So we've gone from --jif to ++jif to no change at all.
> 
> Are you sure that this net removal of --jif is correct?

Yes.

Let's say wall_to_monotonic = { -10, 500000 }  (which is { -9, -500000 }, and
the original code would result in - (- 10) - 1 == 9).

The getboottime calls set_normalized_timespec on { - (-10), - (500000) } which
results to { 10 - 1, - 500000 + 1000000 } = { 9, 500000 }.
tv_sec == 9  =>  correct.

-- 
TJ. (Brno, CZ), BaseOS, Red Hat
