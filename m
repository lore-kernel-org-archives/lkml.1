Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYEPRk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYEPRk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYEPRkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:40:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbYEPRkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:40:16 -0400
Date: Fri, 16 May 2008 10:38:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stas Sergeev <stsp@aknet.ru>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bugme-new] [Bug 10701] New: snd_pcsp lockdep warning
Message-Id: <20080516103827.0d5ab023.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805161338500.3255@apollo.tec.linutronix.de>
References: <bug-10701-10286@http.bugzilla.kernel.org/>
	<20080515110244.6e15d4c3.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805161338500.3255@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 14:46:31 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 15 May 2008, Andrew Morton wrote:
> 
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> > 
> > On Thu, 15 May 2008 03:43:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10701
> > > 
> > >            Summary: snd_pcsp lockdep warning
> > >            Product: Drivers
> > >            Version: 2.5
> > >      KernelVersion: 2.6.26-rc2
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: Sound(ALSA)
> > >         AssignedTo: perex@perex.cz
> > >         ReportedBy: nuclearcat@nuclearcat.com
> > > 
> > > 
> > > Latest working kernel version: unknown
> > > Earliest failing kernel version: 2.6.26-rc2
> > > Distribution: Gentoo
> > > Hardware Environment: Intel 965 chipset, Core 2 Duo
> > > Software Environment: mplayer
> > > Problem Description: Just lockdep warning in dmesg
> > 
> > This looks like a problem in the core hrtimers code?
> 
> No, this is a problem in the sound code. It uses the hrtimer callback
> mode HRTIMER_CB_IRQSAFE. This mode was never intended to provide a
> lock free call mode and was created for very fast callbacks like
> wakeups and the like. Also I find it pretty amazing that the pscp code
> has the following comment:
> 
> /*
>  * We need the hrtimer_start as a tasklet to avoid
>  * the nasty locking problem. :(
>  * The problem:
>  * - The timer handler is called with the cpu_base->lock
>  *   already held by hrtimer code.
>  * - snd_pcm_period_elapsed() takes the
>  *   substream->self_group.lock.
>  * So far so good.
>  * But the snd_pcsp_trigger() is called with the
>  * substream->self_group.lock held, and it calls
>  * hrtimer_start(), which takes the cpu_base->lock.
>  * You see the problem. We have the code pathes
>  * which take two locks in a reverse order. This
>  * can deadlock and the lock validator complains.
>  * The only solution I could find was to move the
>  * hrtimer_start() into a tasklet. -stsp
>  */
> 
> So the author was well aware of locking problem and the whole code is
> just a stupid hack around the problem without solving it. This code is
> not at all suited for HRTIMER_CB_IRQSAFE.

You sound impressed!  So what's the fix?  HRTIMER_CB_SOFTIRQ?
