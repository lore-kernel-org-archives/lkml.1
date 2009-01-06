Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZAFKOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZAFKOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZAFKOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:14:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59463 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750792AbZAFKOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:14:14 -0500
Date: Tue, 6 Jan 2009 11:14:03 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
Message-ID: <20090106111403.2bdc0f83@hskinnemoen-d830>
In-Reply-To: <20090106.103344.134344452.nemoto@toshiba-tops.co.jp>
References: <20090105153024.179c9f29@hskinnemoen-d830>
	<20090106.003558.115932572.anemo@mba.ocn.ne.jp>
	<20090105164847.6fbca375@hskinnemoen-d830>
	<20090106.103344.134344452.nemoto@toshiba-tops.co.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> > > > Since dwc_scan_descriptors() was just called, all descriptors that were
> > > > completed successfully have been removed from the active list. So the
> > > > first entry must be the broken one.    
> > > 
> > > But the removal from the active list is done in tasklet too.  If the
> > > CPU was slow and DMA engine was fast enough, DMA engine will process
> > > multiple descriptors before the tasklet called, no ?  
> > 
> > The DMA engine stops if it encounters a bad address.  
> 
> Yes.  And it does not mean the bad descriptor is at head of the active
> queue.
> 
> 1) driver enqueue desc A to active list and start DMA engine
> 2) driver enqueue desc B to queue list
> 3) driver enqueue desc C to queue list  (desc C contains bad address)
> 4) DMA engine finish desc A and raise interrupt
> 5) tasklet remove desc A from active list and move desc B and C to active list
> 6) DMA engine finish desc B and raise interrupt
> 7) DMA engine abort desc C and raise interrupt
> 8) tasklet detect error
> 
> The point is the order of (7) and (8) cannot be expected.  If (7)
> comes first, the head of the active list contains desc B at (8) and
> that is not a bad descriptor.

The tasklet won't detect any errors unless the DMA controller flags it,
so (7) must happen before (8). That does not necessarily mean that the
interrupts from (6) and (7) get handled before (8), but I don't think
it matters because dwc_handle_error() calls dwc_scan_descriptors(),
which will remove desc B from the active list if it is finished. And it
must be finished if desc C has failed, so the failed descriptor will
always be at the head of the queue after dwc_scan_descriptors() returns.

Haavard
