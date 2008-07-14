Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYGNATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYGNATY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYGNATQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:19:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:40015 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbYGNATP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:19:15 -0400
Subject: Re: Multiple MSI, take 3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
In-Reply-To: <m1tzet2wie.fsf@frodo.ebiederm.org>
References: <20080711005719.GO14894@parisc-linux.org>
	 <m1iqvc91li.fsf@frodo.ebiederm.org>
	 <20080711215943.GW1678@linux-os.sc.intel.com>
	 <m1d4lkauxc.fsf@frodo.ebiederm.org> <1215834720.7549.154.camel@pasglop>
	 <m13amf3eak.fsf@frodo.ebiederm.org> <1215848161.7549.166.camel@pasglop>
	 <m1iqv9a030.fsf@frodo.ebiederm.org> <1215989044.7549.219.camel@pasglop>
	 <m1tzet2wie.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 10:17:39 +1000
Message-Id: <1215994659.7549.227.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-13 at 16:29 -0700, Eric W. Biederman wrote:
> Ben.  Multi-MSI is a crap hardware design.  Why do you think we have
> MSI-X?  

I know and I agree. Which is why I'd rather keep the SW crap totally
local to the MSI support code and not add new concepts to the generic
IRQ API such as sub-channels, for which it's really not ready for imho.

They -are- separate IRQs, just badly implemented. Besides, a large part
of the problem is purely due to the typical x86 implementation of them,
since for example, on most PowerPC's (and possibly other archs), they
tend to land in the PIC as normal sources, and as such benefit from all
the "features" of such interrupts like HW masking, affinity control,
etc... at the PIC level.

In any case, SW masking will work just fine, and affinity can be dealt
with without too much harm neither.

> MSI-X as specced is a properly operating irq controller that
> we don't need kludges to support.  Multi-MSI with a full set of
> kludges almost work but not quite fits the linux irq model.

And you want to change the model for it ? I say no :-) Just make them
fit with a hammer. In fact, it's not even a big hammer. The only thing
that doesn't really fit is the affinity bits, which can be dealt with.

> Any hardware designer who choose to implement Multi-MSI instead of
> MSI-X was not really concerned about having a high performance device.

Agreed.

> If we can find a way to model the portable capabilities of Multi-MSI
> cleanly then we can support it, and our drivers and our users and our
> intermediate layers won't get surprised.

Our existing model works just fine imho.

> So far we have too close fits but neither model really works.

I think Willy's initial model can work with SW masking. All of the
latching & re-emission stuff is already in the core. The only problem is
affinity which can be hacked around, by either requiring all irqs to
change affinity or bouncing them all on one change, or only exposing
affinity control on the first one, whatever.
 
> Further this is all about driver optimization, so none of this is
> necessary to have working hardware.  Which makes kludges much less
> appropriate.  Modelling Multi-MSI irqs as normal irqs requires a lot
> of nasty kludges.

No. Not a lot. And those kludge are mostly local to the MSI support core
and don't expose new semantics to the existing IRQ model. 

> One of the kludges is allocating a continuous chunk of irq targets,
> and the resulting fragmentation issues that you get when you start
> allowing different sized allocations.

This is purely a backend issue and isn't a big deal imho.

> Overall if Multi-MSI was to become common I think we would really
> regret it.

I agree. But in the meantime, if we want to support it, I prefer the
option of making it fit in the existing model.

Cheers,
Ben.

