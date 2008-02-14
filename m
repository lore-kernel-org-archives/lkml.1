Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbYBNQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbYBNQq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbYBNQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:46:14 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32797 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbYBNQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:46:12 -0500
Date: Thu, 14 Feb 2008 22:25:51 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, aneesh.kumar@in.ibm.com, efault@gmx.de
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080214165551.GA21963@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080130135609.GA5100@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130135609.GA5100@ics.muni.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 02:56:09PM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> I noticed short thread in LKM regarding "sched: add vslice" causes horrible
> interactivity under load.
> 
> I can see similar behavior. If I stress both CPU cores, even typing on
> keyboard suffers from huge latencies, I can see letters appearing with delay
> (typing into xterm). No swap is used at all, having 1GB free RAM.
> 
> I noticed this bad behavior with 2.6.24-git[46], 2.6.24-rc8-git was OK.

Hi Lukas,
	Can you check if the patch below helps improve interactivity for you?

The patch is against 2.6.25-rc1. I would request you to check for
difference it makes with CONFIG_FAIR_GROUP_SCHED and
CONFIG_FAIR_USER_SCHED turned on.

---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -7431,8 +7431,8 @@
 
 			local_load = tg->cfs_rq[i]->load.weight;
 			local_shares = (local_load * total_shares) / total_load;
-			if (!local_shares)
-				local_shares = MIN_GROUP_SHARES;
+			if (!local_load)
+				local_shares = tg->shares;
 			if (local_shares == tg->se[i]->load.weight)
 				continue;
 
@@ -7710,7 +7710,7 @@
 	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	if (!shares)
+	if (shares < MIN_GROUP_SHARES)
 		shares = MIN_GROUP_SHARES;
 
 	on_rq = se->on_rq;

-- 
Regards,
vatsa
