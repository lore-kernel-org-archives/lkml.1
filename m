Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXF2EKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXF2EKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXF2EJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:09:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56110
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbXF2EJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:09:53 -0400
Date: Thu, 28 Jun 2007 21:10:13 -0700 (PDT)
Message-Id: <20070628.211013.74747656.davem@davemloft.net>
To: clameter@sgi.com
Cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter
 gather lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 28 Jun 2007 21:01:36 -0700 (PDT)

> Modify the functions in the affected arches to check for PageSlab() and 
> use a NULL mapping if such a page is encountered. This may only be 
> necessary for parisc and arm since sparc64 and xtensa do not scan over 
> processes mapping a page but I have modified those two arches also for 
> correctnesses sake since they use page_mapping() in flush_dcache_page().
> 
> Still a better solution would be to not use the slab allocator at all for 
> the objects that are used to send commands to the devices. These are not 
> permanent and grabbing a page from the pcp lists and putting it back is 
> likely as fast as performing a kmalloc.

Jens Axboe wants to get references to the page structs behind
kmalloc() allocated pages in his networking splice work.

We pass scatterlists around, but networking buffers are
composed of a kmalloc()'d data header area for packet headers
and some of the initial packet data, then a true scatterlist
of page/offset/len triplets.

Splice wants to work with pages everwhere.

This is a reocurring theme, we should provide some kind of
solution to these issues instead of wishing they would go
away.

We could make a special allocator in the networking that carves
chunks out of pages but I'm sure you'll find that about as stupid
and wasteful as I do :-)

