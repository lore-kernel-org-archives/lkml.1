Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZCJVaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZCJVaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZCJVag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:30:36 -0400
Received: from ping.pong.ch ([212.103.71.101]:39465 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbZCJVac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:32 -0400
Date: Tue, 10 Mar 2009 22:30:27 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
	breaks resume from RAM on PowerBook
Message-ID: <20090310213027.GB6272@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch> <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch> <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch> <1236333440.7260.136.camel@pasglop> <20090306114149.GA5371@soziologie.ch> <1236638264.7260.192.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236638264.7260.192.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:37:44AM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2009-03-06 at 12:41 +0100, Gaudenz Steinlin wrote:
> 
> > > Another thing you can try in radeonfb_pci_resume():
> > > 
> > >         if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> > > +		pci_restore_state(pdev);
> > 
> > Adding this fixes the bug. Apparently the PCI core does not fully
> > restore the state. Before your suggestions I also tried to find out
> > which part of your commit breaks resume and I found out that if I
> > reinsert the parts to save and restore the pci configuration the bug is
> > fixed. It seems that somehow the PCI coniguration is not fully restored [1].  
> 
> Ok so this doesn't make sense to me at this stage... I see two
> possibilities:
> 
>  1- You haven't properly done the test disabling the early resume hack
> (ie, you may have done it with also CPU_FREQ disabled for example) and
> got a false negative there. The platform code calls into the early
> resume stuff before the PCI core gets a chance to restore things so that
> would be an explanation. I'll send a patch fixing that.
> 
> or
> 
>  2- For some reason, the core call to pci_raw_set_power_state() from
> pci_restore_standard_config() is returning an error. That would cause
> the later not to restore the rest of the config.
> 
> So what I suggest is that while keeping your added pci_restore_state()
> in there, you also add some printk's in pci_restore_standard_config() to
> see anything weird happens in there or if it appears to properly call
> pci_restore_state(). It would be useful for us to know.

Are you still interested in these tests after that disabling the early
resume hack fixed things? I can try my best to test and add printk's but
it will probably take some time because I can't constantly reboot my
computer and still do some usefull work...

Gaudenz


-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
