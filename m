Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbXJaQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbXJaQ3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbXJaQ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:29:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbXJaQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:29:07 -0400
Date: Wed, 31 Oct 2007 09:25:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 27/26] lockdep: fix mismatched lockdep_depth/curr_chain_hash
Message-ID: <20071031162514.GB22117@kroah.com>
References: <20071031151015.GA2437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[one more patch added to the 2.6.22-stable queue]


From: Gregory Haskins <ghaskins@novell.com>

patch 3aa416b07f0adf01c090baab26fb70c35ec17623 in mainline.

lockdep: fix mismatched lockdep_depth/curr_chain_hash

It is possible for the current->curr_chain_key to become inconsistent with the
current index if the chain fails to validate.  The end result is that future
lock_acquire() operations may inadvertently fail to find a hit in the cache
resulting in a new node being added to the graph for every acquire.

[ peterz: this might explain some of the lockdep is so _slow_ complaints. ]
[ mingo: this does not impact the correctness of validation, but may slow
  down future operations significantly, if the chain gets very long. ]

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2166,7 +2166,6 @@ out_calc_hash:
 	}
 #endif
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -2215,6 +2214,7 @@ out_calc_hash:
 		if (unlikely(!debug_locks))
 			return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable

