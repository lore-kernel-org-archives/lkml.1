Return-Path: <linux-kernel-owner+w=401wt.eu-S1764457AbXKQTeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764457AbXKQTeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759101AbXKQTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:33:59 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49701 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758975AbXKQTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:33:58 -0500
Date: Sat, 17 Nov 2007 11:33:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
In-Reply-To: <20071117100507.912c5e5c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711171128530.7986@schroedinger.engr.sgi.com>
References: <473DA608.1020804@linux.vnet.ibm.com>
 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
 <20071117100507.912c5e5c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007, Andrew Morton wrote:

> > Don't know who to bug about that.
> 
> That's slub.  It appears that list_lock is being taken from process context
> in one place and from softirq in another.

I kicked out some weird interrupt disable code in mm that was only run during
NUMA bootstrap.

This should fix it but isnt there some mechanism to convince lockdep that 
it is okay to do these things during bootstrap?

---
 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-17 11:31:21.044136631 -0800
+++ linux-2.6/mm/slub.c	2007-11-17 11:32:17.364386560 -0800
@@ -2044,7 +2044,9 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
+	local_irq_disable();
 	add_partial(kmalloc_caches, page, 0);
+	local_irq_enable();
 	return n;
 }
 

