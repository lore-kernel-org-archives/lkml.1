Return-Path: <linux-kernel-owner+w=401wt.eu-S1946180AbXBIHk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946180AbXBIHk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946185AbXBIHk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:40:27 -0500
Received: from mail.suse.de ([195.135.220.2]:36608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946180AbXBIHk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:40:26 -0500
From: Andi Kleen <ak@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Date: Fri, 9 Feb 2007 08:40:12 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20070208203210.GB9798@osiris.ibm.com>
In-Reply-To: <20070208203210.GB9798@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702090840.12899.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 21:32, Heiko Carstens wrote:
> On i386/x86_64 smp_call_function_single() takes call_lock with
> spin_lock_bh(). To me this would imply that it is legal to call
> smp_call_function_single() from softirq context.
> It's not since smp_call_function() takes call_lock with just
> spin_lock(). We can easily deadlock:
> 
> -> [process context]
> -> smp_call_function()
> -> spin_lock(&call_lock)
> -> IRQ -> do_softirq -> tasklet
> -> [softirq context]
> -> smp_call_function_single()
> -> spin_lock_bh(&call_lock)
> -> dead
> 
> So either all spin_lock_bh's should be converted to spin_lock,
> which would limit smp_call_function()/smp_call_function_single()
> to process context & irqs enabled.
> Or the spin_lock's could be converted to spin_lock_bh which would
> make it possible to call these two functions even if in softirq
> context. AFAICS this should be safe.

I'm not so sure. Perhaps drop _bh in both and stick a WARN_ON_ONCE in
to catch the cases? 

-Andi

