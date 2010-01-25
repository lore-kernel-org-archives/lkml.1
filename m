Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589Ab0AYPIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0AYPIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903Ab0AYPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:08:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0AYPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:08:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=yYHeZbYeH2cA:10 a=7U3hwN5JcxgA:10 a=fiCqcSVwVqia5osXQoMA:9 a=jGfOmXf7WTs9kA8TwRJQg56e8f8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
 non-dynticked CPU
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <4B5D8E72.3050807@cn.fujitsu.com>
References: <20100125034816.GA14043@linux.vnet.ibm.com>
	 <4B5D8E72.3050807@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 25 Jan 2010 10:08:17 -0500
Message-ID: <1264432097.31321.409.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 20:28 +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:

> > +	/* Don't bother unless we are the last non-dyntick-idle CPU. */
> > +	for_each_cpu(thatcpu, nohz_cpu_mask)
> > +		if (thatcpu != cpu)
> > +			return rcu_needs_cpu_quick_check(cpu);
> 
> The comment and the code are not the same, I think.
> 

I once heard this quote, but I don't know who said it:

"If the comment and the code do not match, they probably are both wrong"

Anyway, you are correct, the comment does not match, but I think the
code is wrong. The code returns if any cpu is in non-dyntick-idle state.
Reading the change log, that looks wrong. Perhaps this is what was
needed:


	for_each_online_cpu(thatcpu) {
		if (thatcpu != cpu && !cpumask_test_cpu(thatcpu, nohz_cpu_mask)
			return rcu_needs_cpu_quick_check(cpu);
	}

-- Steve


