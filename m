Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYA3Vl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYA3Vl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYA3Vlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:41:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60423 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYA3Vln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:41:43 -0500
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080130212011.GA26621@uranus.ravnborg.org>
References: <20080130200336.GN29368@does.not.exist>
	 <1201726817.3292.84.camel@localhost.localdomain>
	 <20080130212011.GA26621@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 15:41:35 -0600
Message-Id: <1201729295.3292.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 22:20 +0100, Sam Ravnborg wrote:
> On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
> > 
> > On Wed, 2008-01-30 at 22:03 +0200, Adrian Bunk wrote:
> > > This patch fixes the following section mismatches:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > > WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
> > > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
> > > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
> > > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
> > > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
> > > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
> > > ...
> > 
> > OK, look, this is really getting out of hand.
> We now at last have some infrastructure that does proper consistency
> check of the use of annotation.
> So it is by no means getting out-of-hands..
> 
> To my understanding Adrian just fixed a potential oops.
> You have a driver that surely are thought to be hotplugable -
> otherwise qpti_sbus_probe() would not have been annotated __devinit.
> And had it ever been hotplugged then you had called a function in
> a __init section that was long gone.

I never said it didn't fix a bug.  I'm just reflecting that all of the
problems would go away and we'd save thousands of person hours on the
infrastructure and bug fixing if we simply #defined most of the
sectional annotations to be nops.

My basic question is "is the value of what all of this buys us
(basically a few hundred k in savings)" worth all the investment we're
putting into it.  Particularly as it looks like that investment is
becoming increasingly expensive.

> > __init is possibly justifiable with a few hundred k savings on boot.
> > __devinit and the rest are surely killable on the grounds they provide
> > little benefit for all the pain they cause.
> For the embedded people a few kb here and there is worth it.
> 
> > all __exit seems to do is set us up for unreferenced pointers in
> > discarded sections, so could we kill that too?
> Again - savings when we build-in the drivers.
> And without the checks we see 'funny' linker errors on the architectues
> that can continue to add the .exit.text in /DISCARD/

Perhaps you have different figures, but my standard kernel linking ones
tell me that the discard sections only save tens of k (not hundreds that
the init ones save), so I really do think they have no real benefit and
land us huge problems of pointer references into discarded sections.

I don't deny we can invest large amounts of work to fix our current
issues and build large scriptable checks to ensure we keep it fixed ...
I'm just asking if, at the end of the day, it's really worth it.

James


