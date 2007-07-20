Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbXGTHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbXGTHUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXGTHUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:20:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39134 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbXGTHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:20:33 -0400
Date: Fri, 20 Jul 2007 16:21:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-Id: <20070720162152.25c929bf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070720060342.GA24765@linux-sh.org>
References: <20070720060342.GA24765@linux-sh.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 15:03:42 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> zone_movable_pfn is presently marked as __initdata and referenced
> from adjust_zone_range_for_zone_movable(), which in turn is
> referenced by zone_spanned_pages_in_node(). Both of these are
> __meminit annotated. When memory hotplug is enabled, this will oops
> on a hot-add, due to zone_movable_pfn having been freed.
> 
> __meminitdata annotation gives the desired behaviour.
> 
> This will only impact platforms that enable both memory hotplug
> and ARCH_POPULATES_NODE_MAP.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
Thank you for catching.
It seems that this route will called at node-hotplug.
We tested node hotplug with our machine but haven't seen this.

The reason is maybe...
==
Currently, our firmware shows *to-be-added* nodes in SRAT at boot and
ia64 creates empty node against possible node. So, when we add node,
pgdat is already allocated and free_area_init_core() is not called at hotplug.
==
We need to use dummy firmware to test this route, sorry.

just thinking of:
I'm now considering to post patches for "specifies a zone which all hotaddes pages are
added to, MOVABLE, NORMAL, DMA..."If we do that, we may be able to avoid calling 
adjust_zone_range_for_zone_movable() (which touches this __meminit data) at hot-add.

Thanks,
-Kame

