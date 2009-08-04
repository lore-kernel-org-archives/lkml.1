Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZHDOpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZHDOpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZHDOpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:45:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZHDOpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:45:35 -0400
Date: Tue, 4 Aug 2009 16:45:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Doug Thompson <norsk5@yahoo.com>,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090804144502.GK7746@elte.hu>
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com> <20090720192229.GC16072@basil.fritz.box> <4A64D0F2.7050009@zytor.com> <4A6538EE.6000903@jp.fujitsu.com> <20090721065128.GA29028@basil.fritz.box> <20090721104924.GD32338@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721104924.GD32338@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Tue, Jul 21, 2009 at 08:51:28AM +0200, Andi Kleen wrote:
> > On Tue, Jul 21, 2009 at 12:41:34PM +0900, Hidetoshi Seto wrote:
> > > H. Peter Anvin wrote:
> > > >  If you want modules to change the behavior, you're talking about a
> > > > *dynamic* change -- the call will point to different things at different
> > > > points in time -- so you need another mechanism, i.e. function pointers.
> > > 
> > > Just FYI, machine check handler on ia64 has such function pointer.
> > > 
> > > [arch/ia64/kernel/mca.c]
> > >     826 /* Function pointer for extra MCA recovery */
> > >     827 int (*ia64_mca_ucmc_extension)
> > >     828         (void*,struct ia64_sal_os_state*)
> > >     829         = NULL;
> > 
> > A notifier would be a much more flexible solution. Function 
> > pointers don't really work well with multiple users, which might 
> > well happen here.
> > 
> > However on the other hand I have some doubts it's really a good 
> > idea to expose fatal MCEs to modules. MCE is a rather critical 
> > code path (a bit similar to an oops), with the machine already 
> > somewhat instable in many cases and if you allow arbitary 
> > modules to hook into that you risk long term instability.
> > 
> > So if a notifier is done I would recommend to only limit it to 
> > corrected MCEs (machine_check_poll), not fatal ones.
> 
> However, the idea is to decode _all_ MCEs so we could look into 
> moving the decoding bits into the EDAC core or some other more 
> appropriate place. Ingo?
> 
> We could then reroute the non fatals to EDAC for further decoding.

Yep, obviously the kernel entity with the wider view (which is EDAC 
here) should interpret such errors and decide policy or do some good 
default actions. The arch level MCE code is basically a lowlevel 
platform driver to the EDAC code.

And please dont do stupid notifiers. They are opaque and cause 
various problems. Integrate the code for good - there's no technical 
reason to keep it all separate.

	Ingo
