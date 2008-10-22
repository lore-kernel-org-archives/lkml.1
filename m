Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYJVTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYJVTu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYJVTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:50:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYJVTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:50:08 -0400
Subject: Re: sched: deep power-saving states
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20081022073616.5eb150fa@infradead.org>
References: <48FF2DDC.5010600@gmail.com>
	 <20081022064738.05818670@infradead.org> <48FF3321.4060809@novell.com>
	 <20081022070701.567f1c9a@infradead.org> <48FF3829.8040704@novell.com>
	 <20081022073616.5eb150fa@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Oct 2008 21:49:52 +0200
Message-Id: <1224704992.20069.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 07:36 -0700, Arjan van de Ven wrote:
> On Wed, 22 Oct 2008 10:26:49 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
> steps, so it'll be
> > > faster) 
> > 
> > [Adding Peter Zijlstra to the thread]
> > 
> > Ah, yes of course!   That makes sense.  So I have to admit I am fairly
> > ignorant of the ACPI C-state stuff, so I just read up on it.  In the
> > context of what you said, it makes perfect sense to me now.
> > 
> > IIUC, the OS selects which C-state it will enter at idle points based
> > on some internal criteria (TBD).  All we have to do is remap the
> > cpupri "IDLE" state to something like IDLE-C1, IDLE-C2, ..., IDLE-Cn
> > and have the cpupri map get updated coincident with the pm_idle()
> > call.  Then the scheduler will naturally favor cores that are in
> > lighter sleep over cores in deep sleep.
> > 
> > I am not sure if this is exactly what you were getting at during the
> > conf, since it doesnt really consider deep-sleep latency times
> > directly.  But I think this is a step in the right direction.
> 
> it for sure is a step in the right direction.
> the actual exit costs are an optional parameter in this sense,
> the steps between C states are non-linear (more like exponential)
> so knowing the actual numbers could be used. but even if you don't
> use it, it still makes sense and is a very good first order behavior.

This still leaves us with the worst case IRQ response as given by the
deepest C state. Which might be un-desirable.

jcm was, once upon a time, working on dynamically changing the idle
routine, so that people who care about wakeup latency can run idle=poll
while their application runs, and the acpi C state stuff when nobody
cares.

This could of course then be tied into the PM QoS stuff Mark has been
doing.

Fact of life is, for some RT apps, anything but idle=poll is too much.

But yes, when C states are in play, it makes sense to try and wake a cpu
that's not deep over a very deep idle one.
