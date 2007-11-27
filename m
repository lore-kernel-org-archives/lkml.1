Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXK0KzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXK0KzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbXK0KzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:55:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59533 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbXK0KzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:55:05 -0500
Date: Tue, 27 Nov 2007 11:55:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: kexec@lists.infradead.org, ak@suse.de, vgoyal@in.ibm.com, hbabu@us.ibm.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127105503.GD24223@one.firstfloor.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127014740.GA28622@hmsreliant.think-freely.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 08:47:40PM -0500, Neil Horman wrote:
> Hey all-
> 	I've been working on an issue lately involving multi socket x86_64
> systems connected via hypertransport bridges.  It appears that some systems,
> disable the hypertransport connections during a kdump operation when all but the
> crashing processor gets halted in machine_crash_shutdown.  This becomes a

That would be hard to believe. Linux cannot shut down CPUs
completely (put them back to SINIT state) because there is no generic
interface for this and it might be impossible. They just get put 
into a HLT loop.

And even if they were in SINIT they would still need the HT connections
otherwise it would be impossible to ever wake them up.

The way HT setup is normally done is that the BIOS sets it all up
and then it never changes (except for some error conditions that 
may cause SYNC flood) 


> problem when the ioapic attempts to route interrupts to the only remaining
> processor.  Even though the active processor is targeted for interrupt
> reception, the fact that the hypertransport connections are inactive result in
> interrupts not getting delivered.  The effective result is that timer interrupts
> are not delivered to the running cpu, and the system hangs on reboot into the
> kdump kernel during calibrate_delay.  I've found that I've been able to avoid
> this hang, by forcing a transition to the bios defined boot cpu during the
> crashing kernel shutdown.  This patch accomplished that.  Tested by myself and
> the origional reporter with successful results.

While that may help I doubt your analysis of the source of the problem
is correct. Most likely something is broken with the IO-APIC, but not
related to HyperTransport.

It would be better to properly root cause before applying.

-Andi
