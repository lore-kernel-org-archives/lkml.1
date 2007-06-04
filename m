Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbXFDUQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbXFDUQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbXFDUP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:15:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760236AbXFDUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:15:55 -0400
Date: Mon, 4 Jun 2007 13:02:25 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>, Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: iperf: performance regression (was b44 driver problem?)
Message-ID: <20070604130225.08e45b72@freepuppy>
In-Reply-To: <200706042148.02450.maxi@daemonizer.de>
References: <20070525172431.60affaca@freepuppy>
	<20070604105158.31ede1f5@freepuppy>
	<20070604193206.GA13271@elte.hu>
	<200706042148.02450.maxi@daemonizer.de>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 21:47:59 +0200
Maximilian Engelhardt <maxi@daemonizer.de> wrote:

> On Monday 04 June 2007, Ingo Molnar wrote:
> > * Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > Yes, the following patch makes iperf work better than ever. But are
> > > other broken applications going to have same problem. Sounds like the
> > > old "who runs first" fork() problems.
> >
> > this is the first such app and really, and even for this app: i've been
> > frequently running iperf on -rt kernels for _years_ and never noticed
> > how buggy its 'locking' code was, and that it would under some
> > circumstances use up the whole CPU on high-res timers.
> 
> I must admit I don't know much about that topic, but there is one thing I 
> don't understand. Why is iperf (even if it's buggy) able to use up the whole 
> cpu? I didn't run it as root but as my normal user so it should have limited 
> rights. Shouldn't the linux scheduler distribute cpu time among all running 
> processes?

In this case, there are two threads. One is receiving data and the other
is spinning checking on progress. If the spinning thread doesn't yield,
it will end up using it's whole quantum (10ms at 100hz), before the
scheduler lets the receiver run again. If the receiving thread doesn't
get to run then on a UP the performance stinks.

The problem only showed up laptop because most of my other systems are
SMP (or fake SMP/HT), and usually set HZ to 1000 not 100.

It kind of reminds me of the family road trip with the kids in the back
seat going "Are we there yet?"

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
