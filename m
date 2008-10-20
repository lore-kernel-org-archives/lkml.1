Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYJTXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYJTXXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYJTXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:23:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYJTXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:23:03 -0400
Date: Tue, 21 Oct 2008 01:22:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: maluta_tiago@yahoo.com.br, lguest@ozlabs.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Lguest] lguest: unhandled trap
Message-ID: <20081020232241.GB9589@elte.hu>
References: <713731.28571.qm@web50701.mail.re2.yahoo.com> <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu> <200810210948.01108.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810210948.01108.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 20 October 2008 18:22:36 Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > On Monday 20 October 2008 12:50:09 Tiago Maluta wrote:
> > > > --- On Sun, 10/19/08, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > > > Hi,
> > > > > >
> > > > > > I'm using 2.6.27-05323-g26e9a39 and when I try to
> > > > >
> > > > > use lguest:
> > > > > > ~#Documentation/lguest/lguest 128 vmlinux
> > > > > > lguest: unhandled trap 14 at 0xc0594f6a (0xff900000)
> > > > >
> > > > > Yes, I found the same issue.  Does this fix it for you?
> > > >
> > > > Yes. This code fixed the problem.
> > >
> > > Thanks.  Ingo, can you push this?
> > >
> > > Subject: lguest: don't try DMI
> > >
> > > dmi_scan_machine breaks under lguest; this is the simplest fix (though
> > > ugly).  Perhaps this hurts Xen too?
> > >
> > > Error:
> > > 	lguest: unhandled trap 14 at 0xc04edeae (0xffa00000)
> > >
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > >
> > > diff -r 47449cd8e3d8 drivers/firmware/dmi_scan.c
> > > --- a/drivers/firmware/dmi_scan.c	Fri Oct 17 12:14:40 2008 +1100
> > > +++ b/drivers/firmware/dmi_scan.c	Fri Oct 17 20:54:30 2008 +1100
> > > @@ -369,6 +369,11 @@ void __init dmi_scan_machine(void)
> > >  	char __iomem *p, *q;
> > >  	int rc;
> > >
> > > +#ifdef CONFIG_PARAVIRT
> > > +	if (strcmp(pv_info.name, "lguest") == 0)
> > > +		goto error;
> > > +#endif
> > > +
> >
> > hm, could you give some more background please? I'm not subscribed to
> > the lguest list and the thread is not Cc:-ed to lkml (Cc:-ed it now).
> > The patch looks quite ugly because it adds a special-case.
> >
> > Was the problem introduced by:
> >
> > 5649b7c: x86: add DMI quirk for AMI BIOS which corrupts address 0xc000
> > during
> >
> > perhaps?
> >
> > i think Xen can withstand DMI scanning just fine.
> >
> > without having seen any background, my general feeling is that lguest
> > should either do what Xen does and reserve the classic BIOS ranges that
> > we probe - or we should make DMI scanning more robust by making sure
> > real RAM ranges are never probed. (only ranges that the BIOS itself
> > marks as reserved in the e820 map)
> >
> > (with exceptions for the first 4K perhaps.)
> >
> > 	Ingo
> 
> Yes, after this discussion I'm not even sure why it's triggering: even 
> if there's crap in the memory it should not fault.  Digging further.

we could also add an x86_quirks entry to skip the particular DMI scan 
that is causing problems. Would be nice to avoid it though, and fix 
lguest if possible.

	Ingo
