Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXHUCDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXHUCDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 22:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXHUCCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 22:02:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbXHUCCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 22:02:53 -0400
Date: Mon, 20 Aug 2007 19:02:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Stuart Hayes <stuart_hayes@dell.com>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <200708201841.51366.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.999.0708201853020.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com> <46C09C11.3070105@googlemail.com>
 <200708201841.51366.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, David Brownell wrote:

> On Monday 13 August 2007, Michal Piotrowski wrote:
> > Subject         : EHCI Regression in 2.6.23-rc2
> > References      : http://lkml.org/lkml/2007/8/10/81
> > Last known good : ?
> > Submitter       : Daniel Exner <dex@dragonslave.de>
> > Caused-By       : Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
> >                   commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
> > Handled-By      : ?
> > Status          : unknown
> 
> Fixed I believe by Stuart's patch:
> 
> http://marc.info/?l=linux-usb-devel&m=118765934722610&w=2

Quite frankly, I'd personally prefer to just revert commit 
196705c9bbc03540429b0f7cf9ee35c2f928a534 entirely instead.

The whole dependency on cpufreq seems totally bogus. Would it not be a lot 
more natural to handle the *result* of the problem (ie the MMF errors by 
broken EHCI controllers?) rather than add totally insane workarounds for 
this case to try to hide them in the first place?

There can be *other* delays in reading memory that have nothing to do with 
cpu frequency shifting, and everything to do with exteme situations on the 
bus. If the stupid EHCI controller has some tight latency issues, that's a 
generic problem.

That commit 196705c9bbc03540429b0f7cf9ee35c2f928a534 just exemplifies what 
is wrong with USB, but it does so by adding incredibly ugly code. I'd 
rather not add even *more* ugly code - especially not for a case where we 
then seem to blame the wrong party (ie a VIA controller that didn't need 
the ugly code in the first place).

Serverworks/Broadcom makes totally crap chips (not just in USB) and then 
doesn't even document their buggy crap hardware. But that is NOT a reason 
for then making the kernel have buggy crap software in it.

So really - is there any reason why we just don't say "Broadcom chips 
suck, and get MMF errors under normal circumstances because they are 
crap". And from *that*, the obvious solution would seem to not be to 
penalize everybody else, but to just say that "We will try to recover from 
MMF errors gracefully by retrying the transaction". Hmm?

			Linus
