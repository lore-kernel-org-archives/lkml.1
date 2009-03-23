Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZCWQu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZCWQu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZCWQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:50:17 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:49845 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZCWQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:50:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALtUx0lMQW1W/2dsb2JhbACBUNEag34GYg
Date: Mon, 23 Mar 2009 12:50:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090323165009.GC22501@Krystal>
References: <20090317013220.GA22474@Krystal> <49BFEF01.1060703@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49BFEF01.1060703@hp.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:44:32 up 23 days, 13:10,  1 user,  load average: 0.40, 0.79,
	0.71
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan D. Brunelle (Alan.Brunelle@hp.com) wrote:
> Here are the results for:
> 
> processor  : 31
> vendor     : GenuineIntel
> arch       : IA-64
> family     : 32
> model      : 0
> model name : Dual-Core Intel(R) Itanium(R) 2 Processor 9050
> revision   : 7
> archrev    : 0
> features   : branchlong, 16-byte atomic ops
> cpu number : 0
> cpu regs   : 4
> cpu MHz    : 1598.002
> itc MHz    : 400.000000
> BogoMIPS   : 3186.68
> siblings   : 2
> physical id: 196865
> core id    : 1
> thread id  : 0
> 
> test init
> test results: time for baseline
> number of loops: 20000
> total time: 5002
> -> baseline takes 0 cycles
> test end
> test results: time for locked cmpxchg
> number of loops: 20000
> total time: 60083
> -> locked cmpxchg takes 3 cycles
> test end
> test results: time for non locked cmpxchg
> number of loops: 20000
> total time: 60002
> -> non locked cmpxchg takes 3 cycles
> test end
> test results: time for locked add return
> number of loops: 20000
> total time: 155007
> -> locked add return takes 7 cycles
> test end
> test results: time for non locked add return
> number of loops: 20000
> total time: 155004
> -> non locked add return takes 7 cycles
> test end
> test results: time for enabling interrupts (STI)
> number of loops: 20000
> total time: 45003
> -> enabling interrupts (STI) takes 2 cycles
> test end
> test results: time for disabling interrupts (CLI)
> number of loops: 20000
> total time: 59998
> -> disabling interrupts (CLI) takes 2 cycles
> test end
> test results: time for disabling/enabling interrupts (STI/CLI)
> number of loops: 20000
> total time: 107274
> -> enabling/disabling interrupts (STI/CLI) takes 5 cycles
> test end

Hi Alan,

Wow, disabling interrupts is incredibly cheap on the ia64, and
local_add_return especially costly. I think it's because it is done by
an underlying cmpxchg, and therefore not supported directly by the
architecture (except for the fetch add which is limited to very specific
values).

Given some ia64 code refers to NMIs, I guess this architecture supports
them. So in the end, the decision between speed and atomicity will
depend on a solidness vs speed tradeoff. But given the time it takes to
write data to memory, I think 5 cycles vs 10 cycles won't make a big
difference overall.

Thanks for those results !

Mathieu

> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
