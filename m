Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZHZN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZHZN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZHZN4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:56:17 -0400
Received: from smtp.knology.net ([24.214.63.101]:38912 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397AbZHZN4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:56:16 -0400
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
From: David Dillow <dave@thedillows.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <m1iqgbknun.fsf_-_@fess.ebiederm.org>
References: <1250895567.23419.1.camel@obelisk.thedillows.org>
	 <1250897657.23419.5.camel@obelisk.thedillows.org>
	 <m1iqggf4rf.fsf@fess.ebiederm.org> <m18whcf3w2.fsf@fess.ebiederm.org>
	 <1250973787.3582.14.camel@obelisk.thedillows.org>
	 <m1r5v0ogvw.fsf@fess.ebiederm.org>
	 <1251169150.4023.11.camel@obelisk.thedillows.org>
	 <m1prajabk8.fsf@fess.ebiederm.org>
	 <1251232848.9607.15.camel@lap75545.ornl.gov>
	 <m1k50r8u4p.fsf@fess.ebiederm.org>
	 <20090825221903.GA13630@electric-eye.fr.zoreil.com>
	 <m1iqgbknun.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 09:56:14 -0400
Message-Id: <1251294974.14241.9.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 00:58 -0700, Eric W. Biederman wrote:
> As of 2.6.30 I have been observing soft lockups and netdev watchdog
> timeouts caused by looping in the r8169 interrupt handler.
> 
> - Introduce a hard limit to the maximum number of times we will loop in
>   the interrupt handler, and print a message when we hit it.
> 
> - Break out of the loop if after looking none of the events in status
>   are events we expect to be delivered by an interrupt.
> 
> With just the hard limit and message bits of my patch in my test case
> I get hit my limit of 10 loops 12 times.  After filtering by intr_mask
> and intr_event I don't get any warnings.
> 
> Any complaints from those who know the driver better than I?

Have you tried this under a sustained heavy transmit load? I think you
may have reintroduced the problem the original patch was trying to
prevent -- wedging the MSI interrupt by not ACKing all outstanding
interrupt sources, masked or otherwise. I'll try to test this out on the
machine where I've seen the problem consistently, but it may be this
weekend.

> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index 3b19e0c..2214945 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c

> +
> +		/* Ignore the parts of status that reflect more than
> +		 * the enabled interrupts.
> +		 */
> +		smp_rmb();
> +		if (!(status & tp->intr_mask & tp->intr_event))
> +			break;
>  	}

This looks like an odd construct, since we're just about to go back the
while condition up top -- why not just mask it here and let the loop
handle it naturally?


