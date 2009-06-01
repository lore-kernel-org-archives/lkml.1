Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZFAX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZFAX6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZFAX6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:58:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42176 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFAX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:58:37 -0400
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
From: John Stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
In-Reply-To: <20090601232223.GH749@elte.hu>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>
	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
	 <1243542817.29511.523.camel@jstultz-laptop>  <20090601232223.GH749@elte.hu>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:58:36 -0700
Message-Id: <1243900716.11263.42.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:
> * John Stultz <johnstul@us.ibm.com> wrote:
> > On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
> > > ntp: adjust SHIFT_PLL to improve NTP convergence
> > > 
> > > The conversion to the ntpv4 reference model
> > > f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
> > > reference model") in 2.6.19 added nanosecond resolution the adjtimex
> > > interface, but also changed the "stiffness" of the frequency adjustments,
> > > causing NTP convergence time to greatly increase.
> > > 
> > > SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
> > > designed to be inversely linked to HZ, and the reference value of 4 was
> > > designed for Unix systems using HZ=100.  However Linux's clock steering
> > > code mostly independent of HZ.
> > > 
> > > So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
> > > behavior to match kernels prior to 2.6.19, greatly reducing convergence
> > > times, and improving close synchronization through environmental thermal
> > > changes.
> > > 
> > > 
> > > [ Impact: tweak NTP algorithm for faster convergence ]
> >
> > 	So I've been speaking with Miroslav (cc'ed) who maintains 
> > the RH ntpd packages, and he's concerned that this patch takes us 
> > out of NTP's expected behavior, which may cause problems when 
> > dealing with non-linux systems using NTP.
> 
> I might be missing something here - but Linux converging faster 
> seems like a genuinely good thing. What non-Linux problem could 
> there be? Linux's convergence is really Linux's private issue. 

Yea. It does seem that way. Miroslav can likely expand on the issue to
help clarify, but as I understand it, the example is if you have a
number of systems that are peers in an NTP network. All of them are
using the same userland NTP daemon. However, if the rate of change that
corrections are applied is different in half of them, you will have
problems getting all the systems to converge together. 

An rough analogy might be creating a an automatic control system to
drive an RC car, and then letting it control a Ferrari. 

Now, that said, I have yet to actually see or hear of any negative
effects of the patch in testing, but I'd  prefer to try to keep to the
NTP spec if we can.

So Miroslav is helping by looking for similar changes we can possibly
make from the userland side. This not only lets us keep the adjtimex()
interface stable while we sort out what options we have, but also, by
trying to tune the NTP knobs in userland instead of kernel space, we are
more likely to get feedback and hopefully constructive solutions by the
NTP gurus who have in the past have maybe been less interested in
Linux's behavior.

So yea, we'll see what comes of it. In the meantime, I know some folks
who will continue to use this patch on their systems because it really
improves things for them. So I'm not abandoning the patch just yet, but
I want to really make sure we're not needlessly changing the kernel
behavior.

thanks
-john

