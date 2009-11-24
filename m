Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZKXHJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZKXHJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbZKXHJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:09:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39493 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbZKXHJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:09:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0B8683.6020104@jp.fujitsu.com>
Date: Tue, 24 Nov 2009 16:08:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH tip/sched/core] introduce task_times() to replace	task_[us]time()
 pair
References: <4B061E9A.8040100@jp.fujitsu.com> <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com> <4B0B714C.9080607@jp.fujitsu.com>
In-Reply-To: <4B0B714C.9080607@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> And just now I noticed that using msecs_to_cputime() is problematic,
> since the type of its return value is "unsigned long" so not 64bit.
> I'll make and post a patch to fix this asap.

Sorry, I was confused.  Please ignore the above.

The problem is that since the type of msecs_to_cputime() argument is
unsigned int, it would be wrong if calculated msecs is greater than
UINT_MAX.

Another problem is that msecs_to_jiffies() returns MAX_JIFFY_OFFSET
if msecs > INT_MAX. 

   5168 #ifndef nsecs_to_cputime
   5169 # define nsecs_to_cputime(__nsecs) \
   5170         msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
   5171 #endif

    452 unsigned long msecs_to_jiffies(const unsigned int m)
    453 {
    454         /*
    455          * Negative value, means infinite timeout:
    456          */
    457         if ((int)m < 0)
    458                 return MAX_JIFFY_OFFSET;
     :

What I need here is a simple function can convert 64bit nsecs to
cputime_t, which is unsigned long in asm-generic/cputime.h.
Humm...


Thanks,
H.Seto

