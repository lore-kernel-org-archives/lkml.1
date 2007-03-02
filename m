Return-Path: <linux-kernel-owner+w=401wt.eu-S965445AbXCBSED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445AbXCBSED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXCBSED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:04:03 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:46918 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965445AbXCBSEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:04:01 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each round_jiffies second
Date: Fri, 2 Mar 2007 19:03:56 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@linux.intel.com
References: <45E0577C.9020409@simon.arlott.org.uk> <200703021735.55142.dada1@cosmosbay.com> <45E85FC3.801@simon.arlott.org.uk>
In-Reply-To: <45E85FC3.801@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703021903.56720.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 18:32, Simon Arlott wrote:
> On 02/03/07 16:35, Eric Dumazet wrote:

> > You could just change LOAD_FREQ from (5*HZ) to (5*HZ+1)
> > You can see that 5.01 instead of 5.00 second gives the same EXP_xx
> > values.
> >
> > So (5*HZ + 1) is safe. (because HZ >= 100)
>
> On HZ=1000, this would cause the load average to be pushed towards +1.00
> for up to 2 minutes every ~83 minutes with no obvious cause. (If a task
> takes ~10-20ms to run, so 20 runs are needed at HZ=1000 before it passes
> it again).

Nope, you dont quite understand how load (avenrun[]) is computed.

Every 5 seconds, three values are adjusted, based on their previous value and 
the actual value. Lets focus on the first value (mean load average on one 
minute)

exp = 1.0 / exp(5.0/60.0);
avenrun[0] = (avenrun[0] * exp) + (active * (1.0 - exp));

If previous value is 0.0, and current active count 1, then next value for 
avenrun[0] will be : 0.0799556

Not exactly 1.0 as you think !

Then in the next intervals (if active count is 0), it will decrease 'slowly' : 
0.0735627
0.0676809
0.0622695
0.0572907

In average, your load factor close to reality.

Just try my suggestion, it should work. I even proved it in my previous 
mail :)

Eric
