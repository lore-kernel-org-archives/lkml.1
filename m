Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXHNTNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXHNTNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbXHNTMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:12:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39877 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934243AbXHNTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:16 -0400
Date: Tue, 14 Aug 2007 12:12:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <p73vebhnauo.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com>
 <p73vebhnauo.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> Christoph Lameter <clameter@sgi.com> writes:
> 
> > Reclaim can be called with interrupts disabled in atomic reclaim.
> > vmscan.c is currently using spinlock_irq(). Switch to spin_lock_irqsave().
> 
> I like the idea in principle. If this fully works out we could
> potentially keep less memory free by default which would be a good
> thing in general: free memory is bad memory.

Right.
 
> But would be interesting to measure what the lock
> changes do to interrupt latency. Probably nothing good.

Yup.
 
> A more benign alternative might be to just set a per CPU flag during
> these critical sections and then only do atomic reclaim on a local
> interrupt when the flag is not set.  That would make it a little less
> reliable, but much less intrusive and with some luck still give many
> of the benefits.

There are other lock interactions that may cause problems. If we do not 
switch to the saving of irq flags then all involved spinlocks must become 
trylocks because the interrupt could have happened while the spinlock is 
held. So interrupts must be disabled on locks acquired during an 
interrupt.

