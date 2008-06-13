Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbYFMVLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbYFMVLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFMVK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:10:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYFMVKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:10:55 -0400
Date: Fri, 13 Jun 2008 23:10:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, vgusev@openvz.org, mcmanus@ducksong.com,
       xemul@openvz.org, netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [TCP]: TCP_DEFER_ACCEPT causes leak sockets
Message-ID: <20080613211033.GA9379@elte.hu>
References: <20080611.165255.242691774.davem@davemloft.net> <20080612.163212.148965080.davem@davemloft.net> <20080613063037.GA16943@elte.hu> <20080613.023208.78649628.davem@davemloft.net> <20080613110913.GB9867@elte.hu> <20080613114746.GA27811@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613114746.GA27811@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > far, and updated it to yours. The delta between the two is the 3 lines 
> > patch below.
> > 
> > A few testsystems already booted into your patch, so if i dont report 
> > a hung TCP connection in the next 6 hours consider it:
> > 
> > Tested-by: Ingo Molnar <mingo@elte.hu>
> 
> this threw the warning below - never saw that before in thousands of 
> bootups and this was the only networking change that happened. config 
> and bootlog attached. Might be unlucky coincidence.

hm, threw a second warning after 6 more hours of testing:

[  362.170209] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0xde/0xf0()

that appears to be more than just coincidence. I've applied the patch 
below - which brings me back to the well-tested revert from Ilpo.

This is the only change i've done for the overnight -tip testruns, so if 
the warning from sch_generic.c goes away it's this change that has an 
impact on that warning.

	Ingo

--------------------->
commit 3019ae9652fe44c099669e5dba116acad583cfcb
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 13 23:09:28 2008 +0200

    tcp: revert again
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 045e799..ec83448 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -466,9 +466,9 @@ void inet_csk_reqsk_queue_prune(struct sock *parent,
 		reqp=&lopt->syn_table[i];
 		while ((req = *reqp) != NULL) {
 			if (time_after_eq(now, req->expires)) {
-				if ((req->retrans < (inet_rsk(req)->acked ? max_retries : thresh)) &&
-				    (inet_rsk(req)->acked ||
-				     !req->rsk_ops->rtx_syn_ack(parent, req))) {
+				if ((req->retrans < thresh ||
+				     (inet_rsk(req)->acked && req->retrans < max_retries))
+				    && !req->rsk_ops->rtx_syn_ack(parent, req)) {
 					unsigned long timeo;
 
 					if (req->retrans++ == 0)
