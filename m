Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYIYQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYIYQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYIYQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:16:06 -0400
Received: from colo.lackof.org ([198.49.126.79]:41085 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYIYQQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:16:03 -0400
Date: Thu, 25 Sep 2008 10:15:52 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
Message-ID: <20080925161552.GD2997@colo.lackof.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org> <20080924055116.GA3101@colo.lackof.org> <20080924154439.GM27204@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924154439.GM27204@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:44:40AM -0600, Matthew Wilcox wrote:
> On Tue, Sep 23, 2008 at 11:51:16PM -0600, Grant Grundler wrote:
> > Being one of the "driver guys", let me add my thoughts.
> > For the following discussion, I think we can treat MSI and MSI-X the
> > same and will just say "MSI".
> 
> I really don't think so.  MSI suffers from numerous problems, including
> on x86 the need to have all interrupts targetted at the same CPU.  You
> effectively can't reprogram the number of MSI allocated while the device
> is active.  So I would say this discussion applies *only* to MSI-X.

I would entirely agree with this but we have the "N:1" case that I described.
(multiple vectors which by design should target one CPU.)
In any case, MSI-X is clearly more interesting for this discussion.

> > Dave Miller (and others) have clearly stated they don't want to see
> > CPU affinity handled in the device drivers and want irqbalanced
> > to handle interrupt distribution. The problem with this is irqbalanced
> > needs to know how each device driver is binding multiple MSI to it's queues.
> > Some devices could prefer several MSI go to the same processor and
> > others want each MSI bound to a different "node" (NUMA).
> 
> But that's *policy*.  It's not what the device wants, it's what the
> sysadmin wants.

That sounds remarkable close saying the sysadmin has to know about
each devices attributes. If interpreted that way, I'll argue that's
not realistic in 99% of the cases and certainly not how sysadmins
want to spend their time (frobbing irqbalanced policy).

> 
> > A second solution I thought of later might be for the device driver to
> > export (sysfs?) to irqbalanced which MSIs the driver instance owns and
> > how many "domains" those MSIs can serve.  irqbalanced can then write
> > back into the same (sysfs?) the mapping of MSI to domains and update
> > the smp_affinity mask for each of those MSI.
> > 
> > The driver could quickly look up the reverse map CPUs to "domains".
> > When a process attempts to start an IO, driver wants to know which
> > queue pair the IO should be placed on so the completion event will
> > be handled in the same "domain". The result is IOs could start/complete
> > on the same (now warm) "CPU cache" with minimal spinlock bouncing.
> > 
> > I'm not clear on details right now. I belive this would allow
> > irqbalanced to manage IRQs in an optimal way without having to
> > have device specific code in it. Unfortunately, I'm not in a position
> > propose patches due to current work/family commitments. It would
> > be fun to work on. *sigh*
> 
> I think looking at this in terms of MSIs is the wrong level.  The driver
> needs to be instructed how many and what type of *queues* to create.
> Then allocation of MSIs falls out naturally from that.

Yes, good point. That's certainly a better approach and could precede
the "second proposal" above. ie driver queries how many domains it
should "plan" for, set up that many queues, and request the same number
of MSI-X vectors.

That still leaves open which code is going to export queue attribute
information to irqbalanced. My guess is the driver query could provide
a table which could be exported. But it would make more sense to export
when the msi's are allocated since we want to associate with actually
allocated MSI-X vectors.

thanks,
grant
