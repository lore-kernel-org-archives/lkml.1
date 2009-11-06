Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZKFFNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZKFFNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZKFFNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:13:11 -0500
Received: from waste.org ([173.11.57.241]:56038 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKFFNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:13:10 -0500
Subject: Re: netconsole: tulip: possible remote DoS? due to kernel freeze
 on heavy RX traffic after Order-1 allocation failure
From: Matt Mackall <mpm@selenic.com>
To: Tobias Diedrich <ranma@tdiedrich.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091106032754.GA15429@yumi.tdiedrich.de>
References: <20091105113106.GA4373@yumi.tdiedrich.de>
	 <1257450578.2873.609.camel@calx> <20091106032754.GA15429@yumi.tdiedrich.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 23:13:04 -0600
Message-ID: <1257484384.2873.618.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 04:27 +0100, Tobias Diedrich wrote:
> Matt Mackall wrote:
> > > Example from netconsole log:
> > > |perl: page allocation failure. order:1, mode:0x20
> > > |Pid: 3541, comm: perl Tainted: G        W  2.6.30.9-tomodachi #16
> > > |Call Trace:
> > > | [<c013e56d>] ? __alloc_pages_internal+0x353/0x36f
> > > | [<c0154f2c>] ? cache_alloc_refill+0x2ab/0x544
> > > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > > | [<c015526f>] ? __kmalloc_track_caller+0xaa/0xf9
> > > | [<c0354ae5>] ? __alloc_skb+0x48/0xff
> > > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > > | [<c02d4ba9>] ? tulip_refill_rx+0x3c/0x115
> > > | [<c02d4fff>] ? tulip_poll+0x37d/0x416
> > > | [<c0359763>] ? net_rx_action+0x6b/0x12f
> > > | [<c0121ad7>] ? __do_softirq+0x4e/0xbf
> > > | [<c0121a89>] ? __do_softirq+0x0/0xbf
> > > | <IRQ>  [<c0107700>] ? do_IRQ+0x53/0x63
> > > | [<c0106610>] ? common_interrupt+0x30/0x38
> > 
> > I don't see anything in this trace to implicate netconsole? This is the
> > normal network receive path running out of input buffers then running
> > into memory fragmentation.
> 
> I'm just thinking the hang might be related to using netconsole.
> I guess I should try reproducing it without it.

You should, though I'd be surprised if it matters.

> Or is it normal that a box will hang if the network receive path runs out of
> input buffers?

No, it's not normal.

> Why does it allocate Order-1 buffers anyway?

Your skbs are allocated via the SLAB allocator, which packs 5 skbs into
an order-1 buffer rather than 4 into 2 order-0 buffers.

Running out of order-1 buffers hasn't been a problem for most people
lately though - is there anything interesting about your workload? Lots
of threads? NFS? Long network processing latencies?

-- 
http://selenic.com : development and support for Mercurial and Linux


