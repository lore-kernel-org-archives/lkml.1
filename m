Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbXLRTFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbXLRTFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 14:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLRTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 14:04:55 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56234 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXLRTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 14:04:54 -0500
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: akepner@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, James.Bottomley@steeleye.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20071218001758.GO21916@sgi.com>
	<4767FA62.9060002@s5r6.in-berlin.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 18 Dec 2007 11:04:47 -0800
In-Reply-To: <4767FA62.9060002@s5r6.in-berlin.de> (Stefan Richter's message of "Tue, 18 Dec 2007 17:50:42 +0100")
Message-ID: <adaejdj3ju8.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2007 19:04:48.0485 (UTC) FILETIME=[DC354950:01C841A8]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Waaay back in October I sent some patches for passing additional 
 > > attributes to the dma_map_* routines:
 > > 
 > > http://marc.info/?l=linux-kernel&m=119137949604365&w=2
 > 
 > Do I understand correctly?:  A device and the CPUs communicate via two
 > separate memory areas:  A data buffer and a status FIFO.  The NUMA
 > interconnect may reorder accesses of the device to the areas.  (Write
 > accesses?  Read accesses?  Both?)

Yes, that is correct.  In-flight DMA writes from the device to system
memory can pass each other, so that the CPU sees a "complete" status
in the completion queue before the operation in question has actually
finished updating CPU memory.

 > To ensure synchronization between device and CPUs, you want to mark a
 > memory area which is to be dma-mapped with a flag which says:  "Writes
 > to the memory region will cause in-flight DMA to be flushed".  Whose
 > writes?  A write access from the device or a write access from a CPU?

Write access from the device.  The idea is to set the flag on the
completion queue, so that when the device writes the "complete" status
for the operation, all DMAs associated with that operation are flushed
first.

 - R.
