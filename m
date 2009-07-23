Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZGWH7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZGWH7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZGWH7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:59:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60119 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZGWH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:59:21 -0400
Date: Thu, 23 Jul 2009 13:27:35 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ken Chen <kenchen@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: CFS group scheduler fairness broken starting from 2.6.29-rc1
Message-ID: <20090723075735.GA18878@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Group scheduler fainess is broken since 2.6.29-rc1. git bisect led me
to this commit:

commit ec4e0e2fe018992d980910db901637c814575914
Author: Ken Chen <kenchen@google.com>
Date:   Tue Nov 18 22:41:57 2008 -0800

    sched: fix inconsistency when redistribute per-cpu tg->cfs_rq shares
    
    Impact: make load-balancing more consistent
    
    In the update_shares() path leading to tg_shares_up(), the calculation of
    per-cpu cfs_rq shares is rather erratic even under moderate task wake up
    rate.  The problem is that the per-cpu tg->cfs_rq load weight used in the
    sd_rq_weight aggregation and actual redistribution of the cfs_rq->shares
    are collected at different time.  Under moderate system load, we've seen
    quite a bit of variation on the cfs_rq->shares and ultimately wildly
    affects sched_entity's load weight.
    
    This patch caches the result of initial per-cpu load weight when doing the
    sum calculation, and then pass it down to update_group_shares_cpu() for
    redistributing per-cpu cfs_rq shares.  This allows consistent total cfs_rq
    shares across all CPUs. It also simplifies the rounding and zero load
    weight check.
    
    Signed-off-by: Ken Chen <kenchen@google.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

======================================================================
			% CPU time division b/n groups
Group		2.6.29-rc1		2.6.29-rc1 w/o the above patch
======================================================================
a with 8 tasks	44			31
b with 5 tasks  32			34
c with 3 tasks  22			34
======================================================================
All groups had equal shares.

Regards,
Bharata.
