Return-Path: <linux-kernel-owner+w=401wt.eu-S1946213AbXBIInd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946213AbXBIInd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946223AbXBIInd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:43:33 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:35108 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946213AbXBIInc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:43:32 -0500
Date: Fri, 9 Feb 2007 09:42:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@osdl.org, mingo@elte.hu, ak@suse.de, jan.glauber@de.ibm.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Message-ID: <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
References: <20070208203210.GB9798@osiris.ibm.com> <20070208.124328.88477956.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208.124328.88477956.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 12:43:28PM -0800, David Miller wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Thu, 8 Feb 2007 21:32:10 +0100
>  
> > So either all spin_lock_bh's should be converted to spin_lock,
> > which would limit smp_call_function()/smp_call_function_single()
> > to process context & irqs enabled.
> > Or the spin_lock's could be converted to spin_lock_bh which would
> > make it possible to call these two functions even if in softirq
> > context. AFAICS this should be safe.
> [...]
> In short, it's a mess :-)
>  
> I think it's logically simpler if we disallow smp_call_function*()
> from any kind of asynchronous context.  But I'm sure your driver
> has a true need for this for some reason.

I just want to avoid that s390 has different semantics for
smp_call_functiom*() than any other architecture. But then again it
will probably not hurt since we allow more.
Another thing that comes into my mind is smp_call_function together
with cpu hotplug. Who is responsible that preemption and with that
cpu hotplug is disabled?
Is it the caller or smp_call_function itself?
If it's smp_call_function then s390 would be broken, since
then we would have
int cpus = num_online_cpus()-1;
in preemptible context... I agree: what a mess :)
