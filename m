Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYGODn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYGODn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYGODnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:43:19 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51986 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbYGODnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:43:19 -0400
Message-ID: <487C1CBF.4040605@linux.vnet.ibm.com>
Date: Tue, 15 Jul 2008 09:12:55 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk, pzijlstr@redhat.com
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan> <48638906.4090308@linux.vnet.ibm.com> <87y74l4scd.fsf@skyscraper.fehenstaub.lan> <87fxqp7nye.fsf@skyscraper.fehenstaub.lan> <4871E657.3040403@linux.vnet.ibm.com> <87d4lqq7ec.fsf@saeurebad.de> <487300B1.4040300@linux.vnet.ibm.com> <877ibukn8k.fsf@saeurebad.de>
In-Reply-To: <877ibukn8k.fsf@saeurebad.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> [added Peter on CC, lockdep confuses me]
> Hmmm, it's weird.  This path should be okay.  I wonder where the
> dependency work -> dbs_mutex comes from.  The mutex is nowhere taken
> with the work lock held (I removed this in the new version of the patch,
> can you double-check you applied to correct patch?).
> 
> So the chain should really be dbs_mutex -> work-lock.
> 
> 
> Uhm, this dependency is as new as the actual lockdep detection (the same
> backtrace as the whole event, see below).  What is lockdep doing here?
> Shouldn't this be the callpath where the lock was taken for the first
> time?
> 
> I can not see where the chain is ever work-lock -> dbs_mutex, so how
> does lockdep come to the conclusion this would be the correct order?
> 

I confirm that Linux kernel patched with the following patches.

--
From: Johannes Weiner <hannes@saeurebad.de>
Subject: cpufreq: cancel self-rearming work synchroneously

The ondemand and conservative governor workers are self-rearming.
Cancel them synchroneously to avoid nasty races.

This patch also removes taking a mutex in the conservative worker
function as the locking is dbs_mutex -> work and not the
other way round.

Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---


---
From: Johannes Weiner <hannes@saeurebad.de>
Subject: cpufreq: Fix race in enabling ondemand/conservative governors

Prevent double activation of the governor if two processes race on the
check for whether the governor is already active.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Thanks

Regards
R.Nageswara Sastry
