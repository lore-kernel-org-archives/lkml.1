Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbXJHQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbXJHQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXJHQtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:49:23 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:31155 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJHQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:49:23 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Date: Mon, 8 Oct 2007 18:49:04 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>, Luca Tettamanti <kronos.it@gmail.com>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
References: <200710031433.34504.elendil@planet.nl> <200710042310.25223.borntraeger@de.ibm.com> <200710051749.33381.elendil@planet.nl>
In-Reply-To: <200710051749.33381.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081849.04380.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Oktober 2007 schrieb Frans Pop:
> On Thursday 04 October 2007, you wrote:
> > Frans can you test this patch if this makes stime and utime monotic
> > again?
> >
> > It basically reverts the rest of 
> > b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa and should restore the 2.6.22
> > behavior. The process time is used from tasks utime and stime instead of
> > the scheduler clock. That means, in general after a long period of time,
> > it is less accurate than the current time and behaves like 2.6.22.
> >
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Yes, this gives steady increases.
> For kontact it also again shows updates only once every minute. I really 
> wonder where all the other fluctuations for contact come from with the 
> alternative code.

Please correct me, if I am wrong, but here is my guess:

I think that the new code gives actually better numbers for kontact. Kontact 
is using the cpu for very short periods, right? The old code updates utime 
and stime via sampling at each timer tick. If kontact is scheduled based on 
the timer tick(lets say timeout and a low amount of other interrupts) it will 
start shortly after a tick. If kontact now manages to return the cpu before 
the next tick, the old code would not account anything for kontact.
The new code instead, should be correct in terms of overall runtime as it 
accounts the scheduled time in ns.

Why does it still shows numbers going backwards? I guess the sampled values 
for stime and utime change in flight between task_utime and task_stime are 
called. Lets say utime will be increased. Given the same sum_exec_runtime 
that means that the result of task_stime() will get smaller at this point. 

So Chucks patch only deals with sum_exec_runtime changing.

> 
> It seems to me that this patch would be the best option for 2.6.23.

Ingo, do you have any opinion about how to proceed?

Christian
