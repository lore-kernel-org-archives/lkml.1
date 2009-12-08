Return-Path: <linux-kernel-owner+w=401wt.eu-S966806AbZLHWnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966806AbZLHWnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZLHWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:43:38 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:55552
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbZLHWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:43:37 -0500
Message-ID: <4B1ED69F.4050609@microgate.com>
Date: Tue, 08 Dec 2009 16:43:43 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt dropped transmit data bugfix
References: <1260310010.3764.49.camel@x2.microgate.com> <20091208135510.ffd75637.akpm@linux-foundation.org>
In-Reply-To: <20091208135510.ffd75637.akpm@linux-foundation.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 08 Dec 2009 16:06:50 -0600
> Paul Fulghum <paulkf@microgate.com> wrote:
> 
>> +	/* check required buffer space */
>> +	bufs_needed = (size/DMABUFSIZE);
>> +	if (size % DMABUFSIZE)
>> +		++bufs_needed;
> 
> 	bufs_needed = DIV_ROUND_UP(size, DMABUFSIZE);

A reasonable substitution.

> That unsent_tbufs() call looks like it might be expensive.

unsent_tbufs() is called from isr_txeom() when the serial
transmitter has gone idle.

The common case is that the DMA buffers are empty
(all count fields reset to zero by DMA controller)
so the loop falls out on the first comparison.

The second most common case will be a single
data block added just after the DMA controller quits but
before the serial transmitter is idle. Here you only
need to back track the few buffers consumed by that block.

The degenerate case is a large burst of write calls
just after the DMA controller quits but before the
serial transmitter is idle. There are only 32 total
descriptors to iterate so worst case is still not that bad
and won't happen often. There is a single comparison per
descriptor and the descriptors are contained in system
memory and not card memory behind a PCI bridge.

The case of keeping the buffers full and transmitter
constantly active (sustained heavy traffic) results
in no calls to unsent_tbufs().


-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
