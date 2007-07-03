Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbXGCHXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbXGCHXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXGCHXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:23:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXGCHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:23:00 -0400
Date: Tue, 3 Jul 2007 09:22:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Keith Packard <keith.packard@intel.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070703072252.GB29984@elte.hu>
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com> <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com> <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com> <20070702155029.GA13241@elte.hu> <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com> <1183446743.7070.14.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1183446743.7070.14.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Mike Galbraith <efault@gmx.de> wrote:

> This doesn't appear to be a CFS problem.  I can reproduce the problem 
> easily in virgin 2.6.22-rc7 by starting xterm-spam at nice -1 or 
> better. As soon as xterm-spam can get enough CPU to keep the xterm 
> fully busy, it's game over, the xterm freezes.  The more accurate 
> fairness of CFS to sleepers just tips the balance quicker.  In 
> mainline, the xterm has an unfair advantage and maintains it 
> indefinitely... until you tip the scales just a wee bit, at which time 
> it inverts.

ah. That indeed makes sense. It seems like the xterm doesnt process the 
Ctrl-C/Z keypresses _at all_ when it is 'spammed' with output. Normally, 
output 'spam' is throttled by the scroll buffer's overhead. But in 
Vegard's case, the printout involves a \r carriage return:

       printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);

which allows xterm-spam (attached) to easily flood the xterm (without 
any scrolling that would act as a throttle) and the xterm to flood Xorg. 

I suspect we need the help of an xterm/Xorg expert? (maybe Keith can 
give us further pointers? I can reproduce the problem on a T60 with i940 
and Core2Duo running Fedora 7 + Xorg 7.1.)

	Ingo

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xterm-spam.c"


#include <time.h>

main ()
{
   while(1)
       printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);
}

--SLDf9lqlvOQaIe6s--
