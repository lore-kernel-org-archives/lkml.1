Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYEPMrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYEPMrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYEPMrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:47:32 -0400
Received: from www.tglx.de ([62.245.132.106]:42349 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYEPMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:47:31 -0400
Date: Fri, 16 May 2008 14:46:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10701] New: snd_pcsp lockdep warning
In-Reply-To: <20080515110244.6e15d4c3.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805161338500.3255@apollo.tec.linutronix.de>
References: <bug-10701-10286@http.bugzilla.kernel.org/> <20080515110244.6e15d4c3.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Andrew Morton wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Thu, 15 May 2008 03:43:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=10701
> > 
> >            Summary: snd_pcsp lockdep warning
> >            Product: Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.26-rc2
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Sound(ALSA)
> >         AssignedTo: perex@perex.cz
> >         ReportedBy: nuclearcat@nuclearcat.com
> > 
> > 
> > Latest working kernel version: unknown
> > Earliest failing kernel version: 2.6.26-rc2
> > Distribution: Gentoo
> > Hardware Environment: Intel 965 chipset, Core 2 Duo
> > Software Environment: mplayer
> > Problem Description: Just lockdep warning in dmesg
> 
> This looks like a problem in the core hrtimers code?

No, this is a problem in the sound code. It uses the hrtimer callback
mode HRTIMER_CB_IRQSAFE. This mode was never intended to provide a
lock free call mode and was created for very fast callbacks like
wakeups and the like. Also I find it pretty amazing that the pscp code
has the following comment:

/*
 * We need the hrtimer_start as a tasklet to avoid
 * the nasty locking problem. :(
 * The problem:
 * - The timer handler is called with the cpu_base->lock
 *   already held by hrtimer code.
 * - snd_pcm_period_elapsed() takes the
 *   substream->self_group.lock.
 * So far so good.
 * But the snd_pcsp_trigger() is called with the
 * substream->self_group.lock held, and it calls
 * hrtimer_start(), which takes the cpu_base->lock.
 * You see the problem. We have the code pathes
 * which take two locks in a reverse order. This
 * can deadlock and the lock validator complains.
 * The only solution I could find was to move the
 * hrtimer_start() into a tasklet. -stsp
 */

So the author was well aware of locking problem and the whole code is
just a stupid hack around the problem without solving it. This code is
not at all suited for HRTIMER_CB_IRQSAFE.

Thanks,
	tglx
