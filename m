Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXHXPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXHXPxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXHXPwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:52:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894AbXHXPws convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:52:48 -0400
Date: Fri, 24 Aug 2007 08:52:03 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: akepner@sgi.com, netdev <netdev@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: RFC: issues concerning the next NAPI interface
Message-ID: <20070824085203.42f4305c@freepuppy.rosehill.hemminger.net>
In-Reply-To: <200708241747.16592.ossthema@de.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com>
	<20070824153703.GN5592@sgi.com>
	<200708241747.16592.ossthema@de.ibm.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 17:47:15 +0200
Jan-Bernd Themann <ossthema@de.ibm.com> wrote:

> Hi,
> 
> On Friday 24 August 2007 17:37, akepner@sgi.com wrote:
> > On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:
> > > .......
> > > 3) On modern systems the incoming packets are processed very fast. Especially
> > >    on SMP systems when we use multiple queues we process only a few packets
> > >    per napi poll cycle. So NAPI does not work very well here and the interrupt 
> > >    rate is still high. What we need would be some sort of timer polling mode 
> > >    which will schedule a device after a certain amount of time for high load 
> > >    situations. With high precision timers this could work well. Current
> > >    usual timers are too slow. A finer granularity would be needed to keep the
> > >    latency down (and queue length moderate).
> > > 
> > 
> > We found the same on ia64-sn systems with tg3 a couple of years 
> > ago. Using simple interrupt coalescing ("don't interrupt until 
> > you've received N packets or M usecs have elapsed") worked 
> > reasonably well in practice. If your h/w supports that (and I'd 
> > guess it does, since it's such a simple thing), you might try 
> > it.
> > 
> 
> I don't see how this should work. Our latest machines are fast enough that they
> simply empty the queue during the first poll iteration (in most cases).
> Even if you wait until X packets have been received, it does not help for
> the next poll cycle. The average number of packets we process per poll queue
> is low. So a timer would be preferable that periodically polls the 
> queue, without the need of generating a HW interrupt. This would allow us
> to wait until a reasonable amount of packets have been received in the meantime
> to keep the poll overhead low. This would also be useful in combination
> with LRO.
> 

You need hardware support for deferred interrupts. Most devices have it (e1000, sky2, tg3)
and it interacts well with NAPI. It is not a generic thing you want done by the stack,
you want the hardware to hold off interrupts until X packets or Y usecs have expired.

The parameters for controlling it are already in ethtool, the issue is finding a good
default set of values for a wide range of applications and architectures. Maybe some
heuristic based on processor speed would be a good starting point. The dynamic irq
moderation stuff is not widely used because it is too hard to get right.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
