Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390Ab0AMGcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0AMGcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191Ab0AMGcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:32:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0AMGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:32:53 -0500
Date: Wed, 13 Jan 2010 01:32:46 -0500
From: Dave Jones <davej@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Thomas Renninger <trenn@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
Message-ID: <20100113063246.GA20803@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Thomas Renninger <trenn@suse.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100113051438.GA32519@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113051438.GA32519@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 01:14:38PM +0800, Wu Fengguang wrote:
 > Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:
 > 
 > --- linux-mm.orig/drivers/cpufreq/cpufreq.c	2010-01-13 13:06:03.000000000 +0800
 > +++ linux-mm/drivers/cpufreq/cpufreq.c	2010-01-13 13:06:57.000000000 +0800
 > @@ -72,7 +72,8 @@ int lock_policy_rwsem_##mode						\
 >  (int cpu)								\
 >  {									\
 >  	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
 > -	BUG_ON(policy_cpu == -1);					\
 > +	if (policy_cpu == -1)						\
 > +		return -1;						\
 >  	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 >  	if (unlikely(!cpu_online(cpu))) {				\
 >  		up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));	\

So instead of always BUG'ing, we'll always fail to get the lock ?
How can this be correct ?

This makes no sense. cpufreq_update_policy shouldn't be called without
an existing policy.   Can someone send me the full trace ?

Andrew cc'd me on a revert of Thomas's last patch to this file,
but again, no trace, and I can't find the mails he refers to.

	Dave

