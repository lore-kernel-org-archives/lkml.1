Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXHUEs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXHUEs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXHUEst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:48:49 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:30571 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751174AbXHUEss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:48:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q1WchSKKSc3KWozMoGLffXpVAKwisCUmLFeNJXOs08RvCocwCGZlYSGz3Vy2mbA2yH7QeaIWN5bqaNYyfJXHJPHhyyx8okGDBEWHWk1qE/qyR0SpgZAxGtabbqgkRS+SOJNdeoy+TsGvxOOdRP+onaitR+EicB3qicau4BGk+OY=  ;
X-YMail-OSG: Q6PcAlIVM1mBYjoIN4bV917SrP4HqNGWCDkylAx6hckJ0p.eXttaIFaf3AFEglUicDJAaOwWSwn1Tr0O5jhISWP_qnGp.6TfCxzwuLAphu_kzoUC.KBKKhDioZbPsT4h.hSpliJ5.jX9pI4-
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Mon, 20 Aug 2007 21:48:45 -0700
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
References: <46C098FD.1030601@googlemail.com> <200708202102.58508.david-b@pacbell.net> <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708202148.45575.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007, Linus Torvalds wrote:
> 
> On Mon, 20 Aug 2007, David Brownell wrote:
> > 
> > MMF basically means the "Transaction Translating" (TT) hub had data
> > for the host, but the host didn't collect it in time ... so that some
> > data was lost.
> > 
> > Unfortunately, that's the type of fault that's especially hard to
> > recover from.
> 
> Fair enough. However, it still seems particularly idiotic to
>  - penalize everybody
>  - mix up two totally unrelated areas (cpufreq and USB) for a bug that is 
>    extremely rare and could be handled differently.

Yes on #1, but on #2 ... frequency transitions are a common place
for systems to want to hiccup.  Maybe less so on PCs, but it's
hard to say that re-clocking an I/O or memory bus shouldn't affect
the peripherals using it for "realtime" (deadlines) I/O !!


My more complete response suggested maybe just vetoing cpufreq
transitions if the Broadcom chipset (or maybe it's just specific
boards?) finds itself in the awkward configuration ... penalizing
only the people we know could have trouble.


> For example, if it really ends up being practically impossible to recover 
> from split transaction errors, I would still suggest reverting that horrid 
> commit, and then just black-listing the known-broken EHCI controllers and 
> simply not *do* any split transactions on them. That way there's no 
> complexity.
> 
> As far as I know, split transactions aren't required anyway, they are just 
> a performance optimization.

Nope.  Linus, this is at least the second or third time you've
been wrong -- sorry.  But I wish you were right, since they're
such a PITA to cope with.  ;)

Split transactions are how the full and low speed devices bridge
to high speed busses.  Think of the TT hub as a speed converter,
buffering data and then retransmitting it at the other (slower or
faster) speed.  Some systems don't even have a full/low speed host
adapter ... they just have a high speed root hub and rely on some
external TT hubs (maybe on a mainboard) to handle the rest.


> Basically, we not only know that the commit has caused problems, it's 
> fundamentally ugly, fragile, and not very maintainable, and the whole 
> reason for doing it is pretty dubious.
> 
> Why not just admit that certain hardware is broken (and the vendor isn't 
> worth even bothering to be polite with, since they try to screw us every 
> chance they get) and cannot reliably do split transactions? Problem 
> solved, no real downside, and nobody will even *notice*.

Well, I suggested an alternate fix that I hope Stuart will look at.
I think it achieves your goals (only impacting Broadcom systems).

- Dave




> 
> 			Linus
> 


