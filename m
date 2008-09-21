Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYIULJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYIULJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 07:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYIULJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 07:09:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:5362 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYIULJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 07:09:20 -0400
Message-ID: <48D62B7F.10905@colorfullife.com>
Date: Sun, 21 Sep 2008 13:09:51 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <48CFE466.8010200@colorfullife.com> <20080916173012.GC6717@linux.vnet.ibm.com> <48CFF150.8070400@colorfullife.com>
In-Reply-To: <48CFF150.8070400@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Some further thoughts about design differences between your and my 
implementation:

- rcutree's qsmaskinit  is the worst-case list of cpus that could be in 
rcu read side critical sections.
- rcustate's cpu_total is the accurate list of cpus that could be in rcu 
read side critical sections.

Both variables are read rarely: for rcu_state, twice per grace period.

rcutree fixes up cpus that are "incorrectly" listed in qsmaskinit with 
force_quiescent_state(). It forces rcutree to use a cpu bitmask for 
qsmask and it forces rcutree to store the "done" information in a global 
structure. Additionately, in the worst case force_quiescent_state() must 
loop over all cpus.
rcustate can use per-cpu structures and a global atomic_t. There is no 
loop over all cpus. That's a big advantage, thus I think it's worth the 
effort to maintain an accurate list.
Unfortunately, I don't have an efficient implementation for the accurate 
list.

Some random ideas:
- cpu_total is only read rarely. Thus it would be ok if the read 
operation is expensive [e.g. collect data from multiple cachelines, 
acquire spinlocks...]
- updates to cpu_total happen with every interrupt on an idle system 
with no_hz.
    Thus it must be very scalable, preferably per-cpu data.
    And: Updates are far more frequent than grace periods.
- updates to cpu_total happen nearly never without no_hz.
   Especially: far less frequent than grace periods.

What about adding an "invalid" flag to cpu_total? The "real" data is 
stored in per-cpu structures.
- when a cpu enters/leaves nohz, then it invalidates the global 
cpu_total and updates a per-cpu structure
- when the state machine needs the number of rcu-tracked cpus, then it 
checks if the global cpu_total is valid.
If it's valid, then cpu_total is used directly. Otherwise the per-cpu 
structures are enumerated and the new value is stored as cpu_total.

What do you think?

--
    Manfred
