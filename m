Return-Path: <linux-kernel-owner+w=401wt.eu-S2992581AbXCBQ17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992581AbXCBQ17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992583AbXCBQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:27:58 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41385 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992581AbXCBQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:27:58 -0500
X-AuditID: d80ac287-a1830bb000002978-73-45e8508de47c 
Date: Fri, 2 Mar 2007 16:27:58 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
In-Reply-To: <20070224225316.GH5049@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0703021617520.6498@blonde.wat.veritas.com>
References: <20070223212303.GA423@tv-sign.ru> <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
 <20070224225316.GH5049@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 Mar 2007 16:27:56.0789 (UTC) FILETIME=[BC313250:01C75CE7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Paul E. McKenney wrote:
> On Sat, Feb 24, 2007 at 10:04:04PM +0000, Hugh Dickins wrote:
> >
> > Have you checked through the SLAB_DESTROY_BY_RCU end in slab.c?
> > Is what that's doing still valid?
> 
> The only thing I see needed due to PREEMPT_RCU is the following comment
> change.
> 
> For a terrified few minutes, I thought that the code assumed that struct
> rcu_head was the same size as struct list_head, but it turns out to only
> assume that struct slab is at least as large as struct slab_rcu.
> 
> 						Thanx, Paul

Thanks for enduring the terror, checking it out, and arriving at
such a reassuring conclusion.  Andrew, please add this to your -mm
collection after (or folded into) Paul's rcu-preemptible-rcu.patch.


PREEMPT_RCU has stricter needs: updated comment on SLAB_DESTROY_BY_RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
---

diff -urpNa -X dontdiff linux-2.6.20/mm/slab.c linux-2.6.20-slabrcufix/mm/slab.c
--- linux-2.6.20/mm/slab.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20-slabrcufix/mm/slab.c	2007-02-24 14:50:39.000000000 -0800
@@ -238,7 +238,7 @@ struct slab {
  * other kind of object (which our subsystem's lock might corrupt).
  *
  * rcu_read_lock before reading the address, then rcu_read_unlock after
- * taking the spinlock within the structure expected at that address.
+ * releasing the spinlock within the structure expected at that address.
  *
  * We assume struct slab_rcu can overlay struct slab when destroying.
  */
