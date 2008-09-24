Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYIXPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYIXPpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYIXPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:44:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39739 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYIXPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:44:56 -0400
Date: Wed, 24 Sep 2008 09:44:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
Message-ID: <20080924154439.GM27204@parisc-linux.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org> <20080924055116.GA3101@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924055116.GA3101@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:51:16PM -0600, Grant Grundler wrote:
> Being one of the "driver guys", let me add my thoughts.
> For the following discussion, I think we can treat MSI and MSI-X the
> same and will just say "MSI".

I really don't think so.  MSI suffers from numerous problems, including
on x86 the need to have all interrupts targetted at the same CPU.  You
effectively can't reprogram the number of MSI allocated while the device
is active.  So I would say this discussion applies *only* to MSI-X.

> Dave Miller (and others) have clearly stated they don't want to see
> CPU affinity handled in the device drivers and want irqbalanced
> to handle interrupt distribution. The problem with this is irqbalanced
> needs to know how each device driver is binding multiple MSI to it's queues.
> Some devices could prefer several MSI go to the same processor and
> others want each MSI bound to a different "node" (NUMA).

But that's *policy*.  It's not what the device wants, it's what the
sysadmin wants.

> A second solution I thought of later might be for the device driver to
> export (sysfs?) to irqbalanced which MSIs the driver instance owns and
> how many "domains" those MSIs can serve.  irqbalanced can then write
> back into the same (sysfs?) the mapping of MSI to domains and update
> the smp_affinity mask for each of those MSI.
> 
> The driver could quickly look up the reverse map CPUs to "domains".
> When a process attempts to start an IO, driver wants to know which
> queue pair the IO should be placed on so the completion event will
> be handled in the same "domain". The result is IOs could start/complete
> on the same (now warm) "CPU cache" with minimal spinlock bouncing.
> 
> I'm not clear on details right now. I belive this would allow
> irqbalanced to manage IRQs in an optimal way without having to
> have device specific code in it. Unfortunately, I'm not in a position
> propose patches due to current work/family commitments. It would
> be fun to work on. *sigh*

I think looking at this in terms of MSIs is the wrong level.  The driver
needs to be instructed how many and what type of *queues* to create.
Then allocation of MSIs falls out naturally from that.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
