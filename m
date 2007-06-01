Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbXFASAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbXFASAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbXFAR77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:59:59 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbXFAR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:59:58 -0400
Date: Fri, 1 Jun 2007 10:59:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
In-Reply-To: <466058F8.4050107@pobox.com>
Message-ID: <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> 
 <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
 <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org> 
 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com> 
 <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
 <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
 <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org>
 <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com>
 <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org>
 <466058F8.4050107@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Jeff Garzik wrote:
> 
> With these old PATA devices, device reset is "six of one, half-dozen of the
> other."  Using SRST is the only way to kick some ATAPI devices into working:
> http://suif.stanford.edu/~csapuntz/blackmagic.html#reset

Well, wouldn't it be a good thing to
 1) if BUSY/DRQ is set even before you try the problem, obviously skip the 
    two polite cases, and go to #4
 2) try to just do an IDENTIFY 
 3) if that doesn't work, do a HOST RESET and then try again
 4) if that doesn't work, do the full SRST

(or some variation of the above).

That at least has the potential to get you six working devices, and half a 
dozen other working devices, for a total of 12. With no unnecessary resets 
or long timeouts!

(Btw, the 150ms wait after reset is really nasty. A few of those, and 
we're wasting seconds during bootup. Why the hell does it do that, when 
the old driver - and the spec - said 2ms?)

> I'm mainly interested in hearing feedback from Fedora 7 damage, before making
> a major decision about the probing code.  If this is a single dain bramaged
> device, we should avoid punishing the majority.  But if this is a trend, it
> warrants careful reconsideration.

I thought the default in Fedora was to use the PATA driver first? If so, 
you're going to miss a lot of cases that "just work", because they use the 
old driver.

At least that was what my situation was on the P4 that I recently 
complained about the "set transfer mode" problem: it used to use the old 
PATA drivers that didn't have the issue, so I never even _knew_ the new 
libata-based code had problems.

		Linus
