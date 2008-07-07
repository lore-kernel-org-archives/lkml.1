Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYGGLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYGGLvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYGGLvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:51:04 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:48326 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751319AbYGGLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:51:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0UC8Fv4uaTOlkg8CFIvVSdtIu79QcrYI5936+Wuu6Cusq7/CXoVh3WvLLGTu2CoOH0dkgWMcaJgBLvJwikA4Fy3EIskZB/n7qf4IhuSVLw0HlCo1kbwhssCiQC8swzV34T2GocAo2Bovi2dEH7xi4jrzGD3150YUvUnFD78bgNY=  ;
X-YMail-OSG: RRJPtmAVM1nXNgCS4lDsq49eOxjAONadz0AVvFI4mEKr.fGkI5Hk2Gf_qvVTUxb6BiHyyowhyzStYgX88JvcDAJlZ8HfPyZ59doQJ3tDZhn3SHubwKSDrIcDZFLv3jcGXkU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disable
Date: Mon, 7 Jul 2008 21:50:39 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <1214254730.11254.34.camel@twins> <48630420.1090102@goop.org>
In-Reply-To: <48630420.1090102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072150.39571.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 12:51, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-06-23 at 13:45 -0700, Christoph Lameter wrote:
> >> On Mon, 23 Jun 2008, Peter Zijlstra wrote:
> >>>> It is good that the locks are build with _trylock and _can_lock
> >>>> because then we can reenable interrupts while spinning.
> >>>
> >>> Well, good and bad, the turn side is that fairness schemes like ticket
> >>> locks are utterly defeated.
> >>
> >> True. But maybe we can make these fairness schemes more generic so that
> >> they can go into core code?
> >
> > The trouble with ticket locks is that they can't handle waiters going
> > away - or in this case getting preempted by irq handlers. The one who
> > took the ticket must pass it on, so if you're preempted it just sits
> > there being idle, until you get back to deal with the lock.
> >
> > But yeah, perhaps another fairness scheme might work in the generic
> > code..
>
> Thomas Friebel presented results at the Xen Summit this week showing
> that ticket locks are an absolute disaster for scalability in a virtual
> environment, for a similar reason.  It's a bit irritating if the lock
> holder vcpu gets preempted by the hypervisor, but its much worse when
> they release the lock: unless the vcpu scheduler gives a cpu to the vcpu
> with the next ticket, it can waste up to N timeslices spinning.

I didn't realise it is good practice to run multiple "virtual CPUs"
of the same guest on a single physical CPU on the host...


> I'm experimenting with adding pvops hook to allow you to put in new
> spinlock implementations on the fly.  If nothing else, it will be useful
> for experimenting with different algorithms.  But it definitely seems
> like the old unfair lock algorithm played much better with a virtual
> environment, because the next cpu to get the lock is the next one the
> scheduler gives time, rather than dictating an order - and the scheduler
> should mitigate the unfairness that ticket locks were designed to solve.

... if it is good practice, then, virtualizing spinlocks I guess is
reasonable. If not, then "don't do that". Considering that probably
many bare metal systems will run pv kernels, every little cost adds
up.

