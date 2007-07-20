Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbXGTHbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbXGTHbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbXGTHbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:31:18 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35315 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbXGTHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:31:17 -0400
Date: Fri, 20 Jul 2007 16:30:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720073053.GA26080@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070720060342.GA24765@linux-sh.org> <20070720162152.25c929bf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720162152.25c929bf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 04:21:52PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 20 Jul 2007 15:03:42 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > zone_movable_pfn is presently marked as __initdata and referenced
> > from adjust_zone_range_for_zone_movable(), which in turn is
> > referenced by zone_spanned_pages_in_node(). Both of these are
> > __meminit annotated. When memory hotplug is enabled, this will oops
> > on a hot-add, due to zone_movable_pfn having been freed.
> > 
> > __meminitdata annotation gives the desired behaviour.
> > 
> > This will only impact platforms that enable both memory hotplug
> > and ARCH_POPULATES_NODE_MAP.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > 
> Thank you for catching.
> It seems that this route will called at node-hotplug.
> We tested node hotplug with our machine but haven't seen this.
> 
> The reason is maybe...
> ==
> Currently, our firmware shows *to-be-added* nodes in SRAT at boot and
> ia64 creates empty node against possible node. So, when we add node,
> pgdat is already allocated and free_area_init_core() is not called at hotplug.
> ==
> We need to use dummy firmware to test this route, sorry.
> 
Correct, if the pgdat is already allocated on the node you're adding,
then you shouldn't hit this path. I've been toying with the hotplug code
for handoffs of small SRAM blocks (transitioning between exclusive
application usage and letting the kernel manage it as a node), which can
reliably follow this path. It's managed to find a couple of oopses in
this area at least, this not being the first :-)
