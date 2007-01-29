Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXA2TOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXA2TOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXA2TOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:14:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXA2TOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:14:38 -0500
Date: Mon, 29 Jan 2007 20:12:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070129191241.GB14353@elte.hu>
References: <20070124161559.GA1762@linux.vnet.ibm.com> <20070124210645.GA19650@in.ibm.com> <20070126191113.GA14770@in.ibm.com> <20070126112837.059502fc.akpm@osdl.org> <20070126194622.GA17134@in.ibm.com> <20070126121739.be3e072a.akpm@osdl.org> <20070126204406.GB17134@in.ibm.com> <20070126132949.50544e90.akpm@osdl.org> <20070128224756.GA7672@linux.vnet.ibm.com> <20070128153005.f320b834.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128153005.f320b834.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> > The idea being to essentially suspend the system to RAM, remove the 
> > CPU and then unsuspend it?  Seems like quite high overhead -- or am 
> > I misunderstanding the proposal?
> 
> The process freezer basically wakes up all threads in the machine and 
> makes them go to sleep in a specific place, so they're all in a known 
> state. kernel threads are also captured, via their open-coded polling 
> call to try_to_freeze().
> 
> The machine suspend code uses the process freezer, as does kprobes.  
> The freezer isn't tied to suspend or to power management.
> 
> The freezer does have potential to be expensive if used frequently and 
> if there are many threads.  But I don't think anyone has looked at 
> optimising it. [...]

i've measured it and it takes a few milliseconds typically - certainly 
not noticeable even for hypothetical highly scripted CPU-hotplug 
environments. (i doubt they really exist in practice)

in fact (new) kprobes uses the freezer, and it's far more performance 
sensitive than the handling of CPU hotplug events.

And there was almost no effort put into making the freezer fast, i'm 
sure if it ever becomes a problem we could improve it quite drastically. 
And that effort would improve suspend performance and kprobes 
performance as well - while the cpu-hotplug locking hell is just an 
unneeded distraction nobody really can deal with properly. So i say lets 
ditch CPU hotplug locking completely and lets go for the dead-simple 
freezer based design ...

	Ingo
