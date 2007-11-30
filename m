Return-Path: <linux-kernel-owner+w=401wt.eu-S934846AbXK3Cq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846AbXK3Cq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763916AbXK3Cqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:46:44 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:43814 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759161AbXK3Cqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:46:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=alFpJEh2/F5bYMEWClrQdW0ZpXsnybY2xbLQQIOf+J0cZ6OQVUAdX9vv9p7MznBdQHx5zid+2ReTQxSIhUb/a0R+aYDv04oD9O44B2pk6Vw9VsI/5eG5Tn1/NX1/zQoFEG8ojpzi0YC/oDzUv0VaoakzwjW1C90ySt97TsdcNNw=  ;
X-YMail-OSG: ie.jxQMVM1ktnyqhWl47x0PazSZDnyPpmF027ccHgk5zItzo
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Fri, 30 Nov 2007 13:46:22 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <20071127145747.5f4d0aca@laptopd505.fenrus.org>
In-Reply-To: <20071127145747.5f4d0aca@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301346.22573.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 09:57, Arjan van de Ven wrote:
> On Tue, 27 Nov 2007 17:33:05 +0800
>
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > If echo "1">/proc/sys/kernel/sched_compat_yield before starting
> > volanoMark testing, the result is very good with kernel 2.6.24-rc3 on
> > my 16-core tigerton.
> >
> > 1) If /proc/sys/kernel/sched_compat_yield=1, comparing with 2.6.22,
> > 2.6.24-rc3 has more than 70% improvement;
> > 2) If /proc/sys/kernel/sched_compat_yield=0, comparing with 2.6.22,
> > 2.6.24-rc3 has more than 80% regression;
> >
> > On other machines, the volanoMark result also has much improvement if
> > /proc/sys/kernel/sched_compat_yield=1.
> >
> > Would you like to change function yield_task_fair to delete codes
> > around sysctl_sched_compat_yield, or just initiate it to 1?
>
> sounds like a bad idea; volanomark (well, technically the jvm behind
> it) is abusing sched_yield() by assuming it does something it really
> doesn't do, and as it happens some of the earlier 2.6 schedulers
> accidentally happened to behave in a way that was nice for this
> benchmark.

OK, why is this still happening? Haven't we been asking JVMs to use
futexes or posix locking for years and years now? Are there any sane
jvms that _don't_ use yield?


> Todays kernel has a different behavior somewhat (and before people
> scream "regression"; sched_yield() behavior isn't really specified and
> doesn't make any sense at all, whatever you get is what you get....
> it's pretty much an insane defacto behavior that is incredibly tied to
> which decisions the scheduler makes how, and no app can depend on that

It is a performance regression. Is there any reason *not* to use the
"compat" yield by default? As you say, for SCHED_OTHER tasks, yield
can do almost anything. We may as well do something that isn't a
regression...


> in any way. In fact, I've proposed to make sched_yield() just do an
> msleep(1)... that'd be closer to what sched_yield is supposed to do
> standard wise than any of the current behaviors .... ;_

What makes you say that? IIRC of all the things that sched_yeild can
do, it is not allowed to block. So this is about the only thing that
will break the standard...
