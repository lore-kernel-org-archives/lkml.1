Return-Path: <linux-kernel-owner+w=401wt.eu-S1764970AbXJPJbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764970AbXJPJbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbXJPJb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:31:28 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37112 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbXJPJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:31:26 -0400
Message-ID: <471484B3.9010903@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 15:00:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Frans Pop <elendil@planet.nl>,
       Greg KH <greg@kroah.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <200710130953.22099.elendil@planet.nl> <200710142236.10768.borntraeger@de.ibm.com> <200710161029.27132.borntraeger@de.ibm.com>
In-Reply-To: <200710161029.27132.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Chuck, Balbir,
> 
> we still have a problem with stime occosionally going backwards. I stated
> below that I think this is not fixable with the current utime/stime split
> algorithm.
> 

Hi,

I missed seeing this problem before, sorry about that. Thanks for the
link below, I now understand the problem.

> Balbir, you wrote this code, Chuck you tried to fix it. Any ideas how to
> fix this properly? The only idea I have requires that we save the old value
> of utime and stime and therefore requires additional locking.
> 

I am trying to think out loud as to what the root cause of the problem
might be. In one of the discussion threads, I saw utime going backwards,
which seemed very odd, I suspect that those are rounding errors.

I don't understand your explanation below

Initially utime = 9, stime = 0, sum_exec_runtime = S1

Later

utime = 9, stime = 1, sum_exec_runtime = S2

We can be sure that S >= (utime + stime)

If S2 = S1 + delta, then as per our calculation

Initially

utime_proc = (utime * (S1))/(utime + stime)
           = nsec_to_clock_t(9 * S1 / 9)

later

utime_proc = nsec_to_clock_t(9 * S2/10)

Given that S >= (utime + stime), we should be fine.
The only problem I see is with rounding, like I mentioned before at two
places

1. Rounding at do_div() in task_utime()
2. Rounding in conversion from clock_t_to_cputime()

I have tried and not had any success reproducing the problem, could you
please help me with some pointers/steps to reproduce the problem?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
