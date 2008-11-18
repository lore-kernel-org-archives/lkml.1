Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKRQPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKRQPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYKRQO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:14:56 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:61537 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYKRQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:14:54 -0500
Message-ID: <4922E9EC.3070606@nortel.com>
Date: Tue, 18 Nov 2008 10:14:36 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: BUG?  timer_create() with SIGEV_THREAD not working (at least on ppc64)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2008 16:14:40.0445 (UTC) FILETIME=[C289FED0:01C94998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code below sets up a simple timer with SIGEV_THREAD.  I compiled the 
code as "g++ timertest.cc -o timertest -lrt -pthread".

Running it on my G5 with 2.6.27 (but with an older glibc), it prints:

Creating timer
Setting timer 268509264 for 5-second expiration...

and then the timer never expires.  I have an old Fedora Core 4 x86 
machine and there it works as expected.

Is there some hard requirement to upgrade glibc?  If not, then this 
looks like a bug somewhere.

Thanks,

Chris



int main(void)
{
     timer_t  timer_id;
     struct itimerspec    its;
     struct sigevent      se;

     // set timer signal event
     se.sigev_notify = SIGEV_THREAD;
     se.sigev_value.sival_ptr = &timer_id;
     se.sigev_notify_function = handler;
     se.sigev_notify_attributes = NULL;

     if ( timer_create(CLOCK_REALTIME, &se, &timer_id) < 0)
     {
         printf("create timer failed\n");
         fflush(0);
         return 0;
     }

     // set timer.
     its.it_value.tv_sec     = 1;
     its.it_value.tv_nsec    = 0;
     its.it_interval.tv_sec  = 1;
     its.it_interval.tv_nsec = 0;
     if ( timer_settime(timer_id, 0, &its, NULL) < 0)
     {
         printf("set timer failed\n");
         fflush(0);
         return 0;
     }

     printf("set timer OK\n");
     fflush(0);

     while(1)
     {  pause();}
     return 0;
}
