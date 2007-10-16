Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXJPKfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXJPKfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932381AbXJPKfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:35:07 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:56638 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbXJPKfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:35:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Tue, 16 Oct 2007 12:34:35 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>, Frans Pop <elendil@planet.nl>,
       Greg KH <greg@kroah.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <200710161029.27132.borntraeger@de.ibm.com> <471484B3.9010903@linux.vnet.ibm.com>
In-Reply-To: <471484B3.9010903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710161234.35529.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Oktober 2007 schrieb Balbir Singh:
> I am trying to think out loud as to what the root cause of the problem
> might be. In one of the discussion threads, I saw utime going backwards,
> which seemed very odd, I suspect that those are rounding errors.
> 
> I don't understand your explanation below
> 
> Initially utime = 9, stime = 0, sum_exec_runtime = S1
> 
> Later
> 
> utime = 9, stime = 1, sum_exec_runtime = S2
> 
> We can be sure that S >= (utime + stime)

I think here is the problem. How can we be sure? We cant. utime and stime
are sampled, so they can be largely off in any direction,if the program
sleeps often and manages to synchronize itself to the timer tick. Lets say
a program only does a simple system call and then sleeps. So sum_exec_runtime
is increased by lets say 1000 cycles on a 1Ghz box which means 1000ns. If now 
the timer tick happens exactly at this moment, stime is increased by 1 tick
= 1000000ns. 

Maybe there is some magic in the code which I did not see, but obviously
the problem exists and looking at Frans data (stime+utime) are not decreasing,
but stime isnt and utime is. If you look at Frans data you see:
Oct 16 11:54:48 8 10
Oct 16 11:54:49 6 12  <-- utime
Oct 16 11:54:50 6 12
Oct 16 11:54:51 6 12
Oct 16 11:54:52 8 10  <-- stime
Oct 16 11:54:53 8 10
Oct 16 11:54:54 8 10
Oct 16 11:54:55 8 12
Oct 16 11:54:56 8 12

(stime+utime) is constant. That means that S2-S1 is obviously smaller than
one tick (See the calculation in task_stime). I am quite sure it is caused
by changes in the sampled values p->utime and p->stime.

> 
> If S2 = S1 + delta, then as per our calculation
> 
> Initially
> 
> utime_proc = (utime * (S1))/(utime + stime)
>            = nsec_to_clock_t(9 * S1 / 9)
> 
> later
> 
> utime_proc = nsec_to_clock_t(9 * S2/10)
> 
> Given that S >= (utime + stime), we should be fine.



