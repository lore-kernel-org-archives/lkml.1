Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbXKZSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbXKZSOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXKZSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:14:08 -0500
Received: from ev1s-75-125-39-150.ev1servers.net ([75.125.39.150]:40334 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbXKZSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:14:07 -0500
X-Greylist: delayed 2353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 13:14:05 EST
Date: Mon, 26 Nov 2007 19:28:37 +0100
Message-Id: <200711261828.lAQISbqP003414@colorfullife.mysite.adiungo.com>
From: Manfred Spraul <manfred@colorfullife.com>
Subject: __rcu_process_callbacks() in Linux 2.6
To: "James Huang" <jamesclhuang@yahoo.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

If I understand the issue correctly, then the race is:

step 1: cpu 1: starts a new rcu batch (i.e. rcp->cur++, smb_mb)

step 2: cpu 2: completes the quiet state 
step 3: cpu 2: reads pointer 0x123 (ptr to a rcu protected struct)

step 4: cpu 3: call_rcu(0x123): rcu protected struct added to rdp->nxtlist
step 5: cpu 3: moves a new batch into rdp->curlist, rdp->batch = rcp->cur+1.
xxxxxxxxxxxxxxx Problem: where is the smp_rmb() that guarantees that
xxxxxxxxxxxxxxx   update to rcp->cur from step 1 is seen by cpu 3?
step 6: cpu 3: completes quiet state
step 7: cpu 3: struct 0x123 destroyed

step 8: cpu 2: accesses pointer 0x123, but the struct is already destroyed

James: Is that the race?

I agree with Paul, there are smb_rmb's on cpu 3 between Step 1 and Step 5:
Either the test_and_set_bit in tasklet_action for rcu_process_callback
if step 4 happens before the tasklet or somewhere in the irq handler
path if step 4 happens in an irq handler that interrupted
rcu_process_callback.

Thus theoretically no additional smb_rmb() should be necessary.
What is missing is proper documentation.

I'm analyzing the code right now:
Is it really true that typically a cpu only completes data in every other rcu
cycle? I.e. that most structures are stored in the rcu callback list until two
quiet states happened?

I've tried to track the values of rcp->cur and rdp->batch.
If next_pending is set, then cpu_quiet() immetiately starts
the next rcu cycle and a cpu cannot both complete the currently
pending rcu callbacks and add new callbacks to the next cycle,
thus a cpu only takes part in every other rcu cycle.

The oocalc file is at
http://www.colorfullife.com/~manfred/rcu.ods
http://www.colorfullife.com/~manfred/rcu.pdf

Is that analysis correct? Perhaps the whole code should be rewritten?

--
	Manfred

