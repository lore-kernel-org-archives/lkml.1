Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbXLJUE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbXLJUE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXLJUEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:04:11 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:52332 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbXLJUEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:04:09 -0500
Message-ID: <475D9BB5.20808@jlab.org>
Date: Mon, 10 Dec 2007 15:04:05 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org> <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu>
In-Reply-To: <20071210105943.GA5370@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> I did patch the header file and recompiled the kernel. I observed no 
>> difference (two threads overhead stays too high). Thank you.
> 
> ok, i think i found it. You do this in your qmt/pthread_sync.c 
> test-code:
> 
>  double get_time_of_day_()
>  {
>  ...
>    err = gettimeofday(&ts, NULL);
>  ...
>  }
> 
> and then you use this in the measurement loop:
> 
>    for (k=0; k<=OUTERREPS; k++){
>      start  = getclock();
>      for (j=0; j<innerreps; j++){
>  #ifdef _QMT_PUBLIC
>        delay((void *)0, 0);
>  #else
>        delay(0, 0, 0, (void *)0);
>  #endif
>      }
>      times[k] = (getclock() - start) * 1.0e6 / (double) innerreps;
>    }
> 
> the problem is, this does not take the overhead of gettimeofday into 
> account - which overhead can easily reach 10 usecs (the observed 
> regression). Could you try to eliminate the gettimeofday overhead from 
> your measurement?
> 
> gettimeofday overhead is something that might have changed from .21 to 
> .22 on your box.
> 
> 	Ingo

Hi, Ingo:

In my pthread_sync code, I first call refer () subroutine which actually 
establishes the elapsed time (reference time) for non-synchronized 
delay() using the gettimeofday. Then each synchronization overhead value 
is obtained by subtracting the reference time from the elapsed time with 
introduced synchronization. The effect of gettimeofday() should be 
minimal if the time difference (overhead value) is the interest here. 
Unless the gettimeofday behaves differently in the case of running 8 
threads .vs. running 2 threads.

I will try to replace gettimeofday with a lightweight timer call in my 
test code. Thank you very much.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

