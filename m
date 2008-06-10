Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYFJIQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYFJIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYFJIQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:16:09 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37508 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753358AbYFJIQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:16:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ampOq7kgAKdOGOXR2oUVYblZkV9Dj9XXHlXYmTBDM/qtssDp8Edxl56hWAda0wm0M5eTD4HdEsD15FHKTCQHH4qBCYFLI6hYKaVIggvM3ZtaKZsC4bPb94ETpuSfXIa6jMv+oT8GfUCtByhjOVApAwsSJyIKvhdwn7iBYrb5tWs=  ;
X-YMail-OSG: 87htxq8VM1lLFfLtqr.cyMf8ANgNcoCUWPHXVNEqIQCcxHaz_jdrLH9HJK8_9im5EqJndDI5W_nlZAE41YHXIaSGXcmHnio0u.csXG8wkR9ZZQ0F_JurnrhBL5S77T7UkJw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
Date: Tue, 10 Jun 2008 18:15:53 +1000
User-Agent: KMail/1.9.5
Cc: Isaku Yamahata <yamahata@valinux.co.jp>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
References: <20080610073532.GG24381%yamahata@valinux.co.jp> <200806101741.39871.nickpiggin@yahoo.com.au> <484E33F1.5000503@goop.org>
In-Reply-To: <484E33F1.5000503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101815.53729.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 17:57, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > On Tuesday 10 June 2008 17:35, Isaku Yamahata wrote:
> >> This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
> >> Use wmb instead of rmb to enforce ordering between
> >> evtchn_upcall_pending and evtchn_pending_sel stores
> >> in xen_evtchn_do_upcall().
> >
> > There are a whole load of places in the kernel that should be using
> > smp_ variants of memory barriers. This seemed to me like one of them,
> > but I could be wrong.
>
> No, it needs to be an unconditional barrier.  This is synchronizing with
> the hypervisor - even if the kernel is compiled UP, the SMP hypervisor
> may be testing/setting the events pending bits from another (physical) cpu.

OK. What you *really* want is smp_*mb_even_if_compiled_for_UP() ;)
That is, a small set of primitives that are compiled with CONFIG_SMP
(and given some xxx_ prefix to distinguish).

IO barriers are probably the best thing you can use for the moment.


> > Also, if you do that can you get rid of the ifdef? If it really *really*
> > mattered, we could introduce smp_mb before/after xchg... but if you
> > use smp_wmb anyway then it definitely does not matter because that is a
> > noop on x86.
>
> Yes, I'd like to lose the #ifdef.  Unfortunately I think putting a
> "lock; addl $0,0(%%esp)" style barrier had a measurable negative
> performance impact, but I may be thinking of something else.  I don't
> know how expensive sfence is.
>
> The alternative is to make ia64's xchg a barrier (or to add a barrier
> variant of it).  It seems like a wart to have a cross-architecture
> function like xchg(), but then have different architectures differ in
> important details like barrier-ness.

Well, no you have to be careful. Because even if we did ask for ia64's
xchg to be a full barrier, you wouldn't get the right behaviour on UP
because it would be free to optimise that away -- those kinds of barriers
referred to in all those primitives are defined for cacheable memory and
CPU-to-CPU only...

I guess under the circumstances, leaving the ifdef there is probably
reasonable.
