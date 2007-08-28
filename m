Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXH1LVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXH1LVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXH1LVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:21:15 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2926 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXH1LVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:21:13 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: David Miller <davem@davemloft.net>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Tue, 28 Aug 2007 13:21:09 +0200
User-Agent: KMail/1.8.2
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
References: <46D1D634.7060007@katalix.com> <46D2F301.7050105@katalix.com> <20070827.140251.95055210.davem@davemloft.net>
In-Reply-To: <20070827.140251.95055210.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708281321.10679.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Monday 27 August 2007 23:02, David Miller wrote:
> But there are huger fish to fry for you I think.  Talk to your
> platform maintainers and ask for an interface for obtaining
> a flat static distribution of interrupts to cpus in order to
> support multiqueue NAPI better.
> 
> In your previous postings you made arguments saying that the
> automatic placement of interrupts to cpus made everything
> bunch of to a single cpu and you wanted to propagate the
> NAPI work to other cpu's software interrupts from there.
> 
> That logic is bogus, because it merely proves that the hardware
> interrupt distribution is broken.  If it's a bad cpu to run
> software interrupts on, it's also a bad cpu to run hardware
> interrupts on.
> 

As already mentioned some mails were mixed up here. To clarify the interrupt
issue that has nothing to do with the reduction of interrupts:
- Interrupts are distributed the round robin way on IBM POWER6 processors
- Interrupt distribution can be modified by user/daemons (smp_affinity, pinning)
- NAPI is scheduled on CPU where interrupt is catched
- NAPI polls on that CPU as long as poll has packets to process (default)
(David please correct if there is a misunderstanding here)

Problem for multi queue driver with interrupt distribution scheme set to
round robin for this simple example:
Assuming we have 2 SLOW CPUs. CPU_1 is under heavy load (applications). CPU_2
is not under heavy load. Now we receive a lot of packets (high load situation).
Receive queue 1 (RQ1) is scheduled on CPU_1. NAPI-Poll does not manage to empty
RQ1 ever, so it stays on CPU_1. The second receive queue (RQ2) is scheduled on
CPU_2. As that CPU is not under heavy load, RQ2 can be emptied, and the next IRQ
for RQ2 will go to CPU_1. Then both RQs are on CPU_1 and will stay there if
no IRQ is forced at some time as both RQs are never emptied completely.

This is a simplified example to demonstrate the problem. The interrupt scheme
is not bogus, it is just an effect you see if you don't use pinning.
The user can avoid this problem by pinning the interrupts to CPUs.

As pointed out by David, it will be too expensive to schedule NAPI poll on
a different CPU than the one that gets the IRQ. So I guess one solution 
is to "force" an HW interrupt when two many RQs are processed on the same CPU
(when no IRQ pinning is used). This is something the driver has to handle.

Regards,
Jan-Bernd
