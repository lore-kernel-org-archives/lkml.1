Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbXBXWxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbXBXWxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933577AbXBXWxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:53:14 -0500
Received: from pool-71-111-73-6.ptldor.dsl-w.verizon.net ([71.111.73.6]:9172
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933579AbXBXWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:53:14 -0500
X-Greylist: delayed 980 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 17:53:13 EST
Date: Sat, 24 Feb 2007 14:53:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
Message-ID: <20070224225316.GH5049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070223212303.GA423@tv-sign.ru> <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 10:04:04PM +0000, Hugh Dickins wrote:
> On Sat, 24 Feb 2007, Oleg Nesterov wrote:
>
> Have you checked through the SLAB_DESTROY_BY_RCU end in slab.c?
> Is what that's doing still valid?

The only thing I see needed due to PREEMPT_RCU is the following comment
change.

For a terrified few minutes, I thought that the code assumed that struct
rcu_head was the same size as struct list_head, but it turns out to only
assume that struct slab is at least as large as struct slab_rcu.

						Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
