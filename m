Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYEWHfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYEWHfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYEWHfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:35:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47767 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYEWHff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:35:35 -0400
Date: Fri, 23 May 2008 13:14:31 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Tong N" <tong.n.li@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080523074431.GJ3780@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins> <4835D14B.20904@nortel.com> <1211486868.6463.134.camel@lappy.programming.kicks-ass.net> <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com> <1211490819.6463.172.camel@lappy.programming.kicks-ass.net> <48360D21.9060102@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48360D21.9060102@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 06:17:37PM -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
>
>> Given the following:
>>       root
>>      / | \
>>    _A_ 1  2
>>   /| |\
>>  3 4 5 B
>>       / \
>>      6   7
>>      CPU0            CPU1
>>      root            root
>>      /  \            /  \
>>     A    1          A    2
>>    / \             / \
>>   4   B           3   5
>>      / \
>>     6   7
>
> How do you move specific groups to different cpus.  Is this simply using 
> cpusets?

No. Moving groups to different cpus is just a group-aware extension to
move_tasks() that is invoked as part of regular load balance operation.
move_tasks()->sched_fair_class.load_balance() has been modified to
understand how much various task-groups at various levels (ex: A at level 1,
B at level 2 etc) contribute to cpu load. It moves tasks between cpus
using this knowledge.

For ex: if we were to consider all tasks shown above to be in same cpu,
CPU0, this is how it would look:

	CPU0		CPU1
       root		root
      / | \
     A  1  2
   /| |\
  3 4 5 B
       / \
      6   7

Then cpu0 load = weight of A + weight of 1 + weight of 2
	       = 1024 + 1024 + 1024 = 3072

while cpu1 load = 0

load to be moved to cut down this imbalance = 3072/2 = 1536

move_tasks() running on CPU1 would try to pull iteratively tasks such
that total weight moved is <= 1536.

	Task moved		Total Weight moved
	---------		------------
	    2			     1024
	    3			     1024 + 256 = 1280
	    5			     1280 + 256 = 1536

resulting in:

      CPU0            CPU1
      root            root
      /  \            /  \
     A    1          A    2
    / \             / \
   4   B           3   5
      / \
     6   7

>> Numerical examples given the above scenario, assuming every body's
>> weight is 1024:
>
>>  s_(0,A) = s_(1,A) = 512
>
> Just to make sure I understand what's going on...this is half of 1024 
> because it shows up on both cpus?

not exactly ..as Peter put it:

  s_(i,g) = W_g * rw_(i,g) / \Sum_j rw_(j,g)

In this case, 

  s_(0,A) = W_A * rw_(0, A) / \Sum_j rw_(j, A)

W_A = shares given to A by admin = 1024

rw_(0,A) = Weight of 4 + Weight of B = 1024 + 1024 = 2048
rw_(1,A) = Weight of 3 + Weight of 5 = 1024 + 1024 = 2048
\Sum_j rw_(j, A) = 4096

So,

  s_(0,A) = 1024 *2048 / 4096 = 512


>>  s_(0,B) = 1024, s_(1,B) = 0
>
> This gets the full 1024 because it's only on one cpu.

Not exactly. rw_(0, B) = \Sum_j rw_(j, B) and that's why s_(0,B) = 1024

>>  rw_(0,A) = rw(1,A) = 2048
>>  rw_(0,B) = 2048, rw_(1,B) = 0
>
> How do we get 2048?  Shouldn't this be 1024?

Hope this is clarified from above.

>>  h_load_(0,A) = h_load_(1,A) = 512
>>  h_load_(0,B) = 256, h_load(1,B) = 0
>
> At this point the numbers make sense, but I'm not sure how the formula for 
> h_load_ works given that I'm not sure what's going on for rw_.

-- 
Regards,
vatsa
