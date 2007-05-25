Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXEYKLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXEYKLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXEYKLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:11:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXEYKLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:11:43 -0400
X-Greylist: delayed 52379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 06:11:43 EDT
Date: Fri, 25 May 2007 12:11:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070525101105.GA9268@elte.hu>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > i very much agree that this kmalloc_index() one shouldnt be called a 
> > "BUG: ", but if you look at the majority of WARN_ON() instances they 
> > are checks for clear, serious kernel bugs.
> 
> I _still_ disagree.
> 
> There's a huge difference between "You killed my father, prepare to 
> die", and "Btw, I didn't like that, but I'll just continue".

yeah ...

> And that's the difference between BUG_ON() and WARN_ON().

how about this solution: make WARN_ON() a "WARNING: " like you suggested 
(i still agree with that in principle), but also solve the additional 
problem i'm trying to outline: make BUG_ON() _not_ crash the box [only 
if the user asks for a crash to happen in such circumstances - this can 
be a sysctl.]. Then i can change the majority of the current WARN_ON()s 
to BUG_ON()s.

Most of the WARN_ON()s i personally add (and most of the WARN_ON()s i 
see others adding) are not WARN_ON()s because "i didnt like that and 
i'll just continue", they are WARN_ON() because i want _actual feedback 
from users_.

A BUG_ON() has a (much) lower likelyhood of being reported back - for 
most users it is a "X just hung hard, there was nothing in the syslog, i 
had to switch back to the older kernel" experience, and they do not have 
a serial console to hook up (newer hardware often doesnt even have a 
serial port). With the WARN_ON()s we have a _chance_ that despite the 
seriousness of the bug, the message makes it to the syslog, until the 
system comes to a screeching halt due to side-effects of the bug.

in that sense i am part of the problem: i was adding WARN_ON()s that 
werent true 'warnings' but 'bugs'. So i'd very much like to fix that 
problem, but i'd also like to solve the (very serious and existing) 
problem of BUG_ON()s making it less likely to get bugs reported back. 

	Ingo
