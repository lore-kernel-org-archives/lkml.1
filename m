Return-Path: <linux-kernel-owner+w=401wt.eu-S1161584AbXBOWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161584AbXBOWju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161579AbXBOWju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:39:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45325 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161580AbXBOWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:39:49 -0500
Date: Thu, 15 Feb 2007 14:39:48 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: James Morris <jmorris@namei.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <20070215135157.18085ae3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702151426260.31972@schroedinger.engr.sgi.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702150926560.25081@d.namei> <20070215135157.18085ae3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Andrew Morton wrote:

> I don't immediately see why that code isn't racy: the page can remain
> in the pagevec for arbitrary amounts of time and someone can come along
> and mlock it again.  But given the ease with which you're hitting this,
> it may not be a race.

As long as the page is on the pagevec it should be off the LRU. 
Marking a page PageMlocked requires the page to be on the LRU. So a page 
cannot be marked PageMlocked as long as it is on the regular pagevecs.

Somehow a page off the LRU was marked PageMlocked. Or a new anonymous page 
was allocated and marked PageMlocked and then some later processing put it 
onto the LRU?

Maybe try_to_set_mlocked does work some havoc here.

Could you see if this patch fixes it? This just disabled an optimization 
to set PageMlocked early.

Index: linux-2.6.20-mm1/mm/memory.c
===================================================================
--- linux-2.6.20-mm1.orig/mm/memory.c	2007-02-15 14:35:41.000000000 -0800
+++ linux-2.6.20-mm1/mm/memory.c	2007-02-15 14:35:54.000000000 -0800
@@ -930,6 +930,8 @@ static void try_to_set_mlocked(struct pa
 	struct zone *zone;
 	unsigned long flags;
 
+	return;
+
 	if (!PageLRU(page) || PageMlocked(page))
 		return;
 
