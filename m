Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbXHUE1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbXHUE1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXHUE13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:27:29 -0400
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:27968 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742AbXHUE12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:27:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=RKNQ6mX/mUOWDAku0ix2A8OSObDaiKduLFVa/V4HUTMiQgmFiq+CivSGbpxrJ92dCY530IVSkwGqQiSeZhmZLxxsdcJ/XcNFAmK7lLPMWp/PIeboNGhBO0bwoK7k4rjA0ab7RnEa1f4ZSH6MM48uIiLJK3eTuShD5jLDIFrhkjo=  ;
X-YMail-OSG: kTP4NPQVM1lxXic2wlPEF.qDFeXxHMc8XESFZzOpGVfH4uwaVr.virpxOZXHIgs3tryNaNYERZYUJSfecOr7aGuIXB1wMB5_r67G_Qy5W1IZoSJJDBI-
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
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
Content-Disposition: inline
Date: Mon, 20 Aug 2007 21:27:25 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200708202127.26130.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ GRR sorry for the premature "SEND" ... mouspads-r-evil ]

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

MMF basically means the "Transaction Translating" (TT) Hub had data
for the host, but the host didn't collect it in time ... so that some
data was lost.  In this context, it's only for periodic transfers,
meaning interrupt (for HID keyboards, mice, etc) or isochronous (mostly
audio or video, but sometimes ATM).

Unfortunately, that's the type of fault that's especially hard to
recover from.  Plus, very few of the upper layer drivers have even
a minor clue about fault recovery strategies during I/O ... it's not
supposed to happen for interrupt transfers, one hopes the drivers
will at least die gracefully.   With ISO, faults are expected (since
it's "best effort" delivery, time-priority).

On the plus side, MMF errors have been vanishingly rare until this
cpufreq interaction came up ... which of course implies the downside
that those "handle the result" code paths are all but untested.


> There can be *other* delays in reading memory that have nothing to do with 
> cpu frequency shifting, and everything to do with exteme situations on the 
> bus. If the stupid EHCI controller has some tight latency issues, that's a 
> generic problem.

There could be such problems, yes.  But in practice, I don't know
that we've ever seen them.

(There's a first time for everthing, yes.  I *just* fetched a webpage
where an image got overwritten about half way through fetching it.
Top half was today's, bottom half was tomorrow's, update 12 midnight EST.
Strangest looking JPG ever!  ;)


> That commit 196705c9bbc03540429b0f7cf9ee35c2f928a534 just exemplifies what 
> is wrong with USB, but it does so by adding incredibly ugly code. I'd 
> rather not add even *more* ugly code - especially not for a case where we 
> then seem to blame the wrong party (ie a VIA controller that didn't need 
> the ugly code in the first place).
> 
> Serverworks/Broadcom makes totally crap chips (not just in USB) and then 
> doesn't even document their buggy crap hardware.

That's pretty much how I feel about VIA's USB stuff:
buggy crap that I actively steer people away from.

And that's why it doesn't seem odd to me to add even
more workarounds for VIA-only bugs.


> But that is NOT a reason  
> for then making the kernel have buggy crap software in it.

I don't think we always have the option not to cope with
broken hardware.  We may have some options about *how* we
cope with it though ...


> So really - is there any reason why we just don't say "Broadcom chips 
> suck, and get MMF errors under normal circumstances because they are 
> crap". And from *that*, the obvious solution would seem to not be to 
> penalize everybody else, but to just say that "We will try to recover from 
> MMF errors gracefully by retrying the transaction". Hmm?

Well, see above about why retrying wouldn't work well.  Data lost, and
not recoverable ... although if the events are only USB keyboards/mice,
then the user might be able to recover.  (Stuart?)

Alternatively, if Broadcom then just veto cpufreq changes whenever
there are USB interrupt transfers active.  (We *can* veto changes
in notifiers, yes?)

- Dave



> 
> 			Linus
> 


