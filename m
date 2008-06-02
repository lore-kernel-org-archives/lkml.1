Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYFBUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYFBUD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYFBUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:03:17 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41507 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYFBUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:03:15 -0400
Message-ID: <484451F7.5090001@nortel.com>
Date: Mon, 02 Jun 2008 14:03:03 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com> <483F207D.4010908@nortel.com> <20080530113653.GI12836@linux.vnet.ibm.com>
In-Reply-To: <20080530113653.GI12836@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2008 20:03:10.0738 (UTC) FILETIME=[AEB2EF20:01C8C4EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:

> That seems to be pretty difficult to achieve with the per-cpu runqueue
> and smpnice based load balancing approach we have now.

Okay, thanks.

>>Initially I tried a simple setup with three hogs all in the default "sys" 
>>group.  Over multiple retries using 10-sec intervals, sometimes it gave 
>>roughly 67% for each task, other times it settled into a 100/50/50 split 
>>that remained stable over time.

> Was this with imbalance_pct set to 105? Does it make any difference if
> you change imbalance_pct to say 102?

It was set to 105 initially.  I later reproduced the problem with 102. 
For example, the following was with 102, with three tasks created in the 
sys class.  Based on the runtime, pid 2499 has been getting a cpu all to 
itself for over a minute.

  2499 cfriesen  20   0  3800  392  336 R 99.8  0.0   1:05.85 cat
  2496 cfriesen  20   0  3800  392  336 R 50.0  0.0   0:32.95 cat
  2498 cfriesen  20   0  3800  392  336 R 50.0  0.0   0:32.97 cat

The next run was much better, with sub-second fairness after a minute.

  2505 cfriesen  20   0  3800  392  336 R 68.2  0.0   1:00.32 cat
  2506 cfriesen  20   0  3800  392  336 R 66.9  0.0   0:59.85 cat
  2503 cfriesen  20   0  3800  392  336 R 64.2  0.0   1:00.21 cat

The lack of predictability is disturbing, as it implies some sensitivity 
to the specific test conditions.

>>With three groups, one task in each, I tried both 10 and 60 second 
>>intervals.  The longer interval looked better but was still up to 0.8% off:
> 
> 
> I honestly don't know if we can do better than 0.8%! In any case, I'd
> expect that it would require more drastic changes.

No problem.  It's still far superior than the SMP performance of CKRM,
which is what we're currently using (although heavily modified).

Chris

