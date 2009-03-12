Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZCLQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZCLQum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbZCLQud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:50:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZCLQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:50:32 -0400
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Peter Zijlstra <peterz@infradead.org>
To: Timur Tabi <timur@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, will.newton@gmail.com,
       hancockrwd@gmail.com, jeremy@goop.org
In-Reply-To: <49B9362D.3090805@freescale.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
	 <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
	 <49B9362D.3090805@freescale.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 17:50:09 +0100
Message-Id: <1236876609.5090.934.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 11:19 -0500, Timur Tabi wrote:
> Grant Likely wrote:
> 
> > #define spin_until_timeout(condition, timeout, rc)          \
> >       for (unsigned long __timeout = jiffies + (timeout);     \
> >               (!(rc = (condition)) && time_after(jiffies, __timeout)); )
> 
> Ooo, that's good.
> 
> I'm still not crazy about using jiffies, since it doesn't get
> incremented when interrupts are disabled, and I'd like this function to
> work in those cases.  How about get_cycles()?  I know it's not supported
> on all platforms, but I'm willing to live with that.
> 
> The other problem with get_cycles() is that there doesn't appear to be a
> num_cycles_per_usec() function, so there's no way for me to scale the
> count to a fixed time period.

sched_clock() does that, but:
  - it falls back to jiffies on poor platforms
  - it requires to be called with IRQs disabled
  - it can basically jump any random way on funky hardware

then there is cpu_clock(int cpu):
  - still falls back to jiffies on poor platforms
  - is monotonic when used on the same cpu
  - can drift up to a few jiffies when used between cpus

But something that seems to always work, is simply count loops and rely
on whatever delay is in the specified loop.

#define spin_until_timeout(condition, timeout, rc) \
	for (unsigned long __timeout = 0; \
	     !(rc = (condition)) && __timeout < (timeout); \
	     __timeout++)

