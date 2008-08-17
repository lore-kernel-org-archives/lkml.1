Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbYHQNFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbYHQNFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYHQNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 09:05:06 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:45120 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752856AbYHQNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 09:05:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4vl7gR5uoaP5Igiqu60sAypVuJteiaXgPg3MfJlloieCuKnO/zt8DZa22rioBic7kqzjsDje6MdAJCFqSHk9QbFZjlqbiukNxdzrbmb64Nj8Hk13zcqrS0bXB+8PIGFOoME6mq/p8ao9jp3PVai3Uz54EzAA0Fg+TG9yT0xS+Sg=  ;
X-YMail-OSG: bbOAdQgVM1ls5IrLZ6KfLdTO9JwMKvgB7P1s9_cGDyZsEJkZQM14N4n0pXQJBCQB4wCOvCETecCtu_2SggmJK2yuREwo96NkJdZJpOkfo6GOTfcGS3DEP3KsBuEwpQkXWuI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
Date: Sun, 17 Aug 2008 23:04:49 +1000
User-Agent: KMail/1.9.5
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
References: <1218880552.11912.9.camel@matrix> <1218898413.10800.252.camel@twins>
In-Reply-To: <1218898413.10800.252.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808172304.50103.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 August 2008 00:53, Peter Zijlstra wrote:
> On Sat, 2008-08-16 at 11:55 +0200, Stefani Seibold wrote:
> > Hi kernel hackers,
> >
> > it seems that the new completely fair scheduler breaks the SCHED_RR and
> > SCHED_FIFO realtime scheduler.
> >
> > In my opinion a high priority real time user process with SCHED_FIFO
> > should be only interrupted by the kernel or a process with an higher
> > priority. So a user process running under SCHED_FIFO and priority 99
> > should never be interrupted by any other process.  This was true under
> > kernel 2.6.20.
> >
> > On my pentium/celeron III/400 MHz system with kernel 2.6.20 a busy loop
> > using the "time stamp counter" of the x86 cpu for delaying, this was
> > very accurate. The max. jitter of the delaying was about 5 microseconds.
> >
> > With the new kernel 2.6.26 the jitter is about 51177 microseconds or in
> > other words 51 milliseconds or more the 10000 times greater than kernel
> > 2.6.20. This huge latency is far away from realtime.
> >
> > Below are the results of the attached test program. Maybe somebody else
> > can confirm this results. All measurements was done with no other
> > process running, only the busybox 1.11.1 shell and the init process was
> > there.
>
> Has nothing to do with CFS, but everything to do with the fact that we
> now have a 95% bandwidth control by default.
>
> Does doing:
>
> echo -1 > /proc/sys/kernel/sched_rt_runtime_us
>
> fix it?
>
> So, up to 95% cpu usage (per sched_rt_period_us) FIFO and RR behave like
> they always did, once they cross that line, they'll be throttled.
>
> 95% seemed like a sane default in that it leaves a little room to
> recover from a run-away rt process (esp handy now that !root users can
> also use RT scheduling classes), and should be enough for most
> applications as they usually don't consume all that much time.

Did it seem sane to break POSIX and backwards compatiblity by default?
