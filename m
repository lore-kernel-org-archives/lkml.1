Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbXKZXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbXKZXXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXKZXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:23:17 -0500
Received: from mx1.watchguard.com ([206.191.171.101]:30412 "EHLO
	mars.watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755155AbXKZXXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:23:16 -0500
X-Greylist: delayed 2107 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 18:23:16 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: __rcu_process_callbacks() in Linux 2.6
Date: Mon, 26 Nov 2007 14:48:08 -0800
Message-ID: <F474D80A8B96F34D8D70C85A98D6FC178D8BE7@VS02SE.wgti.net>
In-Reply-To: <590353.52909.qm@web83819.mail.sp1.yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: __rcu_process_callbacks() in Linux 2.6
Thread-Index: AcgweqsBKgo85llSTfaTKtjYiD+IaQAAA/ow
References: <590353.52909.qm@web83819.mail.sp1.yahoo.com>
From: "James Huang" <James.Huang@watchguard.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       <linux-kernel@vger.kernel.org>,
       "Manfred Spraul" <manfred@colorfullife.com>
Cc: <jamesclhuang@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Huang [mailto:jamesclhuang@yahoo.com]
> Sent: Monday, November 26, 2007 2:21 PM
> To: James Huang
> Subject: Fw: __rcu_process_callbacks() in Linux 2.6
> 
> ----- Forwarded Message ----
> From: Manfred Spraul <manfred@colorfullife.com>
> To: James Huang <jamesclhuang@yahoo.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>; linux-
> kernel@vger.kernel.org
> Sent: Monday, November 26, 2007 10:28:37 AM
> Subject: __rcu_process_callbacks() in Linux 2.6
> 
> Hi James,
> 
> If I understand the issue correctly, then the race is:
> 
> step 1: cpu 1: starts a new rcu batch (i.e. rcp->cur++, smb_mb)
> 
> step 2: cpu 2: completes the quiet state
> step 3: cpu 2: reads pointer 0x123 (ptr to a rcu protected struct)
> 
> step 4: cpu 3: call_rcu(0x123): rcu protected struct added to
rdp->nxtlist
> step 5: cpu 3: moves a new batch into rdp->curlist, rdp->batch = rcp-
> >cur+1.
> xxxxxxxxxxxxxxx Problem: where is the smp_rmb() that guarantees that
> xxxxxxxxxxxxxxx  update to rcp->cur from step 1 is seen by cpu 3?
> step 6: cpu 3: completes quiet state
> step 7: cpu 3: struct 0x123 destroyed
> 
> step 8: cpu 2: accesses pointer 0x123, but the struct is already
destroyed
> 
> James: Is that the race?


[James Huang] 

Yes, this is the race condition that I am concerned about.


> 
> I agree with Paul, there are smb_rmb's on cpu 3 between Step 1 and
Step 5:
> Either the test_and_set_bit in tasklet_action for rcu_process_callback
> if step 4 happens before the tasklet or somewhere in the irq handler
> path if step 4 happens in an irq handler that interrupted
> rcu_process_callback.
> 
> Thus theoretically no additional smb_rmb() should be necessary.
> What is missing is proper documentation.
> 


[James Huang] 

Is it true that a smb_rmb() before a read operation (say from variable
X) will guarantee that the read will always retrieve the most "current"
value of X?   I can not find such a guarantee in atomic_ops.txt or
memory-barriers.txt under Linux's documentation directory.  What is
described in both documents is relative ordering, e.g.

            CPU1                       CPU2
           ------                     ------
          write X = x1
          smp_wmb()  
          write Y = y1 

                                      read Y
                                      smp_rmb()
                                      read X

Then CPU2 will read X with a value of x1 if it reads Y with a value of
y1.

Please point me to the right section in the document if smp_rmb() does
provide such a guarantee.


Thanks,
-- James Huang



> I'm analyzing the code right now:
> Is it really true that typically a cpu only completes data in every
other
> rcu
> cycle? I.e. that most structures are stored in the rcu callback list
until
> two
> quiet states happened?
> 
> I've tried to track the values of rcp->cur and rdp->batch.
> If next_pending is set, then cpu_quiet() immetiately starts
> the next rcu cycle and a cpu cannot both complete the currently
> pending rcu callbacks and add new callbacks to the next cycle,
> thus a cpu only takes part in every other rcu cycle.
> 
> The oocalc file is at
> http://www.colorfullife.com/~manfred/rcu.ods
> http://www.colorfullife.com/~manfred/rcu.pdf
> 
> Is that analysis correct? Perhaps the whole code should be rewritten?
> 
> --
>     Manfred
