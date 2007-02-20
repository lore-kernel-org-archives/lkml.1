Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXBTTmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXBTTmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXBTTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:42:12 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45637 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932985AbXBTTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:42:11 -0500
Date: Tue, 20 Feb 2007 11:42:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space when (re)activating page
In-Reply-To: <45DB4C87.6050809@redhat.com>
Message-ID: <Pine.LNX.4.64.0702201138360.16314@schroedinger.engr.sgi.com>
References: <45D63445.5070005@redhat.com> <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
 <45DAF794.2000209@redhat.com> <Pine.LNX.4.64.0702200833460.13913@schroedinger.engr.sgi.com>
 <45DB25E1.7030504@redhat.com> <Pine.LNX.4.64.0702201015590.14497@schroedinger.engr.sgi.com>
 <45DB4C87.6050809@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Rik van Riel wrote:

> > Maybe the hunk does apply in a different location than I thought.
> 
> I suspect that's the case ...

No that is not the case:

@@ -875,6 +878,11 @@ force_reclaim_mapped:
 		pagevec_strip(&pvec);
 		spin_lock_irq(&zone->lru_lock);
 	}
+	if (vm_swap_full()) {
+		spin_unlock_irq(&zone->lru_lock);
+		pagevec_swap_free(&pvec);
+		spin_lock_irq(&zone->lru_lock);
+	}
 
 	pgmoved = 0;
 	while (!list_empty(&l_active)) {

So you do the swap free on the pages leftover from moving to the inactive 
list and not to the pages that will be moved to the active list. It does 
not do what you wanted to be done.

You need to

1. Do the pagevec_swap_free in the loop over the active pages

2. At end of the loop over the active pages do something like the above.

