Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYCRHPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYCRHPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYCRHPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:15:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbYCRHPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:15:31 -0400
Date: Tue, 18 Mar 2008 00:14:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080318001429.896acf51.akpm@linux-foundation.org>
In-Reply-To: <200803161246.23909.david-b@pacbell.net>
References: <20080316184349.GA28543@khazad-dum.debian.net>
	<200803161246.23909.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 11:46:23 -0800 David Brownell <david-b@pacbell.net> wrote:

> On Sunday 16 March 2008, Henrique de Moraes Holschuh wrote:
> > Is the use of "if (preempt_count())" to know when to defer led gpio work to
> > a workqueue needed? __Shouldn't "if (in_atomic())" be enough?
> 
> At this point, I don't know of any such reason.
> 
> I remember hunting for the right heuristic, and settling on
> that one for reasons that I can't recall now.  They may even
> be no longer applicable.

Both are incorrect.  When CONFIG_PREEMPT=n we have no support for
determining whether schedule() may be called.  The calling code has to sort
out its stuff on its own.

<greps for preempt_count>

The LEDs code seems to be the sole offender.  print_vma_addr() might be
wrong too, but Ingo did it, and perhaps he knows that all code paths which
call print_vma_addr() from deadlockable contexts have already called
inc_preempt_count().  But is that true for all architectures?

<greps for in_atomic>

omigawd, what have we done, and how can we fix it? :(
