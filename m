Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248Ab0ANLxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0ANLxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092Ab0ANLxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:53:05 -0500
Received: from www.tglx.de ([62.245.132.106]:43777 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0ANLxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:53:04 -0500
Date: Thu, 14 Jan 2010 12:52:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] clockevent: don't remove broadcast device when cpu is
 dead
In-Reply-To: <4B4F0376.3090906@redhat.com>
Message-ID: <alpine.LFD.2.00.1001141248510.6420@localhost.localdomain>
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.1001121300190.6420@localhost.localdomain> <4B4D2678.5090601@redhat.com> <alpine.LFD.2.00.1001132305280.6420@localhost.localdomain> <4B4F0376.3090906@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Xiaotian Feng wrote:
> On 01/14/2010 06:08 AM, Thomas Gleixner wrote:
> > On Wed, 13 Jan 2010, Xiaotian Feng wrote:
> > > On 01/12/2010 09:20 PM, Thomas Gleixner wrote:
> > > > On Thu, 7 Jan 2010, Xiaotian Feng wrote:
> > > > 
> > > > > Marc reported BUG during shutdown, after debugging, kernel is trying
> > > > > to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.
> > > > > 
> > > > > The root cause for this bug is that in clockevents_notify,
> > > > > "cpumask_weight(dev->cpumask) == 1" is always true even if dev is a
> > > > 
> > > > Why is cpumask_weight(dev->cpumask) == 1 always true when we shutdown
> > > > a non boot cpu ?
> > > > 
> > > > The broadcast device is not a per cpu device and the cpumask should
> > > > not only contain the CPU which is shut down !
> > > 
> > > At least for hpet broadcast dev, it's dev->cpumask is only contain the CPU
> > > which it is initialized from.
> > 
> > Which is fundamentaly wrong and the root cause of the problem. I'll
> > have a look tomorrow morning when my brain is more awake than now.
> 
> hpet_legacy_clockevent_register is trying to register new CE, but replace
> failed,
> then in tick_check_new_device -> tick_check_broadcast_device, the legacy hpet
> CE
> was registered as multicast device, but its dev->cpumask is cpumask of
> smp_processor_id().
> 
> on my system its dev->cpumask is cpumask of 0, but in Marc's, dev->cpumask is
> cpumask of 4.
> So when kernel is trying to offline cpu 4, the broadcast hpet is removed.

I know, but the point is that a broadcast device should not be bound
to the CPU which is registering it. Working on a fix.

Thanks,

	tglx
