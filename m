Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbYETTFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbYETTFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbYETTE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:04:56 -0400
Received: from mx1.slu.se ([130.238.96.70]:48158 "EHLO mx1.slu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043AbYETTEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:04:55 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 15:04:55 EDT
From: Robert Olsson <Robert.Olsson@data.slu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18483.6334.468166.282922@robur.slu.se>
Date: Tue, 20 May 2008 20:30:22 +0200
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/4] pktgen: make sure that pktgen_thread_worker has been executed
In-Reply-To: <1211277589-8565-2-git-send-email-den@openvz.org>
References: <1211277589-8565-1-git-send-email-den@openvz.org>
	<1211277589-8565-2-git-send-email-den@openvz.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Denis V. Lunev writes:

 > The problem is that pktgen_thread_worker can not be executed if kthread_stop
 > has been called too early. Insert a completion on the normal initialization
 > path to make sure that pktgen_thread_worker will gain the control for sure.


 Yes how about if we move the wait_for_completion() to pg_cleanup before
 we remove the threads. And move the complete() last in pktgen_thread_worker. 
 This completion would sync with both start and stop.

 Cheers.
					--ro


 > diff --git a/net/core/pktgen.c b/net/core/pktgen.c
 > index 8dca211..fdf5377 100644
 > --- a/net/core/pktgen.c
 > +++ b/net/core/pktgen.c
 > @@ -390,6 +390,7 @@ struct pktgen_thread {
 >  	int cpu;
 >  
 >  	wait_queue_head_t queue;
 > +	struct completion start_done;
 >  };
 >  
 >  #define REMOVE 1
 > @@ -3414,6 +3415,7 @@ static int pktgen_thread_worker(void *arg)
 >  	BUG_ON(smp_processor_id() != cpu);
 >  
 >  	init_waitqueue_head(&t->queue);
 > +	complete(&t->start_done);
 >  
 >  	pr_debug("pktgen: starting pktgen/%d:  pid=%d\n", cpu, task_pid_nr(current));
 >  
 > @@ -3615,6 +3617,7 @@ static int __init pktgen_create_thread(int cpu)
 >  	INIT_LIST_HEAD(&t->if_list);
 >  
 >  	list_add_tail(&t->th_list, &pktgen_threads);
 > +	init_completion(&t->start_done);
 >  
 >  	p = kthread_create(pktgen_thread_worker, t, "kpktgend_%d", cpu);
 >  	if (IS_ERR(p)) {
 > @@ -3639,6 +3642,7 @@ static int __init pktgen_create_thread(int cpu)
 >  	}
 >  
 >  	wake_up_process(p);
 > +	wait_for_completion(&t->start_done);
 >  
 >  	return 0;
 >  }
 > -- 
 > 1.5.3.rc5
