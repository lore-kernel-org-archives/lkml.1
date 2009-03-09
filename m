Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZCIWid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZCIWid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCIWiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:38:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:58578 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZCIWiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:38:24 -0400
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090306114149.GA5371@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch>
	 <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch>
	 <1236333440.7260.136.camel@pasglop>  <20090306114149.GA5371@soziologie.ch>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 09:37:44 +1100
Message-Id: <1236638264.7260.192.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 12:41 +0100, Gaudenz Steinlin wrote:

> > Another thing you can try in radeonfb_pci_resume():
> > 
> >         if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> > +		pci_restore_state(pdev);
> 
> Adding this fixes the bug. Apparently the PCI core does not fully
> restore the state. Before your suggestions I also tried to find out
> which part of your commit breaks resume and I found out that if I
> reinsert the parts to save and restore the pci configuration the bug is
> fixed. It seems that somehow the PCI coniguration is not fully restored [1].  

Ok so this doesn't make sense to me at this stage... I see two
possibilities:

 1- You haven't properly done the test disabling the early resume hack
(ie, you may have done it with also CPU_FREQ disabled for example) and
got a false negative there. The platform code calls into the early
resume stuff before the PCI core gets a chance to restore things so that
would be an explanation. I'll send a patch fixing that.

or

 2- For some reason, the core call to pci_raw_set_power_state() from
pci_restore_standard_config() is returning an error. That would cause
the later not to restore the rest of the config.

So what I suggest is that while keeping your added pci_restore_state()
in there, you also add some printk's in pci_restore_standard_config() to
see anything weird happens in there or if it appears to properly call
pci_restore_state(). It would be useful for us to know.

Cheers,
Ben.


