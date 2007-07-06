Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbXGFH2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbXGFH2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXGFH16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:27:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbXGFH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:27:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:35:10 +0200
User-Agent: KMail/1.9.5
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <CF60EC03-0171-4052-924D-57555A393168@mac.com> <1183694347.3388.114.camel@localhost.localdomain>
In-Reply-To: <1183694347.3388.114.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060935.11186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 05:59, Benjamin Herrenschmidt wrote:
> 
> > How about a freezer whose job it is to "wait for pending hard  
> > interrupts to complete when we have already guaranteed that we won't  
> > get any more"?  That part should be really *REALLY* easy.  You don't  
> > need to care about either userspace processes or kernel threads at  
> > all.  Specifically, Step 1 consists of:
> 
> Well, waiting for pending DMA and making sure to not trigger more
> activity is what driver suspend() is supposed to do. With the ability
> for simple drivers that can cope with it to just basically use a
> late_suspend(), called after IRQs are off, that basically does what you
> describe: wait for pending HW tasks to complete (polling) and turn the
> damn thing off.
> 
> Note that the later is really a shortcut for somewhat dump and directly
> accessible devices (PCI comes to mind). Things like USB has to use the
> "normal" mechanism of blocking IOs etc... at suspend(), at least, USB
> devices have to since the USB HC will not issue any new URBs. (And will
> return them with a nice error code which is a perfect way to deal with
> it in driver, been there, it works fine, once we fixed the races in the
> USB host code itself, which I think we pretty much did by now).
> 
> > Scheduling and userspace are all still fully enabled in this  
> > scenario.  Once all your devices are turned off, the only remaining  
> > running threads will be those which haven't done IO since the  
> > beginning of the suspend.  We can then disable preemption, turn off  
> > the timer interrupts, and tell the other CPUs to park all their  
> > remaining threads in schedule() and sleep.  Then we put the IRQ  
> > controller to sleep and go to sleep ourselves.  If our driver model  
> > locking is sufficient to handle putting a parent device to sleep  
> > while threads are sleeping on a child device then there are exactly 0  
> > problems.
> 
> What you propose is basically a slightly over-simplistic version of what
> I think (and Paulus think) should be done. We do need to do it via
> driver callbacks down the tree since only drivers can know how to deal
> with their DMA etc... and ordering need to be respected, but that's
> basically it.
> 
> And guess what ? It's what we do on powerbooks, and it works fine,
> without a freezer :-)

On powerbooks you disable the nonboot CPUs before suspending devices, which
simplifies things _a_ _lot_ in comparison with the general case.

If you additionally disable kernel preemption, then you don't need anything
like the freezer anyway in that case (except for detecting situations in which
the suspend process can deadlock with a task stuck in the D state holding a
lock, but that's overkill).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
