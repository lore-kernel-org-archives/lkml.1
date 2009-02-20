Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZBTAvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZBTAvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBTAvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:51:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42106 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZBTAvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:51:37 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>
CC: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Date: Thu, 19 Feb 2009 18:50:52 -0600
Subject: RE: [PATCH E 11/14] OMAP clock: track child clocks
Thread-Topic: [PATCH E 11/14] OMAP clock: track child clocks
Thread-Index: AcmSjGIpbwnLdr55SiaKzodolaFJKAAZYHpg
Message-ID: <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
 <20090128192756.29333.41541.stgit@localhost.localdomain>
 <20090129151401.GC18233@n2100.arm.linux.org.uk>
 <20090129220608.GJ18233@n2100.arm.linux.org.uk>
 <20090209141156.GB16626@n2100.arm
 <20090219121932.GL6407@n2100.arm.linux.org.uk>
In-Reply-To: <20090219121932.GL6407@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Thursday, February 19, 2009 6:20 AM

> > > > Consider what happens when a clock is enabled - we walk up the tree
> > > > enabling all parents.  If we then change the clock's parent, and
> > > > then disable the child, we will again walk up the tree, but since
> > > > we've reparented it, it will be a different clock tree.  The result
> > > > is that the ancestors clock usage counts, and therefore their enable
> > > > status, will end up getting screwed up.
> > >
> > > Agreed.

The historic usage of this has been against single use leaf clocks (1st instance of gptimer).  When it was used it did:
        clk_get()
        clk_set_parent()
        clk_enable()

This usage was ok for that. Use on a disabled clock is needed.

If there are multiple users on the clock or it is enabled there are problems.

> > > > This brings up a question: what we currently do here is:
> > > >
> > > > - disable the child
> > > > - program clksel
> > > > - enable the child
> > > > - change child->parent
> > > >
> > > > If we add in the parent handling, there are two possibilities:
> > > >
> > > > - disable the child
> > > > - enable the new parent tree
> > > > - program clksel
> > > > - change child->parent
> > > > - disable the old parent tree
> > > > - enable the child
> > > >
> > > > OR
> > > >
> > > > - disable the child and the old parent tree
> > > > - program clksel
> > > > - change child->parent
> > > > - enable the new parent tree and the child
> > > >
> > > > (note those 'and's have implied ordering).
> > > >
> > > > Is there anything which dictates one approach over the other?
> > > > Obviously the latter approach results in something smaller and
> > > > cleaner, but might not be technically correct.
> > >
> > > I don't know of any hardware reason to prefer one approach over the other,
> > > but Richard might know better.

I'm not aware of any hw issue. I like option #2 it keeps parent tree (likely) off when divider is set.

The call can still be unfriendly if 2 different drivers are using the clock with their own clock get/enable. It might be the function should return an error if usecount != 0 to stop surprises.  It is all around better if the parenting is done when the clock is off.

The end user needs to be smart also. If the module has local divider it should set it _before_ enabling the clock. Letting a clock which is too fast for you propagate in can cause badness.

clk_get
clk_set_parent
rate = Clk_get_rate
set local divider
clk_enable

Regards,
Richard W.
