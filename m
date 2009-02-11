Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZBKFIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZBKFIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 00:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZBKFIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 00:08:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZBKFIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 00:08:14 -0500
Message-ID: <49925D31.6050006@cn.fujitsu.com>
Date: Wed, 11 Feb 2009 13:08:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux	(repost)
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal>	<20090206130640.GB10918@linux.vnet.ibm.com>	<20090206163432.GF10918@linux.vnet.ibm.com>	<20090208224419.GA19512@Krystal>	<20090209041153.GR7120@linux.vnet.ibm.com>	<20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal>	<20090209070317.GA31583@Krystal>	<20090209153305.GA6802@linux.vnet.ibm.com> <20090210191731.GA20867@Krystal>
In-Reply-To: <20090210191731.GA20867@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> I just did a mb() version of the urcu :
> 
> (uncomment CFLAGS=+-DDEBUG_FULL_MB in the Makefile)
> 
> Time per read : 48.4086 cycles
> (about 6-7 times slower, as expected)
> 

I had read many papers of Paul.
(http://www.rdrop.com/users/paulmck/RCU/)
and I know Paul did his endeavor to remove memory barrier in
RCU read site in kernel. His work is of consequence.

But, I think,
1) Userspace RCU's read site can pay for the latency of
memory barrier(include atomic operator).
   Userspace does not access to shared data so frequently as kernel.
and userspace's read site is not so fast as kernel.

2) Userspace uses RCU is for RCU's excellence, not saving a little cpu cycles
   (http://lwn.net/Articles/263130/)
   One of the most important excellence is lock-free.


If my thinking is right, the following opinion has some meaning too.

Use All-SYSTEM 's RCU for Userspace RCU.

All-SYSTEM 's RCU is QRCU which is implemented by Paul.
http://lwn.net/Articles/223752/

Any system which has mechanisms equivalent to atomic_op,
__wait_event, wake_up, mutex, This system can also implement QRCU.
So most system can implement QRCU, and I say QRCU is All-SYSTEM 's RCU.

Obviously, we can implement a portable QRCU highly simply in NPTL.
and read lock is:
	for (;;) {
		int idx = qp->completed & 0x1;
		if (likely(atomic_inc_not_zero(qp->ctr + idx)))
			return idx;
	}
"atomic_inc_not_zero" is called once likely, it's fast enough.

Lai.



