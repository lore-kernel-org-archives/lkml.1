Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153Ab0AHS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0AHS1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259Ab0AHS1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:27:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:46595 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0AHS1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:27:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qNxRGsjFrV5mCZq+tOOJwmzvxqObM8V40SOZZMYmuVG2zjK0tW3I1fpKSNdCzfeorw
         ppheK6LEjUYqB2Z23RN0CEGNOP2R6KxQq1WtnfH5KOeYKKzhiQPjJF0z9k8PEBgKgRIz
         88IlFDz3x9dAY4tZwGcNGpQygBuJlmkIcTmxI=
Date: Fri, 8 Jan 2010 19:27:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Yi <yi.li@analog.com>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
Message-ID: <20100108182746.GA5606@nowhere>
References: <1262925925.27700.15.camel@adam-desktop> <20100108051847.GB5468@nowhere> <1262964163.28171.3781.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262964163.28171.3781.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 10:22:43AM -0500, Steven Rostedt wrote:
> On Fri, 2010-01-08 at 06:18 +0100, Frederic Weisbecker wrote:
> Comment needed here:
> 
> /*
>  * The irqsoff tracer uses atomic_inc_return to prevent recursion.
>  * Unfortunately, in this file, atomic_inc_return disables interrupts
>  * which causes the recursion the irqsoff trace was trying to prevent.
>  *
>  * The irqsoff tracer will define __ATOMIC_NEED_RAW_IRQ_SAVE before
>  * including this file, which will make the atomic_inc_return use
>  * the raw versions of interrupts disabling. This will allow other
>  * users of the atomic_inc_return to still have the interrupt
>  * disabling be traced, but will prevent the recursion by the
>  * irqsoff tracer itself.
>  */
> 



Yep, that was a first catch, just to ping opinions, it was even
not tested :)


> I wonder if we could just use a per_cpu variable and increment that
> instead. Since the irqsoff tracer only gets called with interrupts
> disabled (and the preemptoff with preemption disabled), a per_cpu
> variable should be protected well.



Doh! I thought about that but feared about preempt_disable recursion.
I didn't realize this code was under such context already.

True, that's indeed a much better idea!

