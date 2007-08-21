Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbXHUEDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbXHUEDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXHUEDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:03:18 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:48016 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752888AbXHUEDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:03:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1zvNek4yMl3dKyOoKO1ZrxYRcdm/kPOwPuqvO8xXxtC4JkGUbedZLjPOYbjM29Zro19/IYJrhmo9jdxjHzPNQzUkSxNXWKs+fgoFG3DKJHNOKfyZqLqnG402Fn27b7JUjOWR1TyaL1N1nbHz7ZSBWwLTkYQr0UVSFQn9lRRSZ+E=  ;
X-YMail-OSG: TsaXmgQVM1ltnuUpdZXxCfcf732IjLADs7dU24e6S3m9467wWU6qOF5.ZW4Lx52Zwlw4NyqLMmgdHWqKvUFuMJp6T_3JgcOaLuTTMuUaiMWqbpnkIrdgVJ6UsJ6moD59dYl96cDmfEfbaqA-
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Mon, 20 Aug 2007 21:02:58 -0700
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
References: <46C098FD.1030601@googlemail.com> <200708201841.51366.david-b@pacbell.net> <alpine.LFD.0.999.0708201853020.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708201853020.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708202102.58508.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007, Linus Torvalds wrote:
> 
> On Mon, 20 Aug 2007, David Brownell wrote:
> 
> > On Monday 13 August 2007, Michal Piotrowski wrote:
> > > Subject         : EHCI Regression in 2.6.23-rc2
> > > References      : http://lkml.org/lkml/2007/8/10/81
> > > Last known good : ?
> > > Submitter       : Daniel Exner <dex@dragonslave.de>
> > > Caused-By       : Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
> > >                   commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
> > > Handled-By      : ?
> > > Status          : unknown
> > 
> > Fixed I believe by Stuart's patch:
> > 
> > http://marc.info/?l=linux-usb-devel&m=118765934722610&w=2
> 
> Quite frankly, I'd personally prefer to just revert commit 
> 196705c9bbc03540429b0f7cf9ee35c2f928a534 entirely instead.
> 
> The whole dependency on cpufreq seems totally bogus. Would it not be a lot 
> more natural to handle the *result* of the problem (ie the MMF errors by 
> broken EHCI controllers?) rather than add totally insane workarounds for 
> this case to try to hide them in the first place?

MMF basically means the "Transaction Translating" (TT) hub had data
for the host, but the host didn't collect it in time ... so that some
data was lost.

Unfortunately, that's the type of fault that's especially hard to
recover from.  Plus, very few of the upper layer drivers have even
a minor clue about fault recovery strategies.  And I don't trust
the current hcd/usbcore code that tries to clean up after MMF.

On the plus side, MMF errors have been vanishingly rare until this
cpufreq interaction came up ... which of course implies the downside
that those "handle the result" code paths are all but untested.


> There can be *other* delays in reading memory that have nothing to do with 
> cpu frequency shifting, and everything to do with exteme situations on the 
> bus. If the stupid EHCI controller has some tight latency issues, that's a 
> generic problem.

There could be such problems, yes.  But in practice, I don't know
that we've ever seen them.  (There's a first time for everthing,
yes.  I *just* fetched a webpage where an image got overwritten
about 

> That commit 196705c9bbc03540429b0f7cf9ee35c2f928a534 just exemplifies what 
> is wrong with USB, but it does so by adding incredibly ugly code. I'd 
> rather not add even *more* ugly code - especially not for a case where we 
> then seem to blame the wrong party (ie a VIA controller that didn't need 
> the ugly code in the first place).
> 
> Serverworks/Broadcom makes totally crap chips (not just in USB) and then 
> doesn't even document their buggy crap hardware. But that is NOT a reason 
> for then making the kernel have buggy crap software in it.
> 
> So really - is there any reason why we just don't say "Broadcom chips 
> suck, and get MMF errors under normal circumstances because they are 
> crap". And from *that*, the obvious solution would seem to not be to 
> penalize everybody else, but to just say that "We will try to recover from 
> MMF errors gracefully by retrying the transaction". Hmm?
> 
> 			Linus
> 


