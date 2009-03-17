Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbZCQEpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbZCQEpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZCQEpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:45:05 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:38993 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZCQEpD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:45:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFAJnFvklMQW1W/2dsb2JhbACBTtMlg38G
Date: Tue, 17 Mar 2009 00:44:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jwboyer@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090317044454.GA28245@Krystal>
References: <20090317013220.GA22474@Krystal> <20090316.203705.218202510.davem@davemloft.net> <20090317041016.GA26748@Krystal> <20090316.212717.233062381.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090316.212717.233062381.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:33:16 up 17 days, 59 min,  1 user,  load average: 0.58, 0.50,
	0.47
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Tue, 17 Mar 2009 00:10:16 -0400
> 
> > Thanks for running those tests. Actually, I did not expect good results
> > for sparc64 because the local_t primitives map to atomic_t. Looking at
> > sparc atomic_64.h, I notice that all atomic operations except cmpxchg
> > are done through function calls even when those functions only contain
> > few instructions.  Is there any particular reason for that ? These
> > function calls can be quite costly. We could easily inline those.
> 
> With all the memory barriers, cpu bug workarounds, et al.
> it's way too much to expand inline.
> 
> > And to "unleash" the full power of local_t, we should see if there are
> > variants of the atomic operations which are safe only on UP and if there
> > are some memory barriers currently embedded in the atomic_t ops we could
> > remove in a local_t version. Actually, all the
> > BACKOFF_SETUP/BACKOFF_SPIN is specific to SMP, and therefore the local_t
> > version probably does not need that because it touches specifically
> > per-cpu data. That could give very interesting results.
> > 
> > The reason why the results shows 0 cycles per loop is just because there
> > is less that a bus clock cycle per loop. But the total time (in bus
> > cycles) for the whole 20000 cycles gives us equivalent information.
> 
> I don't think it's worth it.  Rusty made similar tests not too long
> ago.
> 
> IRQ disabling/enabling on sparc64 is 9 cycles (each) and the atomic
> operation on the other hand is at least 35 cycles.

OK, so sparc64 should probably implement local_t with interrupt
disabling on the local CPU and two atomic aligned operations (1 read, 1
write) of 64-bits variables from/to memory, so we make sure that if a
remote CPU tries to simply read the information, it is never seen as
corrupted.

Note that any code doing "remote reads" and "write expected to be read
from a remote cpu" on local_t variables must provide its own memory
barriers.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
