Return-Path: <linux-kernel-owner+w=401wt.eu-S964841AbZGQPo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbZGQPo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 11:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbZGQPo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 11:44:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964823AbZGQPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 11:44:57 -0400
Date: Fri, 17 Jul 2009 08:44:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [patch 1/3] net: serialize hrtimer callback in sched_cbq
In-Reply-To: <1247832892.15751.35.camel@twins>
Message-ID: <alpine.LFD.2.01.0907170838091.13838@localhost.localdomain>
References: <20090709215606.526259917@linutronix.de>  <20090712.135555.207096388.davem@davemloft.net>  <alpine.LFD.2.00.0907141040350.2777@localhost.localdomain>  <20090714.090055.56906831.davem@davemloft.net>  <1247588890.7500.186.camel@twins> 
 <alpine.LFD.2.01.0907140940440.13838@localhost.localdomain> <1247832892.15751.35.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Jul 2009, Peter Zijlstra wrote:
> 
> How would something like the below work for people?

This looks saner.

It was the insanity of having the core timer code know about different 
modes that caused all the sily problems.

Having a separate abstraction layer for "I want to get a softirq timeout" 
sounds fine, as long as the timer code itself never cares.

That said, I don't think this shoud be a "hrtimer" issue (reflected in 
your naming and include file choice). I think this is a softirq or tasklet 
(or whatever) issue, and should be named that way.

Why should the timer code (and header files) care about how you can use 
tasklets with them? It shouldn't. The timers should be seen as the really 
low-level critical code, and the timer code should never need to know 
about softirq's or tasklets or whatever.

So I think you shouldmove it to kernel/softirq.c.

			Linus
