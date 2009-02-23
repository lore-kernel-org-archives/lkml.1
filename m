Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZBWG6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZBWG6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZBWG6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:58:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZBWG63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:58:29 -0500
Date: Mon, 23 Feb 2009 07:58:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/1] LinuxPPS core support.
Message-ID: <20090223065801.GA16621@elte.hu>
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <1234274752-29847-2-git-send-email-giometti@linux.it> <20090222203933.GA18914@elte.hu> <49A1BC28.9020402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1BC28.9020402@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> >>
> >> Common use is the combination of the NTPD as userland program 
> >> with a GPS receiver as PPS source to obtain a wallclock-time 
> >> with sub-millisecond synchronisation to UTC.
> > 
> > Hm. I was looking at this stuff with the prospect of adding it 
> > to the timer tree, but i'm really struggling with a few 
> > fundamental questions.
> > 
> > The most basic one is: why do we need this?
> > 
> > The main purpose of your current patchset seems to be to deliver 
> > interrupt timestamps to user-space, where it will in essence be 
> > used to feed new adjtimex adjustments via ntpd.
> > 
> > I.e. the whole thing comes around in a circle in the end, but 
> > via user-space, where jitter will only increase.
> > 
> > Why not cut out the jittery middle man and add some intelligent 
> > API to register PPS interrupt sources straight with the NTP 
> > code, and let those IRQ timestamps be fed _directly_ into our 
> > time adjustment code?
> > 
> 
> Well, let's be fair here... the kernel-user space time model 
> involving ntpd has been very carefully developed over a period 
> of over a decade. It's known to work.  The userspace 
> involvement isn't just about feeding the data to the local 
> clock, but also -- or perhaps primarily so -- to keep the 
> timing inside ntpd calibrated, as that is the time that will 
> be provided to the outside world.

Sure thing, the policy bits should still be done by user-space - 
something does have to know that there's a PPS device on the 
serial, parallel or any other port, and has to configure set up 
the actual parameters as well, etc.

What i'm pointing out is that there's no technical benefit from 
passing the _timestamps_ through user-space and from not 
coupling the NTP code with the PPS edges.

Nor has it really been designed into NTP that way. We already 
have all the traditional PPS parameters in the NTP syscall 
interface:

include/linux/timex.h:

struct timex {
[...]
        long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
        long jitter;            /* pps jitter (us) (ro) */
        int shift;              /* interval duration (s) (shift) (ro) */
        long stabil;            /* pps stability (scaled ppm) (ro) */
        long jitcnt;            /* jitter limit exceeded (ro) */
        long calcnt;            /* calibration intervals (ro) */
        long errcnt;            /* calibration errors (ro) */
        long stbcnt;            /* stability limit exceeded (ro) */

(these are the bits to query the state of kernel-side PPS 
support.)

and we have the bits to enable a PPS line disciple, etc., etc. 
We might need some extensions, but since the PPS device will be 
handled by the kernel anyway and the NTP adjustments are done in 
the kernel too, there's no strong reason to route the actual 
timestamps via user-space. In fact, doing so obviously increases 
jitter and slows down NTP convergence.

	Ingo
