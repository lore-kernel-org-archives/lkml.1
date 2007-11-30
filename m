Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbXK3D3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbXK3D3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763216AbXK3D3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:29:34 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:47099 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762406AbXK3D3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:29:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nMXuscf3tJZDMuMVAY68W1NrZ9getlmczv/LBvY/Vi23LhOeKOQCxGiU+nx5aO16ef3NBI40NfhaNaJS3oHxeNQMpMHzQ8vKE0kdYD/8QuT2wFRRoHrui4nfDAcZK4JBdk5jFDIez6zAhZXr7Ny1GM7d2bMcRDy25tjsLBLTiOo=  ;
X-YMail-OSG: Py8x_VcVM1lH6N5Lw5r1fiIcPEH50va5lYYLSA3NvXksTx1YrQV0_qnasycEy6Y_dj9NRawuOA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Fri, 30 Nov 2007 14:29:15 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200711301346.22573.nickpiggin@yahoo.com.au> <1196392527.25646.65.camel@ymzhang>
In-Reply-To: <1196392527.25646.65.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301429.15664.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 14:15, Zhang, Yanmin wrote:
> On Fri, 2007-11-30 at 13:46 +1100, Nick Piggin wrote:
> > On Wednesday 28 November 2007 09:57, Arjan van de Ven wrote:

> > > sounds like a bad idea; volanomark (well, technically the jvm behind
> > > it) is abusing sched_yield() by assuming it does something it really
> > > doesn't do, and as it happens some of the earlier 2.6 schedulers
> > > accidentally happened to behave in a way that was nice for this
> > > benchmark.
> >
> > OK, why is this still happening? Haven't we been asking JVMs to use
> > futexes or posix locking for years and years now? Are there any sane
> > jvms that _don't_ use yield?
>
> I think it's an issue of volanomark (a kind of java application) instead of
> JVM.

volanomark itself and not the jvm is calling sched_yield()? Do we have
any non-toy threaded java apps? (what's JAVA in the kernel-perf tests?)


> > > Todays kernel has a different behavior somewhat (and before people
> > > scream "regression"; sched_yield() behavior isn't really specified and
> > > doesn't make any sense at all, whatever you get is what you get....
> > > it's pretty much an insane defacto behavior that is incredibly tied to
> > > which decisions the scheduler makes how, and no app can depend on that
> >
> > It is a performance regression. Is there any reason *not* to use the
> > "compat" yield by default?
>
> There is no, so I suggest to set sched_compat_yield=1 by default.
> If sched_compat_yield=0, kernel almost does nothing but returns. When
> sched_compat_yield=1, it is closer to the meaning of sched_yield man page.

sched_yield() is really only defined for posix realtime scheduling
AFAIK, which talks about priority lists. 

SCHED_OTHER is defined to be a single priority, below the rest of the
realtime priorities. So at first you *might* say that the process
should then be made to run only after all other SCHED_OTHER processes,
however there is no such ordering requirement for SCHED_OTHER
scheduling. The SCHED_OTHER scheduler can run any task at any time.

That said, I think people would *expect* that call be much closer to
the compat behaviour than the current default. And that's definitely
what Linux has done in the past. So there really does need to be a
good reason to change it like this IMO.


> > As you say, for SCHED_OTHER tasks, yield
> > can do almost anything. We may as well do something that isn't a
> > regression...
>
> I just found SCHED_OTHER in man sched_setscheduler. Is it SCHED_NORMAL in
> the latest kernel?

Yes, SCHED_NORMAL is SCHED_OTHER. Don't know why it got renamed...
