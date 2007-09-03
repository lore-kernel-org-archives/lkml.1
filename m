Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXICPUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXICPUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 11:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXICPU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 11:20:27 -0400
Received: from web32611.mail.mud.yahoo.com ([68.142.207.238]:20550 "HELO
	web32611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752404AbXICPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 11:20:26 -0400
X-YMail-OSG: ge2swkMVM1nLUzJUp_H3fS23Ja3qPOOMNbf2A6CoUtSc3VZHQY0opEQTmjAdPkcxwEfW8_B0LlutHQReBDYz2nvSQg--
X-RocketYMMF: knobi.rm
Date: Mon, 3 Sep 2007 08:20:25 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: RFC: [PATCH] Small patch on top of per device dirty throttling -v9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, spamtrap@knobisoft.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1187890919.6114.411.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <569958.63157.qm@web32611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-08-23 at 08:59 -0700, Martin Knoblauch wrote:
> > --- Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2007-08-16 at 05:49 -0700, Martin Knoblauch wrote:
> > > 
> > > > Peter,
> > > > 
> > > >  any chance to get a rollup against 2.6.22-stable?
> > > > 
> > > >  The 2.6.23 series may not be usable for me due to the
> > > > nosharedcache changes for NFS (the new default will massively
> > > > disturb the user-space automounter).
> > > 
> > > I'll see what I can do, bit busy with other stuff atm, hopefully
> > > after
> > > the weekend.
> > > 
> > Hi Peter,
> > 
> >  any progress on a version against 2.6.22.5? I have seen the very
> > positive report from Jeffrey W. Baker and would really love to test
> > your patch. But as I said, anything newer than 2.6.22.x might not
> be an
> > option due to the NFS changes.
> 
> mindless port, seems to compile and boot on my test box ymmv.
> 
Hi Peter,

 while doing my tests I observed that setting dirty_ratio below 5% did
not make a difference at all. Just by chance I found that this
apparently is an enforced limit in mm/page-writeback.c.

 With below patch I have lowered the limit to 2%. With that, things
look a lot better on my systems. Load during write stays below 1.5 for
one writer. Responsiveness is good. 

This may even help without the throttling patch. Not sure that this is
the right thing to do, but it helps :-)

Cheers
Martin

--- linux-2.6.22.5-bdi-v9/mm/page-writeback.c
+++ linux-2.6.22.6+bdi-v9/mm/page-writeback.c
@@ -311,8 +311,11 @@
        if (dirty_ratio > unmapped_ratio / 2)
                dirty_ratio = unmapped_ratio / 2;

-       if (dirty_ratio < 5)
-               dirty_ratio = 5;
+/*
+** MKN: Lower enforced limit from 5% to 2%
+*/
+       if (dirty_ratio < 2)
+               dirty_ratio = 2;

        background_ratio = dirty_background_ratio;
        if (background_ratio >= dirty_ratio)


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
